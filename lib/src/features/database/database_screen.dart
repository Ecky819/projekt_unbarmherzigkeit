import 'package:flutter/material.dart';
import '../../data/profile.dart';
import '../../data/databaseRepository.dart';
import '../../data/MockDatabaseRepository.dart';
import '../../common/custom_appbar.dart';
import '../../common/favorite_button.dart';
import 'detail_screen.dart';

// Enum für Sortieroptionen
enum SortOption {
  nameAsc('Name (A-Z)'),
  nameDesc('Name (Z-A)'),
  dateAsc('Datum (alt-neu)'),
  dateDesc('Datum (neu-alt)'),
  typeAsc('Typ (A-Z)'),
  typeDesc('Typ (Z-A)');

  const SortOption(this.displayName);
  final String displayName;
}

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
  List<dynamic> _sortedResults = [];
  bool _isLoading = false;
  bool _showSearchFields = true;

  // Sortier-Variablen
  SortOption _currentSort = SortOption.nameAsc;
  bool _showSortOptions = false;

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
      _sortedResults.clear();
    });

    try {
      // Hole alle Daten aus allen Kategorien
      final victims = await _repository.getVictims();
      final camps = await _repository.getConcentrationCamps();
      final commanders = await _repository.getCommanders();

      List<dynamic> allResults = [...victims, ...camps, ...commanders];

      // Filtere die Ergebnisse basierend auf den Suchkriterien
      _searchResults = _filterResults(allResults);

      // Sortiere die Ergebnisse
      _applySorting();

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

  void _applySorting() {
    _sortedResults = List.from(_searchResults);

    switch (_currentSort) {
      case SortOption.nameAsc:
        _sortedResults.sort((a, b) => _getName(a).compareTo(_getName(b)));
        break;
      case SortOption.nameDesc:
        _sortedResults.sort((a, b) => _getName(b).compareTo(_getName(a)));
        break;
      case SortOption.dateAsc:
        _sortedResults.sort((a, b) => _compareDate(a, b, ascending: true));
        break;
      case SortOption.dateDesc:
        _sortedResults.sort((a, b) => _compareDate(a, b, ascending: false));
        break;
      case SortOption.typeAsc:
        _sortedResults.sort((a, b) => _getType(a).compareTo(_getType(b)));
        break;
      case SortOption.typeDesc:
        _sortedResults.sort((a, b) => _getType(b).compareTo(_getType(a)));
        break;
    }
  }

  String _getName(dynamic item) {
    if (item is Victim) {
      return '${item.surname}, ${item.name}';
    } else if (item is ConcentrationCamp) {
      return item.name;
    } else if (item is Commander) {
      return '${item.surname}, ${item.name}';
    }
    return '';
  }

  String _getType(dynamic item) {
    if (item is Victim) {
      return 'A_Opfer'; // Prefix für konsistente Sortierung
    } else if (item is ConcentrationCamp) {
      return 'B_Lager';
    } else if (item is Commander) {
      return 'C_Kommandant';
    }
    return 'Z_Unbekannt';
  }

  int _compareDate(dynamic a, dynamic b, {required bool ascending}) {
    DateTime? dateA = _getPrimaryDate(a);
    DateTime? dateB = _getPrimaryDate(b);

    // Elemente ohne Datum ans Ende sortieren
    if (dateA == null && dateB == null) return 0;
    if (dateA == null) return 1;
    if (dateB == null) return -1;

    return ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
  }

  DateTime? _getPrimaryDate(dynamic item) {
    if (item is Victim) {
      return item.birth ??
          item.death; // Bevorzuge Geburtsdatum, dann Sterbedatum
    } else if (item is ConcentrationCamp) {
      return item.date_opened ?? item.liberation_date;
    } else if (item is Commander) {
      return item.birth ?? item.death;
    }
    return null;
  }

  void _changeSorting(SortOption newSort) {
    setState(() {
      _currentSort = newSort;
      _showSortOptions = false;
      _applySorting();
    });
  }

  List<dynamic> _filterResults(List<dynamic> results) {
    final ortQuery = _ortController.text.toLowerCase().trim();
    final ereignisQuery = _ereignisController.text.toLowerCase().trim();
    final nameQuery = _nameController.text.toLowerCase().trim();
    final jahrQuery = _jahrController.text.trim();

    return results.where((item) {
      // Ort-Filter
      if (ortQuery.isNotEmpty) {
        bool ortMatch = false;

        if (item is ConcentrationCamp) {
          ortMatch =
              item.location.toLowerCase().contains(ortQuery) ||
              item.country.toLowerCase().contains(ortQuery) ||
              item.name.toLowerCase().contains(ortQuery);
        } else if (item is Victim) {
          if (item.birthplace != null) {
            ortMatch = item.birthplace!.toLowerCase().contains(ortQuery);
          }
          if (!ortMatch && item.deathplace != null) {
            ortMatch = item.deathplace!.toLowerCase().contains(ortQuery);
          }
          if (!ortMatch && item.c_camp.isNotEmpty) {
            ortMatch = item.c_camp.toLowerCase().contains(ortQuery);
          }
        } else if (item is Commander) {
          if (item.birthplace != null) {
            ortMatch = item.birthplace!.toLowerCase().contains(ortQuery);
          }
          if (!ortMatch && item.deathplace != null) {
            ortMatch = item.deathplace!.toLowerCase().contains(ortQuery);
          }
        }

        if (!ortMatch) return false;
      }

      // Name-Filter
      if (nameQuery.isNotEmpty) {
        bool nameMatch = false;

        if (item is Victim) {
          nameMatch =
              item.name.toLowerCase().contains(nameQuery) ||
              item.surname.toLowerCase().contains(nameQuery);
        } else if (item is Commander) {
          nameMatch =
              item.name.toLowerCase().contains(nameQuery) ||
              item.surname.toLowerCase().contains(nameQuery);
        } else if (item is ConcentrationCamp) {
          nameMatch =
              item.name.toLowerCase().contains(nameQuery) ||
              item.commander.toLowerCase().contains(nameQuery);
        }

        if (!nameMatch) return false;
      }

      // Ereignis-Filter
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

      // Jahr-Filter
      if (jahrQuery.isNotEmpty) {
        final searchYear = int.tryParse(jahrQuery);
        if (searchYear != null) {
          bool jahrMatch = false;

          if (item is Victim) {
            if (item.birth != null && item.birth!.year == searchYear) {
              jahrMatch = true;
            }
            if (!jahrMatch &&
                item.death != null &&
                item.death!.year == searchYear) {
              jahrMatch = true;
            }
          } else if (item is ConcentrationCamp) {
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
      _sortedResults.clear();
      _showSearchFields = true;
      _currentSort = SortOption.nameAsc; // Reset Sortierung
    });
  }

  void _toggleSearchFields() {
    setState(() {
      _showSearchFields = !_showSearchFields;
    });
  }

  String _getItemId(dynamic item) {
    if (item is Victim) {
      return item.victim_id.toString();
    } else if (item is ConcentrationCamp) {
      return item.camp_id.toString();
    } else if (item is Commander) {
      return item.commander_id.toString();
    }
    return '0';
  }

  String _getItemType(dynamic item) {
    if (item is Victim) {
      return 'victim';
    } else if (item is ConcentrationCamp) {
      return 'camp';
    } else if (item is Commander) {
      return 'commander';
    }
    return 'unknown';
  }

  String _getItemTitle(dynamic item) {
    if (item is Victim) {
      return '${item.surname}, ${item.name}';
    } else if (item is ConcentrationCamp) {
      return item.name;
    } else if (item is Commander) {
      return '${item.surname}, ${item.name}';
    }
    return 'Unbekannt';
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

  Widget _buildSortButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.sort, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Sortiert nach: ${_currentSort.displayName}',
                    style: const TextStyle(fontSize: 14, fontFamily: 'SFPro'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _showSortOptions = !_showSortOptions;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(40, 58, 73, 1.0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _showSortOptions ? Icons.expand_less : Icons.expand_more,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOptions() {
    if (!_showSortOptions) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: SortOption.values.map((option) {
          final isSelected = option == _currentSort;
          return InkWell(
            onTap: () => _changeSorting(option),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromRGBO(40, 58, 73, 1.0).withOpacity(0.1)
                    : null,
                border: option != SortOption.values.last
                    ? Border(bottom: BorderSide(color: Colors.grey[200]!))
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? const Color.fromRGBO(40, 58, 73, 1.0)
                        : Colors.grey[400],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option.displayName,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SFPro',
                        color: isSelected
                            ? const Color.fromRGBO(40, 58, 73, 1.0)
                            : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check,
                      color: Color.fromRGBO(40, 58, 73, 1.0),
                      size: 18,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FavoriteIconButton(
                itemId: _getItemId(item),
                itemType: _getItemType(item),
                itemTitle: _getItemTitle(item),
              ),
              const Icon(Icons.chevron_right, size: 20),
            ],
          ),
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FavoriteIconButton(
                itemId: _getItemId(item),
                itemType: _getItemType(item),
                itemTitle: _getItemTitle(item),
              ),
              const Icon(Icons.chevron_right, size: 20),
            ],
          ),
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FavoriteIconButton(
                itemId: _getItemId(item),
                itemType: _getItemType(item),
                itemTitle: _getItemTitle(item),
              ),
              const Icon(Icons.chevron_right, size: 20),
            ],
          ),
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
    final displayResults = _sortedResults.isNotEmpty
        ? _sortedResults
        : _searchResults;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(233, 229, 221, 1.0),
      appBar: CustomAppBar(
        context: context,
        pageIndex: 1,
        title: 'Datenbank',
        navigateTo: (desc) {},
        nav: const [],
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Toggle-Button für Suchfelder
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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

            // Suchfelder
            if (_showSearchFields) ...[
              _buildSearchField(
                label: 'Name',
                hint: 'Name von Opfern, Kommandanten oder Lagern',
                controller: _nameController,
              ),
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

            // Ausblenden-Button
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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

            // Sortier-Optionen (nur wenn Ergebnisse vorhanden)
            if (_searchResults.isNotEmpty) ...[
              _buildSortButton(),
              _buildSortOptions(),
            ],

            // Suchergebnisse
            Expanded(
              child: displayResults.isEmpty && !_isLoading
                  ? const Center(
                      child: Text(
                        'Geben Sie Suchbegriffe ein und drücken Sie "Suchen".\n\n'
                        'Ort: Findet hauptsächlich Lager und deren Standorte\n'
                        'Name: Findet hauptsächlich Opfer und Personen\n'
                        'Jahr: Durchsucht alle Jahresangaben\n'
                        'Ereignis: Findet Lagertypen, Schicksale, etc.\n\n'
                        'Tipp: Verwenden Sie das ♡ Symbol um Einträge zu favorisieren!',
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
                        // Ergebnisanzahl und Sortierung anzeigen
                        if (displayResults.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${displayResults.length} Ergebnis${displayResults.length != 1 ? 'se' : ''} gefunden',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'SFPro',
                                    color: Color.fromARGB(255, 101, 101, 101),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.bookmark_border,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Zum Favorisieren',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontFamily: 'SFPro',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        // Ergebnisliste
                        Expanded(
                          child: ListView.builder(
                            itemCount: displayResults.length,
                            itemBuilder: (context, index) {
                              return _buildResultItem(displayResults[index]);
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
