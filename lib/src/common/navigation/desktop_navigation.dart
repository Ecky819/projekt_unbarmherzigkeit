import 'package:flutter/material.dart';
import 'package:projekt_unbarmherzigkeit/src/common/language_switcher.dart';
import 'package:projekt_unbarmherzigkeit/src/data/database_repository.dart';
import 'package:projekt_unbarmherzigkeit/src/features/admin/admin_dashboard_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/database/database_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/news/news_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/services/auth_service.dart';
import '../../../l10n/app_localizations.dart';

class DesktopNavigation extends StatefulWidget {
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

  const DesktopNavigation({
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
  State<DesktopNavigation> createState() => _DesktopNavigationState();
}

class _DesktopNavigationState extends State<DesktopNavigation> {
  bool _isNavigationRailExtended = true;
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
              navigateTo: widget.navigateTo,
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

  Widget _buildUserInfoBadge() {
    if (widget.authService.isLoggedIn) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF283A49).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              _isAdmin ? Icons.admin_panel_settings : Icons.person,
              size: 20,
              color: _isAdmin ? Colors.orange : const Color(0xFF283A49),
            ),
            const SizedBox(width: 8),
            Text(
              widget.authService.currentUser?.email ?? widget.l10n.unknownEmail,
              style: const TextStyle(fontSize: 14, fontFamily: 'SF Pro'),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

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
        label: Text(
          widget.l10n.admindashboard,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildQuickAccessButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.l10n.quickAccessTitle,
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
            widget.l10n.navigationdatabase,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        TextButton.icon(
          onPressed: navigateToNews,
          icon: const Icon(Icons.newspaper, color: Colors.white70),
          label: Text(
            widget.l10n.navigationnews,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD),
      body: Row(
        children: [
          Container(
            width: _isNavigationRailExtended ? 250 : 80,
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
              selectedIndex: widget.selectedIndex,
              onDestinationSelected: widget.onDestinationSelected,
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
                          ? widget.l10n.navigationRailCollapse
                          : widget.l10n.navigationRailExtend,
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
                              if (_isAdmin) _buildAdminButton(),
                              const Divider(color: Colors.white24),
                              _buildQuickAccessButtons(),
                              const SizedBox(height: 16),
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
          Expanded(
            child: Container(
              color: const Color(0xFFE9E5DD),
              child: Column(
                children: [
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
                            widget.getLocalizedScreenTitle(
                              widget.selectedIndex,
                              widget.authService.isLoggedIn,
                              widget.l10n,
                            ),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF283A49),
                              fontFamily: 'SF Pro',
                            ),
                          ),
                          const Spacer(),
                          _buildUserInfoBadge(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: widget.isLoadingRepository
                        ? widget.buildDatabaseLoadingState(widget.l10n)
                        : IndexedStack(
                            index: widget.selectedIndex,
                            children: widget.screens
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
