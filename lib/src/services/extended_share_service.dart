import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/profile.dart';
import 'share_service.dart';
import 'dart:convert';

/// Erweiterte Sharing-Funktionalität mit zusätzlichen Features
class ExtendedShareService extends ShareService {
  /// Teilt über spezifische Social Media Plattformen
  static Future<void> shareToSocialMedia(
    BuildContext context,
    dynamic item,
    SocialMediaPlatform platform,
  ) async {
    try {
      String shareText = _generateSocialMediaText(item, platform);
      String url = '';

      switch (platform) {
        case SocialMediaPlatform.twitter:
          url =
              'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(shareText)}';
          break;
        case SocialMediaPlatform.facebook:
          url =
              'https://www.facebook.com/sharer/sharer.php?quote=${Uri.encodeComponent(shareText)}';
          break;
        case SocialMediaPlatform.telegram:
          url = 'https://t.me/share/url?text=${Uri.encodeComponent(shareText)}';
          break;
        case SocialMediaPlatform.whatsapp:
          url = 'https://wa.me/?text=${Uri.encodeComponent(shareText)}';
          break;
        case SocialMediaPlatform.email:
          final subject = Uri.encodeComponent(_getEmailSubject(item));
          final body = Uri.encodeComponent(shareText);
          url = 'mailto:?subject=$subject&body=$body';
          break;
      }

      await _launchUrl(url);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${platform.displayName} ist nicht verfügbar: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  /// Generiert plattformspezifischen Text
  static String _generateSocialMediaText(
    dynamic item,
    SocialMediaPlatform platform,
  ) {
    switch (platform) {
      case SocialMediaPlatform.twitter:
        return _generateTwitterText(item);
      case SocialMediaPlatform.facebook:
        return _generateFacebookText(item);
      case SocialMediaPlatform.telegram:
      case SocialMediaPlatform.whatsapp:
        return _generateMessagingText(item);
      case SocialMediaPlatform.email:
        return _generateEmailText(item);
    }
  }

  /// Twitter-optimierter Text (280 Zeichen Limit)
  static String _generateTwitterText(dynamic item) {
    if (item is Victim) {
      return '🕯️ Erinnerung an ${item.surname}, ${item.name} '
          '(${item.nationality}) - Opfer der NS-Zeit. '
          '#NieWieder #Gedenken #${ShareService.appName.replaceAll(' ', '')}';
    } else if (item is ConcentrationCamp) {
      return '🏛️ ${item.type} ${item.name} (${item.location}, ${item.country}) '
          '- Ort des Gedenkens. #NieWieder #Geschichte';
    } else if (item is Commander) {
      return '⚔️ NS-Kriegsverbrecher: ${item.surname}, ${item.name} '
          '(${item.rank}) - Dokumentation für die Geschichte. '
          '#Aufarbeitung #Geschichte';
    }
    return 'Geteilt über #${ShareService.appName.replaceAll(' ', '')}';
  }

  /// Facebook-optimierter Text
  static String _generateFacebookText(dynamic item) {
    final buffer = StringBuffer();

    if (item is Victim) {
      buffer.writeln('🕯️ Zum Gedenken an die Opfer der NS-Zeit');
      buffer.writeln();
      buffer.writeln('${item.surname}, ${item.name}');
      if (item.nationality.isNotEmpty) {
        buffer.writeln('Nationalität: ${item.nationality}');
      }
      if (item.cCamp.isNotEmpty) {
        buffer.writeln('Interniert in: ${item.cCamp}');
      }
    } else if (item is ConcentrationCamp) {
      buffer.writeln('🏛️ Gedenkstätte und historischer Ort');
      buffer.writeln();
      buffer.writeln('${item.type} ${item.name}');
      buffer.writeln('Standort: ${item.location}, ${item.country}');
    } else if (item is Commander) {
      buffer.writeln('⚔️ Historische Dokumentation');
      buffer.writeln();
      buffer.writeln('${item.surname}, ${item.name}');
      buffer.writeln('Rang: ${item.rank}');
    }

    buffer.writeln();
    buffer.writeln('Mehr erfahren über ${ShareService.appName}');
    buffer.writeln('#NieWieder #Gedenken #Geschichte');

    return buffer.toString();
  }

  /// Messaging-optimierter Text (WhatsApp, Telegram)
  static String _generateMessagingText(dynamic item) {
    // Verwende eine öffentliche Methode statt der privaten _generateShareText
    return generateShareTextPublic(item);
  }

  /// Öffentliche Version der generateShareText Methode
  static String generateShareTextPublic(dynamic item) {
    if (item is Victim) {
      return _generateVictimShareTextPublic(item);
    } else if (item is ConcentrationCamp) {
      return _generateCampShareTextPublic(item);
    } else if (item is Commander) {
      return _generateCommanderShareTextPublic(item);
    }
    return 'Geteilt über ${ShareService.appName}';
  }

  /// Generiert Share-Text für Opfer (öffentliche Version)
  static String _generateVictimShareTextPublic(Victim victim) {
    final buffer = StringBuffer();

    buffer.writeln('🕯️ Erinnerung an ein Opfer der NS-Zeit');
    buffer.writeln();
    buffer.writeln('${victim.surname}, ${victim.name}');

    if (victim.birth != null || victim.death != null) {
      buffer.write('Lebensdaten: ');
      if (victim.birth != null) {
        buffer.write(_formatDatePublic(victim.birth!));
      } else {
        buffer.write('unbekannt');
      }
      buffer.write(' - ');
      if (victim.death != null) {
        buffer.write(_formatDatePublic(victim.death!));
      } else {
        buffer.write('unbekannt');
      }
      buffer.writeln();
    }

    if (victim.nationality.isNotEmpty) {
      buffer.writeln('Nationalität: ${victim.nationality}');
    }

    if (victim.cCamp.isNotEmpty) {
      buffer.writeln('Interniert in: ${victim.cCamp}');
    }

    if (victim.prisonerNumber != null) {
      buffer.writeln('Häftlingsnummer: ${victim.prisonerNumber}');
    }

    buffer.writeln();
    buffer.writeln('Quelle: ${ShareService.appName}');
    buffer.writeln('Weitere Informationen: ${ShareService.appUrl}');

    return buffer.toString();
  }

  /// Generiert Share-Text für Konzentrationslager (öffentliche Version)
  static String _generateCampShareTextPublic(ConcentrationCamp camp) {
    final buffer = StringBuffer();

    buffer.writeln('🏛️ ${camp.type} ${camp.name}');
    buffer.writeln();
    buffer.writeln('Standort: ${camp.location}, ${camp.country}');

    if (camp.dateOpened != null || camp.liberationDate != null) {
      buffer.write('Betriebszeit: ');
      if (camp.dateOpened != null) {
        buffer.write(_formatDatePublic(camp.dateOpened!));
      } else {
        buffer.write('unbekannt');
      }
      buffer.write(' - ');
      if (camp.liberationDate != null) {
        buffer.write(_formatDatePublic(camp.liberationDate!));
      } else {
        buffer.write('unbekannt');
      }
      buffer.writeln();
    }

    if (camp.commander.isNotEmpty) {
      buffer.writeln('Kommandant: ${camp.commander}');
    }

    if (camp.description.isNotEmpty && camp.description.length > 100) {
      buffer.writeln();
      buffer.writeln('${camp.description.substring(0, 100)}...');
    } else if (camp.description.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(camp.description);
    }

    buffer.writeln();
    buffer.writeln('Quelle: ${ShareService.appName}');
    buffer.writeln('Weitere Informationen: ${ShareService.appUrl}');

    return buffer.toString();
  }

  /// Generiert Share-Text für Kommandanten (öffentliche Version)
  static String _generateCommanderShareTextPublic(Commander commander) {
    final buffer = StringBuffer();

    buffer.writeln('⚔️ NS-Kriegsverbrecher');
    buffer.writeln();
    buffer.writeln('${commander.surname}, ${commander.name}');
    buffer.writeln('Rang: ${commander.rank}');

    if (commander.birth != null || commander.death != null) {
      buffer.write('Lebensdaten: ');
      if (commander.birth != null) {
        buffer.write(_formatDatePublic(commander.birth!));
      } else {
        buffer.write('unbekannt');
      }
      buffer.write(' - ');
      if (commander.death != null) {
        buffer.write(_formatDatePublic(commander.death!));
      } else {
        buffer.write('unbekannt');
      }
      buffer.writeln();
    }

    if (commander.birthplace?.isNotEmpty == true) {
      buffer.writeln('Geburtsort: ${commander.birthplace}');
    }

    if (commander.description.isNotEmpty &&
        commander.description.length > 150) {
      buffer.writeln();
      buffer.writeln('${commander.description.substring(0, 150)}...');
    } else if (commander.description.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(commander.description);
    }

    buffer.writeln();
    buffer.writeln('Quelle: ${ShareService.appName}');
    buffer.writeln('Weitere Informationen: ${ShareService.appUrl}');

    return buffer.toString();
  }

  /// Formatiert Datum für die Ausgabe (öffentliche Version)
  static String _formatDatePublic(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  /// E-Mail-optimierter Text
  static String _generateEmailText(dynamic item) {
    final buffer = StringBuffer();

    buffer.writeln('Liebe/r Empfänger/in,');
    buffer.writeln();
    buffer.writeln('ich möchte historische Informationen mit Ihnen teilen:');
    buffer.writeln();

    // Füge den Standard-Share-Text hinzu
    buffer.writeln(generateShareTextPublic(item));

    buffer.writeln();
    buffer.writeln('Mit freundlichen Grüßen');

    return buffer.toString();
  }

  /// E-Mail Betreff
  static String _getEmailSubject(dynamic item) {
    if (item is Victim) {
      return 'Historische Information: ${item.surname}, ${item.name}';
    } else if (item is ConcentrationCamp) {
      return 'Gedenkstätte: ${item.type} ${item.name}';
    } else if (item is Commander) {
      return 'Historische Dokumentation: ${item.surname}, ${item.name}';
    }
    return 'Historische Informationen aus ${ShareService.appName}';
  }

  /// Erstellt Betreff für das Teilen (öffentliche Version)
  static String getShareSubjectPublic(dynamic item) {
    if (item is Victim) {
      return 'Erinnerung an ${item.surname}, ${item.name}';
    } else if (item is ConcentrationCamp) {
      return '${item.type} ${item.name}';
    } else if (item is Commander) {
      return 'NS-Kriegsverbrecher: ${item.surname}, ${item.name}';
    }
    return 'Geteilt über ${ShareService.appName}';
  }

  /// Hilfsmethode zum Öffnen von URLs
  static Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('URL kann nicht geöffnet werden: $url');
    }
  }

  /// Generiert eine JSON-Struktur für strukturiertes Teilen
  static Map<String, dynamic> generateStructuredData(dynamic item) {
    final Map<String, dynamic> data = {
      'type': 'historical_record',
      'app': ShareService.appName,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (item is Victim) {
      data.addAll({
        'category': 'victim',
        'person': {
          'name': item.name,
          'surname': item.surname,
          'nationality': item.nationality,
          'birth': item.birth?.toIso8601String(),
          'death': item.death?.toIso8601String(),
          'prisoner_number': item.prisonerNumber,
          'concentration_camp': item.cCamp,
          'fate': item.fate,
        },
      });
    } else if (item is ConcentrationCamp) {
      data.addAll({
        'category': 'concentration_camp',
        'facility': {
          'name': item.name,
          'location': item.location,
          'country': item.country,
          'type': item.type,
          'date_opened': item.dateOpened?.toIso8601String(),
          'liberation_date': item.liberationDate?.toIso8601String(),
          'commander': item.commander,
        },
      });
    } else if (item is Commander) {
      data.addAll({
        'category': 'commander',
        'person': {
          'name': item.name,
          'surname': item.surname,
          'rank': item.rank,
          'birth': item.birth?.toIso8601String(),
          'death': item.death?.toIso8601String(),
          'birthplace': item.birthplace,
          'deathplace': item.deathplace,
        },
      });
    }

    return data;
  }

  /// Erweiterte Share-Optionen Modal
  static Future<void> showExtendedShareOptions(
    BuildContext context,
    dynamic item,
  ) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ExtendedShareOptionsSheet(item: item),
    );
  }
}

