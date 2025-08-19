import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
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
  
  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
  
  // Passwort vergessen
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
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
      default:
        return 'Ein unbekannter Fehler ist aufgetreten: ${e.message}';
    }
  }
}