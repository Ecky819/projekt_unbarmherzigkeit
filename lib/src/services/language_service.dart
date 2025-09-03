import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  // Unterstützte Sprachen
  static const List<Locale> supportedLocales = [
    Locale('de', 'DE'), // Deutsch als Standard
    Locale('en', 'US'), // Englisch
    Locale('el', 'GR'), // Griechisch
  ];

  Locale _currentLocale = const Locale('de', 'DE');

  Locale get currentLocale => _currentLocale;

  // Initialisierung
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);

      if (languageCode != null) {
        final locale = supportedLocales.firstWhere(
          (locale) => locale.languageCode == languageCode,
          orElse: () => const Locale('de', 'DE'),
        );
        _currentLocale = locale;
      }
    } catch (e) {
      debugPrint('Error loading language: $e');
      _currentLocale = const Locale('de', 'DE');
    }
  }

  // EINFACHER SPRACHWECHSEL - nur notifyListeners
  Future<void> changeLanguage(Locale newLocale) async {
    if (!supportedLocales.contains(newLocale) || _currentLocale == newLocale) {
      return;
    }

    try {
      // Sprache setzen
      _currentLocale = newLocale;

      // UI sofort aktualisieren
      notifyListeners();

      // Asynchron speichern (nicht blockierend)
      _saveLanguageAsync(newLocale);
    } catch (e) {
      debugPrint('Error changing language: $e');
    }
  }

  // Asynchrones Speichern ohne UI zu blockieren
  Future<void> _saveLanguageAsync(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
  }

  // Helper-Methoden
  bool get isGreek => _currentLocale.languageCode == 'el';
  bool get isEnglish => _currentLocale.languageCode == 'en';
  bool get isGerman => _currentLocale.languageCode == 'de';

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

  String get currentLanguageFlag {
    switch (_currentLocale.languageCode) {
      case 'el':
        return 'assets/icons/flag_greece.png';
      case 'en':
        return 'assets/icons/flag_uk.png';
      case 'de':
        return 'assets/icons/flag_de.png';
      default:
        return 'assets/icons/flag_de.png';
    }
  }

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
