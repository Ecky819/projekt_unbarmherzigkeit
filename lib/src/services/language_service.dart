import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  // Unterstützte Sprachen
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // Englisch
    Locale('el', 'GR'), // Griechisch
  ];

  Locale _currentLocale = const Locale('en', 'US');

  Locale get currentLocale => _currentLocale;

  // Initialisierung - lädt gespeicherte Sprache
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey);

    if (languageCode != null) {
      _currentLocale = supportedLocales.firstWhere(
        (locale) => locale.languageCode == languageCode,
        orElse: () => const Locale('en', 'US'),
      );
      notifyListeners();
    }
  }

  // Sprache wechseln
  Future<void> changeLanguage(Locale newLocale) async {
    if (!supportedLocales.contains(newLocale)) return;

    _currentLocale = newLocale;

    // Speichern in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, newLocale.languageCode);

    notifyListeners();
  }

  // Helper: Aktuelle Sprache ist Griechisch?
  bool get isGreek => _currentLocale.languageCode == 'el';

  // Helper: Aktuelle Sprache ist Englisch?
  bool get isEnglish => _currentLocale.languageCode == 'en';

  // Helper: Sprache formatiert anzeigen
  String get currentLanguageDisplayName {
    switch (_currentLocale.languageCode) {
      case 'el':
        return 'Ελληνικά';
      case 'en':
      default:
        return 'English';
    }
  }

  // Helper: Flag-Icon Path
  String get currentLanguageFlag {
    switch (_currentLocale.languageCode) {
      case 'el':
        return 'assets/icons/flag_greece.png';
      case 'en':
      default:
        return 'assets/icons/flag_uk.png';
    }
  }
}
