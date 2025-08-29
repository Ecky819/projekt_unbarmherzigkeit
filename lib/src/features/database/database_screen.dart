import 'package:flutter/material.dart';
import '../../data/profile.dart';
import '../../data/database_repository.dart';
import '../../data/mockdatabase_repository.dart';
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

// Search Query Klasse für saubere Parameter-Übergabe
class SearchQuery {
  final String name;
  final String location;
  final String year;
  final String event;
  final SortOption sortOption;

  const SearchQuery({
    this.name = '',
    this.location = '',
    this.year = '',
    this.event = '',
    this.sortOption = SortOption.nameAsc,
  });

  SearchQuery copyWith({
    String? name,
    String? location,
    String? year,
    String? event,
    SortOption? sortOption,
  }) {
    return SearchQuery(
      name: name ?? this.name,
      location: location ?? this.location,
      year: year ?? this.year,
      event: event ?? this.event,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  bool get isEmpty =>
      name.isEmpty && location.isEmpty && year.isEmpty && event.isEmpty;
  bool get isNotEmpty => !isEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchQuery &&
        other.name == name &&
        other.location == location &&
        other.year == year &&
        other.event == event &&
        other.sortOption == sortOption;
  }

  @override
  int get hashCode => Object.hash(name, location, year, event, sortOption);
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

  // FutureBuilder-relevante Variablen
  Future<DatabaseResult<List<SearchResult>>>? _searchFuture;
  SearchQuery _currentQuery = const SearchQuery();

  // UI State
  bool _showSearchFields = true;
  bool _showSortOptions = false;
  SortOption _currentSort = SortOption.nameAsc;

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

  // Zentrale Suchfunktion mit FutureBuilder
  Future<DatabaseResult<List<SearchResult>>> _executeSearch(
    SearchQuery query,
  ) async {
    if (query.isEmpty) {
      return const DatabaseResult.success([]);
    }

    // Verwende die Repository-Suchfunktion
    final result = await _repository.search(
      nameQuery: query.name.trim().isEmpty ? null : query.name.trim(),
      locationQuery: query.location.trim().isEmpty
          ? null
          : query.location.trim(),
      yearQuery: query.year.trim().isEmpty ? null : query.year.trim(),
      eventQuery: query.event.trim().isEmpty ? null : query.event.trim(),
    );

    if (!result.isSuccess || result.data == null) {
      return result;
    }

    // Sortiere die Ergebnisse
    final sortedResults = _sortResults(result.data!, query.sortOption);
    return DatabaseResult.success(sortedResults);
  }

  List<SearchResult> _sortResults(
    List<SearchResult> results,
    SortOption sortOption,
  ) {
    final sortedResults = List<SearchResult>.from(results);

    switch (sortOption) {
      case SortOption.nameAsc:
        sortedResults.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.nameDesc:
        sortedResults.sort((a, b) => b.title.compareTo(a.title));
        break;
      case SortOption.dateAsc:
        sortedResults.sort((a, b) => _compareDate(a, b, ascending: true));
        break;
      case SortOption.dateDesc:
        sortedResults.sort((a, b) => _compareDate(a, b, ascending: false));
        break;
      case SortOption.typeAsc:
        sortedResults.sort((a, b) => a.type.compareTo(b.type));
        break;
      case SortOption.typeDesc:
        sortedResults.sort((a, b) => b.type.compareTo(a.type));
        break;
    }

    return sortedResults;
  }

  int _compareDate(SearchResult a, SearchResult b, {required bool ascending}) {
    final dateA = a.primaryDate;
    final dateB = b.primaryDate;

    // Elemente ohne Datum ans Ende sortieren
    if (dateA == null && dateB == null) return 0;
    if (dateA == null) return 1;
    if (dateB == null) return -1;

    return ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
  }

  void _performSearch() {
    final query = SearchQuery(
      name: _nameController.text,
      location: _ortController.text,
      year: _jahrController.text,
      event: _ereignisController.text,
      sortOption: _currentSort,
    );

    if (query != _currentQuery) {
      setState(() {
        _currentQuery = query;
        _searchFuture = _executeSearch(query);

        // Blende Suchfelder aus, wenn eine Suche gestartet wird
        if (query.isNotEmpty) {
          _showSearchFields = false;
        }
      });
    }
  }

  void _changeSorting(SortOption newSort) {
    if (newSort != _currentSort) {
      setState(() {
        _currentSort = newSort;
        _showSortOptions = false;

        // Aktualisiere die Suche mit neuer Sortierung
        final query = _currentQuery.copyWith(sortOption: newSort);
        _currentQuery = query;
        _searchFuture = _executeSearch(query);
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _ortController.clear();
      _ereignisController.clear();
      _nameController.clear();
      _jahrController.clear();
      _currentQuery = const SearchQuery();
      _searchFuture = null;
      _showSearchFields = true;
      _currentSort = SortOption.nameAsc;
      _showSortOptions = false;
    });
  }

  void _toggleSearchFields() {
    setState(() {
      _showSearchFields = !_showSearchFields;
    });
  }

  void _retrySearch() {
    setState(() {
      _searchFuture = _executeSearch(_currentQuery);
    });
  }

  String _getItemId(SearchResult result) => result.id;
  String _getItemType(SearchResult result) => result.type;
  String _getItemTitle(SearchResult result) => result.title;

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
            onSubmitted: (_) => _performSearch(),
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
                    ? const Color.fromRGBO(
                        40,
                        58,
                        73,
                        1.0,
                      ).withValues(alpha: 0.1)
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

  Widget _buildResultItem(SearchResult result) {
    IconData icon;
    Color iconColor;

    switch (result.type) {
      case 'victim':
        icon = Icons.person;
        iconColor = const Color.fromRGBO(40, 58, 73, 1.0);
        break;
      case 'camp':
        icon = Icons.location_city;
        iconColor = Colors.black54;
        break;
      case 'commander':
        icon = Icons.military_tech;
        iconColor = Colors.black87;
        break;
      default:
        icon = Icons.help;
        iconColor = Colors.grey;
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(result.title),
        subtitle: Text(result.subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FavoriteIconButton(
              itemId: _getItemId(result),
              itemType: _getItemType(result),
              itemTitle: _getItemTitle(result),
            ),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
        onTap: () => _navigateToDetailPage(result.item),
      ),
    );
  }

  void _navigateToDetailPage(dynamic item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen(item: item)),
    );
  }

