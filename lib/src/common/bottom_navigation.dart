import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        final isLoggedIn = snapshot.data != null;
        final isAdmin = authService.isAdmin;

        return NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          height: 55,
          backgroundColor: const Color.fromRGBO(40, 58, 73, 1.0),
          indicatorColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            // Home
            NavigationDestination(
              icon: ImageIcon(
                const AssetImage('assets/icons/home_icon.png'),
                size: 35,
                color: selectedIndex == 0
                    ? const Color.fromRGBO(131, 132, 140, 1.0)
                    : Colors.white,
              ),
              label: '',
            ),

            // Timeline
            NavigationDestination(
              icon: ImageIcon(
                const AssetImage('assets/icons/timeline_icon.png'),
                size: 35,
                color: selectedIndex == 1
                    ? const Color.fromRGBO(131, 132, 140, 1.0)
                    : Colors.white,
              ),
              label: '',
            ),

            // Map
            NavigationDestination(
              icon: ImageIcon(
                const AssetImage('assets/icons/map_icon.png'),
                size: 35,
                color: selectedIndex == 2
                    ? const Color.fromRGBO(131, 132, 140, 1.0)
                    : Colors.white,
              ),
              label: '',
            ),

            // Bookmarks
            NavigationDestination(
              icon: ImageIcon(
                const AssetImage('assets/icons/bookmark_icon.png'),
                size: 30,
                color: selectedIndex == 3
                    ? const Color.fromRGBO(131, 132, 140, 1.0)
                    : Colors.white,
              ),
              label: '',
            ),

            // Profile mit User-Status-Indikator
            NavigationDestination(
              icon: _buildProfileIconWithStatus(
                isLoggedIn: isLoggedIn,
                isAdmin: isAdmin,
                isSelected: selectedIndex == 4,
              ),
              label: '',
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileIconWithStatus({
    required bool isLoggedIn,
    required bool isAdmin,
    required bool isSelected,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Haupt-Icon
        ImageIcon(
          const AssetImage('assets/icons/settings_icon.png'),
          size: 35,
          color: isSelected
              ? const Color.fromRGBO(131, 132, 140, 1.0)
              : Colors.white,
        ),

        // Status-Indikator nur wenn eingeloggt
        if (isLoggedIn)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isAdmin
                    ? Colors
                          .orange // Orange für Admin
                    : Colors.green, // Grün für normale User
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromRGBO(40, 58, 73, 1.0),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isAdmin ? Colors.orange : Colors.green).withValues(
                      alpha: 0.5,
                    ),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),

        // Optional: Zusätzlicher Admin-Stern
        if (isLoggedIn && isAdmin)
          Positioned(
            right: -1,
            top: -1,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star, size: 6, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
