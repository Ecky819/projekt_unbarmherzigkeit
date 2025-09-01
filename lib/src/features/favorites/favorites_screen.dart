import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/favorites_service.dart';
import '../../services/auth_service.dart';
import '../../data/database_repository.dart';
import '../../data/profile.dart'; // Hinzugefügter Import für DatabaseResult
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

  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD),
      body: StreamBuilder<User?>(
        stream: _authService.authStateChanges,
        builder: (context, authSnapshot) {
          // Loading State
          if (authSnapshot.connectionState == ConnectionState.waiting) {
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

          // User ist eingeloggt - verwende Firestore Stream für Realtime Updates
          return StreamBuilder<List<FavoriteItem>>(
            stream: _favoritesService.getFavoritesStream(),
            builder: (context, favoritesSnapshot) {
              if (favoritesSnapshot.connectionState ==
                  ConnectionState.waiting) {
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

              if (favoritesSnapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Fehler beim Laden der Favoriten',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                            fontFamily: 'SF Pro',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          favoritesSnapshot.error.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red[600],
                            fontFamily: 'SF Pro',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {}); // Trigger rebuild
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF283A49),
                          ),
                          child: const Text(
                            'Erneut versuchen',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final favorites = favoritesSnapshot.data ?? [];
              final filteredFavorites = _getFilteredFavorites(favorites);
              final favoritesCounts = _getFavoritesCounts(favorites);

              return RefreshIndicator(
                onRefresh: () async {
                  // Force refresh durch setState
                  setState(() {});
                },
                color: const Color(0xFF283A49),
                child: Column(
                  children: [
                    // Filter Chips
                    if (favorites.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildFilterChips(favoritesCounts),
                      const SizedBox(height: 8),
                    ],

                    // Favoriten Liste
                    Expanded(
                      child: favorites.isEmpty
                          ? _buildEmptyState()
                          : filteredFavorites.isEmpty
                          ? _buildNoResultsForFilter()
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredFavorites.length,
                              itemBuilder: (context, index) {
                                return _buildFavoriteItem(
                                  filteredFavorites[index],
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      // Floating Action Button für Datenbank-Navigation
      floatingActionButton: _authService.isLoggedIn
          ? StreamBuilder<List<FavoriteItem>>(
              stream: _favoritesService.getFavoritesStream(),
              builder: (context, snapshot) {
                final favorites = snapshot.data ?? [];

                if (favorites.isEmpty) {
                  return FloatingActionButton.extended(
                    heroTag: "favorites_fab",
                    onPressed: () {
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
                  );
                }
                return const SizedBox.shrink(); // Leeres Widget wenn Favoriten vorhanden
              },
            )
          : null,
    );
  }

  List<FavoriteItem> _getFilteredFavorites(List<FavoriteItem> favorites) {
    if (_selectedFilter == 'all') return favorites;
    return favorites.where((fav) => fav.itemType == _selectedFilter).toList();
  }

  Map<String, int> _getFavoritesCounts(List<FavoriteItem> favorites) {
    final counts = <String, int>{
      'all': favorites.length,
      'victim': 0,
      'camp': 0,
      'commander': 0,
    };

    for (var favorite in favorites) {
      counts[favorite.itemType] = (counts[favorite.itemType] ?? 0) + 1;
    }

    return counts;
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
                );
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

  Widget _buildNoResultsForFilter() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_list_off, size: 64, color: Colors.grey[400]),
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
    );
  }

  Widget _buildFilterChips(Map<String, int> counts) {
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

  Future<void> _removeFavorite(FavoriteItem favorite) async {
    try {
      await _favoritesService.removeFavorite(
        itemId: favorite.itemId,
        itemType: favorite.itemType,
      );

      if (mounted) {
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

  // KORRIGIERTE VERSION
  Future<dynamic> _loadDetailItem(FavoriteItem favorite) async {
    if (widget.repository == null) return null;

    try {
      late DatabaseResult result;

      switch (favorite.itemType) {
        case 'victim':
          result = await widget.repository!.getVictimById(favorite.itemId);
          break;
        case 'camp':
          result = await widget.repository!.getConcentrationCampById(
            favorite.itemId,
          );
          break;
        case 'commander':
          result = await widget.repository!.getCommanderById(favorite.itemId);
          break;
        default:
          return null;
      }

      // Check if the result is successful and has data
      if (result.isSuccess && result.data != null) {
        return result.data;
      } else {
        // Log the error for debugging (optional)
        // print(
        //   'Error loading detail item: ${result.error?.message ?? "Unknown error"}',
        // );
        return null;
      }
    } catch (e) {
      // print('Exception while loading detail item: $e');
      return null;
    }
  }

  // KORRIGIERTE VERSION
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
}
