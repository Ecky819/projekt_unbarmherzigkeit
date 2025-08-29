import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../../l10n/app_localizations.dart';

class LanguageSwitcher extends StatelessWidget {
  final bool showText;
  final bool compact;

  const LanguageSwitcher({
    super.key,
    this.showText = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final languageService = context.watch<LanguageService>();
    final l10n = AppLocalizations.of(context)!;

    if (compact) {
      return _buildCompactSwitcher(context, languageService);
    } else {
      return _buildFullSwitcher(context, languageService, l10n);
    }
  }

  Widget _buildCompactSwitcher(
    BuildContext context,
    LanguageService languageService,
  ) {
    return PopupMenuButton<Locale>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            languageService.currentLanguageFlag,
            width: 20,
            height: 14,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.language, size: 20, color: Colors.white);
            },
          ),
          if (showText) ...[
            const SizedBox(width: 6),
            Text(
              languageService.currentLanguageDisplayName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'SF Pro',
              ),
            ),
          ],
        ],
      ),
      onSelected: (locale) => languageService.changeLanguage(locale),
      itemBuilder: (context) => LanguageService.supportedLocales.map((locale) {
        final isSelected = locale == languageService.currentLocale;
        final displayName = _getDisplayName(locale.languageCode);
        final flagPath = _getFlagPath(locale.languageCode);

        return PopupMenuItem<Locale>(
          value: locale,
          child: Row(
            children: [
              Image.asset(
                flagPath,
                width: 24,
                height: 16,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.language, size: 16);
                },
              ),
              const SizedBox(width: 12),
              Text(
                displayName,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Theme.of(context).primaryColor : null,
                  fontFamily: 'SF Pro',
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                Icon(
                  Icons.check,
                  size: 18,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFullSwitcher(
    BuildContext context,
    LanguageService languageService,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            languageService.currentLanguageFlag,
            width: 20,
            height: 14,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.language, size: 20, color: Colors.white);
            },
          ),
          const SizedBox(width: 8),
          Text(
            languageService.currentLanguageDisplayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'SF Pro',
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
        ],
      ),
    );
  }

  String _getDisplayName(String languageCode) {
    switch (languageCode) {
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

  String _getFlagPath(String languageCode) {
    switch (languageCode) {
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
}

// Erweiterte Language Switcher Variante für Settings
class LanguageSwitcherTile extends StatelessWidget {
  const LanguageSwitcherTile({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = context.watch<LanguageService>();

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF283A49).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.language, color: Color(0xFF283A49), size: 20),
      ),
      title: const Text(
        'Sprache / Language / Γλώσσα',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF283A49),
          fontFamily: 'SF Pro',
        ),
      ),
      subtitle: Text(
        languageService.currentLanguageDisplayName,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
          fontFamily: 'SF Pro',
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            languageService.currentLanguageFlag,
            width: 24,
            height: 16,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.language, size: 20);
            },
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
      onTap: () => _showLanguageDialog(context, languageService),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    LanguageService languageService,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Sprache wählen / Choose Language / Επιλέξτε γλώσσα',
            style: TextStyle(fontFamily: 'SF Pro'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: LanguageService.supportedLocales.map((locale) {
              final isSelected = locale == languageService.currentLocale;
              final displayName = _getDisplayName(locale.languageCode);
              final flagPath = _getFlagPath(locale.languageCode);

              return ListTile(
                leading: Image.asset(
                  flagPath,
                  width: 32,
                  height: 22,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.language, size: 24);
                  },
                ),
                title: Text(
                  displayName,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontFamily: 'SF Pro',
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                    : null,
                onTap: () {
                  languageService.changeLanguage(locale);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Schließen / Close / Κλείσιμο',
                style: TextStyle(fontFamily: 'SF Pro'),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getDisplayName(String languageCode) {
    switch (languageCode) {
      case 'el':
        return 'Ελληνικά (Greek)';
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch (German)';
      default:
        return 'Deutsch';
    }
  }

  String _getFlagPath(String languageCode) {
    switch (languageCode) {
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
}
