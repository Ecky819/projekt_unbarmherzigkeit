import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/profile.dart';

class ShareService {
  static const String appName = 'Projekt Unbarmherzigkeit';
  static const String appUrl =
      'https://unbarmherzigkeit.de'; // Ihre Website URL

  /// Teilt Informationen über einen Eintrag (Opfer, Lager, Kommandant)
  static Future<void> shareItem(
    dynamic item, {
    Rect? sharePositionOrigin,
  }) async {
    try {
      String shareText = _generateShareText(item);

      await Share.share(
        shareText,
        subject: _getShareSubject(item),
        sharePositionOrigin: sharePositionOrigin ?? const Rect.fromLTWH(0, 0, 1, 1),
      );
    } catch (e) {
      debugPrint('Fehler beim Teilen: $e');
      throw ShareException('Teilen fehlgeschlagen: $e');
    }
  }

  /// Teilt Informationen mit zusätzlichen Optionen
  static Future<void> shareItemWithOptions(
    BuildContext context,
    dynamic item,
  ) async {
    try {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => _ShareOptionsSheet(item: item),
      );
    } catch (e) {
      debugPrint('Fehler beim Anzeigen der Teilen-Optionen: $e');
    }
  }

  /// Generiert den Haupttext für das Teilen
  static String _generateShareText(dynamic item) {
    if (item is Victim) {
      return _generateVictimShareText(item);
    } else if (item is ConcentrationCamp) {
      return _generateCampShareText(item);
    } else if (item is Commander) {
      return _generateCommanderShareText(item);
    }
    return 'Geteilt über $appName';
  }

  /// Generiert Share-Text für Opfer
  static String _generateVictimShareText(Victim victim) {
    final buffer = StringBuffer();

    buffer.writeln('🕯️ Erinnerung an ein Opfer der NS-Zeit');
    buffer.writeln();
    buffer.writeln('${victim.surname}, ${victim.name}');

    if (victim.birth != null || victim.death != null) {
      buffer.write('Lebensdaten: ');
      if (victim.birth != null) {
        buffer.write(_formatDate(victim.birth!));
      } else {
        buffer.write('unbekannt');
      }
      buffer.write(' - ');
      if (victim.death != null) {
        buffer.write(_formatDate(victim.death!));
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
    buffer.writeln('Quelle: $appName');
    buffer.writeln('Weitere Informationen: $appUrl');

    return buffer.toString();
  }

  /// Generiert Share-Text für Konzentrationslager
  static String _generateCampShareText(ConcentrationCamp camp) {
    final buffer = StringBuffer();

    buffer.writeln('🏛️ ${camp.type} ${camp.name}');
    buffer.writeln();
    buffer.writeln('Standort: ${camp.location}, ${camp.country}');

    if (camp.dateOpened != null || camp.liberationDate != null) {
      buffer.write('Betriebszeit: ');
      if (camp.dateOpened != null) {
        buffer.write(_formatDate(camp.dateOpened!));
      } else {
        buffer.write('unbekannt');
      }
      buffer.write(' - ');
      if (camp.liberationDate != null) {
        buffer.write(_formatDate(camp.liberationDate!));
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
    buffer.writeln('Quelle: $appName');
    buffer.writeln('Weitere Informationen: $appUrl');

    return buffer.toString();
  }

  /// Generiert Share-Text für Kommandanten
  static String _generateCommanderShareText(Commander commander) {
    final buffer = StringBuffer();

    buffer.writeln('⚔️ NS-Kriegsverbrecher');
    buffer.writeln();
    buffer.writeln('${commander.surname}, ${commander.name}');
    buffer.writeln('Rang: ${commander.rank}');

    if (commander.birth != null || commander.death != null) {
      buffer.write('Lebensdaten: ');
      if (commander.birth != null) {
        buffer.write(_formatDate(commander.birth!));
      } else {
        buffer.write('unbekannt');
      }
      buffer.write(' - ');
      if (commander.death != null) {
        buffer.write(_formatDate(commander.death!));
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
    buffer.writeln('Quelle: $appName');
    buffer.writeln('Weitere Informationen: $appUrl');

    return buffer.toString();
  }

  /// Erstellt Betreff für das Teilen
  static String _getShareSubject(dynamic item) {
    if (item is Victim) {
      return 'Erinnerung an ${item.surname}, ${item.name}';
    } else if (item is ConcentrationCamp) {
      return '${item.type} ${item.name}';
    } else if (item is Commander) {
      return 'NS-Kriegsverbrecher: ${item.surname}, ${item.name}';
    }
    return 'Geteilt über $appName';
  }

  /// Formatiert Datum für die Ausgabe
  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  /// Teilt nur als Text (für spezielle Anwendungsfälle)
  static Future<void> shareAsText(String text, {String? subject, Rect? sharePositionOrigin}) async {
    try {
      await Share.share(text, subject: subject, sharePositionOrigin: sharePositionOrigin ?? const Rect.fromLTWH(0, 0, 1, 1));
    } catch (e) {
      throw ShareException('Text-Teilen fehlgeschlagen: $e');
    }
  }

  /// Öffnet eine URL zum Teilen (für Webversion)
  static Future<void> shareViaUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw ShareException('URL kann nicht geöffnet werden: $url');
      }
    } catch (e) {
      throw ShareException('URL-Teilen fehlgeschlagen: $e');
    }
  }

  /// Generiert eine teilbare URL (falls Sie eine Webversion haben)
  static String generateShareableUrl(dynamic item) {
    String itemType = '';
    String itemId = '';

    if (item is Victim) {
      itemType = 'victim';
      itemId = item.victimId;
    } else if (item is ConcentrationCamp) {
      itemType = 'camp';
      itemId = item.campId;
    } else if (item is Commander) {
      itemType = 'commander';
      itemId = item.commanderId;
    }

    return '$appUrl/detail/$itemType/$itemId';
  }
}

/// Custom Exception für Share-Fehler
class ShareException implements Exception {
  final String message;
  ShareException(this.message);

  @override
  String toString() => 'ShareException: $message';
}

/// Modal Sheet für erweiterte Teilen-Optionen
class _ShareOptionsSheet extends StatelessWidget {
  final dynamic item;

  const _ShareOptionsSheet({required this.item});

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
                'Teilen',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Teilen-Optionen
            ListTile(
              leading: const Icon(Icons.share, color: Color(0xFF283A49)),
              title: const Text('Als Text teilen'),
              subtitle: const Text(
                'Teilt die Informationen als formatierter Text',
              ),
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

            if (ShareService.generateShareableUrl(item).isNotEmpty)
              ListTile(
                leading: const Icon(Icons.link, color: Color(0xFF283A49)),
                title: const Text('Link teilen'),
                subtitle: const Text('Teilt einen Link zu diesem Eintrag'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final url = ShareService.generateShareableUrl(item);
                    await ShareService.shareAsText(
                      'Mehr erfahren: $url\n\nGeteilt über ${ShareService.appName}',
                      subject: ShareService._getShareSubject(item),
                    );
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
}
