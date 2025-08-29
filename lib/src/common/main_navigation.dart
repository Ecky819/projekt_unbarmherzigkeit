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
import '../data/database_repository.dart';
import '../data/firebaserepository.dart';
import '../data/data_initialization.dart';
import '../services/auth_service.dart';
import '../services/platform_service.dart';
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
  final List<int> _navigationHistory = [0];
  final AuthService _authService = AuthService();

  // Repository management
  DatabaseRepository? _currentRepository;
  bool _isLoadingRepository = false;

  // Für Desktop/Web Navigation Rail
  bool _isNavigationRailExtended = true;

  @override
  void initState() {
    super.initState();
    _currentRepository = widget.repository;
    _initializeScreens();

    // Auth-State-Listener mit Repository-Reload
    _authService.authStateChanges.listen((user) async {
      if (mounted) {
        //print('Auth state changed: ${user?.email}');

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
            setState(() {});
          }
        });
      }
    });
  }

  // Repository bei Auth-Änderungen neu laden
  Future<void> _reloadRepositoryOnAuthChange() async {
    if (_isLoadingRepository) return;

    setState(() {
      _isLoadingRepository = true;
    });

    try {
      //print('Reloading repository due to auth state change...');
      final newRepository = await _initializeRepository();

      if (mounted) {
        setState(() {
          _currentRepository = newRepository;
          _isLoadingRepository = false;
        });
        //print('Repository successfully reloaded');
      }
    } catch (e) {
      //print('Error reloading repository: $e');
      if (mounted) {
        setState(() {
          _isLoadingRepository = false;
        });
      }
    }
  }

  Future<DatabaseRepository> _initializeRepository() async {
    try {
      final firebaseRepo = FirebaseRepository();
      return firebaseRepo;
    } catch (e) {
      // print('Firebase Repository konnte nicht initialisiert werden: $e');
      // print('Verwende Mock Repository als Fallback');
      return await initializeMockData();
    }
  }

  void _initializeScreens() {
    // Screens werden dynamisch basierend auf Auth-Status erstellt
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

  void _addToHistory() {
    if (_navigationHistory.isEmpty ||
        _navigationHistory.last != _selectedIndex) {
      _navigationHistory.add(_selectedIndex);
    }
  }

  // Navigation Helper Methods
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
        _reloadRepositoryOnAuthChange();
      }
    } else {
      _navigateToLogin(
        'Sie müssen sich anmelden, um auf die Datenbank zugreifen zu können.',
      );
    }
  }

  void navigateToNews() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewsScreen()),
    );
  }

  void navigateToAdminDashboard() {
    // print('Admin Dashboard Navigation aufgerufen');
    // print('User logged in: ${_authService.isLoggedIn}');
    // print('User email: ${_authService.currentUser?.email}');
    // print('Is admin: ${_authService.isAdmin}');

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
      _reloadRepositoryOnAuthChange();
      return;
    }

    //print('Navigiere zum Admin Dashboard...');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AdminDashboardScreen(repository: _currentRepository!),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  void navigateToProfile() {
    if (_authService.isLoggedIn) {
      _addToHistory();
      setState(() {
        _selectedIndex = 4;
      });
    } else {
      _navigateToLogin(
        'Melden Sie sich an, um auf Ihr Profil zugreifen zu können.',
      );
    }
  }

  void _navigateToLogin(String message) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    ).then((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              // print(
              //   'UI nach Login aktualisiert - Admin status: ${_authService.isAdmin}',
              // );
            });
          }
        });
      }
    });

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

  String _getScreenTitle(int index, bool isLoggedIn) {
    const List<String> baseTitles = ['Home', 'Timeline', 'Karte', 'Favoriten'];

    if (index < baseTitles.length) {
      return baseTitles[index];
    } else if (index == 4) {
      return isLoggedIn ? 'Profil' : 'Anmelden';
    }
    return 'Unknown';
  }

  // Build Navigation Destinations für Rail/Drawer
  List<NavigationDestination> _buildNavigationDestinations() {
    return [
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      const NavigationDestination(
        icon: ImageIcon(AssetImage('assets/icons/timeline_icon.png')),
        selectedIcon: ImageIcon(AssetImage('assets/icons/timeline_icon.png')),
        label: 'Timeline',
      ),
      const NavigationDestination(
        icon: Icon(Icons.map_outlined),
        selectedIcon: Icon(Icons.map),
        label: 'Karte',
      ),
      const NavigationDestination(
        icon: Icon(Icons.bookmark_outline),
        selectedIcon: Icon(Icons.bookmark),
        label: 'Favoriten',
      ),
      NavigationDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: _authService.isLoggedIn ? 'Profil' : 'Anmelden',
      ),
    ];
  }

  // Desktop/Web Layout mit Navigation Rail
  Widget _buildDesktopLayout(List<Map<String, dynamic>> screens) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD),
      body: Row(
        children: [
          // Navigation Rail
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF283A49),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                if (index == 4) {
                  navigateToProfile();
                } else if (index != _selectedIndex) {
                  _addToHistory();
                  setState(() {
                    _selectedIndex = index;
                  });
                }
              },
              extended: _isNavigationRailExtended,
              backgroundColor: const Color(0xFF283A49),
              selectedIconTheme: const IconThemeData(
                color: Color(0xFF283A49),
                size: 28,
              ),
              unselectedIconTheme: const IconThemeData(
                color: Colors.white70,
                size: 24,
              ),
              selectedLabelTextStyle: const TextStyle(
                color: Color(0xFF283A49),
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelTextStyle: const TextStyle(
                color: Colors.white70,
                fontFamily: 'SF Pro',
                fontSize: 14,
              ),
              indicatorColor: Colors.white,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (_isNavigationRailExtended)
                      Image.asset(
                        'assets/logos/Logo.png',
                        width: 120,
                        height: 56,
                      )
                    else
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    const SizedBox(height: 8),
                    IconButton(
                      icon: Icon(
                        _isNavigationRailExtended
                            ? Icons.menu_open
                            : Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isNavigationRailExtended =
                              !_isNavigationRailExtended;
                        });
                      },
                    ),
                  ],
                ),
              ),
              trailing: _isNavigationRailExtended
                  ? Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_authService.isAdmin) _buildAdminButton(),
                              const Divider(color: Colors.white24),
                              _buildQuickAccessButtons(),
                            ],
                          ),
                        ),
                      ),
                    )
                  : null,
              destinations: _buildNavigationDestinations()
                  .map(
                    (dest) => NavigationRailDestination(
                      icon: dest.icon,
                      selectedIcon: dest.selectedIcon,
                      label: Text(dest.label),
                    ),
                  )
                  .toList(),
            ),
          ),

          // Content Area
          Expanded(
            child: Container(
              color: const Color(0xFFE9E5DD),
              child: Column(
                children: [
                  // Custom App Bar for Web
                  Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Text(
                            _getScreenTitle(
                              _selectedIndex,
                              _authService.isLoggedIn,
                            ),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF283A49),
                              fontFamily: 'SF Pro',
                            ),
                          ),
                          const Spacer(),
                          // User Info Badge
                          if (_authService.isLoggedIn)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF283A49,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _authService.isAdmin
                                        ? Icons.admin_panel_settings
                                        : Icons.person,
                                    size: 20,
                                    color: _authService.isAdmin
                                        ? Colors.orange
                                        : const Color(0xFF283A49),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _authService.currentUser?.email ?? 'Gast',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'SF Pro',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Main Content
                  Expanded(
                    child: _isLoadingRepository
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Color(0xFF283A49),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Datenbank wird neu geladen...',
                                  style: TextStyle(
                                    color: Color(0xFF283A49),
                                    fontSize: 16,
                                    fontFamily: 'SF Pro',
                                  ),
                                ),
                              ],
                            ),
                          )
                        : IndexedStack(
                            index: _selectedIndex,
                            children: screens
                                .map((screen) => screen['screen'] as Widget)
                                .toList(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tablet Layout - Kompakte Navigation
  Widget _buildTabletLayout(List<Map<String, dynamic>> screens) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD),
      body: Row(
        children: [
          // Kompakter Navigation Rail
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              if (index == 4) {
                navigateToProfile();
              } else if (index != _selectedIndex) {
                _addToHistory();
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
            extended: false,
            backgroundColor: const Color(0xFF283A49),
            selectedIconTheme: const IconThemeData(color: Colors.white),
            unselectedIconTheme: const IconThemeData(color: Colors.white70),
            indicatorColor: const Color(0xFF283A49).withValues(alpha: 0.2),
            destinations: _buildNavigationDestinations()
                .map(
                  (dest) => NavigationRailDestination(
                    icon: dest.icon,
                    selectedIcon: dest.selectedIcon,
                    label: Text(dest.label),
                  ),
                )
                .toList(),
          ),

          // Content
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF283A49),
                foregroundColor: Colors.white,
                title: Text(
                  _getScreenTitle(_selectedIndex, _authService.isLoggedIn),
                ),
                actions: [
                  if (_authService.isAdmin)
                    IconButton(
                      icon: const Icon(Icons.admin_panel_settings),
                      onPressed: navigateToAdminDashboard,
                      tooltip: 'Admin Dashboard',
                    ),
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => _showMobileDrawer(context),
                  ),
                ],
              ),
              body: _isLoadingRepository
                  ? const Center(child: CircularProgressIndicator())
                  : IndexedStack(
                      index: _selectedIndex,
                      children: screens
                          .map((screen) => screen['screen'] as Widget)
                          .toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Mobile Layout - Original
  Widget _buildMobileLayout(List<Map<String, dynamic>> screens) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD),
      appBar: CustomAppBar(
        context: context,
        pageIndex: _selectedIndex,
        title: _getScreenTitle(_selectedIndex, _authService.isLoggedIn),
        navigateTo: navigateTo,
        nav: screens.map((screen) => screen['screen']).toList(),
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
      body: _isLoadingRepository
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF283A49)),
                  SizedBox(height: 16),
                  Text(
                    'Datenbank wird neu geladen...',
                    style: TextStyle(
                      color: Color(0xFF283A49),
                      fontSize: 16,
                      fontFamily: 'SF Pro',
                    ),
                  ),
                ],
              ),
            )
          : IndexedStack(
              index: _selectedIndex,
              children: screens
                  .map((screen) => screen['screen'] as Widget)
                  .toList(),
            ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          if (index == 4) {
            navigateToProfile();
          } else if (index != _selectedIndex) {
            _addToHistory();
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }

  // Helper Widgets
  Widget _buildAdminButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: navigateToAdminDashboard,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: const Icon(Icons.admin_panel_settings),
        label: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildQuickAccessButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton.icon(
          onPressed: navigateToDatabase,
          icon: const Icon(Icons.data_usage, color: Colors.white70),
          label: const Text(
            'Datenbank',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        TextButton.icon(
          onPressed: navigateToNews,
          icon: const Icon(Icons.newspaper, color: Colors.white70),
          label: const Text('News', style: TextStyle(color: Colors.white70)),
        ),
      ],
    );
  }

  void _showMobileDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.data_usage),
              title: const Text('Datenbank'),
              onTap: () {
                Navigator.pop(context);
                navigateToDatabase();
              },
            ),
            ListTile(
              leading: const Icon(Icons.newspaper),
              title: const Text('News'),
              onTap: () {
                Navigator.pop(context);
                navigateToNews();
              },
            ),
            if (_authService.isAdmin)
              ListTile(
                leading: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.orange,
                ),
                title: const Text('Admin Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                  navigateToAdminDashboard();
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, authSnapshot) {
        // Loading State
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFE9E5DD),
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
                      fontFamily: 'SF Pro',
                      color: Color(0xFF283A49),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Error State
        if (authSnapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFFE9E5DD),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Fehler beim Laden der Navigation: ${authSnapshot.error}',
                    style: const TextStyle(fontSize: 16, fontFamily: 'SF Pro'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text('Erneut versuchen'),
                  ),
                ],
              ),
            ),
          );
        }

        final isLoggedIn = authSnapshot.data != null;

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
          {
            'screen': FavoriteScreen(repository: _currentRepository),
            'title': 'Favoriten',
          },
          {
            'screen': isLoggedIn ? const ProfileScreen() : const LoginScreen(),
            'title': isLoggedIn ? 'Profil' : 'Anmelden',
          },
        ];

        _screens = screens;

        // Index-Validierung
        if (_selectedIndex >= screens.length) {
          _selectedIndex = 0;
        }

        // Responsive Layout basierend auf Screen Size
        return LayoutBuilder(
          builder: (context, constraints) {
            // Desktop Layout (>= 1200px)
            if (PlatformService.isLargeScreen(context)) {
              return _buildDesktopLayout(screens);
            }
            // Tablet Layout (600-1200px)
            else if (PlatformService.isMediumScreen(context)) {
              return _buildTabletLayout(screens);
            }
            // Mobile Layout (< 600px)
            else {
              return _buildMobileLayout(screens);
            }
          },
        );
      },
    );
  }
}

// Navigation Destination Helper Class
class NavigationDestination {
  final Widget icon;
  final Widget selectedIcon;
  final String label;

  const NavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
