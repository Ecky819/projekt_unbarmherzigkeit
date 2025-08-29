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

  // Check if current user is admin
  bool get isAdmin {
    final user = currentUser;
    final result = user != null && user.email == 'marcoeggert73@gmail.com';
    //print('AuthService.isAdmin - User: ${user?.email}, Result: $result');
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

  // VERBESSERTE E-Mail-Verifizierung
  Future<void> sendEmailVerification() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('Kein Benutzer angemeldet');
      }

      if (user.emailVerified) {
        throw Exception('E-Mail-Adresse ist bereits verifiziert');
      }

      // Sende Verifizierungs-E-Mail mit verbessertem Error Handling
      await user.sendEmailVerification();

      // print('E-Mail-Verifizierung gesendet an: ${user.email}');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'too-many-requests':
          throw 'Zu viele Anfragen. Warten Sie eine Minute und versuchen Sie es erneut.';
        case 'invalid-email':
          throw 'Ungültige E-Mail-Adresse.';
        case 'user-disabled':
          throw 'Ihr Konto wurde deaktiviert.';
        default:
          throw 'Fehler beim Senden der Verifizierungs-E-Mail: ${e.message}';
      }
    } catch (e) {
      throw 'Unerwarteter Fehler: $e';
    }
  }

  // E-Mail-Verifizierungsstatus prüfen (mit Reload)
  Future<bool> checkEmailVerificationStatus() async {
    try {
      final user = currentUser;
      if (user == null) return false;

      // User-Daten vom Server neu laden
      await user.reload();

      // Aktuellen User nach Reload erneut abrufen
      final refreshedUser = _auth.currentUser;

      return refreshedUser?.emailVerified ?? false;
    } catch (e) {
      //print('Fehler beim Prüfen des Verifizierungsstatus: $e');
      return false;
    }
  }

  // Registrierung mit automatischer E-Mail-Verifizierung
  Future<UserCredential?> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Automatisch E-Mail-Verifizierung senden
      if (result.user != null && !result.user!.emailVerified) {
        try {
          await result.user!.sendEmailVerification();
          // print('Verifizierungs-E-Mail automatisch gesendet');
        } catch (e) {
          // print(
          //   'Fehler beim automatischen Senden der Verifizierungs-E-Mail: $e',
          // );
          // Registrierung trotzdem erfolgreich, nur Verifizierung fehlgeschlagen
        }
      }

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
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Google Sign-In fehlgeschlagen: $e';
    }
  }

  // Logout
  Future<void> logout() async {
    List<String> errors = [];
    bool hasLoggedOut = false;

    try {
      if (isGoogleUser) {
        try {
          final isSignedIn = await _googleSignIn.isSignedIn();
          if (isSignedIn) {
            await _googleSignIn.signOut();
            //print('Google Sign-Out erfolgreich');
          }
        } on PlatformException catch (e) {
          // print('Google Sign-Out PlatformException: ${e.message}');
          errors.add('Google Sign-Out: ${e.message}');
        } catch (e) {
          // print('Google Sign-Out Fehler: $e');
          errors.add('Google Sign-Out: $e');
        }
      }

      try {
        await _auth.signOut();
        hasLoggedOut = true;
        //  print('Firebase Auth Sign-Out erfolgreich');
      } on FirebaseAuthException catch (e) {
        //  print('Firebase Auth Sign-Out FirebaseAuthException: ${e.message}');
        errors.add('Firebase: ${e.message}');
        throw _handleAuthException(e);
      } on PlatformException catch (e) {
        // print('Firebase Auth Sign-Out PlatformException: ${e.message}');
        errors.add('Firebase Platform: ${e.message}');

        if (e.code == 'channel-error' || e.code == 'network_error') {
          hasLoggedOut = true;
          // print('Logout trotz PlatformException als erfolgreich gewertet');
        } else {
          throw 'Firebase Logout PlatformException: ${e.message}';
        }
      } catch (e) {
        // print('Firebase Auth Sign-Out unbekannter Fehler: $e');
        errors.add('Firebase unbekannt: $e');
        throw 'Firebase Logout Fehler: $e';
      }

      if (isGoogleUser && !hasLoggedOut) {
        try {
          await _googleSignIn.disconnect();
          //print('Google disconnect als Fallback ausgeführt');
        } catch (e) {
          //print('Google disconnect Fallback Fehler: $e');
        }
      }

      if (hasLoggedOut) {
        //print('Logout erfolgreich abgeschlossen');
        if (errors.isNotEmpty) {
          //print('Logout mit Warnungen: ${errors.join(', ')}');
        }
      } else {
        throw 'Logout konnte nicht abgeschlossen werden';
      }
    } catch (e) {
      if (e is String) {
        rethrow;
      } else {
        throw 'Unerwarteter Logout-Fehler: $e';
      }
    }
  }

  // Vereinfachter Logout (Fallback)
  Future<void> simpleLogout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      //print('Simple logout Fehler: $e');
      rethrow;
    }
  }

  // Forcierter Logout
  Future<void> forceLogout() async {
    try {
      await Future.wait([
        _auth.signOut().catchError(
          // ignore: avoid_print
          (e) => print('Force Firebase logout error: $e'),
        ),
        _googleSignIn.signOut().catchError((e) {
          //print('Force Google logout error: $e');
          return null;
        }),
        _googleSignIn.disconnect().catchError((e) {
          //print('Force Google disconnect error: $e');
          return null;
        }),
      ]);
    } catch (e) {
      //print('Force logout error: $e');
    }
  }

  // Passwort zurücksetzen
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Admin-Berechtigung prüfen
  void requireAdmin() {
    if (!isAdmin) {
      throw Exception('Admin-Berechtigung erforderlich');
    }
  }

  // Admin-Status abrufen
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

  // User-Rolle bestimmen
  String getUserRole() {
    if (!isLoggedIn) return 'guest';
    if (isAdmin) return 'admin';
    return 'user';
  }

  // Admin-Aktion-Berechtigung prüfen
  bool canPerformAdminAction(String action) {
    if (!isAdmin) return false;

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

  // Debug Admin-Status
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

  // Fehlerbehandlung für FirebaseAuthException
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
      case 'unauthorized-domain':
        return 'Die Domain ist nicht für dieses Projekt autorisiert. Kontaktieren Sie den Administrator.';
      default:
        return 'Ein unbekannter Fehler ist aufgetreten: ${e.message}';
    }
  }

  // PlatformException Behandlung
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
      case 'ERROR_UNAUTHORIZED_DOMAIN':
        return 'Domain nicht autorisiert. Kontaktieren Sie den Administrator.';
      default:
        return 'Plattform-Fehler: ${e.message ?? e.code}';
    }
  }
}
