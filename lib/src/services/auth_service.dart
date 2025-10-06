import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'dart:async';

/// Service für Authentifizierung und Admin-Verwaltung
///
/// Dieser Service verwaltet:
/// - Benutzer-Authentifizierung (E-Mail/Passwort, Google)
/// - Admin-Rollen und Berechtigungen
/// - Custom Claims Caching
/// - Cloud Functions Integration
class AuthService {
  // Singleton Pattern für konsistente Verwendung
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // Cache für Custom Claims
  Map<String, dynamic>? _cachedCustomClaims;
  DateTime? _claimsLastRefresh;
  static const Duration _claimsCacheDuration = Duration(minutes: 5);

  // ==========================================================================
  // AUTHENTICATION STATE
  // ==========================================================================

  /// Stream für Auth State Changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Aktueller User
  User? get currentUser => _auth.currentUser;

  /// Ist User eingeloggt
  bool get isLoggedIn => currentUser != null;

  /// Check if user signed in with Google
  bool get isGoogleUser {
    final user = currentUser;
    if (user == null) return false;

    return user.providerData.any(
      (provider) => provider.providerId == 'google.com',
    );
  }

  // ==========================================================================
  // CUSTOM CLAIMS & CACHING
  // ==========================================================================

  /// Custom Claims abrufen mit Caching
  ///
  /// Cached Claims für 5 Minuten um unnötige Token-Refreshes zu vermeiden
  Future<Map<String, dynamic>> getCustomClaims({
    bool forceRefresh = false,
  }) async {
    // Prüfe Cache (außer bei forceRefresh)
    if (!forceRefresh &&
        _cachedCustomClaims != null &&
        _claimsLastRefresh != null &&
        DateTime.now().difference(_claimsLastRefresh!) < _claimsCacheDuration) {
      return _cachedCustomClaims!;
    }

    try {
      final user = currentUser;
      if (user == null) return {};

      // Token neu laden um aktuelle Claims zu erhalten
      final idTokenResult = await user.getIdTokenResult(forceRefresh);
      final claims = idTokenResult.claims ?? {};

      // Cache aktualisieren
      _cachedCustomClaims = Map<String, dynamic>.from(claims);
      _claimsLastRefresh = DateTime.now();

      return _cachedCustomClaims!;
    } catch (e) {
      print('Fehler beim Abrufen der Custom Claims: $e');
      return {};
    }
  }

  /// Cache leeren (nach Änderungen der Claims)
  void clearClaimsCache() {
    _cachedCustomClaims = null;
    _claimsLastRefresh = null;
  }

  // ==========================================================================
  // ADMIN STATUS CHECKS
  // ==========================================================================

  /// Admin-Status basierend auf Custom Claims
  ///
  /// Prüft ob der User Admin-Berechtigung hat.
  /// Fallback auf Legacy-Admin (marcoeggert73@gmail.com) für Migration.
  Future<bool> get isAdmin async {
    try {
      final claims = await getCustomClaims();
      final isAdminClaim = claims['admin'] == true;

      // Fallback für Migration - prüfe auch Legacy-Admin
      if (!isAdminClaim) {
        return _isLegacyAdmin();
      }

      return isAdminClaim;
    } catch (e) {
      print('Fehler bei Admin-Check: $e');
      // Fallback auf Legacy-System
      return _isLegacyAdmin();
    }
  }

  /// Super-Admin-Status prüfen
  ///
  /// Super-Admins haben vollständigen Zugriff auf alle Funktionen
  Future<bool> get isSuperAdmin async {
    try {
      final claims = await getCustomClaims();
      return claims['admin'] == true && claims['adminLevel'] == 'super';
    } catch (e) {
      print('Fehler bei Super-Admin-Check: $e');
      return false;
    }
  }

