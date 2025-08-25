import 'package:flutter/material.dart';

class Detail28Oktober1940 extends StatefulWidget {
  const Detail28Oktober1940({super.key});

  @override
  State<Detail28Oktober1940> createState() => _Detail28Oktober1940State();
}

class _Detail28Oktober1940State extends State<Detail28Oktober1940> {
  String? _overlayImage;

  void _toggleOverlay(String? imagePath) {
    setState(() {
      _overlayImage = _overlayImage == null ? imagePath : null;
    });
  }

  Widget _buildZoomableImage(String imagePath) {
    return GestureDetector(
      onTap: () => _toggleOverlay(imagePath),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('28. Oktober 1940'),
        backgroundColor: Theme.of(context).primaryColor, // sicherstellen
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '28. Oktober 1940',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Der italienische Einmarsch in Griechenland am 28. Oktober 1940 markierte den Beginn des Balkanfeldzugs im Zweiten Weltkrieg. '
                    'Benito Mussolini, bestrebt, das italienische Imperium zu erweitern, startete den Angriff von Albanien aus. '
                    'Der Plan war, Griechenland schnell zu besetzen und Italiens Einfluss in Südosteuropa zu stärken. '
                    'Doch der unerwartete Widerstand der griechischen Armee führte zu einem Fiasko für Italien.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildZoomableImage(
                    'assets/images/greek_timeline/invasion_map.jpg',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Der Verlauf des Feldzugs',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Italienische Truppen überschritten die Grenze bei Epirus, stießen jedoch auf heftigen Widerstand. '
                    'Die griechischen Streitkräfte, unterstützt von schwierigem Gelände und winterlichen Bedingungen, '
                    'setzten sich erfolgreich zur Wehr. Sie drängten die Italiener sogar zurück und eroberten Teile Albaniens. '
                    'Erst durch das Eingreifen deutscher Truppen im April 1941 konnte Griechenland besiegt werden.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildZoomableImage(
                    'assets/images/greek_timeline/griechischer_widerstand.jpg',
                  ),
                ],
              ),
            ),
          ),
          if (_overlayImage != null)
            GestureDetector(
              onTap: () => _toggleOverlay(null),
              child: Container(
                color: Colors.black.withValues(alpha: 0.8),
                alignment: Alignment.center,
                child: InteractiveViewer(child: Image.asset(_overlayImage!)),
              ),
            ),
        ],
      ),
    );
  }
}