  // Error Widget für konsistente Fehleranzeige
  Widget _buildErrorDisplay(DatabaseException error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            const Text(
              'Fehler beim Laden der Daten',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFPro',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.message,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'SFPro',
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _retrySearch,
              icon: const Icon(Icons.refresh),
              label: const Text('Erneut versuchen'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Loading Widget
  Widget _buildLoadingDisplay() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Suche läuft...',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'SFPro',
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //rIcon(Icons.search, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 10),
            Text(
              _currentQuery.isEmpty
                  ? 'Geben Sie Suchbegriffe ein und drücken Sie "Suchen".'
                  : 'Keine Ergebnisse gefunden.',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFPro',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Ort: Findet hauptsächlich Lager und deren Standorte\n'
              'Name: Findet hauptsächlich Opfer und Personen\n'
              'Jahr: Durchsucht alle Jahresangaben\n'
              'Ereignis: Findet Lagertypen, Schicksale, etc.\n\n',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'SFPro',
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            if (!_showSearchFields && _currentQuery.isNotEmpty)
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
                      onPressed: _performSearch,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Suchen',
                        style: TextStyle(fontSize: 16, fontFamily: 'SFPro'),
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

              const SizedBox(height: 20),
            ],

            // Ausblenden-Button
            if (_showSearchFields && _currentQuery.isNotEmpty)
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

            // FutureBuilder für Suchergebnisse
            Expanded(
              child: _searchFuture == null
                  ? _buildEmptyState()
                  : FutureBuilder<DatabaseResult<List<SearchResult>>>(
                      future: _searchFuture,
                      builder: (context, snapshot) {
                        // Loading State
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildLoadingDisplay();
                        }

                        // Error State
                        if (snapshot.hasError) {
                          return _buildErrorDisplay(
                            DatabaseException(
                              'Unerwarteter Fehler: ${snapshot.error}',
                            ),
                          );
                        }

                        // Data State
                        if (!snapshot.hasData) {
                          return _buildErrorDisplay(
                            const DatabaseException('Keine Daten empfangen'),
                          );
                        }

                        final result = snapshot.data!;

                        // Database Error State
                        if (!result.isSuccess || result.error != null) {
                          return _buildErrorDisplay(result.error!);
                        }

                        final searchResults = result.data ?? [];

                        // Empty Results State
                        if (searchResults.isEmpty) {
                          return _buildEmptyState();
                        }

                        // Results State
                        return Column(
                          children: [
                            // Sortier-Optionen (nur wenn Ergebnisse vorhanden)
                            _buildSortButton(),
                            _buildSortOptions(),

                            // Ergebnisanzahl und Info
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${searchResults.length} Ergebnis${searchResults.length != 1 ? 'se' : ''} gefunden',
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
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  _retrySearch();
                                  // Warte auf das neue Future
                                  await _searchFuture;
                                },
                                child: ListView.builder(
                                  itemCount: searchResults.length,
                                  itemBuilder: (context, index) {
                                    return _buildResultItem(
                                      searchResults[index],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
