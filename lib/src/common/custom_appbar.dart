import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../theme/app_textstyles.dart';
import '../theme/app_colors.dart';
import '../services/auth_service.dart';
import '../services/language_service.dart';
import '../../l10n/app_localizations.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final void Function(String) navigateTo;
  final VoidCallback? onBackPressed;
  final int pageIndex;
  final String title;
  final List<dynamic> nav;

  const CustomAppBar({
    super.key,
    required this.context,
    required this.pageIndex,
    this.title = "",
    required this.navigateTo,
    required this.nav,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56.0),
      child: AppBar(
        backgroundColor: const Color.fromRGBO(40, 58, 73, 1.0),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: pageIndex == 0 ? false : true,
        titleSpacing: 0,
        leading: (pageIndex > 0
            ? IconButton(
                onPressed: () {
                  if (onBackPressed != null) {
                    onBackPressed!();
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: Image.asset('assets/icons/back_button.png'),
                tooltip: AppLocalizations.of(context)?.commonback ?? 'Back',
              )
            : null),
        title: (pageIndex == 0
            ? const Padding(
                padding: EdgeInsets.all(0.0),
                child: Image(
                  image: AssetImage('assets/logos/Logo.png'),
                  height: 56,
                ),
              )
            : Text(
                title,
                style: const TextStyle(
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              )),
        actions: [
          // Language Switcher Button - ruft denselben Dialog auf
          Consumer<LanguageService>(
            builder: (context, languageService, child) {
              return IconButton(
                onPressed: () => _showLanguageDialog(context),
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      languageService.currentLanguageFlag,
                      width: 20,
                      height: 14,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.language,
                          size: 20,
                          color: Colors.white,
                        );
                      },
                    ),
                  ],
                ),
                tooltip:
                    AppLocalizations.of(context)?.languageSwitch ?? 'Language',
              );
            },
          ),
          const SizedBox(width: 8),
          // Drawer Button
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.white,
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: AppLocalizations.of(context)?.commonclose ?? 'Menu',
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  // Zentrale Language Dialog Methode - wird von AppBar und Drawer verwendet
  static void _showLanguageDialog(BuildContext context) {
    final languageService = context.read<LanguageService>();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            l10n.languageDialogTitle,
            style: const TextStyle(fontFamily: 'SF Pro'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: LanguageService.supportedLocales.map((locale) {
              final isSelected = locale == languageService.currentLocale;
              final displayName = _getDisplayName(locale.languageCode);
              final flagPath = _getFlagPath(locale.languageCode);

              return ListTile(
                leading: Image.asset(
                  flagPath,
                  width: 32,
                  height: 22,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.language, size: 24);
                  },
                ),
                title: Text(
                  displayName,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontFamily: 'SF Pro',
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check,
                        color: Theme.of(dialogContext).primaryColor,
                      )
                    : null,
                onTap: () {
                  languageService.changeLanguage(locale);
                  Navigator.of(dialogContext).pop();
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.languageDialogClose,
                style: const TextStyle(
                  fontFamily: 'SF Pro',
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper-Methoden für Language Dialog
  static String _getDisplayName(String languageCode) {
    switch (languageCode) {
      case 'el':
        return 'Ελληνικά (Greek)';
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch (German)';
      default:
        return 'Deutsch';
    }
  }

  static String _getFlagPath(String languageCode) {
    switch (languageCode) {
      case 'el':
        return 'assets/icons/flag_greece.png';
      case 'en':
        return 'assets/icons/flag_uk.png';
      case 'de':
        return 'assets/icons/flag_de.png';
      default:
        return 'assets/icons/flag_de.png';
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class CustomDrawer extends StatelessWidget {
  final void Function(String) navigateTo;
  final VoidCallback navigateToDatabase;
  final VoidCallback navigateToNews;
  final VoidCallback? navigateToAdminDashboard;

  const CustomDrawer({
    super.key,
    required this.navigateTo,
    required this.navigateToDatabase,
    required this.navigateToNews,
    this.navigateToAdminDashboard,
  });

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: 300,
      height: 670,
      child: Drawer(
        backgroundColor: AppColors.secondary,
        child: StreamBuilder<User?>(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            final user = snapshot.data;
            final isLoggedIn = user != null;

            return FutureBuilder<bool>(
              future: authService.isAdmin,
              builder: (context, adminSnapshot) {
                final isAdmin = adminSnapshot.data ?? false;

                return ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    // DrawerHeader - Erweitert mit Admin-Indikator
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        gradient: isAdmin
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary,
                                  Colors.orange.withValues(alpha: 0.3),
                                ],
                              )
                            : null,
                      ),
                      child: isLoggedIn
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Profilbild mit Admin-Badge
                                Stack(
                                  children: [
                                    Container(
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(36),
                                        border: isAdmin
                                            ? Border.all(
                                                color: Colors.orange,
                                                width: 2,
                                              )
                                            : null,
                                      ),
                                      child: Icon(
                                        isAdmin
                                            ? Icons.admin_panel_settings
                                            : Icons.person,
                                        size: 36,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (isAdmin)
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.star,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // E-Mail des Users
                                Text(
                                  user.email ?? l10n.unknownEmail,
                                  style: AppTextStyles.drawerUserName,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                // Status Row mit Admin-Badge
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Verifikations-Status
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: user.emailVerified
                                            ? Colors.green.withValues(
                                                alpha: 0.2,
                                              )
                                            : Colors.orange.withValues(
                                                alpha: 0.2,
                                              ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        user.emailVerified
                                            ? l10n.profileverified
                                            : l10n.profilenotVerified,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    // Admin-Badge
                                    if (isAdmin) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withValues(
                                            alpha: 0.9,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          l10n.adminBadge,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.account_circle,
                                  size: 72,
                                  color: Colors.white54,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.drawernotLoggedIn,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  l10n.drawerloginForMoreFeatures,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 14),

                    // Standard Navigation Buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _drawerButton(
                            context,
                            icon: Icons.home_outlined,
                            text: l10n.drawerhome,
                            onTap: () {
                              Navigator.pop(context);
                              navigateTo(l10n.navigationhome);
                            },
                          ),
                          _drawerButton(
                            context,
                            icon: Icons.data_usage,
                            text: l10n.drawerdatabase,
                            onTap: () {
                              Navigator.pop(context);
                              navigateToDatabase();
                            },
                          ),
                          _drawerButton(
                            context,
                            icon: Icons.newspaper_outlined,
                            text: l10n.drawernews,
                            onTap: () {
                              Navigator.pop(context);
                              navigateToNews();
                            },
                          ),
                          _drawerButton(
                            context,
                            icon: null,
                            text: l10n.drawertimeline,
                            iconAsset: 'assets/icons/timeline_icon.png',
                            onTap: () {
                              Navigator.pop(context);
                              navigateTo(l10n.navigationtimeline);
                            },
                          ),
                          _drawerButton(
                            context,
                            icon: Icons.map_outlined,
                            text: l10n.drawermap,
                            onTap: () {
                              Navigator.pop(context);
                              navigateTo(l10n.navigationmap);
                            },
                          ),
                          _drawerButton(
                            context,
                            icon: Icons.bookmark_outline,
                            text: l10n.drawerfavorites,
                            onTap: () {
                              Navigator.pop(context);
                              navigateTo(l10n.navigationfavorites);
                            },
                          ),
                          _drawerButton(
                            context,
                            icon: Icons.person_outline,
                            text: l10n.drawerprofile,
                            onTap: () {
                              Navigator.pop(context);
                              navigateTo(l10n.navigationprofile);
                            },
                          ),
                          // Admin Section - nur wenn Admin und Dashboard verfügbar
                          if (isAdmin && navigateToAdminDashboard != null) ...[
                            const SizedBox(height: 16),

                            // Admin Trennlinie
                            Container(
                              height: 1,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.orange.withValues(alpha: 0.5),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),

                            // Admin Label
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.admin_panel_settings,
                                    size: 16,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.draweradministrator,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Admin Dashboard Button
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.orange.withValues(alpha: 0.1),
                                    Colors.deepOrange.withValues(alpha: 0.1),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.orange.withValues(alpha: 0.5),
                                  width: 1,
                                ),
                              ),
                              child: _drawerButton(
                                context,
                                icon: Icons.dashboard_customize,
                                text: l10n.draweradminDashboard,
                                onTap: () {
                                  Navigator.pop(context);
                                  navigateToAdminDashboard!();
                                },
                                isAdmin: true,
                              ),
                            ),

                            // Admin Statistiken (falls verfügbar)
                            if (isLoggedIn)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: _buildAdminStats(
                                  context,
                                  authService,
                                  l10n,
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Language Section für Drawer - verwendet denselben Dialog wie AppBar

  Widget _drawerButton(
    BuildContext context, {
    IconData? icon,
    required String text,
    String? iconAsset,
    required VoidCallback onTap,
    bool isAdmin = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: isAdmin ? Colors.orange : AppColors.primary,
          foregroundColor: Colors.white,
          elevation: isAdmin ? 6 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        icon: iconAsset != null ? ImageIcon(AssetImage(iconAsset)) : Icon(icon),
        label: Text(
          text,
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontWeight: isAdmin ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildAdminStats(
    BuildContext context,
    AuthService authService,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              Text(
                l10n.draweradminPermissionActive,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.drawerfullAccess,
            style: TextStyle(fontSize: 10, color: Colors.orange.shade600),
          ),
        ],
      ),
    );
  }
}
