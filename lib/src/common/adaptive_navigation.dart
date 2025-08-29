import 'package:flutter/material.dart';
import '../services/platform_service.dart';
import 'bottom_navigation.dart';

class AdaptiveNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final List<NavigationDestination> destinations;

  const AdaptiveNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    // Desktop/Web Large Screen - NavigationRail
    if (PlatformService.isLargeScreen(context)) {
      return Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            extended: true,
            destinations: destinations
                .map(
                  (dest) => NavigationRailDestination(
                    icon: dest.icon,
                    label: Text(dest.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Content wird außerhalb gerendert
        ],
      );
    }

    // Tablet - NavigationRail collapsed
    if (PlatformService.isMediumScreen(context)) {
      return NavigationRail(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        extended: false,
        destinations: destinations
            .map(
              (dest) => NavigationRailDestination(
                icon: dest.icon,
                label: Text(dest.label),
              ),
            )
            .toList(),
      );
    }

    // Mobile - Bottom Navigation (bestehendes CustomNavigationBar)
    return CustomNavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
    );
  }
}

class NavigationDestination {
  final Widget icon;
  final String label;

  NavigationDestination({required this.icon, required this.label});
}
