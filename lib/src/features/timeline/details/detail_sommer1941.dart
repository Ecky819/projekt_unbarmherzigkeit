import 'package:flutter/material.dart';

class DetailSommer1941 extends StatelessWidget {
  const DetailSommer1941({super.key});

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
