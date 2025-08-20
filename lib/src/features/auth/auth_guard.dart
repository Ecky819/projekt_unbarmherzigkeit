import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/profiles/registration_screen.dart';
import '../../services/auth_service.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  final String? redirectMessage;
  final bool showLoadingScreen;

  const AuthGuard({
    super.key,
    required this.child,
    this.redirectMessage,
    this.showLoadingScreen = true,
  });

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Loading State
        if (snapshot.connectionState == ConnectionState.waiting &&
            showLoadingScreen) {
          return const Scaffold(
            backgroundColor: Color.fromRGBO(233, 229, 221, 1.0),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Authentifizierung wird überprüft...',
                    style: TextStyle(fontSize: 16, fontFamily: 'SFPro'),
                  ),
                ],
              ),
            ),
          );
        }

        // User ist eingeloggt - zeige geschützten Content
        if (snapshot.data != null) {
          return child;
        }

        // User ist nicht eingeloggt - zeige Login Screen mit optionaler Nachricht
        return LoginScreenWithMessage(
          message:
              redirectMessage ??
              'Sie müssen sich anmelden, um auf diese Funktion zugreifen zu können.',
        );
      },
    );
  }
}

class LoginScreenWithMessage extends StatelessWidget {
  final String message;

  const LoginScreenWithMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD),
      appBar: AppBar(
        title: const Text('Anmeldung erforderlich'),
        backgroundColor: const Color(0xFF283A49),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Info Message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.orange),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),

          // Login Screen Content - OHNE AppBar
          const Expanded(child: _LoginScreenBody()),
        ],
      ),
    );
  }
}

// Extrahierte Login-Body-Komponente ohne AppBar
class _LoginScreenBody extends StatefulWidget {
  const _LoginScreenBody();

  @override
  State<_LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<_LoginScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        // Zurück zur vorherigen Seite oder zur Hauptseite
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final result = await _authService.signInWithGoogle();

      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erfolgreich mit Google angemeldet!'),
            backgroundColor: Colors.green,
          ),
        );
        // Zurück zur vorherigen Seite oder zur Hauptseite
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google Anmeldung fehlgeschlagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  Future<void> _forgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte geben Sie Ihre E-Mail-Adresse ein.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await _authService.sendPasswordResetEmail(_emailController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'E-Mail zum Zurücksetzen des Passworts wurde gesendet.',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Willkommen zurück',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF283A49),
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Melden Sie sich an, um fortzufahren',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF283A49)),
            ),
            const SizedBox(height: 24),

            // E-Mail
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'E-Mail-Adresse',
                hintText: 'max.mustermann@example.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bitte geben Sie Ihre E-Mail-Adresse ein.';
                }
                if (!value.contains('@')) {
                  return 'Bitte geben Sie eine gültige E-Mail-Adresse ein.';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Passwort
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Passwort',
                hintText: 'Geben Sie Ihr Passwort ein',
                suffixIcon: IconButton(
                  onPressed: _togglePasswordVisibility,
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bitte geben Sie Ihr Passwort ein.';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _login(),
            ),
            const SizedBox(height: 20),

            // Einloggen Button
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  backgroundColor: const Color(0xFF283A49),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Einloggen',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),

            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: _forgotPassword,
                child: const Text(
                  'Passwort vergessen?',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),

            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Noch kein Konto?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistrationScreen(),
                      ),
                    );
                  },
                  child: const Text('Jetzt registrieren'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Trennlinie mit "oder"
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'oder',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 24),

            // Google Sign-In Button
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: (_isGoogleLoading || _isLoading)
                    ? null
                    : _signInWithGoogle,
                icon: _isGoogleLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.grey,
                        ),
                      )
                    : Image.asset(
                        'assets/icons/google_icon.png',
                        height: 24,
                        width: 24,
                      ),
                label: Text(
                  _isGoogleLoading
                      ? 'Anmeldung läuft...'
                      : 'Mit Google anmelden',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Andere Social Login Buttons (nur als Platzhalter)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _socialLoginButton('assets/icons/apple_icon.png', 'Apple'),
                _socialLoginButton(
                  'assets/icons/facebook_icon.png',
                  'Facebook',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialLoginButton(String assetPath, String provider) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$provider Login noch nicht implementiert'),
            backgroundColor: Colors.orange,
          ),
        );
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFF3EFE7),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(assetPath),
        ),
      ),
    );
  }
}
