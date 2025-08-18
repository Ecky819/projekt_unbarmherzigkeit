import 'package:flutter/material.dart';
import '../../data/profile.dart';
import '../../data/databaseRepository.dart';
import '../../data/MockDatabaseRepository.dart';
import '../../common/custom_appbar.dart';
import 'detail_screen.dart';

class DatabaseScreen extends StatefulWidget {
  final DatabaseRepository? repository;

  const DatabaseScreen({super.key, this.repository});

  @override
  State<DatabaseScreen> createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  final TextEditingController _ortController = TextEditingController();
  final TextEditingController _ereignisController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jahrController = TextEditingController();

  late DatabaseRepository _repository;
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  bool _showSearchFields = true; // Neue Variable für Suchfelder-Sichtbarkeit

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? MockDatabaseRepository();
  }

  @override
  void dispose() {
    _ortController.dispose();
    _ereignisController.dispose();
    _nameController.dispose();
    _jahrController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
      _searchResults.clear();
    });

    try {
      // Hole alle Daten aus allen Kategorien
      final victims = await _repository.getVictims();
      final camps = await _repository.getConcentrationCamps();
      final commanders = await _repository.getCommanders();

      List<dynamic> allResults = [...victims, ...camps, ...commanders];

      // Filtere die Ergebnisse basierend auf den Suchkriterien
      _searchResults = _filterResults(allResults);

      // Blende Suchfelder aus, wenn Ergebnisse gefunden wurden
      if (_searchResults.isNotEmpty) {
        _showSearchFields = false;
      }

      print('Suche mit folgenden Parametern:');
      print('Ort: ${_ortController.text}');
      print('Ereignis: ${_ereignisController.text}');
      print('Name: ${_nameController.text}');
      print('Jahr: ${_jahrController.text}');
      print('Gefundene Ergebnisse: ${_searchResults.length}');
    } catch (e) {
      print('Fehler beim Suchen: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler beim Suchen: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<dynamic> _filterResults(List<dynamic> results) {
    final ortQuery = _ortController.text.toLowerCase().trim();
    final ereignisQuery = _ereignisController.text.toLowerCase().trim();
    final nameQuery = _nameController.text.toLowerCase().trim();
    final jahrQuery = _jahrController.text.trim();

    return results.where((item) {
      // Ort-Filter: Hauptsächlich für Konzentrationslager, aber auch Geburts-/Sterbeorte
      if (ortQuery.isNotEmpty) {
        bool ortMatch = false;

        if (item is ConcentrationCamp) {
          // Priorität auf Lager-Standorte
          ortMatch =
              item.location.toLowerCase().contains(ortQuery) ||
              item.country.toLowerCase().contains(ortQuery) ||
              item.name.toLowerCase().contains(ortQuery);
        } else if (item is Victim) {
          // Sekundär: Geburts- und Sterbeorte von Opfern
          if (item.birthplace != null) {
            ortMatch = item.birthplace!.toLowerCase().contains(ortQuery);
          }
          if (!ortMatch && item.deathplace != null) {
            ortMatch = item.deathplace!.toLowerCase().contains(ortQuery);
          }
          // Auch das Lager, in dem das Opfer war
          if (!ortMatch && item.c_camp.isNotEmpty) {
            ortMatch = item.c_camp.toLowerCase().contains(ortQuery);
          }
        } else if (item is Commander) {
          // Tertiär: Geburts- und Sterbeorte von Kommandanten
          if (item.birthplace != null) {
            ortMatch = item.birthplace!.toLowerCase().contains(ortQuery);
          }
          if (!ortMatch && item.deathplace != null) {
            ortMatch = item.deathplace!.toLowerCase().contains(ortQuery);
          }
        }

        if (!ortMatch) return false;
      }

      // Name-Filter: Hauptsächlich für Opfer, aber auch andere Personen und Lager
      if (nameQuery.isNotEmpty) {
        bool nameMatch = false;

        if (item is Victim) {
          // Priorität auf Opfer-Namen
          nameMatch =
              item.name.toLowerCase().contains(nameQuery) ||
              item.surname.toLowerCase().contains(nameQuery);
        } else if (item is Commander) {
          // Sekundär: Kommandanten-Namen
          nameMatch =
              item.name.toLowerCase().contains(nameQuery) ||
              item.surname.toLowerCase().contains(nameQuery);
        } else if (item is ConcentrationCamp) {
          // Tertiär: Lager-Namen oder Kommandant des Lagers
          nameMatch =
              item.name.toLowerCase().contains(nameQuery) ||
              item.commander.toLowerCase().contains(nameQuery);
        }

        if (!nameMatch) return false;
      }

      // Ereignis-Filter: Für Lager-Typen und Schicksale
      if (ereignisQuery.isNotEmpty) {
        bool ereignisMatch = false;

        if (item is ConcentrationCamp) {
          ereignisMatch =
              item.type.toLowerCase().contains(ereignisQuery) ||
              item.description.toLowerCase().contains(ereignisQuery);
        } else if (item is Victim) {
          ereignisMatch =
              item.fate.toLowerCase().contains(ereignisQuery) ||
              item.occupation.toLowerCase().contains(ereignisQuery) ||
              item.religion.toLowerCase().contains(ereignisQuery);
        } else if (item is Commander) {
          ereignisMatch =
              item.rank.toLowerCase().contains(ereignisQuery) ||
              item.description.toLowerCase().contains(ereignisQuery);
        }

        if (!ereignisMatch) return false;
      }

      // Jahr-Filter: Umfassende Suche in allen Jahresangaben
      if (jahrQuery.isNotEmpty) {
        final searchYear = int.tryParse(jahrQuery);
        if (searchYear != null) {
          bool jahrMatch = false;

          if (item is Victim) {
            // Geburts- und Sterbejahr von Opfern
            if (item.birth != null && item.birth!.year == searchYear) {
              jahrMatch = true;
            }
            if (!jahrMatch &&
                item.death != null &&
                item.death!.year == searchYear) {
              jahrMatch = true;
            }
          } else if (item is ConcentrationCamp) {
            // Eröffnungs- und Befreiungsdatum von Lagern
            if (item.date_opened != null &&
                item.date_opened!.year == searchYear) {
              jahrMatch = true;
            }
            if (!jahrMatch &&
                item.liberation_date != null &&
                item.liberation_date!.year == searchYear) {
              jahrMatch = true;
            }
          } else if (item is Commander) {
            // Geburts- und Sterbejahr von Kommandanten
            if (item.birth != null && item.birth!.year == searchYear) {
              jahrMatch = true;
            }
            if (!jahrMatch &&
                item.death != null &&
                item.death!.year == searchYear) {
              jahrMatch = true;
            }
          }

          if (!jahrMatch) return false;
        }
      }

      return true;
    }).toList();
  }

  void _clearSearch() {
    setState(() {
      _ortController.clear();
      _ereignisController.clear();
      _nameController.clear();
      _jahrController.clear();
      _searchResults.clear();
      _showSearchFields = true; // Zeige Suchfelder wieder an beim Zurücksetzen
    });
  }

  void _toggleSearchFields() {
    setState(() {
      _showSearchFields = !_showSearchFields;
    });
  }

  Widget _buildSearchField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'SFPro',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontFamily: 'SFPro'),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontFamily: 'SFPro',
              ),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: Icon(Icons.search, color: Colors.grey[400]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(dynamic item) {
    if (item is Victim) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: const Icon(
            Icons.person,
            color: Color.fromRGBO(40, 58, 73, 1.0),
          ),
          title: Text('${item.surname}, ${item.name}'),
          subtitle: item.birth != null
              ? Text(
                  'Geboren: ${item.birth!.day}.${item.birth!.month}.${item.birth!.year}',
                )
              : const Text('Geburtsdatum unbekannt'),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () => _navigateToDetailPage(item),
        ),
      );
    } else if (item is ConcentrationCamp) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: const Icon(Icons.location_city, color: Colors.black54),
          title: Text(item.name),
          subtitle: Text(item.type.isNotEmpty ? item.type : 'Typ unbekannt'),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () => _navigateToDetailPage(item),
        ),
      );
    } else if (item is Commander) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: const Icon(Icons.military_tech, color: Colors.black87),
          title: Text('${item.surname}, ${item.name}'),
          subtitle: item.birth != null
              ? Text(
                  'Geboren: ${item.birth!.day}.${item.birth!.month}.${item.birth!.year}',
                )
              : const Text('Geburtsdatum unbekannt'),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () => _navigateToDetailPage(item),
        ),
      );
    }
    return Container();
  }

  void _navigateToDetailPage(dynamic item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(233, 229, 221, 1.0),
      appBar: CustomAppBar(
        context: context,
        pageIndex: 1, // Index für Database-Seite
        title: 'Datenbank',
        navigateTo: (desc) {}, // KORRIGIERT: Komma entfernt
        nav: [], // Leere Liste, da wir keine andere Navigation brauchen
        onBackPressed: () =>
            Navigator.pop(context), // Zurück zur vorherigen Seite
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Toggle-Button für Suchfelder (nur anzeigen wenn Ergebnisse vorhanden sind)
            if (!_showSearchFields && _searchResults.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: _toggleSearchFields,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Suche einblenden',
                          style: TextStyle(
                            fontFamily: 'SFPro',
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                      ],
                    ),
                  ),
                ),
              ),

            // Suchfelder (nur anzeigen wenn _showSearchFields true ist)
            if (_showSearchFields) ...[
              _buildSearchField(
                label: 'Name',
                hint: 'Name von Opfern, Kommandanten oder Lagern',
                controller: _nameController,
              ),
              // Suchfelder mit spezifischen Hinweisen
              _buildSearchField(
                label: 'Ort',
                hint: 'Lagerstandort, Geburts-/Sterbeort',
                controller: _ortController,
              ),
              _buildSearchField(
                label: 'Jahr',
                hint: 'Geburts-/Sterbe-/Eröffnungs-/Befreiungsjahr',
                controller: _jahrController,
                keyboardType: TextInputType.number,
              ),
              _buildSearchField(
                label: 'Ereignis/Typ',
                hint: 'Lagertyp, Schicksal, Beruf, Religion',
                controller: _ereignisController,
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _performSearch,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Suchen',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'SFPro',
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearSearch,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Zurücksetzen',
                        style: TextStyle(fontSize: 16, fontFamily: 'SFPro'),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],

            // Ausblenden-Button (nur anzeigen wenn Suchfelder sichtbar sind und Ergebnisse vorhanden)
            if (_showSearchFields && _searchResults.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: _toggleSearchFields,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Suche ausblenden',
                          style: TextStyle(
                            fontFamily: 'SFPro',
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.keyboard_arrow_up, color: Colors.black54),
                      ],
                    ),
                  ),
                ),
              ),

            // Suchergebnisse
            Expanded(
              child: _searchResults.isEmpty && !_isLoading
                  ? const Center(
                      child: Text(
                        'Geben Sie Suchbegriffe ein und drücken Sie "Suchen".\n\n'
                        'Ort: Findet hauptsächlich Lager und deren Standorte\n'
                        'Name: Findet hauptsächlich Opfer und Personen\n'
                        'Jahr: Durchsucht alle Jahresangaben\n'
                        'Ereignis: Findet Lagertypen, Schicksale, etc.',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'SFPro',
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Column(
                      children: [
                        // Ergebnisanzahl anzeigen
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '${_searchResults.length} Ergebnis${_searchResults.length != 1 ? 'se' : ''} gefunden',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'SFPro',
                              color: Color.fromARGB(255, 101, 101, 101),
                            ),
                          ),
                        ),
                        // Ergebnisliste
                        Expanded(
                          child: ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              return _buildResultItem(_searchResults[index]);
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
