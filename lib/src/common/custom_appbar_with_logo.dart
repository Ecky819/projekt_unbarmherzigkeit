import 'package:flutter/material.dart';
import '../theme/app_textstyles.dart';
import '../theme/app_colors.dart';

class CustomAppBarWithLogo extends StatelessWidget
    implements PreferredSizeWidget {
  final BuildContext context;
  final VoidCallback? navigateToTimeline;

  const CustomAppBarWithLogo({
    super.key,
    required this.context,
    this.navigateToTimeline,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56.0),
      child: AppBar(
        backgroundColor: const Color.fromRGBO(40, 58, 73, 1.0),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.all(0.0),
          child: Image(image: AssetImage('assets/logos/Logo.png'), height: 56),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class CustomDrawer extends StatelessWidget {
  final VoidCallback navigateToTimeline;
  final VoidCallback navigateToMap;
  final VoidCallback navigateToHome;
  final VoidCallback navigateToFavorites;
  final VoidCallback navigateToProfile;
  final VoidCallback navigateToDatabase;
  final VoidCallback navigateToNews;

  const CustomDrawer({
    super.key,
    required this.navigateToTimeline,
    required this.navigateToMap,
    required this.navigateToHome,
    required this.navigateToFavorites,
    required this.navigateToProfile,
    required this.navigateToDatabase,
    required this.navigateToNews,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 670,
      child: Drawer(
        backgroundColor: AppColors.secondary,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage(
                      'assets/images/default_avatar.jpg',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('John Doe', style: AppTextStyles.drawerUserName),
                  const SizedBox(height: 4),
                  Text(
                    'john.doe@example.com',
                    style: AppTextStyles.drawerUserEmail,
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
                      navigateToHome();
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
                      navigateToTimeline();
                    },
                  ),
                  _drawerButton(
                    context,
                    icon: Icons.map_outlined,
                    text: 'Karte',
                    onTap: () {
                      Navigator.pop(context);
                      navigateToMap();
                    },
                  ),
                  _drawerButton(
                    context,
                    icon: Icons.favorite_outline,
                    text: 'Favoriten',
                    onTap: () {
                      Navigator.pop(context);
                      navigateToFavorites();
                    },
                  ),
                  _drawerButton(
                    context,
                    icon: Icons.person_outline,
                    text: 'Profil',
                    onTap: () {
                      Navigator.pop(context);
                      navigateToProfile();
                    },
                  ),
                  // Weitere Buttons...
                ],
              ),
            ),
          ],
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
