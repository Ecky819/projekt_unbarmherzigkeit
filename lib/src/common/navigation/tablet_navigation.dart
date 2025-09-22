import 'package:flutter/material.dart';
import 'package:projekt_unbarmherzigkeit/src/data/database_repository.dart';
//import 'package:projekt_unbarmherzigkeit/src/features/admin/admin_dashboard_screen.dart';
//import 'package:projekt_unbarmherzigkeit/src/features/database/database_screen.dart';
//import 'package:projekt_unbarmherzigkeit/src/features/news/news_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/services/auth_service.dart';
import '../../../l10n/app_localizations.dart';

class TabletNavigation extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final List<Map<String, dynamic>> screens;
  final AuthService authService;
  final DatabaseRepository? repository;
  final AppLocalizations l10n;
  final VoidCallback onReloadRepository;
  final bool isLoadingRepository;
  final String Function(int, bool, AppLocalizations) getLocalizedScreenTitle;
  final Widget Function(AppLocalizations) buildDatabaseLoadingState;
  final List<int> navigationHistory;
  final VoidCallback goBack;
  final Function(String) navigateTo;
  final VoidCallback navigateToProfile;
  final VoidCallback onAddToHistory;

  const TabletNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.screens,
    required this.authService,
    required this.repository,
    required this.l10n,
    required this.onReloadRepository,
    required this.isLoadingRepository,
    required this.getLocalizedScreenTitle,
    required this.buildDatabaseLoadingState,
    required this.navigationHistory,
    required this.goBack,
    required this.navigateTo,
    required this.navigateToProfile,
    required this.onAddToHistory,
  });

  @override
  State<TabletNavigation> createState() => _TabletNavigationState();
}

class _TabletNavigationState extends State<TabletNavigation> {
  void navigateToDatabase() {
    // ...
  }

  void navigateToNews() {
    // ...
  }

  void navigateToAdminDashboard() {
    // ...
  }

  void _showMobileDrawer() {
    // ...
  }

  // ignore: unused_element
  void _showErrorSnackBar(String message) {
    // ...
  }

  List<NavigationDestination> _buildNavigationDestinations() {
    return [
      NavigationDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: widget.l10n.navigationhome,
      ),
      NavigationDestination(
        icon: const ImageIcon(AssetImage('assets/icons/timeline_icon.png')),
        selectedIcon: const ImageIcon(
          AssetImage('assets/icons/timeline_icon.png'),
        ),
        label: widget.l10n.navigationtimeline,
      ),
      NavigationDestination(
        icon: const Icon(Icons.map_outlined),
        selectedIcon: const Icon(Icons.map),
        label: widget.l10n.navigationmap,
      ),
      NavigationDestination(
        icon: const Icon(Icons.bookmark_outline),
        selectedIcon: const Icon(Icons.bookmark),
        label: widget.l10n.navigationfavorites,
      ),
      NavigationDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: widget.authService.isLoggedIn
            ? widget.l10n.navigationprofile
            : widget.l10n.navigationlogin,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: widget.selectedIndex,
            onDestinationSelected: widget.onDestinationSelected,
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
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF283A49),
                foregroundColor: Colors.white,
                title: Text(
                  widget.getLocalizedScreenTitle(
                    widget.selectedIndex,
                    widget.authService.isLoggedIn,
                    widget.l10n,
                  ),
                ),
                actions: [
                  if (widget.authService.isAdmin)
                    IconButton(
                      icon: const Icon(Icons.admin_panel_settings),
                      onPressed: navigateToAdminDashboard,
                      tooltip: widget.l10n.adminDashboardTooltip,
                    ),
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: _showMobileDrawer,
                  ),
                ],
              ),
              body: widget.isLoadingRepository
                  ? widget.buildDatabaseLoadingState(widget.l10n)
                  : IndexedStack(
                      index: widget.selectedIndex,
                      children: widget.screens
                          .map((screen) => screen['screen'] as Widget)
                          .toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