  /// Moderator-Status prüfen
  ///
  /// Moderatoren können Inhalte bearbeiten aber keine User verwalten
  Future<bool> get isModerator async {
    try {
      final claims = await getCustomClaims();
      return claims['admin'] == true &&
          (claims['adminLevel'] == 'moderator' ||
              claims['adminLevel'] == 'admin' ||
              claims['adminLevel'] == 'super');
    } catch (e) {
      print('Fehler bei Moderator-Check: $e');
      return false;
    }
  }

  /// Rolle abrufen
  Future<String> get userRole async {
    try {
      if (!isLoggedIn) return 'guest';

      final claims = await getCustomClaims();
      return claims['role']?.toString() ?? 'user';
    } catch (e) {
      print('Fehler beim Abrufen der Rolle: $e');
      return 'user';
    }
  }

  /// Legacy-Admin-Check (für Migration)
  bool _isLegacyAdmin() {
    final user = currentUser;
    return user != null && user.email == 'marcoeggert73@gmail.com';
  }

  // ==========================================================================
  // ADMIN PERMISSIONS
  // ==========================================================================

  /// Admin-Berechtigung prüfen (wirft Exception wenn nicht admin)
  Future<void> requireAdmin() async {
    if (!(await isAdmin)) {
      throw Exception('Admin-Berechtigung erforderlich');
    }
  }

  /// Super-Admin-Berechtigung prüfen (wirft Exception wenn nicht super admin)
  Future<void> requireSuperAdmin() async {
    if (!(await isSuperAdmin)) {
      throw Exception('Super-Admin-Berechtigung erforderlich');
    }
  }

  /// Prüft ob User eine spezifische Admin-Aktion durchführen darf
  ///
  /// Aktionen:
  /// - Moderator: create/update/delete victim/camp/commander, view_admin_dashboard
  /// - Admin: manage_users, create/delete_admin
  /// - Super Admin: system_settings, manage_super_admins
  Future<bool> canPerformAdminAction(String action) async {
    if (!(await isAdmin)) return false;

    final claims = await getCustomClaims();
    final adminLevel = claims['adminLevel']?.toString();

    switch (action) {
      case 'create_victim':
      case 'update_victim':
      case 'delete_victim':
      case 'create_camp':
      case 'update_camp':
      case 'delete_camp':
      case 'create_commander':
      case 'update_commander':
      case 'delete_commander':
      case 'view_admin_dashboard':
        return ['moderator', 'admin', 'super'].contains(adminLevel);

      case 'manage_users':
      case 'create_admin':
      case 'delete_admin':
        return ['admin', 'super'].contains(adminLevel);

      case 'system_settings':
      case 'manage_super_admins':
        return adminLevel == 'super';

      default:
        return false;
    }
  }

  /// Admin-Status mit allen Details abrufen
  Future<Map<String, dynamic>> getAdminStatus() async {
    final user = currentUser;
    final claims = await getCustomClaims();

    return {
      'isLoggedIn': isLoggedIn,
      'isAdmin': await isAdmin,
      'isSuperAdmin': await isSuperAdmin,
      'isModerator': await isModerator,
      'userEmail': user?.email,
      'userRole': await userRole,
      'customClaims': claims,
      'hasPermission': await isAdmin,
      'adminLevel': claims['adminLevel'],
      'assignedAt': claims['assignedAt'],
      'assignedBy': claims['assignedBy'],
    };
  }

  // ==========================================================================
  // CLOUD FUNCTIONS - ADMIN MANAGEMENT
  // ==========================================================================

  /// User zu Admin machen via Cloud Function
  ///
  /// [uid] - User ID des Ziel-Users
  /// [adminLevel] - Level: 'moderator', 'admin', oder 'super'
  ///
  /// Nur Super-Admins dürfen diese Funktion aufrufen
  Future<Map<String, dynamic>> makeUserAdmin(
    String uid, {
    String adminLevel = 'admin',
  }) async {
    try {
      final callable = _functions.httpsCallable('makeUserAdmin');
      final result = await callable.call({
        'uid': uid,
        'adminLevel': adminLevel,
      });

      // Cache leeren da sich Claims geändert haben könnten
      clearClaimsCache();

      return Map<String, dynamic>.from(result.data);
    } on FirebaseFunctionsException catch (e) {
      throw _handleFunctionsException(e);
    } catch (e) {
      throw 'Fehler beim Erstellen des Admins: $e';
    }
  }

