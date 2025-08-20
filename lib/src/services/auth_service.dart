import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream für Auth State Changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Aktueller User
  User? get currentUser => _auth.currentUser;

  // Ist User eingeloggt
  bool get isLoggedIn => currentUser != null;

  // DEBUG: Umfassende Admin-Status-Prüfung
  Map<String, dynamic> debugAdminStatus() {
    final user = currentUser;
    return {
      'currentUser': user?.email,
      'isLoggedIn': isLoggedIn,
      'isAdmin': isAdmin,
      'adminEmail': 'marcoeggert73@gmail.com',
      'emailMatch': user?.email == 'marcoeggert73@gmail.com',
      'userProviders': user?.providerData.map((p) => p.providerId).toList(),
      'userUid': user?.uid,
      'emailVerified': user?.emailVerified,
      'creationTime': user?.metadata.creationTime?.toIso8601String(),
      'lastSignInTime': user?.metadata.lastSignInTime?.toIso8601String(),
    };
  }

  // Check if current user is admin
  bool get isAdmin {
    final user = currentUser;
    final result = user != null && user.email == 'marcoeggert73@gmail.com';
    print('AuthService.isAdmin - User: ${user?.email}, Result: $result');
    return result;
  }

  // Check if user signed in with Google
  bool get isGoogleUser {
    final user = currentUser;
    if (user == null) return false;

    return user.providerData.any(
      (provider) => provider.providerId == 'google.com',
    );
  }

  // Registrierung
  Future<UserCredential?> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Login
  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Google Sign-In fehlgeschlagen: $e';
    }
  }

  // VERBESSERTE Logout-Methode mit robustem Fehlerhandling
  Future<void> logout() async {
    List<String> errors = [];
    bool hasLoggedOut = false;

    try {
      // 1. Versuche Google Sign-Out (falls Google User)
      if (isGoogleUser) {
        try {
          // Prüfe erst, ob Google SignIn verfügbar ist
          final isSignedIn = await _googleSignIn.isSignedIn();
          if (isSignedIn) {
            await _googleSignIn.signOut();
            print('Google Sign-Out erfolgreich');
          }
        } on PlatformException catch (e) {
          print('Google Sign-Out PlatformException: ${e.message}');
          errors.add('Google Sign-Out: ${e.message}');
          // Weitermachen mit Firebase Logout
        } catch (e) {
          print('Google Sign-Out Fehler: $e');
          errors.add('Google Sign-Out: $e');
          // Weitermachen mit Firebase Logout
        }
      }

      // 2. Firebase Auth Sign-Out (wichtigster Teil)
      try {
        await _auth.signOut();
        hasLoggedOut = true;
        print('Firebase Auth Sign-Out erfolgreich');
      } on FirebaseAuthException catch (e) {
        print('Firebase Auth Sign-Out FirebaseAuthException: ${e.message}');
        errors.add('Firebase: ${e.message}');
        throw _handleAuthException(e);
      } on PlatformException catch (e) {
        print('Firebase Auth Sign-Out PlatformException: ${e.message}');
        errors.add('Firebase Platform: ${e.message}');

        // Bei PlatformException, versuche trotzdem den Logout zu erzwingen
        if (e.code == 'channel-error' || e.code == 'network_error') {
          // Diese sind oft nicht kritisch für den eigentlichen Logout
          hasLoggedOut = true;
          print('Logout trotz PlatformException als erfolgreich gewertet');
        } else {
          throw 'Firebase Logout PlatformException: ${e.message}';
        }
      } catch (e) {
        print('Firebase Auth Sign-Out unbekannter Fehler: $e');
        errors.add('Firebase unbekannt: $e');
        throw 'Firebase Logout Fehler: $e';
      }

      // 3. Zusätzliche Bereinigung für Google SignIn
      if (isGoogleUser && !hasLoggedOut) {
        try {
          await _googleSignIn.disconnect();
          print('Google disconnect als Fallback ausgeführt');
        } catch (e) {
          print('Google disconnect Fallback Fehler: $e');
          // Nicht kritisch
        }
      }

      // 4. Erfolg bestätigen
      if (hasLoggedOut) {
        print('Logout erfolgreich abgeschlossen');
        if (errors.isNotEmpty) {
          print('Logout mit Warnungen: ${errors.join(', ')}');
        }
      } else {
        throw 'Logout konnte nicht abgeschlossen werden';
      }
    } catch (e) {
      // Final catch - wirft den Fehler weiter für UI-Handling
      if (e is String) {
        throw e;
      } else {
        throw 'Unerwarteter Logout-Fehler: $e';
      }
    }
  }

  // Alternative: Vereinfachter Logout (Fallback-Methode)
  Future<void> simpleLogout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Simple logout Fehler: $e');
      // Selbst bei Fehlern, navigiere trotzdem zur Login-Seite
      rethrow;
    }
  }

  // Neue Methode: Logout-Status prüfen
  Future<bool> isCurrentlySignedOut() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return true;

      // Zusätzliche Prüfung für Google
      if (isGoogleUser) {
        final googleSignedIn = await _googleSignIn.isSignedIn();
        return !googleSignedIn;
      }

      return false;
    } catch (e) {
      print('Fehler bei Logout-Status-Prüfung: $e');
      return true; // Im Zweifel als ausgeloggt betrachten
    }
  }

  // Neue Methode: Forcierter Logout (für schwere Fälle)
  Future<void> forceLogout() async {
    try {
      // Versuche alle Logout-Methoden parallel
      await Future.wait([
        _auth.signOut().catchError(
          (e) => print('Force Firebase logout error: $e'),
        ),
        _googleSignIn.signOut().catchError(
          // ignore: invalid_return_type_for_catch_error
          (e) => print('Force Google logout error: $e'),
        ),
        _googleSignIn.disconnect().catchError(
          // ignore: invalid_return_type_for_catch_error
          (e) => print('Force Google disconnect error: $e'),
        ),
      ]);
    } catch (e) {
      print('Force logout error: $e');
      // Selbst bei Fehlern, betrachte es als erfolgreich
    }
  }

  // Passwort vergessen
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Admin-spezifische Methoden

  // Überprüfe Admin-Berechtigung mit Exception
  void requireAdmin() {
    if (!isAdmin) {
      throw Exception('Admin-Berechtigung erforderlich');
    }
  }

  // Admin-Status mit detaillierter Info
  Map<String, dynamic> getAdminStatus() {
    final user = currentUser;
    return {
      'isLoggedIn': isLoggedIn,
      'isAdmin': isAdmin,
      'userEmail': user?.email,
      'adminEmail': 'marcoeggert73@gmail.com',
      'hasPermission': isAdmin,
    };
  }

  // Aktuelle User-Rolle zurückgeben
  String getUserRole() {
    if (!isLoggedIn) return 'guest';
    if (isAdmin) return 'admin';
    return 'user';
  }

  // Berechtigung für bestimmte Admin-Aktionen prüfen
  bool canPerformAdminAction(String action) {
    if (!isAdmin) return false;

    // Hier könnten in Zukunft granulare Berechtigungen implementiert werden
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
      case 'manage_users':
        return true;
      default:
        return false;
    }
  }

  // ERWEITERTE Fehlerbehandlung mit PlatformException
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
      case 'channel-error':
        return 'Kommunikationsfehler. Versuchen Sie es erneut.';
      default:
        return 'Ein unbekannter Fehler ist aufgetreten: ${e.message}';
    }
  }

  // Neue Methode: Umfassendes Error-Handling für PlatformExceptions
  String handlePlatformException(PlatformException e) {
    switch (e.code) {
      case 'channel-error':
        return 'Verbindungsfehler zur nativen Plattform. Das kann bei schwacher Internetverbindung auftreten.';
      case 'network_error':
        return 'Netzwerkfehler. Überprüfen Sie Ihre Internetverbindung.';
      case 'sign_in_failed':
        return 'Anmeldung fehlgeschlagen. Versuchen Sie es erneut.';
      case 'sign_in_canceled':
        return 'Anmeldung wurde abgebrochen.';
      case 'sign_in_required':
        return 'Anmeldung erforderlich.';
      default:
        return 'Plattform-Fehler: ${e.message ?? e.code}';
    }
  }
}
