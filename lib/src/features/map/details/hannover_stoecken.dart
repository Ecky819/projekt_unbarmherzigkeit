import 'package:flutter/material.dart';

class DetailScreen6 extends StatelessWidget {
  const DetailScreen6({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Außenlager Hannover-Stöcken')),
      body: const Center(
        child: Text(
          'Außenlager Hannover-Stöcken',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
