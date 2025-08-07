import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'src/common/main_navigation.dart';
import 'src/theme/app_theme.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.remove();
  runApp(MyApp());
}

Future initialization(BuildContext? context) async {
  // Hier können Sie Initialisierungen vornehmen, z.B. für Firebase oder andere Dienste
  await Future.delayed(Duration(seconds: 3)); // await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '#PROJEKT UNBARMHERZIGKEIT',
      theme: AppTheme.lightTheme,
      home: const MainNavigation(),
    );
  }
}
