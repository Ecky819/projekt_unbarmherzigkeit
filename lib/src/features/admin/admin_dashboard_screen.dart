import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/databaseRepository.dart';
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

  List<Victim> _victims = [];
  List<ConcentrationCamp> _camps = [];
  List<Commander> _commanders = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final victims = await widget.repository.getVictims();
      final camps = await widget.repository.getConcentrationCamps();
      final commanders = await widget.repository.getCommanders();

      setState(() {
        _victims = victims;
        _camps = camps;
        _commanders = commanders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Laden der Daten: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  List<Victim> get _filteredVictims {
    if (_searchQuery.isEmpty) return _victims;
    return _victims.where((victim) {
      final searchLower = _searchQuery.toLowerCase();
      return victim.name.toLowerCase().contains(searchLower) ||
          victim.surname.toLowerCase().contains(searchLower) ||
          victim.nationality.toLowerCase().contains(searchLower) ||
          victim.c_camp.toLowerCase().contains(searchLower);
    }).toList();
  }

  List<ConcentrationCamp> get _filteredCamps {
    if (_searchQuery.isEmpty) return _camps;
    return _camps.where((camp) {
      final searchLower = _searchQuery.toLowerCase();
      return camp.name.toLowerCase().contains(searchLower) ||
          camp.location.toLowerCase().contains(searchLower) ||
          camp.country.toLowerCase().contains(searchLower) ||
          camp.type.toLowerCase().contains(searchLower);
    }).toList();
  }

  List<Commander> get _filteredCommanders {
    if (_searchQuery.isEmpty) return _commanders;
    return _commanders.where((commander) {
      final searchLower = _searchQuery.toLowerCase();
      return commander.name.toLowerCase().contains(searchLower) ||
          commander.surname.toLowerCase().contains(searchLower) ||
          commander.rank.toLowerCase().contains(searchLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AdminGuard(
      child: Scaffold(
        backgroundColor: const Color(0xFFE9E5DD),
        appBar: _buildAppBar(),
        body: _isLoading ? _buildLoadingIndicator() : _buildTabBarView(),
        floatingActionButton: _isLoading ? null : _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          const Icon(Icons.admin_panel_settings, color: Colors.white),
          const SizedBox(width: 8),
          const Expanded(
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
      elevation: 2,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 65),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'SF Pro',
              ),
              tabs: [
                Tab(
                  icon: const Icon(Icons.person, size: 22),
                  iconMargin: const EdgeInsets.only(bottom: 4),
                  text: 'Opfer (${_victims.length})',
                ),
                Tab(
                  icon: const Icon(Icons.location_city, size: 22),
                  iconMargin: const EdgeInsets.only(bottom: 4),
                  text: 'Lager (${_camps.length})',
                ),
                Tab(
                  icon: const Icon(Icons.military_tech, size: 22),
                  iconMargin: const EdgeInsets.only(bottom: 4),
                  text: 'Kommandanten (${_commanders.length})',
                ),
              ],
            ),

            Container(
              color: const Color(0xFF283A49),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                        decoration: const InputDecoration(
                          hintText: 'Suchen...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF283A49),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        style: const TextStyle(fontFamily: 'SF Pro'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _loadData,
                    tooltip: 'Daten neu laden',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _showLogoutDialog(),
          tooltip: 'Abmelden',
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

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [_buildVictimsTab(), _buildCampsTab(), _buildCommandersTab()],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      backgroundColor: const Color(0xFF283A49),
      foregroundColor: Colors.white,
      onPressed: _showAddDialog,
      icon: const Icon(Icons.add),
      label: const Text(
        'HINZUFÜGEN',
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
                  if (victim.prisoner_number != null)
                    Text('Häftlingsnummer: ${victim.prisoner_number}'),
                  if (victim.birth != null)
                    Text('Geboren: ${_formatDate(victim.birth!)}'),
                  if (victim.death != null)
                    Text('Gestorben: ${_formatDate(victim.death!)}'),
                  Text('Nationalität: ${victim.nationality}'),
                  Text('KZ: ${victim.c_camp}'),
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
                  if (camp.date_opened != null)
                    Text('Eröffnet: ${_formatDate(camp.date_opened!)}'),
                  if (camp.liberation_date != null)
                    Text('Befreit: ${_formatDate(camp.liberation_date!)}'),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.add, color: Color(0xFF283A49)),
            SizedBox(width: 8),
            Text('Neuen Eintrag hinzufügen'),
          ],
        ),
        content: const Text(
          'Was möchten Sie hinzufügen?',
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
      // Zeige Loading-Indikator
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

      // Versuche normalen Logout mit verbessertem AuthService
      await _authService.logout();

      // Schließe Loading-Dialog
      if (mounted) Navigator.pop(context);

      // Navigiere zur Startseite
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } on PlatformException catch (e) {
      // Spezielle Behandlung für PlatformException
      if (mounted) Navigator.pop(context); // Schließe Loading-Dialog

      if (mounted) {
        _showPlatformErrorDialog(e);
      }
    } catch (e) {
      // Schließe Loading-Dialog bei anderen Fehlern
      if (mounted) Navigator.pop(context);

      // Zeige Fehler-Dialog mit Optionen
      if (mounted) {
        _showGeneralErrorDialog(e);
      }
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
              _performSimpleLogout(); // Vereinfachter Logout
            },
            child: const Text('Erneut versuchen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _forceLogout(); // Forcierter Logout
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
              _performLogout(); // Erneut versuchen
            },
            child: const Text('Erneut versuchen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _forceLogout(); // Forcierter Logout
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
        Navigator.pop(context); // Schließe Loading-Dialog
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Schließe Loading-Dialog
        _forceLogout(); // Als letzter Ausweg
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

      // Verwende den neuen forceLogout aus AuthService
      await _authService.forceLogout();

      if (mounted) {
        Navigator.pop(context); // Schließe Loading-Dialog

        // Forciere Navigation zur Startseite
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

        // Zeige Bestätigung
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
        Navigator.pop(context); // Schließe Loading-Dialog

        // Auch bei Fehlern, navigiere trotzdem
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
      await widget.repository.deleteVictim(victim.victim_id.toString());
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
      await widget.repository.deleteConcentrationCamp(camp.camp_id.toString());
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
      await widget.repository.deleteCommander(
        commander.commander_id.toString(),
      );
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
