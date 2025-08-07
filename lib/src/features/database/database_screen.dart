import 'package:flutter/material.dart';

class DatabaseScreen extends StatelessWidget {
  const DatabaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datenbank')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Hier entshen die Datenbankabfragen.',
            style: TextStyle(fontSize: 16, fontFamily: 'SFPro'),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