/// Enum für Social Media Plattformen
enum SocialMediaPlatform {
  twitter,
  facebook,
  whatsapp,
  telegram,
  email;

  String get displayName {
    switch (this) {
      case SocialMediaPlatform.twitter:
        return 'Twitter';
      case SocialMediaPlatform.facebook:
        return 'Facebook';
      case SocialMediaPlatform.whatsapp:
        return 'WhatsApp';
      case SocialMediaPlatform.telegram:
        return 'Telegram';
      case SocialMediaPlatform.email:
        return 'E-Mail';
    }
  }

  IconData get icon {
    switch (this) {
      case SocialMediaPlatform.twitter:
        return Icons.alternate_email; // Twitter-ähnliches Icon
      case SocialMediaPlatform.facebook:
        return Icons.facebook;
      case SocialMediaPlatform.whatsapp:
        return Icons.chat;
      case SocialMediaPlatform.telegram:
        return Icons.send;
      case SocialMediaPlatform.email:
        return Icons.email;
    }
  }

  Color get color {
    switch (this) {
      case SocialMediaPlatform.twitter:
        return const Color(0xFF1DA1F2);
      case SocialMediaPlatform.facebook:
        return const Color(0xFF4267B2);
      case SocialMediaPlatform.whatsapp:
        return const Color(0xFF25D366);
      case SocialMediaPlatform.telegram:
        return const Color(0xFF0088CC);
      case SocialMediaPlatform.email:
        return const Color(0xFF283A49);
    }
  }
}

