import 'package:flutter/material.dart';

class DetailScreen4 extends StatelessWidget {
  const DetailScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cap Arcona Mahnmal')),
      body: const Center(
        child: Text('Cap Arcona Mahnmal', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
