import 'package:flutter/material.dart';

class LoadingDots extends StatelessWidget {
  final Animation<double> animation;

  const LoadingDots({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.3;
            final animationValue = (animation.value - delay).clamp(0.0, 1.0);
            final scale = 0.8 + (0.4 * animationValue);
            final opacity = 0.5 + (0.5 * animationValue);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF283A49).withOpacity(opacity),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
