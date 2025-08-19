import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_textstyles.dart';
import '../theme/app_colors.dart';
import '../services/auth_service.dart';

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
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class CustomDrawer extends StatelessWidget {
  final void Function(String) navigateTo;
  final VoidCallback navigateToDatabase;
  final VoidCallback navigateToNews;

  const CustomDrawer({
    super.key,
    required this.navigateTo,
    required this.navigateToDatabase,
    required this.navigateToNews,
  });

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

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

            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                // DrawerHeader - Zeigt User-Info nur wenn eingeloggt
                DrawerHeader(
                  decoration: const BoxDecoration(color: AppColors.primary),
                  child: isLoggedIn
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profilbild - Placeholder
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(36),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // E-Mail des Users
                            Text(
                              user.email ?? 'Unbekannte E-Mail',
                              style: AppTextStyles.drawerUserName,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // Status
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: user.emailVerified
                                    ? Colors.green.withValues(alpha: 0.2)
                                    : Colors.orange.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                user.emailVerified
                                    ? 'Verifiziert'
                                    : 'Nicht verifiziert',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_circle,
                              size: 72,
                              color: Colors.white54,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Nicht angemeldet',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Melden Sie sich an für mehr Funktionen',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _drawerButton(
                        context,
                        icon: Icons.home_outlined,
                        text: 'Home',
                        onTap: () {
                          Navigator.pop(context);
                          navigateTo('Home');
                        },
                      ),
                      _drawerButton(
                        context,
                        icon: Icons.settings,
                        text: 'Datenbank',
                        onTap: () {
                          Navigator.pop(context);
                          navigateToDatabase();
                        },
                      ),
                      _drawerButton(
                        context,
                        icon: Icons.newspaper_outlined,
                        text: 'News',
                        onTap: () {
                          Navigator.pop(context);
                          navigateToNews();
                        },
                      ),
                      _drawerButton(
                        context,
                        icon: null,
                        text: 'Timeline',
                        iconAsset: 'assets/icons/timeline_icon.png',
                        onTap: () {
                          Navigator.pop(context);
                          navigateTo('Timeline');
                        },
                      ),
                      _drawerButton(
                        context,
                        icon: Icons.map_outlined,
                        text: 'Karte',
                        onTap: () {
                          Navigator.pop(context);
                          navigateTo('Karte');
                        },
                      ),
                      _drawerButton(
                        context,
                        icon: Icons.favorite_outline,
                        text: 'Favoriten',
                        onTap: () {
                          Navigator.pop(context);
                          navigateTo('Favoriten');
                        },
                      ),
                      _drawerButton(
                        context,
                        icon: Icons.person_outline,
                        text: 'Profil',
                        onTap: () {
                          Navigator.pop(context);
                          navigateTo('Profil');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _drawerButton(
    BuildContext context, {
    IconData? icon,
    required String text,
    String? iconAsset,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        icon: iconAsset != null ? ImageIcon(AssetImage(iconAsset)) : Icon(icon),
        label: Text(text, style: const TextStyle(fontFamily: 'SF Pro')),
        onPressed: onTap,
      ),
    );
  }
}