/// Erweiterte Share-Optionen Sheet
class _ExtendedShareOptionsSheet extends StatelessWidget {
  final dynamic item;

  const _ExtendedShareOptionsSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Titel
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Teilen via',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Standard Teilen-Optionen
            ListTile(
              leading: const Icon(Icons.share, color: Color(0xFF283A49)),
              title: const Text('Direkt teilen'),
              subtitle: const Text('Verwende das Standard-Share-Menü'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await ShareService.shareItem(item);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Fehler beim Teilen: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),

            const Divider(),

            // Social Media Optionen
            ...SocialMediaPlatform.values.map(
              (platform) => ListTile(
                leading: Icon(platform.icon, color: platform.color),
                title: Text('Via ${platform.displayName}'),
                onTap: () async {
                  Navigator.pop(context);
                  await ExtendedShareService.shareToSocialMedia(
                    context,
                    item,
                    platform,
                  );
                },
              ),
            ),

            const Divider(),

            // Strukturierte Daten
            ListTile(
              leading: const Icon(Icons.data_object, color: Color(0xFF283A49)),
              title: const Text('Als Daten exportieren'),
              subtitle: const Text('JSON-Format für Entwickler'),
              onTap: () async {
                Navigator.pop(context);
                final structuredData =
                    ExtendedShareService.generateStructuredData(item);
                final jsonString = _formatJson(structuredData);
                await Share.share(
                  jsonString,
                  subject: ExtendedShareService.getShareSubjectPublic(item),
                );
              },
            ),

            // Cancel Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Abbrechen'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatJson(Map<String, dynamic> data) {
    // Verwende dart:convert für bessere JSON-Formatierung
    const encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(data);

    final buffer = StringBuffer();
    buffer.writeln('Strukturierte Daten:');
    buffer.writeln();
    buffer.writeln(jsonString);
    return buffer.toString();
  }
}
