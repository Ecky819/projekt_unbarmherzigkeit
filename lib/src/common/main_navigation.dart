import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projekt_unbarmherzigkeit/src/features/home/home_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/database/database_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/timeline/timeline_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/map/map_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/news/news_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/favorites/favorites_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/profiles/login_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/profiles/profile_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/admin/admin_dashboard_screen.dart';
import '../data/databaseRepository.dart';
import '../data/FirebaseRepository.dart';
import '../data/data_initialization.dart';
import '../services/migration_service.dart';
import '../services/auth_service.dart';
import 'custom_appbar.dart';
import 'bottom_navigation.dart';

class MainNavigation extends StatefulWidget {
  final DatabaseRepository? repository;

  const MainNavigation({super.key, this.repository});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _screens = [];
  List<int> _navigationHistory = [0];
  final AuthService _authService = AuthService();

  // Repository management
  DatabaseRepository? _currentRepository;
  bool _isLoadingRepository = false;

  @override
  void initState() {
    super.initState();
    _currentRepository = widget.repository;
    _initializeScreens();

    // Auth-State-Listener mit Repository-Reload
    _authService.authStateChanges.listen((user) async {
      if (mounted) {
        print('Auth state changed: ${user?.email}');

        // Bei Logout: Navigation zum Home-Screen zurücksetzen
        if (user == null && _selectedIndex == 4) {
          setState(() {
            _selectedIndex = 0;
            _navigationHistory.clear();
            _navigationHistory.add(0);
          });
        }

        // Repository neu laden wenn Auth-State sich ändert
        await _reloadRepositoryOnAuthChange();

        // UI nach Auth-State-Change aktualisieren
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              // Force refresh der UI nach Auth-State-Change
            });
          }
        });
      }
    });
  }

  // NEUE METHODE: Repository bei Auth-Änderungen neu laden
  Future<void> _reloadRepositoryOnAuthChange() async {
    if (_isLoadingRepository)
      return; // Verhindere mehrfache gleichzeitige Ladungen

    setState(() {
      _isLoadingRepository = true;
    });

    try {
      print('Reloading repository due to auth state change...');

      // Lade Repository neu
      final newRepository = await _initializeRepository();

      if (mounted) {
        setState(() {
          _currentRepository = newRepository;
          _isLoadingRepository = false;
        });
        print('Repository successfully reloaded');
      }
    } catch (e) {
      print('Error reloading repository: $e');
      if (mounted) {
        setState(() {
          _isLoadingRepository = false;
        });
      }
    }
  }

  // Repository-Initialisierung (aus main.dart extrahiert)
  Future<DatabaseRepository> _initializeRepository() async {
    try {
      // Versuche Firebase Repository zu verwenden
      final firebaseRepo = FirebaseRepository();
      final migrationService = MigrationService();

      // Prüfe ob Daten bereits migriert wurden
      if (!await migrationService.isDataMigrated()) {
        // Migriere Mock-Daten zu Firestore
        await migrationService.migrateMockDataToFirestore();
      }

      return firebaseRepo;
    } catch (e) {
      print('Firebase Repository konnte nicht initialisiert werden: $e');
      print('Verwende Mock Repository als Fallback');

      // Fallback zu Mock Repository
      return await initializeMockData();
    }
  }

  void _initializeScreens() {
    // Basis-Screens werden dynamisch basierend auf Auth-Status erstellt
    // Diese Methode wird bei Auth-State-Änderungen aufgerufen
  }

  // Navigation zu spezifischen Screens
  void navigateTo(String desc) {
    int index = _screens.indexWhere((screen) => screen['title'] == desc);
    if (index != -1 && index != _selectedIndex) {
      _addToHistory();
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Zurück-Navigation
  void goBack() {
    if (_navigationHistory.isNotEmpty) {
      int previousIndex = _navigationHistory.removeLast();
      setState(() {
        _selectedIndex = previousIndex;
      });
    } else {
      setState(() {
        _selectedIndex = 0;
        _navigationHistory.clear();
      });
    }
  }

  // Hilfsmethode für Navigation History
  void _addToHistory() {
    if (_navigationHistory.isEmpty ||
        _navigationHistory.last != _selectedIndex) {
      _navigationHistory.add(_selectedIndex);
    }
  }

  // Auth-geschützte Navigation zur Datenbank
  void navigateToDatabase() {
    if (_authService.isLoggedIn) {
      if (_currentRepository != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DatabaseScreen(repository: _currentRepository),
          ),
        );
      } else {
        _showErrorSnackBar(
          'Repository nicht verfügbar. Laden Sie die App neu.',
        );
        // Versuche Repository neu zu laden
        _reloadRepositoryOnAuthChange();
      }
    } else {
      _navigateToLogin(
        'Sie müssen sich anmelden, um auf die Datenbank zugreifen zu können.',
      );
    }
  }

  // News Navigation
  void navigateToNews() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewsScreen()),
    );
  }

  // Admin Dashboard Navigation mit Repository-Check
  void navigateToAdminDashboard() {
    print('Admin Dashboard Navigation aufgerufen');
    print('User logged in: ${_authService.isLoggedIn}');
    print('User email: ${_authService.currentUser?.email}');
    print('Is admin: ${_authService.isAdmin}');

    if (!_authService.isLoggedIn) {
      _navigateToLogin(
        'Sie müssen sich anmelden, um auf das Admin-Dashboard zugreifen zu können.',
      );
      return;
    }

    if (!_authService.isAdmin) {
      _showErrorSnackBar(
        'Sie haben keine Admin-Berechtigung für diese Funktion.',
      );
      return;
    }

    if (_currentRepository == null) {
      _showErrorSnackBar('Repository nicht verfügbar. Laden Sie die App neu.');
      // Versuche Repository neu zu laden
      _reloadRepositoryOnAuthChange();
      return;
    }

    // Erfolgreiche Navigation zum Admin Dashboard
    print('Navigiere zum Admin Dashboard...');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AdminDashboardScreen(repository: _currentRepository!),
      ),
    ).then((_) {
      // Optional: Refresh nach Rückkehr vom Admin Dashboard
      if (mounted) {
        setState(() {});
      }
    });
  }

  // Auth-basierte Profil-Navigation
  void navigateToProfile() {
    if (_authService.isLoggedIn) {
      // Zeige Profil Screen für eingeloggte User
      _addToHistory();
      setState(() {
        _selectedIndex = 4; // Index für Profile Screen
      });
    } else {
      // Für nicht eingeloggte User: Zeige Login Screen über Navigation
      _navigateToLogin(
        'Melden Sie sich an, um auf Ihr Profil zugreifen zu können.',
      );
    }
  }

  // Helper: Navigation zum Login
  void _navigateToLogin(String message) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    ).then((_) {
      // UI nach potenziellem Login aktualisieren
      if (mounted) {
        // Zusätzliche Verzögerung für Auth-State-Update
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              print(
                'UI nach Login aktualisiert - Admin status: ${_authService.isAdmin}',
              );
            });
          }
        });
      }
    });

    // Optional: Nachricht anzeigen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  // Helper: Fehler-SnackBar
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Helper: Erfolg-SnackBar
  // ignore: unused_element
  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Debug: Admin-Status anzeigen
  void _showAdminDebugInfo() {
    if (!mounted) return;

    final status = _authService.getAdminStatus();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin-Status Debug'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Eingeloggt: ${status['isLoggedIn']}'),
            Text('Admin: ${status['isAdmin']}'),
            Text('E-Mail: ${status['userEmail'] ?? 'Keine'}'),
            Text('Admin-E-Mail: ${status['adminEmail']}'),
            Text('Berechtigung: ${status['hasPermission']}'),
            Text('Rolle: ${_authService.getUserRole()}'),
            Text('Repository geladen: ${_currentRepository != null}'),
            Text('Repository loading: $_isLoadingRepository'),
            const SizedBox(height: 16),
            const Text('Firebase User:'),
            Text('UID: ${_authService.currentUser?.uid ?? 'Keine'}'),
            Text(
              'Email verified: ${_authService.currentUser?.emailVerified ?? false}',
            ),
            const SizedBox(height: 16),
            if (status['isAdmin'] == true) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  navigateToAdminDashboard();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Test Admin Dashboard'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _reloadRepositoryOnAuthChange();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Repository neu laden'),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {}); // Force refresh
            },
            child: const Text('Refresh UI'),
          ),
        ],
      ),
    );
  }

  // Hilfsmethode: Screen-Titel basierend auf Auth-Status ermitteln
  String _getScreenTitle(int index, bool isLoggedIn) {
    const List<String> baseTitles = ['Home', 'Timeline', 'Karte', 'Favoriten'];

    if (index < baseTitles.length) {
      return baseTitles[index];
    } else if (index == 4) {
      return isLoggedIn ? 'Profil' : 'Anmelden';
    }

    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        // Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color.fromRGBO(233, 229, 221, 1.0),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF283A49)),
                  SizedBox(height: 16),
                  Text(
                    'Lade Navigation...',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'SFPro',
                      color: Color(0xFF283A49),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Error State
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(233, 229, 221, 1.0),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Fehler beim Laden der Navigation: ${snapshot.error}',
                    style: const TextStyle(fontSize: 16, fontFamily: 'SFPro'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {}); // Neustart versuchen
                    },
                    child: const Text('Erneut versuchen'),
                  ),
                ],
              ),
            ),
          );
        }

        final isLoggedIn = snapshot.data != null;
        final isAdmin = _authService.isAdmin;

        // DEBUG: Ausgabe des aktuellen Auth-Status
        print(
          'StreamBuilder Build - User: ${snapshot.data?.email}, Admin: $isAdmin, Repository: ${_currentRepository != null}',
        );

        // Screens basierend auf Auth-Status definieren
        List<Map<String, dynamic>> screens = [
          {
            'screen': HomeScreen(
              navigateTo: navigateTo,
              navigateToNews: navigateToNews,
              navigateToDatabase: navigateToDatabase,
            ),
            'title': 'Home',
          },
          {'screen': const TimelineScreen(), 'title': 'Timeline'},
          {'screen': const MapScreen(), 'title': 'Karte'},
          {'screen': const FavoriteScreen(), 'title': 'Favoriten'},
          {
            // Dynamischer Profil Screen basierend auf Auth Status
            'screen': isLoggedIn ? const ProfileScreen() : const LoginScreen(),
            'title': isLoggedIn ? 'Profil' : 'Anmelden',
          },
        ];

        _screens = screens;

        // Index-Validierung
        if (_selectedIndex >= screens.length) {
          _selectedIndex = 0;
        }

        // Dynamischen Titel verwenden
        final currentTitle = _getScreenTitle(_selectedIndex, isLoggedIn);

        // Repository Loading Overlay
        Widget body = IndexedStack(
          index: _selectedIndex,
          children: screens
              .map((screen) => screen['screen'] as Widget)
              .toList(),
        );

        if (_isLoadingRepository) {
          body = Stack(
            children: [
              body,
              Container(
                color: Colors.black54,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Datenbank wird neu geladen...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'SFPro',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return Scaffold(
          backgroundColor: const Color.fromRGBO(233, 229, 221, 1.0),
          appBar: CustomAppBar(
            context: context,
            pageIndex: _selectedIndex,
            title: currentTitle,
            navigateTo: navigateTo,
            nav: _screens.map((screen) => screen['screen']).toList(),
            onBackPressed: _navigationHistory.isNotEmpty ? goBack : null,
          ),
          endDrawer: CustomDrawer(
            navigateTo: (desc) {
              if (desc == 'Profil') {
                navigateToProfile();
              } else {
                _addToHistory();
                navigateTo(desc);
              }
            },
            navigateToDatabase: navigateToDatabase,
            navigateToNews: navigateToNews,
            navigateToAdminDashboard: navigateToAdminDashboard,
          ),
          body: body,
          bottomNavigationBar: CustomNavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              if (index == 4) {
                // Spezielle Behandlung für Profil Tab
                navigateToProfile();
              } else if (index != _selectedIndex) {
                _addToHistory();
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
          ),
          // Debug FAB
          floatingActionButton: _buildDebugFAB(isAdmin, isLoggedIn),
        );
      },
    );
  }

  // ERWEITERTE Debug Floating Action Button
  Widget? _buildDebugFAB(bool isAdmin, bool isLoggedIn) {
    // Debug-Modus - in Produktion auf false setzen
    const bool debugMode = true;

    // ignore: dead_code
    if (!debugMode) return null;

    return FloatingActionButton.small(
      onPressed: _showAdminDebugInfo,
      backgroundColor: _isLoadingRepository
          ? Colors.purple
          : (isAdmin
                ? Colors.orange
                : (isLoggedIn ? Colors.blue : Colors.grey)),
      child: Icon(
        _isLoadingRepository
            ? Icons.refresh
            : (isAdmin
                  ? Icons.admin_panel_settings
                  : (isLoggedIn ? Icons.person : Icons.person_off)),
        color: Colors.white,
        size: 16,
      ),
    );
  }
}
