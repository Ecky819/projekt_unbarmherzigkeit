import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream für Auth State Changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Aktueller User
  User? get currentUser => _auth.currentUser;

  // Ist User eingeloggt
  bool get isLoggedIn => currentUser != null;

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

  // Logout (erweitert um Google Sign-Out)
  Future<void> logout() async {
    try {
      // Sign out from Google if user was signed in with Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
    } catch (e) {
      throw 'Fehler beim Abmelden: $e';
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

  // Check if user signed in with Google
  bool get isGoogleUser {
    final user = currentUser;
    if (user == null) return false;

    return user.providerData.any(
      (provider) => provider.providerId == 'google.com',
    );
  }

  // Fehlerbehandlung
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
      default:
        return 'Ein unbekannter Fehler ist aufgetreten: ${e.message}';
    }
  }
}
