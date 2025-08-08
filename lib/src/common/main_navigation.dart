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

  @override
  void initState() {
    super.initState();
  }

  void navigateTo(String desc) {
    int index = _screens.indexWhere((screen) => screen['title'] == desc);
    if (index != -1) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Funktion für den Zurück-Button
  void goBack() {
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex = _selectedIndex - 1;
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
        navigateTo: navigateTo, // Korrigiert: direkter Aufruf der Funktion
        navigateToDatabase: navigateToDatabase,
        navigateToNews: navigateToNews,
      ),
      body: screens[_selectedIndex]['screen'],
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
