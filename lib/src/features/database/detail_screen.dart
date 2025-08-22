import 'package:flutter/material.dart';
import '../../data/profile.dart';
import '../../common/favorite_button.dart';

class DetailScreen extends StatelessWidget {
  final dynamic item;

  const DetailScreen({super.key, required this.item});

  String _getTitle() {
    if (item is Victim) {
      return '${item.surname}, ${item.name}';
    } else if (item is ConcentrationCamp) {
      return item.name;
    } else if (item is Commander) {
      return '${item.surname}, ${item.name}';
    }
    return 'Details';
  }

  String _getItemId() {
    if (item is Victim) {
      return item.victim_id.toString();
    } else if (item is ConcentrationCamp) {
      return item.camp_id.toString();
    } else if (item is Commander) {
      return item.commander_id.toString();
    }
    return '0';
  }

  String _getItemType() {
    if (item is Victim) {
      return 'victim';
    } else if (item is ConcentrationCamp) {
      return 'camp';
    } else if (item is Commander) {
      return 'commander';
    }
    return 'unknown';
  }

  IconData _getIcon() {
    if (item is Victim) {
      return Icons.person;
    } else if (item is ConcentrationCamp) {
      return Icons.location_city;
    } else if (item is Commander) {
      return Icons.military_tech;
    }
    return Icons.info;
  }

  Color _getIconColor() {
    if (item is Victim) {
      return Color.fromRGBO(40, 58, 73, 1.0);
    } else if (item is ConcentrationCamp) {
      return Colors.black54;
    } else if (item is Commander) {
      return Colors.black87;
    }
    return Colors.grey;
  }

  String? _getImagePath() {
    if (item is Victim) {
      return (item as Victim).imagePath;
    } else if (item is ConcentrationCamp) {
      return (item as ConcentrationCamp).imagePath;
    } else if (item is Commander) {
      return (item as Commander).imagePath;
    }
    return null;
  }

  String? _getImageDescription() {
    if (item is Victim) {
      return (item as Victim).imageDescription;
    } else if (item is ConcentrationCamp) {
      return (item as ConcentrationCamp).imageDescription;
    } else if (item is Commander) {
      return (item as Commander).imageDescription;
    }
    return null;
  }

  String? _getImageSource() {
    if (item is Victim) {
      return (item as Victim).imageSource;
    } else if (item is ConcentrationCamp) {
      return (item as ConcentrationCamp).imageSource;
    } else if (item is Commander) {
      return (item as Commander).imageSource;
    }
    return null;
  }

