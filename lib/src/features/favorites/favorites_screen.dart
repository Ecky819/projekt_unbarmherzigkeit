import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/favorites_service.dart';
import '../../services/auth_service.dart';
import '../../data/databaseRepository.dart';
import '../database/detail_screen.dart';
import '../database/database_screen.dart';
import '../profiles/login_screen.dart';

class FavoriteScreen extends StatefulWidget {
  final DatabaseRepository? repository;

  const FavoriteScreen({super.key, this.repository});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  final AuthService _authService = AuthService();

  List<FavoriteItem> _favorites = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadFavorites();

    // Listener für Auth-State-Changes hinzufügen
    _authService.authStateChanges.listen((user) {
      if (mounted) {
        print('Auth state changed in FavoritesScreen: ${user?.email}');
        _loadFavorites(); // Favoriten neu laden bei Auth-Änderung
      }
    });
  }

  Future<void> _loadFavorites() async {
    if (!_authService.isLoggedIn) {
      setState(() {
        _favorites = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      print('Loading favorites for user: ${_authService.currentUser?.email}');
      final favorites = await _favoritesService.getUserFavorites();
      print('Loaded ${favorites.length} favorites');

      if (mounted) {
        setState(() {
          _favorites = favorites;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading favorites: $e');
      if (mounted) {
        setState(() {
          _favorites = []; // Setze leere Liste bei Fehler
          _isLoading = false;
        });

        // Zeige Fehler nur wenn es ein echter Fehler ist, nicht nur "keine Favoriten"
        if (!e.toString().contains('permission-denied')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fehler beim Laden der Favoriten: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  List<FavoriteItem> get _filteredFavorites {
    if (_selectedFilter == 'all') return _favorites;
    return _favorites.where((fav) => fav.itemType == _selectedFilter).toList();
  }

  Map<String, int> get _favoritesCounts {
    final counts = <String, int>{
      'all': _favorites.length,
      'victim': 0,
      'camp': 0,
      'commander': 0,
    };

    for (var favorite in _favorites) {
      counts[favorite.itemType] = (counts[favorite.itemType] ?? 0) + 1;
    }

    return counts;
  }

  Future<void> _removeFavorite(FavoriteItem favorite) async {
    try {
      await _favoritesService.removeFavorite(
        itemId: favorite.itemId,
        itemType: favorite.itemType,
      );

      if (mounted) {
        setState(() {
          _favorites.removeWhere((f) => f.id == favorite.id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Favorit entfernt'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Entfernen: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<dynamic> _loadDetailItem(FavoriteItem favorite) async {
    if (widget.repository == null) return null;

    try {
      switch (favorite.itemType) {
        case 'victim':
          return await widget.repository!.getVictimById(favorite.itemId);
        case 'camp':
          return await widget.repository!.getConcentrationCampById(
            favorite.itemId,
          );
        case 'commander':
          return await widget.repository!.getCommanderById(favorite.itemId);
        default:
          return null;
      }
    } catch (e) {
      print('Fehler beim Laden des Detail-Items: $e');
      return null;
    }
  }

  void _navigateToDetail(FavoriteItem favorite) async {
    if (widget.repository == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Datenbank nicht verfügbar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Loading-Indikator anzeigen
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
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Lade Details...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final item = await _loadDetailItem(favorite);

      if (mounted) {
        Navigator.pop(context); // Schließe Loading-Dialog

        if (item != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailScreen(item: item)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Details konnten nicht geladen werden'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Schließe Loading-Dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Laden der Details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'Sie müssen eingeloggt sein, um Favoriten festlegen zu können.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontFamily: 'SF Pro',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                ).then((_) {
                  // Nach dem Login die Favoriten neu laden
                  if (_authService.isLoggedIn) {
                    _loadFavorites();
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF283A49),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.login),
              label: const Text(
                'Anmelden',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SF Pro',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'Noch keine Favoriten',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                fontFamily: 'SF Pro',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Markieren Sie Einträge in der Datenbank als Favoriten, um sie hier zu sehen.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                fontFamily: 'SF Pro',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final counts = _favoritesCounts;

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('all', 'Alle (${counts['all']})', Icons.list),
          const SizedBox(width: 8),
          _buildFilterChip(
            'victim',
            'Opfer (${counts['victim']})',
            Icons.person,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            'camp',
            'Lager (${counts['camp']})',
            Icons.location_city,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            'commander',
            'Kommandanten (${counts['commander']})',
            Icons.military_tech,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, IconData icon) {
    final isSelected = _selectedFilter == value;

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(label)],
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedFilter = value);
        }
      },
      selectedColor: const Color(0xFF283A49).withValues(alpha: 0.2),
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        fontFamily: 'SF Pro',
        color: isSelected ? const Color(0xFF283A49) : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildFavoriteItem(FavoriteItem favorite) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: favorite.typeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(favorite.typeIcon, color: favorite.typeColor, size: 24),
        ),
        title: Text(
          favorite.itemTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'SF Pro',
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              favorite.typeDisplayName,
              style: TextStyle(
                color: favorite.typeColor,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Hinzugefügt: ${_formatDate(favorite.createdAt)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontFamily: 'SF Pro',
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Details anzeigen Button
            IconButton(
              onPressed: () => _navigateToDetail(favorite),
              icon: const Icon(Icons.info_outline),
              tooltip: 'Details anzeigen',
              iconSize: 20,
            ),
            // Favorit entfernen Button
            IconButton(
              onPressed: () => _showRemoveDialog(favorite),
              icon: const Icon(Icons.bookmark),
              color: Colors.red,
              tooltip: 'Von Favoriten entfernen',
              iconSize: 20,
            ),
          ],
        ),
        onTap: () => _navigateToDetail(favorite),
      ),
    );
  }

  void _showRemoveDialog(FavoriteItem favorite) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Row(
            children: [
              Icon(Icons.bookmark, color: Colors.red),
              SizedBox(width: 8),
              Text('Favorit entfernen'),
            ],
          ),
          content: Text(
            'Möchten Sie "${favorite.itemTitle}" wirklich von Ihren Favoriten entfernen?',
            style: const TextStyle(fontFamily: 'SF Pro'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _removeFavorite(favorite);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Entfernen'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD),
      body: StreamBuilder<User?>(
        stream: _authService.authStateChanges,
        builder: (context, snapshot) {
          // Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF283A49)),
                  SizedBox(height: 16),
                  Text(
                    'Lade Favoriten...',
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

          // User nicht eingeloggt
          if (!_authService.isLoggedIn) {
            return _buildLoginPrompt();
          }

          // User ist eingeloggt
          return RefreshIndicator(
            onRefresh: _loadFavorites,
            color: const Color(0xFF283A49),
            child: Column(
              children: [
                // Filter Chips
                if (_favorites.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildFilterChips(),
                  const SizedBox(height: 8),
                ],

                // Favoriten Liste
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xFF283A49),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Lade Favoriten...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'SF Pro',
                                  color: Color(0xFF283A49),
                                ),
                              ),
                            ],
                          ),
                        )
                      : _favorites.isEmpty
                      ? _buildEmptyState()
                      : _filteredFavorites.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.filter_list_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Keine Favoriten in dieser Kategorie',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontFamily: 'SF Pro',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredFavorites.length,
                          itemBuilder: (context, index) {
                            return _buildFavoriteItem(
                              _filteredFavorites[index],
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      // Floating Action Button für Datenbank-Navigation
      floatingActionButton: _authService.isLoggedIn && _favorites.isEmpty
          ? FloatingActionButton.extended(
              heroTag: "favorites_fab", // Eindeutiger Hero-Tag hinzugefügt
              onPressed: () {
                // Navigiere zur Datenbank über den Navigator push
                if (widget.repository != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DatabaseScreen(repository: widget.repository),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Datenbank nicht verfügbar'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              backgroundColor: const Color(0xFF283A49),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.search),
              label: const Text(
                'Datenbank durchsuchen',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
