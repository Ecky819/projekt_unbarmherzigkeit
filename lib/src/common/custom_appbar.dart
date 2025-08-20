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
  final VoidCallback? navigateToAdminDashboard; // Optional für Admin

  const CustomDrawer({
    super.key,
    required this.navigateTo,
    required this.navigateToDatabase,
    required this.navigateToNews,
    this.navigateToAdminDashboard, // Optional Parameter
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
            final isAdmin = authService.isAdmin;

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
                                    color: Colors.white.withValues(alpha: 0.2),
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
                                        borderRadius: BorderRadius.circular(10),
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
                              user.email ?? 'Unbekannte E-Mail',
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
                                        ? Colors.green.withValues(alpha: 0.2)
                                        : Colors.orange.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    user.emailVerified
                                        ? 'Verifiziert'
                                        : 'Nicht verifiziert',
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
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'ADMIN',
                                      style: TextStyle(
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

                // Standard Navigation Buttons
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
                        icon: Icons.data_usage,
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
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.admin_panel_settings,
                                size: 16,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'ADMINISTRATOR',
                                style: TextStyle(
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
                            text: 'Admin Dashboard',
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
                            child: _buildAdminStats(authService),
                          ),
                      ],
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

  Widget _buildAdminStats(AuthService authService) {
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
                'Admin-Berechtigung aktiv',
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
            'Vollzugriff auf alle Verwaltungsfunktionen',
            style: TextStyle(fontSize: 10, color: Colors.orange.shade600),
          ),
        ],
      ),
    );
  }
}
