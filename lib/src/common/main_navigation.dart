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
import '../data/databaseRepository.dart';
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

  @override
  void initState() {
    super.initState();
  }

  void navigateTo(String desc) {
    int index = _screens.indexWhere((screen) => screen['title'] == desc);
    if (index != -1 && index != _selectedIndex) {
      if (_navigationHistory.isEmpty ||
          _navigationHistory.last != _selectedIndex) {
        _navigationHistory.add(_selectedIndex);
      }

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

  // Auth-geschützte Navigation zur Datenbank
  void navigateToDatabase() {
    if (_authService.isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DatabaseScreen(repository: widget.repository),
        ),
      );
    } else {
      // Zeige Login Screen wenn nicht eingeloggt
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void navigateToNews() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewsScreen()),
    );
  }

  // Auth-basierte Profil-Navigation
  void navigateToProfile() {
    if (_authService.isLoggedIn) {
      // Zeige Profil Screen für eingeloggte User
      if (_navigationHistory.isEmpty ||
          _navigationHistory.last != _selectedIndex) {
        _navigationHistory.add(_selectedIndex);
      }
      setState(() {
        _selectedIndex = 4; // Index für Profile Screen
      });
    } else {
      // Zeige Login Screen für nicht eingeloggte User
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ).then((_) {
        // Aktualisiere UI nach potenziellem Login
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        final isLoggedIn = snapshot.data != null;

        List<Map<String, dynamic>> screens = [
          {
            'screen': HomeScreen(
              navigateTo: (desc) => navigateTo(desc),
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
            'title': 'Profil',
          },
        ];
        _screens = screens;

        return Scaffold(
          backgroundColor: const Color.fromRGBO(233, 229, 221, 1.0),
          appBar: CustomAppBar(
            context: context,
            pageIndex: _selectedIndex,
            title: screens[_selectedIndex]['title'],
            navigateTo: navigateTo,
            nav: _screens.map((screen) => screen['screen']).toList(),
            onBackPressed: goBack,
          ),
          endDrawer: CustomDrawer(
            navigateTo: (desc) {
              if (desc == 'Profil') {
                // Spezielle Behandlung für Profil-Navigation
                navigateToProfile();
              } else {
                if (_navigationHistory.isEmpty ||
                    _navigationHistory.last != _selectedIndex) {
                  _navigationHistory.add(_selectedIndex);
                }
                navigateTo(desc);
              }
            },
            navigateToDatabase: navigateToDatabase,
            navigateToNews: navigateToNews,
          ),
          body: screens[_selectedIndex]['screen'],
          bottomNavigationBar: CustomNavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              if (index == 4) {
                // Spezielle Behandlung für Profil Tab
                navigateToProfile();
              } else {
                if (_selectedIndex != index &&
                    (_navigationHistory.isEmpty ||
                        _navigationHistory.last != _selectedIndex)) {
                  _navigationHistory.add(_selectedIndex);
                }

                setState(() {
                  _selectedIndex = index;
                });
              }
            },
          ),
        );
      },
    );
  }
}
