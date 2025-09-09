import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../../l10n/app_localizations.dart';

class LanguageSwitcher extends StatefulWidget {
  final bool showText;
  final bool compact;

  const LanguageSwitcher({
    super.key,
    this.showText = true,
    this.compact = false,
  });

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        // WICHTIG: l10n nur abrufen wenn Widget mounted ist
        if (!mounted) return const SizedBox.shrink();

        final l10n = AppLocalizations.of(context);

        // Fallback falls l10n noch nicht verfügbar
        if (l10n == null) {
          return const SizedBox.shrink();
        }

        if (widget.compact) {
          return _buildCompactSwitcher(context, languageService);
        } else {
          return _buildFullSwitcher(context, languageService, l10n);
        }
      },
    );
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
              return const Icon(
                Icons.language,
                size: 20,
                color: Color.fromARGB(255, 197, 16, 16),
              );
            },
          ),
          if (widget.showText) ...[
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
      onSelected: (locale) {
        if (!mounted) return;

        if (languageService.currentLocale != locale) {
          // Verzögerter Sprachwechsel um Widget-Dispose zu vermeiden
          Future.microtask(() {
            if (mounted) {
              languageService.changeLanguage(locale);
            }
          });
        }
      },
      itemBuilder: (BuildContext itemContext) {
        return LanguageService.supportedLocales.map((locale) {
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
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(itemContext).primaryColor
                        : null,
                    fontFamily: 'SF Pro',
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  Icon(
                    Icons.check,
                    size: 18,
                    color: Theme.of(itemContext).primaryColor,
                  ),
                ],
              ],
            ),
          );
        }).toList();
      },
    );
  }

  Widget _buildFullSwitcher(
    BuildContext context,
    LanguageService languageService,
    AppLocalizations l10n,
  ) {
    return GestureDetector(
      onTap: () {
        if (mounted) {
          _showLanguageDialog(context, languageService, l10n);
        }
      },
      child: Container(
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
                return const Icon(
                  Icons.language,
                  size: 20,
                  color: Colors.white,
                );
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
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    LanguageService languageService,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            l10n.languageDialogTitle,
            style: const TextStyle(fontFamily: 'SF Pro'),
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
                    ? Icon(
                        Icons.check,
                        color: Theme.of(dialogContext).primaryColor,
                      )
                    : null,
                onTap: () {
                  Navigator.of(dialogContext).pop();

                  // Verzögerter Sprachwechsel nach Dialog-Schließung
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (mounted && languageService.currentLocale != locale) {
                      languageService.changeLanguage(locale);
                    }
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.languageDialogClose,
                style: const TextStyle(fontFamily: 'SF Pro'),
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
        return 'Ελληνικά';
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      default:
        return 'Deutsch';
    }
  }

  // KORRIGIERT: Konsistente Flag-Pfade
  String _getFlagPath(String languageCode) {
    switch (languageCode) {
      case 'el':
        return 'assets/icons/flag_greece.png';
      case 'en':
        return 'assets/icons/flag_uk.png';
      case 'de':
        return 'assets/icons/flag_de.png'; // ← KORRIGIERT
      default:
        return 'assets/icons/flag_de.png'; // ← KORRIGIERT
    }
  }
}

// LanguageSwitcherTile für Settings mit sicherem State-Handling
class LanguageSwitcherTile extends StatefulWidget {
  const LanguageSwitcherTile({super.key});

  @override
  State<LanguageSwitcherTile> createState() => _LanguageSwitcherTileState();
}

class _LanguageSwitcherTileState extends State<LanguageSwitcherTile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        if (!mounted) return const SizedBox.shrink();

        final l10n = AppLocalizations.of(context);

        if (l10n == null) {
          return const ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('Loading...'),
          );
        }

        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF283A49).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.language,
              color: Color(0xFF283A49),
              size: 20,
            ),
          ),
          title: Text(
            l10n.languageSwitch,
            style: const TextStyle(
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
          onTap: () {
            if (mounted) {
              _showLanguageDialog(context, languageService, l10n);
            }
          },
        );
      },
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    LanguageService languageService,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            l10n.languageDialogTitle,
            style: const TextStyle(fontFamily: 'SF Pro'),
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
                    ? Icon(
                        Icons.check,
                        color: Theme.of(dialogContext).primaryColor,
                      )
                    : null,
                onTap: () {
                  Navigator.of(dialogContext).pop();

                  // Verzögerter Sprachwechsel
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (mounted && languageService.currentLocale != locale) {
                      languageService.changeLanguage(locale);
                    }
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.languageDialogClose,
                style: const TextStyle(fontFamily: 'SF Pro'),
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

  // KORRIGIERT: Konsistente Flag-Pfade
  String _getFlagPath(String languageCode) {
    switch (languageCode) {
      case 'el':
        return 'assets/icons/flag_greece.png';
      case 'en':
        return 'assets/icons/flag_uk.png';
      case 'de':
        return 'assets/icons/flag_de.png'; // ← KORRIGIERT
      default:
        return 'assets/icons/flag_de.png'; // ← KORRIGIERT
    }
  }
}
