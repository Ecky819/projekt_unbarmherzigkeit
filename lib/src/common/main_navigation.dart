import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projekt_unbarmherzigkeit/src/features/home/home_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/timeline/timeline_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/map/map_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/favorites/favorites_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/profiles/login_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/profiles/profile_screen.dart';
import '../data/database_repository.dart';
import '../data/firebase_repository.dart';
import '../data/data_initialization.dart';
import '../services/auth_service.dart';
import '../services/platform_service.dart';
import '../../l10n/app_localizations.dart';
import 'navigation/desktop_navigation.dart';
import 'navigation/tablet_navigation.dart';
import 'navigation/mobile_navigation.dart';

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
  DatabaseRepository? _currentRepository;
  bool _isLoadingRepository = false;

  @override
  void initState() {
    super.initState();
    _currentRepository = widget.repository;
    _initializeScreens();

    _authService.authStateChanges.listen((user) async {
      if (mounted) {
        if (user == null && _selectedIndex == 4) {
          setState(() {
            _selectedIndex = 0;
            _navigationHistory.clear();
            _navigationHistory.add(0);
          });
        }
        await _reloadRepositoryOnAuthChange();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {});
          }
        });
      }
    });
  }

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

  void _onDestinationSelected(int index) {
    if (index == 4) {
      navigateToProfile();
    } else if (index != _selectedIndex) {
      _addToHistory();
      setState(() {
        _selectedIndex = index;
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState(l10n);
        }

        if (authSnapshot.hasError) {
          return _buildErrorState(l10n, authSnapshot.error!);
        }

        final isLoggedIn = authSnapshot.data != null;

        List<Map<String, dynamic>> screens = [
          {
            'screen': HomeScreen(
              navigateTo: navigateTo,
              navigateToNews: () {},
              navigateToDatabase: () {},
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

        if (_selectedIndex >= screens.length) {
          _selectedIndex = 0;
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            if (PlatformService.isLargeScreen(context)) {
              return DesktopNavigation(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onDestinationSelected,
                screens: screens,
                authService: _authService,
                repository: _currentRepository,
                l10n: l10n,
                onReloadRepository: _reloadRepositoryOnAuthChange,
                isLoadingRepository: _isLoadingRepository,
                getLocalizedScreenTitle: _getLocalizedScreenTitle,
                buildDatabaseLoadingState: _buildDatabaseLoadingState,
                navigationHistory: _navigationHistory,
                goBack: goBack,
                navigateTo: navigateTo,
                navigateToProfile: navigateToProfile,
                onAddToHistory: _addToHistory,
              );
            } else if (PlatformService.isMediumScreen(context)) {
              return TabletNavigation(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onDestinationSelected,
                screens: screens,
                authService: _authService,
                repository: _currentRepository,
                l10n: l10n,
                onReloadRepository: _reloadRepositoryOnAuthChange,
                isLoadingRepository: _isLoadingRepository,
                getLocalizedScreenTitle: _getLocalizedScreenTitle,
                buildDatabaseLoadingState: _buildDatabaseLoadingState,
                navigationHistory: _navigationHistory,
                goBack: goBack,
                navigateTo: navigateTo,
                navigateToProfile: navigateToProfile,
                onAddToHistory: _addToHistory,
              );
            } else {
              return MobileNavigation(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onDestinationSelected,
                screens: screens,
                authService: _authService,
                repository: _currentRepository,
                l10n: l10n,
                onReloadRepository: _reloadRepositoryOnAuthChange,
                isLoadingRepository: _isLoadingRepository,
                getLocalizedScreenTitle: _getLocalizedScreenTitle,
                buildDatabaseLoadingState: _buildDatabaseLoadingState,
                navigationHistory: _navigationHistory,
                goBack: goBack,
                navigateTo: navigateTo,
                navigateToProfile: navigateToProfile,
                onAddToHistory: _addToHistory,
              );
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
