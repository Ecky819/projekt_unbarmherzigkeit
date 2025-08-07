import 'package:flutter/material.dart';
import 'src/features/splash/splash_screen.dart';
import 'src/common/main_navigation.dart';
import 'src/theme/app_theme.dart';

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
        '/main': (context) => const MainNavigation(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
