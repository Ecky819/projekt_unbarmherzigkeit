import 'package:flutter/material.dart';

class DetailScreen5 extends StatelessWidget {
  const DetailScreen5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Außenlager Salzgitter-Drütte')),
      body: const Center(
        child: Text(
          'Außenlager Salzgitter-Drütte',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
