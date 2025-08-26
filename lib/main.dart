import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'configs/firebase_options.dart';
import 'src/features/splash/splash_screen.dart';
import 'src/common/main_navigation.dart';
import 'src/theme/app_theme.dart';
import 'src/services/language_service.dart';
import 'l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialisieren
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Language Service initialisieren
  final languageService = LanguageService();
  await languageService.initialize();

  runApp(MyApp(languageService: languageService));
}

class MyApp extends StatelessWidget {
  final LanguageService languageService;

  const MyApp({super.key, required this.languageService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: languageService,
      child: Consumer<LanguageService>(
        builder: (context, langService, child) {
          return MaterialApp(
            title: '#PROJEKT UNBARMHERZIGKEIT',

            // Lokalisierung
            locale: langService.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageService.supportedLocales,

            theme: AppTheme.lightTheme,
            initialRoute: '/splash',
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/main': (context) => const MainNavigation(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
