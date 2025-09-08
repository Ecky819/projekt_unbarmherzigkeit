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
import '../data/firebase_repository.dart';
import '../data/data_initialization.dart';
import '../services/auth_service.dart';
import '../services/platform_service.dart';
import '../common/language_switcher.dart';
import 'custom_appbar.dart';
import 'bottom_navigation.dart';
import '../../l10n/app_localizations.dart';

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
      final newRepository = await _initializeRepository();

      if (mounted) {
        setState(() {
          _currentRepository = newRepository;
          _isLoadingRepository = false;
        });
      }
    } catch (e) {
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

  // Lokalisierte Screen-Titel
  String _getLocalizedScreenTitle(
    int index,
    bool isLoggedIn,
    AppLocalizations l10n,
  ) {
    switch (index) {
      case 0:
        return l10n.navigationhome;
      case 1:
        return l10n.navigationtimeline;
      case 2:
        return l10n.navigationmap;
      case 3:
        return l10n.navigationfavorites;
      case 4:
        return isLoggedIn ? l10n.navigationprofile : l10n.navigationlogin;
      default:
        return l10n.commonunknown;
    }
  }

  // Navigation Helper Methods - Lokalisiert
  void navigateToDatabase() {
    final l10n = AppLocalizations.of(context)!;

    if (_authService.isLoggedIn) {
      if (_currentRepository != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DatabaseScreen(
              repository: _currentRepository,
              // WICHTIG: Übergebe alle Navigation-Callbacks!
              navigateTo: (String destination) {
                // Navigation zu den Hauptscreens
                if (destination == l10n.navigationhome) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  setState(() {
                    _selectedIndex = 0;
                  });
                } else if (destination == l10n.navigationtimeline) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  setState(() {
                    _selectedIndex = 1;
                  });
                } else if (destination == l10n.navigationmap) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  setState(() {
                    _selectedIndex = 2;
                  });
                } else if (destination == l10n.navigationfavorites) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  setState(() {
                    _selectedIndex = 3;
                  });
                } else if (destination == l10n.navigationprofile) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  if (_authService.isLoggedIn) {
                    setState(() {
                      _selectedIndex = 4;
                    });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                }
              },
              navigateToNews: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsScreen()),
                );
              },
              navigateToAdminDashboard: _authService.isAdmin
                  ? () {
                      if (_currentRepository != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminDashboardScreen(
                              repository: _currentRepository!,
                            ),
                          ),
                        );
                      }
                    }
                  : null, // NULL wenn User kein Admin ist!
            ),
          ),
        );
      } else {
        _showErrorSnackBar(l10n.errorRepositoryUnavailable);
        _reloadRepositoryOnAuthChange();
      }
    } else {
      _navigateToLogin(l10n.errorDatabaseLoginRequired);
    }
  }

  void navigateToNews() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewsScreen()),
    );
  }

  void navigateToAdminDashboard() {
    final l10n = AppLocalizations.of(context)!;

    if (!_authService.isLoggedIn) {
      _navigateToLogin(l10n.errorAdminLoginRequired);
      return;
    }

    if (!_authService.isAdmin) {
      _showErrorSnackBar(l10n.errorAdminPermissionRequired);
      return;
    }

    if (_currentRepository == null) {
      _showErrorSnackBar(l10n.errorRepositoryUnavailable);
      _reloadRepositoryOnAuthChange();
      return;
    }

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
    final l10n = AppLocalizations.of(context)!;

    if (_authService.isLoggedIn) {
      _addToHistory();
      setState(() {
        _selectedIndex = 4;
      });
    } else {
      _navigateToLogin(l10n.errorDatabaseLoginRequired);
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
            setState(() {});
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

  // Loading State - Lokalisiert
  Widget _buildLoadingState(AppLocalizations l10n) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFF283A49)),
            const SizedBox(height: 16),
            Text(
              l10n.loadingNavigation,
              style: const TextStyle(
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

  // Error State - Lokalisiert
  Widget _buildErrorState(AppLocalizations l10n, Object error) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              l10n.errorLoadingNavigation(error.toString()),
              style: const TextStyle(fontSize: 16, fontFamily: 'SF Pro'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: Text(l10n.errorRetryButton),
            ),
          ],
        ),
      ),
    );
  }

  // Database Loading State - Lokalisiert
  Widget _buildDatabaseLoadingState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF283A49)),
          const SizedBox(height: 16),
          Text(
            l10n.loadingDatabase,
            style: const TextStyle(
              color: Color(0xFF283A49),
              fontSize: 16,
              fontFamily: 'SF Pro',
            ),
          ),
        ],
      ),
    );
  }

  // Build Navigation Destinations für Rail/Drawer - Lokalisiert
  List<NavigationDestination> _buildNavigationDestinations(
    AppLocalizations l10n,
  ) {
    return [
      NavigationDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: l10n.navigationhome,
      ),
      NavigationDestination(
        icon: const ImageIcon(AssetImage('assets/icons/timeline_icon.png')),
        selectedIcon: const ImageIcon(
          AssetImage('assets/icons/timeline_icon.png'),
        ),
        label: l10n.navigationtimeline,
      ),
      NavigationDestination(
        icon: const Icon(Icons.map_outlined),
        selectedIcon: const Icon(Icons.map),
        label: l10n.navigationmap,
      ),
      NavigationDestination(
        icon: const Icon(Icons.bookmark_outline),
        selectedIcon: const Icon(Icons.bookmark),
        label: l10n.navigationfavorites,
      ),
      NavigationDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: _authService.isLoggedIn
            ? l10n.navigationprofile
            : l10n.navigationlogin,
      ),
    ];
  }

  // User Info Badge - Lokalisiert
  Widget _buildUserInfoBadge(AppLocalizations l10n) {
    if (_authService.isLoggedIn) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF283A49).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              _authService.isAdmin ? Icons.admin_panel_settings : Icons.person,
              size: 20,
              color: _authService.isAdmin
                  ? Colors.orange
                  : const Color(0xFF283A49),
            ),
            const SizedBox(width: 8),
            Text(
              _authService.currentUser?.email ?? l10n.unknownEmail,
              style: const TextStyle(fontSize: 14, fontFamily: 'SF Pro'),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // Desktop Layout mit Navigation Rail - Lokalisiert
  Widget _buildDesktopLayout(
    List<Map<String, dynamic>> screens,
    AppLocalizations l10n,
  ) {
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
                      tooltip: _isNavigationRailExtended
                          ? l10n.navigationRailCollapse
                          : l10n.navigationRailExtend,
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
                              if (_authService.isAdmin) _buildAdminButton(l10n),
                              const Divider(color: Colors.white24),
                              _buildQuickAccessButtons(l10n),
                              const SizedBox(height: 16),
                              // Language Switcher für Desktop
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: const LanguageSwitcher(
                                  compact: true,
                                  showText: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: const LanguageSwitcher(
                        compact: true,
                        showText: false,
                      ),
                    ),
              destinations: _buildNavigationDestinations(l10n)
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
                            _getLocalizedScreenTitle(
                              _selectedIndex,
                              _authService.isLoggedIn,
                              l10n,
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
                          _buildUserInfoBadge(l10n),
                        ],
                      ),
                    ),
                  ),

                  // Main Content
                  Expanded(
                    child: _isLoadingRepository
                        ? _buildDatabaseLoadingState(l10n)
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

  // Tablet Layout - Kompakte Navigation - Lokalisiert
  Widget _buildTabletLayout(
    List<Map<String, dynamic>> screens,
    AppLocalizations l10n,
  ) {
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
            destinations: _buildNavigationDestinations(l10n)
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
                  _getLocalizedScreenTitle(
                    _selectedIndex,
                    _authService.isLoggedIn,
                    l10n,
                  ),
                ),
                actions: [
                  if (_authService.isAdmin)
                    IconButton(
                      icon: const Icon(Icons.admin_panel_settings),
                      onPressed: navigateToAdminDashboard,
                      tooltip: l10n.adminDashboardTooltip,
                    ),
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => _showMobileDrawer(context, l10n),
                  ),
                ],
              ),
              body: _isLoadingRepository
                  ? _buildDatabaseLoadingState(l10n)
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

  // Mobile Layout - Original - Lokalisiert
  Widget _buildMobileLayout(
    List<Map<String, dynamic>> screens,
    AppLocalizations l10n,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD),
      appBar: CustomAppBar(
        context: context,
        pageIndex: _selectedIndex,
        title: _getLocalizedScreenTitle(
          _selectedIndex,
          _authService.isLoggedIn,
          l10n,
        ),
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
          ? _buildDatabaseLoadingState(l10n)
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

  // Helper Widgets - Lokalisiert
  Widget _buildAdminButton(AppLocalizations l10n) {
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
        label: Text(
          l10n.admindashboard,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildQuickAccessButtons(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.quickAccessTitle,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: navigateToDatabase,
          icon: const Icon(Icons.data_usage, color: Colors.white70),
          label: Text(
            l10n.navigationdatabase,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        TextButton.icon(
          onPressed: navigateToNews,
          icon: const Icon(Icons.newspaper, color: Colors.white70),
          label: Text(
            l10n.navigationnews,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  void _showMobileDrawer(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.mobileDrawerTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'SF Pro',
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.data_usage),
              title: Text(l10n.navigationdatabase),
              onTap: () {
                Navigator.pop(context);
                navigateToDatabase();
              },
            ),
            ListTile(
              leading: const Icon(Icons.newspaper),
              title: Text(l10n.navigationnews),
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
                title: Text(l10n.admindashboard),
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
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, authSnapshot) {
        // Loading State
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState(l10n);
        }

        // Error State
        if (authSnapshot.hasError) {
          return _buildErrorState(l10n, authSnapshot.error!);
        }

        final isLoggedIn = authSnapshot.data != null;

        // Screens basierend auf Auth-Status definieren - Lokalisiert
        List<Map<String, dynamic>> screens = [
          {
            'screen': HomeScreen(
              navigateTo: navigateTo,
              navigateToNews: navigateToNews,
              navigateToDatabase: navigateToDatabase,
            ),
            'title': l10n.navigationhome,
          },
          {'screen': const TimelineScreen(), 'title': l10n.navigationtimeline},
          {'screen': const MapScreen(), 'title': l10n.navigationmap},
          {
            'screen': FavoriteScreen(repository: _currentRepository),
            'title': l10n.navigationfavorites,
          },
          {
            'screen': isLoggedIn ? const ProfileScreen() : const LoginScreen(),
            'title': isLoggedIn ? l10n.navigationprofile : l10n.navigationlogin,
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
              return _buildDesktopLayout(screens, l10n);
            }
            // Tablet Layout (600-1200px)
            else if (PlatformService.isMediumScreen(context)) {
              return _buildTabletLayout(screens, l10n);
            }
            // Mobile Layout (< 600px)
            else {
              return _buildMobileLayout(screens, l10n);
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
