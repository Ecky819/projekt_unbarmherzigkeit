import 'package:flutter/material.dart';

class DetailScreen11 extends StatelessWidget {
  const DetailScreen11({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Außenlager Bremen-Schützenhof')),
      body: const Center(
        child: Text(
          'Außenlager Bremen-Schützenhof',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
