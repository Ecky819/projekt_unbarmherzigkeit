import 'package:flutter/material.dart';
import 'package:projekt_unbarmherzigkeit/src/data/database_repository.dart';
import 'package:projekt_unbarmherzigkeit/src/features/admin/admin_dashboard_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/database/database_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/news/news_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/services/auth_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/custom_appbar.dart';

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
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
    // Listen to auth changes and update admin status
    widget.authService.authStateChanges.listen((_) {
      _checkAdminStatus();
    });
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await widget.authService.isAdmin;
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin;
      });
    }
  }

  void navigateToDatabase() {
    if (widget.authService.isLoggedIn) {
      if (widget.repository != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DatabaseScreen(
              repository: widget.repository,
              navigateTo: (String destination) {
                Navigator.popUntil(context, (route) => route.isFirst);
                widget.navigateTo(destination);
              },
              navigateToNews: navigateToNews,
              navigateToAdminDashboard: _isAdmin
                  ? navigateToAdminDashboard
                  : null,
            ),
          ),
        );
      } else {
        _showErrorSnackBar(widget.l10n.errorRepositoryUnavailable);
        widget.onReloadRepository();
      }
    } else {
      _showErrorSnackBar(widget.l10n.errorDatabaseLoginRequired);
    }
  }

  void navigateToNews() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewsScreen()),
    );
  }

  void navigateToAdminDashboard() {
    if (!widget.authService.isLoggedIn) {
      _showErrorSnackBar(widget.l10n.errorAdminLoginRequired);
      return;
    }
    if (!_isAdmin) {
      _showErrorSnackBar(widget.l10n.errorAdminPermissionRequired);
      return;
    }
    if (widget.repository == null) {
      _showErrorSnackBar(widget.l10n.errorRepositoryUnavailable);
      widget.onReloadRepository();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AdminDashboardScreen(repository: widget.repository!),
      ),
    );
  }

  void _showMobileDrawer() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Color(0xFF283A49),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: CustomDrawer(
          navigateTo: (desc) {
            Navigator.pop(context);
            if (desc == widget.l10n.navigationprofile) {
              widget.navigateToProfile();
            } else {
              widget.onAddToHistory();
              widget.navigateTo(desc);
            }
          },
          navigateToDatabase: () {
            Navigator.pop(context);
            navigateToDatabase();
          },
          navigateToNews: () {
            Navigator.pop(context);
            navigateToNews();
          },
          navigateToAdminDashboard: _isAdmin
              ? () {
                  Navigator.pop(context);
                  navigateToAdminDashboard();
                }
              : null,
        ),
      ),
    );
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
                  if (_isAdmin)
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
