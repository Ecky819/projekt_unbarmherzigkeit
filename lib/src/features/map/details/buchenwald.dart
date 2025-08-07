import 'package:flutter/material.dart';

class DetailScreen10 extends StatelessWidget {
  const DetailScreen10({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KZ Buchenwald')),
      body: const Center(
        child: Text('KZ Buchenwald', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
