import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'configs/firebase_options.dart';
import 'src/features/splash/splash_screen.dart';
import 'src/common/main_navigation.dart';
import 'src/theme/app_theme.dart';

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
        '/main': (context) =>
            const MainNavigation(), // Kein Repository mehr vorab
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
