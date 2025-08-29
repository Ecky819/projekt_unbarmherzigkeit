import 'package:flutter/material.dart';
import '../services/platform_service.dart';

class AdaptiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;

  const AdaptiveGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = _getCrossAxisCount(context);

    if (PlatformService.isSmallScreen(context)) {
      // Mobile: Single Column
      return Column(
        children: children
            .map(
              (child) => Padding(
                padding: EdgeInsets.only(bottom: runSpacing),
                child: child,
              ),
            )
            .toList(),
      );
    }

    // Tablet/Desktop: Grid
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: _getAspectRatio(context),
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 4; // Desktop
    if (width >= 900) return 3; // Large Tablet
    if (width >= 600) return 2; // Tablet
    return 1; // Mobile
  }

  double _getAspectRatio(BuildContext context) {
    if (PlatformService.isLargeScreen(context)) return 1.2;
    if (PlatformService.isMediumScreen(context)) return 1.0;
    return 0.8;
  }
}
