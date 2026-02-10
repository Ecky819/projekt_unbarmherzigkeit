import 'package:flutter/material.dart';
import 'package:projekt_unbarmherzigkeit/src/common/language_switcher.dart';
import 'package:projekt_unbarmherzigkeit/src/data/database_repository.dart';
import 'package:projekt_unbarmherzigkeit/src/features/admin/admin_dashboard_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/database/database_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/impressum/impressum_screen.dart';
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
  int _hoveredIndex = -1;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
    widget.authService.authStateChanges.listen((_) {
      _checkAdminStatus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  void navigateToImpressum() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ImpressumScreen()),
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

  List<_NavItem> _buildNavItems() {
    return [
      _NavItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: widget.l10n.navigationhome,
        isAssetIcon: false,
      ),
      _NavItem(
        icon: Icons.timeline,
        selectedIcon: Icons.timeline,
        label: widget.l10n.navigationtimeline,
        isAssetIcon: true,
        assetPath: 'assets/icons/timeline_icon.png',
      ),
      _NavItem(
        icon: Icons.map_outlined,
        selectedIcon: Icons.map,
        label: widget.l10n.navigationmap,
        isAssetIcon: false,
      ),
      _NavItem(
        icon: Icons.bookmark_outline,
        selectedIcon: Icons.bookmark,
        label: widget.l10n.navigationfavorites,
        isAssetIcon: false,
      ),
      _NavItem(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: widget.authService.isLoggedIn
            ? widget.l10n.navigationprofile
            : widget.l10n.navigationlogin,
        isAssetIcon: false,
      ),
    ];
  }

  Widget _buildSidebarItem(int index, _NavItem item) {
    final isSelected = widget.selectedIndex == index;
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onDestinationSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(
            horizontal: _isNavigationRailExtended ? 12 : 8,
            vertical: 2,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: _isNavigationRailExtended ? 16 : 0,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white
                : isHovered
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: _isNavigationRailExtended
              ? Row(
                  children: [
                    _buildItemIcon(item, isSelected),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF283A49)
                              : Colors.white70,
                          fontFamily: 'SF Pro',
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : Tooltip(
                  message: item.label,
                  preferBelow: false,
                  waitDuration: const Duration(milliseconds: 300),
                  child: Center(child: _buildItemIcon(item, isSelected)),
                ),
        ),
      ),
    );
  }

  Widget _buildItemIcon(_NavItem item, bool isSelected) {
    final color = isSelected ? const Color(0xFF283A49) : Colors.white70;
    final size = isSelected ? 28.0 : 24.0;

    if (item.isAssetIcon && item.assetPath != null) {
      return ImageIcon(
        AssetImage(item.assetPath!),
        color: color,
        size: size,
      );
    }
    return Icon(
      isSelected ? item.selectedIcon : item.icon,
      color: color,
      size: size,
    );
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
        TextButton.icon(
          onPressed: navigateToImpressum,
          icon: const Icon(Icons.info_outline, color: Colors.white70),
          label: const Text(
            'Impressum',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _buildBreadcrumb() {
    final currentTitle = widget.getLocalizedScreenTitle(
      widget.selectedIndex,
      widget.authService.isLoggedIn,
      widget.l10n,
    );

    return Row(
      children: [
        Icon(
          Icons.home,
          size: 16,
          color: const Color(0xFF283A49).withValues(alpha: 0.5),
        ),
        const SizedBox(width: 4),
        Text(
          widget.l10n.navigationhome,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'SF Pro',
            color: const Color(0xFF283A49).withValues(alpha: 0.5),
          ),
        ),
        if (widget.selectedIndex != 0) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.chevron_right,
              size: 16,
              color: const Color(0xFF283A49).withValues(alpha: 0.4),
            ),
          ),
          Text(
            currentTitle,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
              color: Color(0xFF283A49),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final navItems = _buildNavItems();

    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD),
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: _isNavigationRailExtended ? 250 : 72,
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
            child: Column(
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),
                    crossFadeState: _isNavigationRailExtended
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Image.asset(
                      'assets/logos/Logo.png',
                      width: 220,
                      fit: BoxFit.contain,
                    ),
                    secondChild: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Image.asset(
                        'assets/logos/Logo.png',
                        width: 48,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 8),

                // Navigation Items
                ...List.generate(
                  navItems.length,
                  (index) => _buildSidebarItem(index, navItems[index]),
                ),

                const Spacer(),

                // Bottom section: Admin, QuickAccess, Language, Collapse
                if (_isNavigationRailExtended) ...[
                  if (_isAdmin) _buildAdminButton(),
                  const Divider(color: Colors.white24),
                  _buildQuickAccessButtons(),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: const LanguageSwitcher(
                      compact: true,
                      showText: true,
                    ),
                  ),
                ] else ...[
                  if (_isAdmin)
                    Tooltip(
                      message: widget.l10n.admindashboard,
                      child: IconButton(
                        onPressed: navigateToAdminDashboard,
                        icon: const Icon(
                          Icons.admin_panel_settings,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  Tooltip(
                    message: widget.l10n.navigationdatabase,
                    child: IconButton(
                      onPressed: navigateToDatabase,
                      icon: const Icon(Icons.data_usage, color: Colors.white70),
                    ),
                  ),
                  Tooltip(
                    message: widget.l10n.navigationnews,
                    child: IconButton(
                      onPressed: navigateToNews,
                      icon: const Icon(Icons.newspaper, color: Colors.white70),
                    ),
                  ),
                  Tooltip(
                    message: 'Impressum',
                    child: IconButton(
                      onPressed: navigateToImpressum,
                      icon: const Icon(Icons.info_outline, color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const LanguageSwitcher(
                    compact: true,
                    showText: false,
                  ),
                ],

                const SizedBox(height: 8),
                const Divider(color: Colors.white24, height: 1),

                // Collapse button at the very bottom
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _isNavigationRailExtended
                      ? TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _isNavigationRailExtended = false;
                            });
                          },
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.white70,
                          ),
                          label: Text(
                            widget.l10n.navigationRailCollapse,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : Tooltip(
                          message: widget.l10n.navigationRailExtend,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _isNavigationRailExtended = true;
                              });
                            },
                            icon: const Icon(
                              Icons.chevron_right,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),

          // Main content area
          Expanded(
            child: Container(
              color: const Color(0xFFE9E5DD),
              child: Column(
                children: [
                  // Top Bar
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
                          // Title + Breadcrumb
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.getLocalizedScreenTitle(
                                  widget.selectedIndex,
                                  widget.authService.isLoggedIn,
                                  widget.l10n,
                                ),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF283A49),
                                  fontFamily: 'SF Pro',
                                ),
                              ),
                              const SizedBox(height: 2),
                              _buildBreadcrumb(),
                            ],
                          ),
                          const SizedBox(width: 32),

                          // Search field
                          Expanded(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 400),
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F3EF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'SF Pro',
                                ),
                                decoration: InputDecoration(
                                  hintText: widget.l10n.navigationhome == 'Home'
                                      ? 'Search...'
                                      : 'Suche...',
                                  hintStyle: TextStyle(
                                    color: const Color(0xFF283A49)
                                        .withValues(alpha: 0.4),
                                    fontSize: 14,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: 20,
                                    color: const Color(0xFF283A49)
                                        .withValues(alpha: 0.4),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                ),
                                onSubmitted: (query) {
                                  if (query.trim().isNotEmpty) {
                                    // Navigate to database screen with search
                                    navigateToDatabase();
                                  }
                                },
                              ),
                            ),
                          ),

                          const Spacer(),
                          _buildUserInfoBadge(),
                        ],
                      ),
                    ),
                  ),

                  // Screen content with fade animation
                  Expanded(
                    child: widget.isLoadingRepository
                        ? widget.buildDatabaseLoadingState(widget.l10n)
                        : AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            child: IndexedStack(
                              key: ValueKey(widget.selectedIndex),
                              index: widget.selectedIndex,
                              children: widget.screens
                                  .map(
                                      (screen) => screen['screen'] as Widget)
                                  .toList(),
                            ),
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

// Navigation Item data class
class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isAssetIcon;
  final String? assetPath;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.isAssetIcon = false,
    this.assetPath,
  });
}