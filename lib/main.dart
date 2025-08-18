import 'package:flutter/material.dart';
import 'src/features/splash/splash_screen.dart';
import 'src/common/main_navigation.dart';
import 'src/theme/app_theme.dart';
import 'src/data/MockDatabaseRepository.dart';
import 'src/data/data_initialization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

Future<void> initialization(BuildContext? context) async {
  // Hier können Sie Initialisierungen vornehmen, z.B. für Firebase oder andere Dienste
  await Future.delayed(
    const Duration(seconds: 3),
  ); // await Firebase.initializeApp();
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
        '/main': (context) => FutureBuilder<MockDatabaseRepository>(
          // NEU: Repository beim App-Start initialisieren
          future: initializeMockData(),
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
                  child: Text(
                    'Fehler beim Laden der Datenbank: ${snapshot.error}',
                    style: const TextStyle(fontSize: 16, fontFamily: 'SFPro'),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            // NEU: MainNavigation mit Repository übergeben
            return MainNavigation(repository: snapshot.data);
          },
        ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
