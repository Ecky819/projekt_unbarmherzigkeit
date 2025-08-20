import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'configs/firebase_options.dart';
import 'src/features/splash/splash_screen.dart';
import 'src/common/main_navigation.dart';
import 'src/theme/app_theme.dart';
import 'src/data/databaseRepository.dart';
import 'src/data/FirebaseRepository.dart';
import 'src/data/data_initialization.dart';
import 'src/services/migration_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialisieren
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

Future<void> initialization(BuildContext? context) async {
  // Firebase ist bereits in main() initialisiert
  await Future.delayed(const Duration(seconds: 3));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '#PROJEKT UNBARMHERZIGKEIT',
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/main': (context) => FutureBuilder<DatabaseRepository>(
          future: _initializeRepository(),
          builder: (context, snapshot) {
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
                        'Lade Datenbank...',
                        style: TextStyle(fontSize: 16, fontFamily: 'SFPro'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Scaffold(
                backgroundColor: const Color.fromRGBO(233, 229, 221, 1.0),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Fehler beim Laden der Datenbank:\n${snapshot.error}',
                        style: TextStyle(fontSize: 16, fontFamily: 'SFPro'),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Restart app
                          Navigator.pushReplacementNamed(context, '/splash');
                        },
                        child: Text('Erneut versuchen'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return MainNavigation(repository: snapshot.data);
          },
        ),
      },
      debugShowCheckedModeBanner: false,
    );
  }

  Future<DatabaseRepository> _initializeRepository() async {
    try {
      // Versuche Firebase Repository zu verwenden
      final firebaseRepo = FirebaseRepository();
      final migrationService = MigrationService();

      // Prüfe ob Daten bereits migriert wurden
      if (!await migrationService.isDataMigrated()) {
        // Migriere Mock-Daten zu Firestore
        await migrationService.migrateMockDataToFirestore();
      }

      return firebaseRepo;
    } catch (e) {
      print('Firebase Repository konnte nicht initialisiert werden: $e');
      print('Verwende Mock Repository als Fallback');

      // Fallback zu Mock Repository
      return await initializeMockData();
    }
  }
}
