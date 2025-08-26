import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  // Erweiterte unterstützte Sprachen
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // Englisch
    Locale('el', 'GR'), // Griechisch
    Locale('de', 'DE'), // Deutsch
  ];

  Locale _currentLocale = const Locale('de', 'DE'); // Standard: Deutsch

  Locale get currentLocale => _currentLocale;

  // Initialisierung - lädt gespeicherte Sprache
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey);

    if (languageCode != null) {
      _currentLocale = supportedLocales.firstWhere(
        (locale) => locale.languageCode == languageCode,
        orElse: () => const Locale('de', 'DE'), // Fallback zu Deutsch
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

  // Helper: Aktuelle Sprache ist Deutsch?
  bool get isGerman => _currentLocale.languageCode == 'de';

  // Helper: Sprache formatiert anzeigen
  String get currentLanguageDisplayName {
    switch (_currentLocale.languageCode) {
      case 'el':
        return 'Ελληνικά';
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      default:
        return 'Deutsch';
    }
  }

  // Helper: Flag-Icon Path
  String get currentLanguageFlag {
    switch (_currentLocale.languageCode) {
      case 'el':
        return 'assets/icons/flag_greece.png';
      case 'en':
        return 'assets/icons/flag_uk.png';
      case 'de':
        return 'assets/icons/flag_germany.png';
      default:
        return 'assets/icons/flag_germany.png';
    }
  }

  // Helper: Sprachspezifische Datum-Formatierung
  String formatDate(DateTime date) {
    switch (_currentLocale.languageCode) {
      case 'de':
        return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
      case 'en':
        return '${date.month}/${date.day}/${date.year}';
      case 'el':
        return '${date.day}/${date.month}/${date.year}';
      default:
        return '${date.day}.${date.month}.${date.year}';
    }
  }

  // Helper: Sprachspezifische Zahlenformatierung
  String formatNumber(int number) {
    switch (_currentLocale.languageCode) {
      case 'de':
        return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
      case 'en':
        return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
      case 'el':
        return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
      default:
        return number.toString();
    }
  }
}
