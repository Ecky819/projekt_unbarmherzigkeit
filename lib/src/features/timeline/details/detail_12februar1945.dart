import 'package:flutter/material.dart';

class Detail12Februar1945 extends StatelessWidget {
  const Detail12Februar1945({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sommer 1941')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Detailinformationen', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
