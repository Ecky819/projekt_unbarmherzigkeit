import 'package:flutter/material.dart';

class CustomAppBarWithHeadline extends StatelessWidget
    implements PreferredSizeWidget {
  final String title; // 1. Titel hinzugefügt

  const CustomAppBarWithHeadline({
    super.key,
    required this.title, // 2. Titel gefordert
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
        leading: IconButton(
          icon: ImageIcon(AssetImage('assets/icons/back_button.png')),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          title, // 3. Dynamischer Titel
          style: const TextStyle(
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 670,
      child: Drawer(
        backgroundColor: const Color.fromRGBO(243, 239, 231, 1.0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(40, 58, 73, 1.0),
              ),
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
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'john.doe@example.com',
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 14,
                      color: Colors.white,
                    ),
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
                  _drawerButton(context, Icons.home_outlined, 'Home'),
                  _drawerButton(context, Icons.settings_outlined, 'Datenbank'),
                  _drawerButton(
                    context,
                    null,
                    'Timeline',
                    iconAsset: 'assets/icons/timeline_icon.png',
                  ),
                  _drawerButton(context, Icons.map_outlined, 'Karte'),
                  _drawerButton(context, Icons.favorite_outline, 'Favoriten'),
                  _drawerButton(context, Icons.person_2_outlined, 'Profil'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerButton(
    BuildContext context,
    IconData? icon,
    String text, {
    String? iconAsset,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: const Color.fromRGBO(40, 58, 73, 1.0),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        icon: iconAsset != null ? ImageIcon(AssetImage(iconAsset)) : Icon(icon),
        label: Text(text, style: const TextStyle(fontFamily: 'SF Pro')),
        onPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$text ausgewählt')));
        },
      ),
    );
  }
}
