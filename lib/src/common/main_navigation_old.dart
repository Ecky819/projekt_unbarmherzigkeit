import 'package:flutter/material.dart';
import '../features/home/home_screen.dart';
import '../features/database/database_screen.dart';
import '../features/timeline/timeline_screen.dart';
import '../features/map/map_screen.dart';
import '../features/news/news_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/profiles/profile_screen.dart';
import 'custom_appbar_with_logo.dart';
import 'bottom_navigation.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(
        navigateToTimeline: navigateToTimeline,
        navigateToMap: navigateToMap,
        navigateToNews: navigateToNews,
        navigateToDatabase: navigateToDatabase,
      ),
      const TimelineScreen(),
      const MapScreen(),
      const FavoriteScreen(),
      const ProfileScreen(),
    ];
  }

  void navigateToHome() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  void navigateToTimeline() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  void navigateToMap() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  void navigateToFavorites() {
    setState(() {
      _selectedIndex = 3;
    });
  }

  void navigateToProfile() {
    setState(() {
      _selectedIndex = 4;
    });
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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(233, 229, 221, 1.0),
      appBar: CustomAppBarWithLogo(context: context),
      endDrawer: CustomDrawer(
        navigateToHome: navigateToHome,
        navigateToDatabase: navigateToDatabase,
        navigateToNews: navigateToNews,
        navigateToTimeline: navigateToTimeline,
        navigateToMap: navigateToMap,
        navigateToFavorites: navigateToFavorites,
        navigateToProfile: navigateToProfile,
      ),
      body: _pages[_selectedIndex],
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
