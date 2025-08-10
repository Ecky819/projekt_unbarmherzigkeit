import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD), // Beige Hintergrundfarbe
      body: Padding(
        padding: const EdgeInsets.all(24.0),
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

            // E-Mail Feld
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Passwort Feld
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: const Icon(Icons.visibility_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Einloggen Button
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF283A49),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text('Einloggen', style: TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {},
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
                  onPressed: () {},
                  child: const Text('Jetzt registrieren'),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Center(child: Text('Oder anmelden mit:')),
            const SizedBox(height: 16),

            // Social Media Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _socialLoginButton('assets/icons/google_icon.png'),
                _socialLoginButton('assets/icons/apple_icon.png'),
                _socialLoginButton('assets/icons/facebook_icon.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialLoginButton(String assetPath) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Color(0xFFF3EFE7),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
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
