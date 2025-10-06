import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/database_repository.dart';
import '../../data/profile.dart';
import '../../services/auth_service.dart';
import '../auth/admin_guard.dart';
import 'victim_form_screen.dart';
import 'camp_form_screen.dart';
import 'commander_form_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final DatabaseRepository repository;

  const AdminDashboardScreen({super.key, required this.repository});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<Victim> _victims = [];
  List<ConcentrationCamp> _camps = [];
  List<Commander> _commanders = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  bool _isSearchExpanded = false;
  bool _isCategoriesExpanded = true;

  // Sorting
  String _sortField = 'name';
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Timer? _debounceTimer;
  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text.toLowerCase().trim();
        });
      }
    });
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Verwende die neuen DatabaseResult-Returns
      final victimsResult = await widget.repository.getVictims();
      final campsResult = await widget.repository.getConcentrationCamps();
      final commandersResult = await widget.repository.getCommanders();

      // Prüfe auf Fehler
      if (!victimsResult.isSuccess) {
        throw victimsResult.error?.message ?? 'Fehler beim Laden der Opfer';
      }
      if (!campsResult.isSuccess) {
        throw campsResult.error?.message ?? 'Fehler beim Laden der Lager';
      }
      if (!commandersResult.isSuccess) {
        throw commandersResult.error?.message ??
            'Fehler beim Laden der Kommandanten';
      }

      setState(() {
        _victims = victimsResult.data ?? [];
        _camps = campsResult.data ?? [];
        _commanders = commandersResult.data ?? [];
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Laden der Daten: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Erneut versuchen',
              textColor: Colors.white,
              onPressed: _loadData,
            ),
          ),
        );
      }
    }
  }

  List<Victim> get _filteredVictims {
    List<Victim> filtered = _searchQuery.isEmpty
        ? List.from(_victims)
        : _victims.where((victim) {
            final searchLower = _searchQuery;
            return victim.name.toLowerCase().contains(searchLower) ||
                victim.surname.toLowerCase().contains(searchLower) ||
                victim.nationality.toLowerCase().contains(searchLower) ||
                victim.cCamp.toLowerCase().contains(searchLower);
          }).toList();

    filtered.sort((a, b) {
      int result = 0;
      switch (_sortField) {
        case 'name':
          result = '${a.surname}, ${a.name}'.compareTo(
            '${b.surname}, ${b.name}',
          );
          break;
        case 'nationality':
          result = a.nationality.compareTo(b.nationality);
          break;
        case 'camp':
          result = a.cCamp.compareTo(b.cCamp);
          break;
        case 'birth':
          if (a.birth == null && b.birth == null) return 0;
          if (a.birth == null) return 1;
          if (b.birth == null) return -1;
          result = a.birth!.compareTo(b.birth!);
          break;
        case 'death':
          if (a.death == null && b.death == null) return 0;
          if (a.death == null) return 1;
          if (b.death == null) return -1;
          result = a.death!.compareTo(b.death!);
          break;
      }
      return _sortAscending ? result : -result;
    });

    return filtered;
  }

  List<ConcentrationCamp> get _filteredCamps {
    List<ConcentrationCamp> filtered = _searchQuery.isEmpty
        ? List.from(_camps)
        : _camps.where((camp) {
            final searchLower = _searchQuery;
            return camp.name.toLowerCase().contains(searchLower) ||
                camp.location.toLowerCase().contains(searchLower) ||
                camp.country.toLowerCase().contains(searchLower) ||
                camp.type.toLowerCase().contains(searchLower);
          }).toList();

    filtered.sort((a, b) {
      int result = 0;
      switch (_sortField) {
        case 'name':
          result = a.name.compareTo(b.name);
          break;
        case 'location':
          result = a.location.compareTo(b.location);
          break;
        case 'country':
          result = a.country.compareTo(b.country);
          break;
        case 'type':
          result = a.type.compareTo(b.type);
          break;
        case 'opened':
          if (a.dateOpened == null && b.dateOpened == null) return 0;
          if (a.dateOpened == null) return 1;
          if (b.dateOpened == null) return -1;
          result = a.dateOpened!.compareTo(b.dateOpened!);
          break;
      }
      return _sortAscending ? result : -result;
    });

    return filtered;
  }

  List<Commander> get _filteredCommanders {
    List<Commander> filtered = _searchQuery.isEmpty
        ? List.from(_commanders)
        : _commanders.where((commander) {
            final searchLower = _searchQuery;
            return commander.name.toLowerCase().contains(searchLower) ||
                commander.surname.toLowerCase().contains(searchLower) ||
                commander.rank.toLowerCase().contains(searchLower);
          }).toList();

    filtered.sort((a, b) {
      int result = 0;
      switch (_sortField) {
        case 'name':
          result = '${a.surname}, ${a.name}'.compareTo(
            '${b.surname}, ${b.name}',
          );
          break;
        case 'rank':
          result = a.rank.compareTo(b.rank);
          break;
        case 'birth':
          if (a.birth == null && b.birth == null) return 0;
          if (a.birth == null) return 1;
          if (b.birth == null) return -1;
          result = a.birth!.compareTo(b.birth!);
          break;
      }
      return _sortAscending ? result : -result;
    });

    return filtered;
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _searchQuery = '';
      _isSearchExpanded = false;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
      if (!_isSearchExpanded) {
        _clearSearch();
      }
    });
  }

  void _toggleCategories() {
    setState(() {
      _isCategoriesExpanded = !_isCategoriesExpanded;
    });
  }

  void _setSortField(String field) {
    setState(() {
      if (_sortField == field) {
        _sortAscending = !_sortAscending;
      } else {
        _sortField = field;
        _sortAscending = true;
      }
    });
  }

  List<String> get _currentSortFields {
    switch (_tabController.index) {
      case 0:
        return ['name', 'nationality', 'camp', 'birth', 'death'];
      case 1:
        return ['name', 'location', 'country', 'type', 'opened'];
      case 2:
        return ['name', 'rank', 'birth'];
      default:
        return ['name'];
    }
  }

  String _getSortFieldDisplayName(String field) {
    switch (field) {
      case 'name':
        return 'Name';
      case 'nationality':
        return 'Nationalität';
      case 'camp':
        return 'Lager';
      case 'birth':
        return 'Geburt';
      case 'death':
        return 'Tod';
      case 'location':
        return 'Ort';
      case 'country':
        return 'Land';
      case 'type':
        return 'Typ';
      case 'opened':
        return 'Eröffnet';
      case 'rank':
        return 'Rang';
      default:
        return field;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminGuard(
      child: Scaffold(
        backgroundColor: const Color(0xFFE9E5DD),
        appBar: _buildAppBar(),
        body: _errorMessage != null
            ? _buildErrorView()
            : (_isLoading ? _buildLoadingIndicator() : _buildBody()),
        floatingActionButton: _isLoading || _errorMessage != null
            ? null
            : _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            const Text(
              'Fehler beim Laden',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'SF Pro',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unbekannter Fehler',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'SF Pro',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Erneut versuchen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF283A49),
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Zurück'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Row(
        children: [
          Icon(Icons.admin_panel_settings, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Admin Dashboard',
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF283A49),
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _showLogoutDialog(),
          tooltip: 'Abmelden',
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // Collapsible Tab Bar
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: const Color(0xFF283A49),
          child: Column(
            children: [
              // Tab Bar Header with collapse button
              InkWell(
                onTap: _toggleCategories,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.category, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Kategorien',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro',
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        _isCategoriesExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),

              // Collapsible Tab Bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isCategoriesExpanded ? null : 0,
                child: _isCategoriesExpanded
                    ? TabBar(
                        controller: _tabController,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        indicatorColor: Colors.white,
                        indicatorWeight: 3,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro',
                        ),
                        onTap: (index) {
                          setState(() {
                            _sortField = 'name';
                            _sortAscending = true;
                          });
                        },
                        tabs: [
                          Tab(
                            icon: const Icon(Icons.person, size: 22),
                            text: 'Opfer (${_victims.length})',
                          ),
                          Tab(
                            icon: const Icon(Icons.location_city, size: 22),
                            text: 'Lager (${_camps.length})',
                          ),
                          Tab(
                            icon: const Icon(Icons.military_tech, size: 22),
                            text: 'Kommandanten (${_commanders.length})',
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),

        // Search and Sort Controls
        Container(
          color: const Color(0xFF283A49),
          child: Column(
            children: [
              // Search Toggle
              InkWell(
                onTap: _toggleSearch,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isSearchExpanded ? Icons.search_off : Icons.search,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Suche',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro',
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        _isSearchExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),

              // Collapsible Search Bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isSearchExpanded ? 60 : 0,
                child: _isSearchExpanded
                    ? Container(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  focusNode: _searchFocusNode,
                                  style: const TextStyle(fontFamily: 'SF Pro'),
                                  decoration: InputDecoration(
                                    hintText: 'Suchen...',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontFamily: 'SF Pro',
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey[600],
                                    ),
                                    suffixIcon: _searchQuery.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.grey[600],
                                            ),
                                            onPressed: _clearSearch,
                                          )
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                                onPressed: _loadData,
                                tooltip: 'Daten neu laden',
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // Sort Controls
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sort, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Sortieren:',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SF Pro',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _currentSortFields.map((field) {
                            final isActive = _sortField == field;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () => _setSortField(field),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? Colors.white.withValues(alpha: 0.2)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _getSortFieldDisplayName(field),
                                        style: TextStyle(
                                          color: isActive
                                              ? Colors.white
                                              : Colors.white70,
                                          fontFamily: 'SF Pro',
                                          fontSize: 12,
                                          fontWeight: isActive
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      if (isActive) ...[
                                        const SizedBox(width: 4),
                                        Icon(
                                          _sortAscending
                                              ? Icons.arrow_upward
                                              : Icons.arrow_downward,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Search Results Info
        if (_searchQuery.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Suche nach: "$_searchQuery"',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontFamily: 'SF Pro',
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearSearch,
                  child: const Text('Zurücksetzen'),
                ),
              ],
            ),
          ),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildVictimsTab(),
              _buildCampsTab(),
              _buildCommandersTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF283A49)),
          SizedBox(height: 16),
          Text(
            'Lade Daten...',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'SF Pro',
              color: Color(0xFF283A49),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      backgroundColor: const Color(0xFF283A49),
      foregroundColor: Colors.white,
      onPressed: _showAddDialog,
      icon: const Icon(Icons.add),
      label: const Text(
        'Hinzufügen',
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'SF Pro'),
      ),
    );
  }

  Widget _buildVictimsTab() {
    final victims = _filteredVictims;

    if (victims.isEmpty) {
      return _buildEmptyState(
        Icons.person_off,
        _searchQuery.isNotEmpty
            ? 'Keine Opfer gefunden'
            : 'Keine Opfer vorhanden',
        _searchQuery.isNotEmpty
            ? 'Versuchen Sie andere Suchbegriffe.'
            : 'Fügen Sie das erste Opfer hinzu.',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFF283A49),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: victims.length,
        itemBuilder: (context, index) {
          final victim = victims[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF283A49).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person, color: Color(0xFF283A49)),
              ),
              title: Text(
                '${victim.surname}, ${victim.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SF Pro',
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  if (victim.prisonerNumber != null)
                    Text('Häftlingsnummer: ${victim.prisonerNumber}'),
                  if (victim.birth != null)
                    Text('Geboren: ${_formatDate(victim.birth!)}'),
                  if (victim.death != null)
                    Text('Gestorben: ${_formatDate(victim.death!)}'),
                  Text('Nationalität: ${victim.nationality}'),
                  Text('KZ: ${victim.cCamp}'),
                ],
              ),
              trailing: _buildActionMenu(
                onEdit: () => _navigateToVictimForm(victim),
                onDelete: () => _confirmDeleteVictim(victim),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCampsTab() {
    final camps = _filteredCamps;

    if (camps.isEmpty) {
      return _buildEmptyState(
        Icons.location_off,
        _searchQuery.isNotEmpty
            ? 'Keine Lager gefunden'
            : 'Keine Lager vorhanden',
        _searchQuery.isNotEmpty
            ? 'Versuchen Sie andere Suchbegriffe.'
            : 'Fügen Sie das erste Lager hinzu.',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFF283A49),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: camps.length,
        itemBuilder: (context, index) {
          final camp = camps[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF283A49).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.location_city,
                  color: Color(0xFF283A49),
                ),
              ),
              title: Text(
                camp.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SF Pro',
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Ort: ${camp.location}, ${camp.country}'),
                  Text('Typ: ${camp.type}'),
                  Text('Kommandant: ${camp.commander}'),
                  if (camp.dateOpened != null)
                    Text('Eröffnet: ${_formatDate(camp.dateOpened!)}'),
                  if (camp.liberationDate != null)
                    Text('Befreit: ${_formatDate(camp.liberationDate!)}'),
                ],
              ),
              trailing: _buildActionMenu(
                onEdit: () => _navigateToCampForm(camp),
                onDelete: () => _confirmDeleteCamp(camp),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommandersTab() {
    final commanders = _filteredCommanders;

    if (commanders.isEmpty) {
      return _buildEmptyState(
        Icons.person_off_outlined,
        _searchQuery.isNotEmpty
            ? 'Keine Kommandanten gefunden'
            : 'Keine Kommandanten vorhanden',
        _searchQuery.isNotEmpty
            ? 'Versuchen Sie andere Suchbegriffe.'
            : 'Fügen Sie den ersten Kommandanten hinzu.',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFF283A49),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: commanders.length,
        itemBuilder: (context, index) {
          final commander = commanders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF283A49).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.military_tech,
                  color: Color(0xFF283A49),
                ),
              ),
              title: Text(
                '${commander.surname}, ${commander.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SF Pro',
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Rang: ${commander.rank}'),
                  if (commander.birth != null)
                    Text('Geboren: ${_formatDate(commander.birth!)}'),
                  if (commander.death != null)
                    Text('Gestorben: ${_formatDate(commander.death!)}'),
                  if (commander.birthplace != null)
                    Text('Geburtsort: ${commander.birthplace}'),
                ],
              ),
              trailing: _buildActionMenu(
                onEdit: () => _navigateToCommanderForm(commander),
                onDelete: () => _confirmDeleteCommander(commander),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              fontFamily: 'SF Pro',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontFamily: 'SF Pro',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionMenu({
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (action) {
        switch (action) {
          case 'edit':
            onEdit();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18, color: Color(0xFF283A49)),
              SizedBox(width: 8),
              Text('Bearbeiten'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: Colors.red),
              SizedBox(width: 8),
              Text('Löschen', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.add, color: Color(0xFF283A49)),
            SizedBox(width: 8),
            Text(
              'Neuen Eintrag hinzufügen',
              style: TextStyle(fontFamily: 'SF Pro', fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Was möchten Sie hinzufügen?',
          style: TextStyle(fontFamily: 'SF Pro'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToVictimForm();
            },
            child: const Text('Opfer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToCampForm();
            },
            child: const Text('Lager'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToCommanderForm();
            },
            child: const Text('Kommandant'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.orange),
            SizedBox(width: 8),
            Text('Abmelden'),
          ],
        ),
        content: const Text(
          'Möchten Sie sich wirklich abmelden?',
          style: TextStyle(fontFamily: 'SF Pro'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Abmelden'),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xFF283A49)),
                  SizedBox(height: 16),
                  Text('Abmelden...', style: TextStyle(fontFamily: 'SF Pro')),
                ],
              ),
            ),
          ),
        ),
      );

      await _authService.logout();

      if (mounted) Navigator.pop(context);
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } on PlatformException catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) _showPlatformErrorDialog(e);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) _showGeneralErrorDialog(e);
    }
  }

  void _showPlatformErrorDialog(PlatformException e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Verbindungsproblem'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _authService.handlePlatformException(e),
              style: const TextStyle(fontFamily: 'SF Pro'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dies ist oft ein temporäres Problem. Versuchen Sie:',
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Internetverbindung prüfen\n• App neu starten\n• Trotzdem abmelden',
              style: TextStyle(fontFamily: 'SF Pro'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performSimpleLogout();
            },
            child: const Text('Erneut versuchen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _forceLogout();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Trotzdem abmelden'),
          ),
        ],
      ),
    );
  }

  void _showGeneralErrorDialog(dynamic e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Logout-Fehler'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Beim Abmelden ist ein Fehler aufgetreten:',
              style: TextStyle(fontFamily: 'SF Pro'),
            ),
            const SizedBox(height: 8),
            Text(
              e.toString(),
              style: const TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Was möchten Sie tun?',
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout();
            },
            child: const Text('Erneut versuchen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _forceLogout();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Trotzdem abmelden'),
          ),
        ],
      ),
    );
  }

  Future<void> _performSimpleLogout() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xFF283A49)),
                  SizedBox(height: 16),
                  Text('Vereinfachter Logout...'),
                ],
              ),
            ),
          ),
        ),
      );

      await _authService.simpleLogout();

      if (mounted) {
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _forceLogout();
      }
    }
  }

  Future<void> _forceLogout() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.orange),
                  SizedBox(height: 16),
                  Text('Forciere Abmeldung...'),
                ],
              ),
            ),
          ),
        ),
      );

      await _authService.forceLogout();

      if (mounted) {
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sitzung beendet. Bitte melden Sie sich erneut an.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout mit Fehlern: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  // Navigation Methods
  void _navigateToVictimForm([Victim? victim]) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VictimFormScreen(repository: widget.repository, victim: victim),
      ),
    );
    if (result == true && mounted) {
      _loadData();
    }
  }

  void _navigateToCampForm([ConcentrationCamp? camp]) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CampFormScreen(repository: widget.repository, camp: camp),
      ),
    );
    if (result == true && mounted) {
      _loadData();
    }
  }

  void _navigateToCommanderForm([Commander? commander]) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CommanderFormScreen(
          repository: widget.repository,
          commander: commander,
        ),
      ),
    );
    if (result == true && mounted) {
      _loadData();
    }
  }

  // Delete Confirmation Methods
  void _confirmDeleteVictim(Victim victim) {
    _showDeleteConfirmation(
      title: 'Opfer löschen',
      content:
          'Möchten Sie das Opfer "${victim.surname}, ${victim.name}" wirklich löschen?\n\nDiese Aktion kann nicht rückgängig gemacht werden.',
      onConfirm: () => _deleteVictim(victim),
    );
  }

  void _confirmDeleteCamp(ConcentrationCamp camp) {
    _showDeleteConfirmation(
      title: 'Lager löschen',
      content:
          'Möchten Sie das Lager "${camp.name}" wirklich löschen?\n\nDiese Aktion kann nicht rückgängig gemacht werden.',
      onConfirm: () => _deleteCamp(camp),
    );
  }

  void _confirmDeleteCommander(Commander commander) {
    _showDeleteConfirmation(
      title: 'Kommandant löschen',
      content:
          'Möchten Sie den Kommandanten "${commander.surname}, ${commander.name}" wirklich löschen?\n\nDiese Aktion kann nicht rückgängig gemacht werden.',
      onConfirm: () => _deleteCommander(commander),
    );
  }

  void _showDeleteConfirmation({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(content, style: const TextStyle(fontFamily: 'SF Pro')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }

  // Delete Methods
  Future<void> _deleteVictim(Victim victim) async {
    try {
      final result = await widget.repository.deleteVictim(victim.victimId);

      if (!result.isSuccess) {
        throw result.error?.message ?? 'Unbekannter Fehler beim Löschen';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Opfer erfolgreich gelöscht'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Löschen: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _deleteCamp(ConcentrationCamp camp) async {
    try {
      final result = await widget.repository.deleteConcentrationCamp(
        camp.campId,
      );

      if (!result.isSuccess) {
        throw result.error?.message ?? 'Unbekannter Fehler beim Löschen';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lager erfolgreich gelöscht'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Löschen: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _deleteCommander(Commander commander) async {
    try {
      final result = await widget.repository.deleteCommander(
        commander.commanderId,
      );

      if (!result.isSuccess) {
        throw result.error?.message ?? 'Unbekannter Fehler beim Löschen';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kommandant erfolgreich gelöscht'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Löschen: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}