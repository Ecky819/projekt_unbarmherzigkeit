import 'package:flutter/material.dart';

class DetailScreen13 extends StatelessWidget {
  const DetailScreen13({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Außenlager Hamburg-Veddel')),
      body: const Center(
        child: Text(
          'Außenlager Hamburg-Veddel',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
