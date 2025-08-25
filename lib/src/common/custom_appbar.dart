import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../theme/app_textstyles.dart';
import '../theme/app_colors.dart';
import '../services/auth_service.dart';
import '../services/language_service.dart';
import '../common/language_switcher.dart';
import '../../l10n/generated/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final languageService = context.watch<LanguageService>();

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
                tooltip: l10n.commonback,
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
                _getLocalizedTitle(l10n),
                style: const TextStyle(
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              )),
        actions: [
          // Language Switcher für Home Screen
          if (pageIndex == 0) ...[
            const LanguageSwitcher(compact: true, showText: false),
            const SizedBox(width: 8),
          ],
          // Language Switcher für andere Screens (kompakter)
          if (pageIndex != 0) ...[
            PopupMenuButton<Locale>(
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    languageService.currentLanguageFlag,
                    width: 16,
                    height: 11,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.language,
                        size: 16,
                        color: Colors.white,
                      );
                    },
                  ),
                ],
              ),
              tooltip: 'Language / Γλώσσα',
              onSelected: (locale) => languageService.changeLanguage(locale),
              itemBuilder: (context) =>
                  LanguageService.supportedLocales.map((locale) {
                    final isSelected = locale == languageService.currentLocale;
                    final displayName = locale.languageCode == 'el'
                        ? 'Ελληνικά'
                        : 'English';
                    final flagPath = locale.languageCode == 'el'
                        ? 'assets/icons/flag_greece.png'
                        : 'assets/icons/flag_uk.png';

                    return PopupMenuItem<Locale>(
                      value: locale,
                      child: Row(
                        children: [
                          Image.asset(
                            flagPath,
                            width: 24,
                            height: 16,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.language, size: 16);
                            },
                          ),
                          const SizedBox(width: 12),
                          Text(
                            displayName,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : null,
                              fontFamily: 'SF Pro',
                            ),
                          ),
                          if (isSelected) ...[
                            const Spacer(),
                            Icon(
                              Icons.check,
                              size: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }

  String _getLocalizedTitle(AppLocalizations l10n) {
    // Wenn ein spezifischer Titel übergeben wurde, verwende diesen
    if (title.isNotEmpty) {
      // Versuche den Titel zu lokalisieren basierend auf bekannten Titeln
      switch (title.toLowerCase()) {
        case 'datenbank':
        case 'database':
          return l10n.navigationdatabase;
        case 'favoriten':
        case 'favorites':
          return l10n.navigationfavorites;
        case 'profil':
        case 'profile':
          return l10n.navigationprofile;
        case 'anmelden':
        case 'login':
          return l10n.navigationlogin;
        case 'timeline':
        case 'χρονολόγιο':
          return l10n.navigationtimeline;
        case 'karte':
        case 'map':
        case 'χάρτης':
          return l10n.navigationmap;
        case 'news':
        case 'νέα':
          return l10n.navigationnews;
        default:
          return title; // Fallback zum ursprünglichen Titel
      }
    }
    return title;
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
    final languageService = context.watch<LanguageService>();

    return Drawer(
      backgroundColor: AppColors.secondary,
      width: 300,
      child: StreamBuilder<User?>(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          final user = snapshot.data;
          final isLoggedIn = user != null;
          final isAdmin = authService.isAdmin;

          return SafeArea(
            child: Column(
              children: [
                // DrawerHeader mit User-Info
                _buildDrawerHeader(context, user, isLoggedIn, isAdmin, l10n),

                // Hauptnavigation
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 14),

                        // Standard Navigation Buttons
                        _drawerButton(
                          context,
                          icon: Icons.home_outlined,
                          text: l10n.drawerhome,
                          onTap: () {
                            Navigator.pop(context);
                            navigateTo('Home');
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
                            navigateTo('Timeline');
                          },
                        ),
                        _drawerButton(
                          context,
                          icon: Icons.map_outlined,
                          text: l10n.drawermap,
                          onTap: () {
                            Navigator.pop(context);
                            navigateTo('Karte');
                          },
                        ),
                        _drawerButton(
                          context,
                          icon: Icons.favorite_outline,
                          text: l10n.drawerfavorites,
                          onTap: () {
                            Navigator.pop(context);
                            navigateTo('Favoriten');
                          },
                        ),
                        _drawerButton(
                          context,
                          icon: Icons.person_outline,
                          text: l10n.drawerprofile,
                          onTap: () {
                            Navigator.pop(context);
                            navigateTo('Profil');
                          },
                        ),

                        // Admin Section
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
                                  Colors.orange.withOpacity(0.5),
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
                                  Colors.orange.withOpacity(0.1),
                                  Colors.deepOrange.withOpacity(0.1),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.orange.withOpacity(0.5),
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

                          // Admin Statistiken
                          if (isLoggedIn)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: _buildAdminStats(authService, l10n),
                            ),
                        ],

                        // Sprachen-Sektion
                        const SizedBox(height: 20),
                        Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          color: Colors.grey[300],
                        ),

                        // Language Switcher Tile
                        const LanguageSwitcherTile(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Footer mit App-Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border(top: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            languageService.currentLanguageFlag,
                            width: 20,
                            height: 14,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.language, size: 20);
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            languageService.currentLanguageDisplayName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'v1.0',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '#PROJEKT UNBARMHERZIGKEIT',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawerHeader(
    BuildContext context,
    User? user,
    bool isLoggedIn,
    bool isAdmin,
    AppLocalizations l10n,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        gradient: isAdmin
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, Colors.orange.withOpacity(0.3)],
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
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(36),
                        border: isAdmin
                            ? Border.all(color: Colors.orange, width: 2)
                            : null,
                      ),
                      child:
                          user?.photoURL != null && user!.photoURL!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(34),
                              child: Image.network(
                                user.photoURL!,
                                width: 68,
                                height: 68,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    isAdmin
                                        ? Icons.admin_panel_settings
                                        : Icons.person,
                                    size: 36,
                                    color: Colors.white,
                                  );
                                },
                              ),
                            )
                          : Icon(
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
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 2),
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
                  user?.displayName?.isNotEmpty == true
                      ? user!.displayName!
                      : user?.email?.split('@').first ?? l10n.commonunknown,
                  style: AppTextStyles.drawerUserName,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                if (user?.displayName?.isNotEmpty == true) ...[
                  const SizedBox(height: 2),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
                        color: user?.emailVerified == true
                            ? Colors.green.withOpacity(0.2)
                            : Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user?.emailVerified == true
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
                          color: Colors.orange.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          l10n.draweradministrator,
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
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );
  }

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
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: isAdmin ? Colors.orange : AppColors.primary,
            foregroundColor: Colors.white,
            elevation: isAdmin ? 6 : 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          icon: iconAsset != null
              ? ImageIcon(AssetImage(iconAsset), size: 20)
              : Icon(icon, size: 20),
          label: Text(
            text,
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: isAdmin ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget _buildAdminStats(AuthService authService, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.draweradminPermissionActive,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange.shade700,
                  ),
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
