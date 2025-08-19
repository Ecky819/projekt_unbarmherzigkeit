import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../common/main_navigation.dart';
import '../../features/profiles/login_screen.dart';
import '../../data/databaseRepository.dart';

class AuthWrapper extends StatelessWidget {
  final DatabaseRepository? repository;

  const AuthWrapper({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Zeige Loading während der Auth-State-Überprüfung
        if (snapshot.connectionState == ConnectionState.waiting) {
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

        // Fehlerbehandlung
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(233, 229, 221, 1.0),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Authentifizierungsfehler: ${snapshot.error}',
                    style: const TextStyle(fontSize: 16, fontFamily: 'SFPro'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // App neu starten oder zur Login-Seite navigieren
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Erneut versuchen'),
                  ),
                ],
              ),
            ),
          );
        }

        // Auth State ist verfügbar - zeige entsprechende UI
        return MainNavigation(repository: repository);
      },
    );
  }
}
