import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFE9E5DD,
      ), // Beige Hintergrundfarbe wie im ProfileScreen
      appBar: AppBar(
        title: const Text('Registrierung'),
        backgroundColor: const Color(0xFF283A49),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Neues Konto erstellen',
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
                'Füllen Sie alle Felder aus, um sich zu registrieren',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF283A49)),
              ),
              const SizedBox(height: 24),

              // Benutzername
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Benutzername',
                  hintText: 'max.mustermann',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: usernameValidator,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // E-Mail
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-Mail-Adresse',
                  hintText: 'max.mustermann@example.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: emailValidator,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Passwort
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Passwort',
                  hintText: 'Gib dein Passwort ein',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                validator: passwordValidator,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Passwort bestätigen
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Passwort bestätigen',
                  hintText: 'Gib dein Passwort erneut ein',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      );
                    },
                  ),
                ),
                validator: (value) => passwordConfirmationValidator(
                  value,
                  _passwordController.text,
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 24),

              // Registrieren Button
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Glückwunsch, Sie haben sich erfolgreich registriert!',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                      _formKey.currentState!.reset();
                      _passwordController.clear();
                      _confirmPasswordController.clear();

                      // Nach erfolgreicher Registrierung zurück zum Login
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Registrieren',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Bereits ein Konto?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Jetzt anmelden'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Bitte gib eine E-Mail-Adresse ein.';
  }
  if (value.length > 50) return 'Die E-Mail-Adresse ist zu lang.';
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  if (!emailRegex.hasMatch(value)) return 'Die E-Mail-Adresse ist ungültig.';
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) return 'Bitte gib ein Passwort ein.';
  if (value.length < 8) return 'Passwort muss mindestens 8 Zeichen lang sein.';
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Passwort muss mindestens einen Großbuchstaben enthalten.';
  }
  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Passwort muss mindestens eine Ziffer enthalten.';
  }
  if (!value.contains(RegExp(r'[!@#\$%^&*(),.?\":{}|<>]'))) {
    return 'Passwort muss mindestens ein Sonderzeichen enthalten.';
  }
  return null;
}

String? passwordConfirmationValidator(String? value, String password) {
  if (value == null || value.isEmpty) return 'Bitte bestätige dein Passwort.';
  if (value != password) return 'Passwörter stimmen nicht überein.';
  return null;
}

String? usernameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Bitte gib einen Benutzernamen ein.';
  }
  if (value.length < 4 || value.length > 10) {
    return 'Benutzername muss 4 bis 10 Zeichen lang sein.';
  }
  final allowedCharsRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
  if (!allowedCharsRegex.hasMatch(value)) {
    return 'Benutzername darf nur Buchstaben, Ziffern, Unterstriche und Bindestriche enthalten.';
  }
  if (!RegExp(r'^[a-zA-Z0-9].*[a-zA-Z0-9]$').hasMatch(value)) {
    return 'Benutzername darf nicht mit einem Sonderzeichen beginnen oder enden.';
  }
  const takenUsernames = {'admin', 'testuser', 'flutterdev'};
  if (takenUsernames.contains(value.toLowerCase())) {
    return 'Dieser Benutzername ist bereits vergeben.';
  }
  return null;
}