  /// Admin-Status entfernen via Cloud Function
  ///
  /// [uid] - User ID des Ziel-Users
  ///
  /// Nur Super-Admins dürfen diese Funktion aufrufen
  Future<Map<String, dynamic>> removeUserAdmin(String uid) async {
    try {
      final callable = _functions.httpsCallable('removeUserAdmin');
      final result = await callable.call({'uid': uid});

      // Cache leeren da sich Claims geändert haben könnten
      clearClaimsCache();

      return Map<String, dynamic>.from(result.data);
    } on FirebaseFunctionsException catch (e) {
      throw _handleFunctionsException(e);
    } catch (e) {
      throw 'Fehler beim Entfernen des Admin-Status: $e';
    }
  }

  /// Alle Admins auflisten via Cloud Function
  ///
  /// Gibt Liste aller User mit Admin-Berechtigung zurück
  ///
  /// Benötigt mindestens Admin-Berechtigung
  Future<List<Map<String, dynamic>>> listAdmins() async {
    try {
      final callable = _functions.httpsCallable('listAdmins');
      final result = await callable.call();

      final data = Map<String, dynamic>.from(result.data);
      return List<Map<String, dynamic>>.from(data['admins'] ?? []);
    } on FirebaseFunctionsException catch (e) {
      throw _handleFunctionsException(e);
    } catch (e) {
      throw 'Fehler beim Auflisten der Admins: $e';
    }
  }

  /// User Claims abrufen via Cloud Function
  ///
  /// [uid] - Optional: User ID des Ziel-Users (null = eigene Claims)
  Future<Map<String, dynamic>> getUserClaims([String? uid]) async {
    try {
      final callable = _functions.httpsCallable('getUserClaims');
      final result = await callable.call({if (uid != null) 'uid': uid});

      return Map<String, dynamic>.from(result.data);
    } on FirebaseFunctionsException catch (e) {
      throw _handleFunctionsException(e);
    } catch (e) {
      throw 'Fehler beim Abrufen der Claims: $e';
    }
  }

  /// Custom Claims setzen via Cloud Function
  ///
  /// [uid] - User ID des Ziel-Users
  /// [claims] - Claims die gesetzt werden sollen
  ///
  /// Nur Super-Admins dürfen diese Funktion aufrufen
  Future<Map<String, dynamic>> setUserClaims(
    String uid,
    Map<String, dynamic> claims,
  ) async {
    try {
      final callable = _functions.httpsCallable('setUserClaims');
      final result = await callable.call({'uid': uid, 'claims': claims});

      // Cache leeren da sich Claims geändert haben könnten
      clearClaimsCache();

      return Map<String, dynamic>.from(result.data);
    } on FirebaseFunctionsException catch (e) {
      throw _handleFunctionsException(e);
    } catch (e) {
      throw 'Fehler beim Setzen der Claims: $e';
    }
  }

  // ==========================================================================
  // DEBUG & DIAGNOSTICS
  // ==========================================================================

  /// Debug Admin-Status mit allen Details
  ///
  /// Nützlich für Debugging und Troubleshooting
  Future<Map<String, dynamic>> debugAdminStatus() async {
    final user = currentUser;
    final claims = await getCustomClaims();

    return {
      'currentUser': user?.email,
      'isLoggedIn': isLoggedIn,
      'isAdmin': await isAdmin,
      'isSuperAdmin': await isSuperAdmin,
      'isModerator': await isModerator,
      'userRole': await userRole,
      'customClaims': claims,
      'legacyAdmin': _isLegacyAdmin(),
      'userProviders': user?.providerData.map((p) => p.providerId).toList(),
      'userUid': user?.uid,
      'emailVerified': user?.emailVerified,
      'creationTime': user?.metadata.creationTime?.toIso8601String(),
      'lastSignInTime': user?.metadata.lastSignInTime?.toIso8601String(),
      'claimsCached': _cachedCustomClaims != null,
      'claimsLastRefresh': _claimsLastRefresh?.toIso8601String(),
    };
  }

