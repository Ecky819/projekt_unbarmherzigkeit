import 'package:flutter/material.dart';
import 'package:projekt_unbarmherzigkeit/src/features/home/home_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/database/database_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/timeline/timeline_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/map/map_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/news/news_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/favorites/favorites_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/profiles/profile_screen.dart';
import 'custom_appbar.dart';
import 'bottom_navigation.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _screens = [];
  List<int> _navigationHistory = [
    0,
  ]; // History der besuchten Seiten, startet mit Home

  @override
  void initState() {
    super.initState();
  }

  void navigateTo(String desc) {
    int index = _screens.indexWhere((screen) => screen['title'] == desc);
    if (index != -1 && index != _selectedIndex) {
      // Füge aktuellen Index zur History hinzu, falls er nicht bereits der letzte ist
      if (_navigationHistory.isEmpty ||
          _navigationHistory.last != _selectedIndex) {
        _navigationHistory.add(_selectedIndex);
      }

      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Funktion für den Zurück-Button
  void goBack() {
    if (_navigationHistory.isNotEmpty) {
      // Gehe zum vorherigen Bildschirm in der History
      int previousIndex = _navigationHistory.removeLast();
      setState(() {
        _selectedIndex = previousIndex;
      });
    } else {
      // Fallback: Gehe zur Home-Seite
      setState(() {
        _selectedIndex = 0;
        _navigationHistory.clear(); // Clear history when going to home
      });
    }
  }

  // News Navigation unabhängig vom BottomNavigationBar
  void navigateToDatabase() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DatabaseScreen()),
    );
  }

  void navigateToNews() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> screens = [
      {
        'screen': HomeScreen(
          navigateTo: (desc) => navigateTo(desc),
          navigateToNews: () => navigateToNews,
          navigateToDatabase: () => navigateToDatabase,
        ),
        'title': 'Home',
      },
      {'screen': const TimelineScreen(), 'title': 'Timeline'},
      {'screen': const MapScreen(), 'title': 'Karte'},
      {'screen': const FavoriteScreen(), 'title': 'Favoriten'},
      {'screen': const ProfileScreen(), 'title': 'Profil'},
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
        onBackPressed: goBack, // Zurück-Callback hinzugefügt
      ),
      endDrawer: CustomDrawer(
        navigateTo: (desc) {
          // Füge aktuellen Index zur History hinzu, bevor wir über Drawer navigieren
          if (_navigationHistory.isEmpty ||
              _navigationHistory.last != _selectedIndex) {
            _navigationHistory.add(_selectedIndex);
          }
          navigateTo(desc);
        },
        navigateToDatabase: navigateToDatabase,
        navigateToNews: navigateToNews,
      ),
      body: screens[_selectedIndex]['screen'],
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          // Füge aktuellen Index zur History hinzu, bevor wir navigieren
          if (_selectedIndex != index &&
              (_navigationHistory.isEmpty ||
                  _navigationHistory.last != _selectedIndex)) {
            _navigationHistory.add(_selectedIndex);
          }

          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
