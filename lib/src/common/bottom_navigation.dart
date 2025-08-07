import 'package:flutter/material.dart';

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
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      height: 55,
      backgroundColor: const Color.fromRGBO(40, 58, 73, 1.0),
      indicatorColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      destinations: [
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
        NavigationDestination(
          icon: ImageIcon(
            const AssetImage('assets/icons/favorite_icon.png'),
            size: 35,
            color: selectedIndex == 3
                ? const Color.fromRGBO(131, 132, 140, 1.0)
                : Colors.white,
          ),
          label: '',
        ),
        NavigationDestination(
          icon: ImageIcon(
            const AssetImage('assets/icons/settings_icon.png'),
            size: 35,
            color: selectedIndex == 4
                ? const Color.fromRGBO(131, 132, 140, 1.0)
                : Colors.white,
          ),
          label: '',
        ),
      ],
    );
  }
}
