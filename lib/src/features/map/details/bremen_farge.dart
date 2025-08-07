import 'package:flutter/material.dart';

class DetailScreen12 extends StatelessWidget {
  const DetailScreen12({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Außenlager Bremen-Farge')),
      body: const Center(
        child: Text(
          'Außenlager Bremen-Farge\nBunker Valetin',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