  Widget _buildImageWithCaption() {
    final imagePath = _getImagePath();
    final imageDescription = _getImageDescription();
    final imageSource = _getImageSource();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Das Bild
        _buildImageWidget(),

        // Bildbeschreibung und Quelle (falls vorhanden)
        if (imagePath != null && imagePath.isNotEmpty) ...[
          const SizedBox(height: 12),
          Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color.fromRGBO(243, 239, 231, 1.0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bildbeschreibung
                  if (imageDescription != null &&
                      imageDescription.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      imageDescription,
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'SFPro',
                        height: 1.4,
                      ),
                    ),
                  ],

                  // Quellenangabe
                  if (imageSource != null && imageSource.isNotEmpty) ...[
                    if (imageDescription != null && imageDescription.isNotEmpty)
                      const SizedBox(height: 8),
                    Text(
                      'Quelle:',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                        fontFamily: 'SFPro',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      imageSource,
                      style: TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                        fontFamily: 'SFPro',
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImageWidget() {
    final imagePath = _getImagePath();

    // Bestimme Abmessungen basierend auf dem Typ
    double imageHeight;
    double? imageWidth;

    if (item is Victim || item is Commander) {
      // Hochformat für Porträts (3:4 Verhältnis)
      imageHeight = 280;
      imageWidth = 210;
    } else {
      // Querformat für Lager (Landschaftsbilder)
      imageHeight = 200;
      imageWidth = double.infinity;
    }

    if (imagePath == null || imagePath.isEmpty) {
      return Center(
        child: Container(
          height: imageHeight,
          width: imageWidth,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIcon(),
                size: 64,
                color: _getIconColor().withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Kein Bild verfügbar',
                style: TextStyle(color: Colors.grey[600], fontFamily: 'SFPro'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Container(
        height: imageHeight,
        width: imageWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      'Bild konnte nicht geladen werden',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'SFPro',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              fontFamily: 'SFPro',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontFamily: 'SFPro'),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(String label, DateTime? date) {
    if (date == null) return const SizedBox.shrink();

    return _buildDetailRow(label, '${date.day}.${date.month}.${date.year}');
  }

  Widget _buildBooleanRow(String label, bool value) {
    return _buildDetailRow(label, value ? 'Ja' : 'Nein');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: const Color(0xFF283A49),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Favoriten-Button in der AppBar
          FavoriteButton(
            itemId: _getItemId(),
            itemType: _getItemType(),
            itemTitle: _getTitle(),
            size: 28.0,
            favoriteColor: Colors.red[400],
            notFavoriteColor: Colors.white70,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bild mit Beschriftung
              _buildImageWithCaption(),
              const SizedBox(height: 24),

              // Header mit Icon, Titel und Favorit-Button
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(_getIcon(), size: 48, color: _getIconColor()),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getTitle(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SFPro',
                            ),
                          ),
                          Text(
                            _getSubtitle(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontFamily: 'SFPro',
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Großer Favoriten-Button im Header
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FavoriteButton(
                        itemId: _getItemId(),
                        itemType: _getItemType(),
                        itemTitle: _getTitle(),
                        size: 32.0,
                        favoriteColor: Colors.red,
                        notFavoriteColor: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),

              // Details basierend auf Typ
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item is Victim) ..._buildVictimDetails(),
                    if (item is ConcentrationCamp) ..._buildCampDetails(),
                    if (item is Commander) ..._buildCommanderDetails(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSubtitle() {
    if (item is Victim) {
      return 'Opfer';
    } else if (item is ConcentrationCamp) {
      return 'Konzentrationslager';
    } else if (item is Commander) {
      return 'Kommandant';
    }
    return '';
  }

  List<Widget> _buildVictimDetails() {
    final victim = item as Victim;
    return [
      const Text(
        'Persönliche Daten',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFPro',
        ),
      ),
      const SizedBox(height: 16),
      _buildDetailRow('Nachname', victim.surname),
      _buildDetailRow('Vorname', victim.name),
      _buildDetailRow('Häflingsnummer', victim.prisoner_number?.toString()),
      _buildDateRow('Geburtsdatum', victim.birth),
      _buildDetailRow('Geburtsort', victim.birthplace),
      _buildDateRow('Sterbedatum', victim.death),
      _buildDetailRow('Sterbeort', victim.deathplace),
      _buildDetailRow('Nationalität', victim.nationality),
      _buildDetailRow('Religion', victim.religion),
      _buildDetailRow('Beruf', victim.occupation),

      const SizedBox(height: 24),
      const Text(
        'Verfolgung und Schicksal',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFPro',
        ),
      ),
      const SizedBox(height: 16),
      _buildDetailRow('Konzentrationslager', victim.c_camp),
      _buildDateRow('Einlieferungsdatum', victim.env_date),
      _buildDetailRow('Schicksal', victim.fate),
      _buildBooleanRow('Sterbeurkunde vorhanden', victim.death_certificate),
    ];
  }

  List<Widget> _buildCampDetails() {
    final camp = item as ConcentrationCamp;
    return [
      const Text(
        'Lagerinformationen',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFPro',
        ),
      ),
      const SizedBox(height: 16),
      _buildDetailRow('Name', camp.name),
      _buildDetailRow('Ort', camp.location),
      _buildDetailRow('Land', camp.country),
      _buildDetailRow('Typ', camp.type),
      _buildDateRow('Eröffnet', camp.date_opened),
      _buildDateRow('Befreit', camp.liberation_date),
      _buildDetailRow('Kommandant', camp.commander),

      const SizedBox(height: 24),
      const Text(
        'Beschreibung',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFPro',
        ),
      ),
      const SizedBox(height: 16),
      _buildDetailRow('Beschreibung', camp.description),
    ];
  }

  List<Widget> _buildCommanderDetails() {
    final commander = item as Commander;
    return [
      const Text(
        'Persönliche Daten',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFPro',
        ),
      ),
      const SizedBox(height: 16),
      _buildDetailRow('Nachname', commander.surname),
      _buildDetailRow('Vorname', commander.name),
      _buildDetailRow('Letzter Rang', commander.rank),
      _buildDateRow('Geburtsdatum', commander.birth),
      _buildDetailRow('Geburtsort', commander.birthplace),
      _buildDateRow('Sterbedatum', commander.death),
      _buildDetailRow('Sterbeort', commander.deathplace),

      const SizedBox(height: 24),
      const Text(
        'Beschreibung',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFPro',
        ),
      ),
      const SizedBox(height: 16),
      _buildDetailRow('Beschreibung', commander.description),
    ];
  }
}
