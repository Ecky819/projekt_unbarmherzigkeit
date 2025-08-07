import 'package:flutter/material.dart';

class DetailSeptember1941a extends StatelessWidget {
  const DetailSeptember1941a({super.key});

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
