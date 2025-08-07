import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: Color(0xFFF39C12),
        shape: BoxShape.circle,
      ),
      child: CustomPaint(painter: ProfileIconPainter()),
    );
  }
}

class ProfileIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF2C3E50)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw head (circle)
    canvas.drawCircle(Offset(center.dx, center.dy - 8), 10, paint);

    // Draw body (rounded rectangle)
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 12),
        width: 35,
        height: 22,
      ),
      Radius.circular(20),
    );

    canvas.drawRRect(bodyRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