  // ==========================================================================
  // EMAIL VERIFICATION
  // ==========================================================================

  /// E-Mail-Verifizierung senden
  Future<void> sendEmailVerification() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('Kein Benutzer angemeldet');
      }

      if (user.emailVerified) {
        throw Exception('E-Mail-Adresse ist bereits verifiziert');
      }

      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Unerwarteter Fehler: $e';
    }
  }

  /// E-Mail-Verifizierungsstatus prüfen (mit Server-Reload)
  Future<bool> checkEmailVerificationStatus() async {
    try {
      final user = currentUser;
      if (user == null) return false;

      // User-Daten vom Server neu laden
      await user.reload();

      // Aktuellen User nach Reload erneut abrufen
      final refreshedUser = _auth.currentUser;

      // Cache leeren da sich User-Daten geändert haben könnten
      clearClaimsCache();

      return refreshedUser?.emailVerified ?? false;
    } catch (e) {
      print('Fehler beim Prüfen des Verifizierungsstatus: $e');
      return false;
    }
  }

  // ==========================================================================
  // AUTHENTICATION METHODS
  // ==========================================================================

  /// Registrierung mit E-Mail und Passwort
  ///
  /// Sendet automatisch E-Mail-Verifizierung nach erfolgreicher Registrierung
  Future<UserCredential?> register(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Automatisch E-Mail-Verifizierung senden
      if (result.user != null && !result.user!.emailVerified) {
        try {
          await result.user!.sendEmailVerification();
        } catch (e) {
          print(
            'Fehler beim automatischen Senden der Verifizierungs-E-Mail: $e',
          );
        }
      }

      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Unerwarteter Fehler bei der Registrierung: $e';
    }
  }

  /// Login mit E-Mail und Passwort
  Future<UserCredential?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Cache leeren um neue Claims zu laden
      clearClaimsCache();

      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Unerwarteter Fehler beim Login: $e';
    }
  }

  /// Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In Flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google Sign-In wurde abgebrochen');
      }

      // Obtain Google Auth credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final result = await _auth.signInWithCredential(credential);

      // Cache leeren um neue Claims zu laden
      clearClaimsCache();

      return result;
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_canceled') {
        throw 'Anmeldung wurde abgebrochen';
      }
      throw 'Google Sign-In Fehler: ${e.message}';
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Unerwarteter Fehler bei Google Sign-In: $e';
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      // Cache leeren
      clearClaimsCache();

      // Google Sign-Out
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      // Firebase Sign-Out
      await _auth.signOut();
    } catch (e) {
      throw 'Fehler beim Logout: $e';
    }
  }

  /// Passwort-Reset E-Mail senden
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Unerwarteter Fehler beim Passwort-Reset: $e';
    }
  }

  // ==========================================================================
  // LOGOUT VARIANTS
  // ==========================================================================

  /// Vereinfachter Logout (nur Firebase, ohne Google)
  ///
  /// Nützlich als Fallback wenn der normale Logout fehlschlägt
  Future<void> simpleLogout() async {
    try {
      // Cache leeren
      clearClaimsCache();

      // Nur Firebase Sign-Out ohne Google
      await _auth.signOut();
    } catch (e) {
      throw 'Fehler beim vereinfachten Logout: $e';
    }
  }

  /// Erzwungener Logout
  ///
  /// Ignoriert alle Fehler und beendet die Sitzung
  Future<void> forceLogout() async {
    try {
      // Cache leeren
      clearClaimsCache();

      // Versuche Google Sign-Out (ignoriere Fehler)
      try {
        if (await _googleSignIn.isSignedIn()) {
          await _googleSignIn.signOut();
        }
      } catch (e) {
        print('Google Sign-Out Fehler ignoriert: $e');
      }

      // Firebase Sign-Out (ignoriere Fehler)
      try {
        await _auth.signOut();
      } catch (e) {
        print('Firebase Sign-Out Fehler ignoriert: $e');
      }
    } catch (e) {
      // Alle Fehler ignorieren beim Force Logout
      print('Force Logout abgeschlossen trotz Fehlern: $e');
    }
  }

  // ==========================================================================
  // ERROR HANDLING
  // ==========================================================================

  /// Fehlerbehandlung für PlatformException
  ///
  /// Speziell für Google Sign-In Fehler
  String handlePlatformException(PlatformException e) {
    switch (e.code) {
      case 'sign_in_canceled':
        return 'Die Anmeldung wurde abgebrochen.';
      case 'sign_in_failed':
        return 'Die Anmeldung ist fehlgeschlagen. Bitte versuchen Sie es erneut.';
      case 'network_error':
        return 'Netzwerkfehler. Überprüfen Sie Ihre Internetverbindung.';
      case 'sign_in_required':
        return 'Eine erneute Anmeldung ist erforderlich.';
      default:
        return e.message ?? 'Ein unbekannter Fehler ist aufgetreten.';
    }
  }

  /// Fehlerbehandlung für FirebaseAuthException
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Das Passwort ist zu schwach.';
      case 'email-already-in-use':
        return 'Diese E-Mail-Adresse wird bereits verwendet.';
      case 'user-not-found':
        return 'Kein Benutzer mit dieser E-Mail-Adresse gefunden.';
      case 'wrong-password':
        return 'Falsches Passwort.';
      case 'invalid-email':
        return 'Ungültige E-Mail-Adresse.';
      case 'user-disabled':
        return 'Dieser Benutzer wurde deaktiviert.';
      case 'too-many-requests':
        return 'Zu viele Anfragen. Versuchen Sie es später erneut.';
      case 'operation-not-allowed':
        return 'Diese Anmeldeart ist nicht aktiviert.';
      case 'account-exists-with-different-credential':
        return 'Ein Konto mit dieser E-Mail-Adresse existiert bereits mit einer anderen Anmeldemethode.';
      case 'invalid-credential':
        return 'Die Anmeldedaten sind ungültig.';
      case 'credential-already-in-use':
        return 'Diese Anmeldedaten werden bereits von einem anderen Konto verwendet.';
      case 'network-request-failed':
        return 'Netzwerkfehler. Überprüfen Sie Ihre Internetverbindung.';
      case 'requires-recent-login':
        return 'Diese Aktion erfordert eine erneute Anmeldung.';
      default:
        return 'Ein Authentifizierungsfehler ist aufgetreten: ${e.message}';
    }
  }

  /// Fehlerbehandlung für FirebaseFunctionsException
  String _handleFunctionsException(FirebaseFunctionsException e) {
    switch (e.code) {
      case 'unauthenticated':
        return 'Sie müssen angemeldet sein, um diese Aktion durchzuführen.';
      case 'permission-denied':
        return 'Sie haben keine Berechtigung für diese Aktion.';
      case 'invalid-argument':
        return 'Ungültige Parameter: ${e.message}';
      case 'not-found':
        return 'Die angeforderte Ressource wurde nicht gefunden.';
      case 'already-exists':
        return 'Die Ressource existiert bereits.';
      case 'internal':
        return 'Interner Serverfehler. Versuchen Sie es später erneut.';
      case 'unavailable':
        return 'Der Service ist vorübergehend nicht verfügbar.';
      case 'deadline-exceeded':
        return 'Die Anfrage hat zu lange gedauert. Versuchen Sie es erneut.';
      case 'cancelled':
        return 'Die Anfrage wurde abgebrochen.';
      default:
        return 'Cloud Function Fehler: ${e.message ?? 'Unbekannter Fehler'}';
    }
  }
}
