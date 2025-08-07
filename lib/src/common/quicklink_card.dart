import 'package:flutter/material.dart';

class QuicklinkCard extends StatelessWidget {
  final String title;
  final String text;
  final String imagePath;
  final VoidCallback? onTap;

  const QuicklinkCard({
    super.key,
    required this.title,
    required this.text,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(243, 239, 231, 1.0),
      elevation: 10,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: HeadingText(title: title),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(84, 95, 113, 1.0),
                  fontFamily: 'SFPro',
                ),
              ),
            ),
            const SizedBox(height: 8),
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(4),
              child: InkWell(
                onTap: onTap,
                child: Image.asset(imagePath, width: 76, height: 26),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeadingText extends StatelessWidget {
  final String title;

  const HeadingText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'SFPro',
        fontSize: 14,
      ),
    );
  }
}
