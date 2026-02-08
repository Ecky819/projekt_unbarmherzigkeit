import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'configs/firebase_options.dart';
import 'src/features/splash/splash_screen.dart';
import 'src/common/main_navigation.dart';
import 'src/theme/app_theme.dart';
import 'src/services/language_service.dart';
import 'l10n/app_localizations.dart';
import 'src/data/database_repository.dart';
import 'src/data/firebase_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Web: Saubere URLs ohne Hash (#) — z.B. /main statt /#/main
  if (kIsWeb) {
    usePathUrlStrategy();
  }

  // Verbindung zu Firebase herstellen
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Verbindung zum Language Service erstellen und initialisieren
  final languageService = LanguageService();
  await languageService.initialize();
  // Verbindung zur Datenbank erstellen
  final DatabaseRepository repository = FirebaseRepository();

  runApp(MyApp(languageService: languageService, repository: repository));
}

class MyApp extends StatelessWidget {
  final LanguageService languageService;
  final DatabaseRepository repository;

  const MyApp({
    super.key,
    required this.languageService,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageService>.value(value: languageService),
        Provider<DatabaseRepository>.value(value: repository),
      ],
      child: Consumer<LanguageService>(
        builder: (context, langService, child) {
          final l10n = AppLocalizations.of(context);
          return MaterialApp(
            title: l10n?.appTitle,
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
              '/main': (context) => MainNavigation(repository: repository),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
