import 'package:flutter/material.dart';

class DetailScreen2 extends StatelessWidget {
  const DetailScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KZ Dachau')),
      body: const Center(
        child: Text('KZ Dachau', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
