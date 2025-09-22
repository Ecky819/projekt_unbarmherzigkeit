import 'package:flutter/material.dart';
import 'package:projekt_unbarmherzigkeit/src/data/database_repository.dart';
import 'package:projekt_unbarmherzigkeit/src/features/admin/admin_dashboard_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/database/database_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/features/news/news_screen.dart';
import 'package:projekt_unbarmherzigkeit/src/services/auth_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/custom_appbar.dart';
import '../../common/bottom_navigation.dart';
//import '../main_navigation.dart';

class MobileNavigation extends StatefulWidget {
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

  const MobileNavigation({
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
  State<MobileNavigation> createState() => _MobileNavigationState();
}

class _MobileNavigationState extends State<MobileNavigation> {
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
              navigateToAdminDashboard: widget.authService.isAdmin
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
    if (!widget.authService.isAdmin) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E5DD),
      appBar: CustomAppBar(
        context: context,
        pageIndex: widget.selectedIndex,
        title: widget.getLocalizedScreenTitle(
          widget.selectedIndex,
          widget.authService.isLoggedIn,
          widget.l10n,
        ),
        navigateTo: widget.navigateTo,
        nav: widget.screens.map((screen) => screen['screen']).toList(),
        onBackPressed: widget.navigationHistory.isNotEmpty
            ? widget.goBack
            : null,
      ),
      endDrawer: CustomDrawer(
        navigateTo: (desc) {
          if (desc == widget.l10n.navigationprofile) {
            widget.navigateToProfile();
          } else {
            widget.onAddToHistory();
            widget.navigateTo(desc);
          }
        },
        navigateToDatabase: navigateToDatabase,
        navigateToNews: navigateToNews,
        navigateToAdminDashboard: widget.authService.isAdmin
            ? navigateToAdminDashboard
            : null,
      ),
      body: widget.isLoadingRepository
          ? widget.buildDatabaseLoadingState(widget.l10n)
          : IndexedStack(
              index: widget.selectedIndex,
              children: widget.screens
                  .map((screen) => screen['screen'] as Widget)
                  .toList(),
            ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: widget.selectedIndex,
        onDestinationSelected: widget.onDestinationSelected,
      ),
    );
  }
}

// Hier würden die anderen Helper-Klassen und -Methoden hin, die nur von MobileNavigation verwendet werden, aber für diesen Vorschlag bleiben sie in ihren Originaldateien.
