import 'package:flutter/material.dart';

class DetailNovember1942 extends StatefulWidget {
  const DetailNovember1942({super.key});

  @override
  State<DetailNovember1942> createState() => _DetailNovember1942State();
}

class _DetailNovember1942State extends State<DetailNovember1942> {
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
        title: const Text('November 1942'),
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
                    '1. Operation Harling – Sabotage der Gorgopotamos-Brücke (25. November 1942)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Im November 1942 startete die sogenannte Operation Harling, eine der spektakulärsten Sabotageaktionen im besetzten Europa. Eine 12-köpfige Eliteeinheit der britischen SOE (Special Operations Executive), unter Führung von Lt. Col Eddie Myers und Major Chris Woodhouse, wurde nach Griechenland abgesetzt, um die strategische Eisenbahnbrücke über den Gorgopotamos bei Lamia zu zerstören – um die Nachschublinien der Achsenmächte nach Nordafrika zu stören. '
                    'Die Widerstandsgruppen ELAS (86 Kämpfer) und EDES (52 Kämpfer) unterstützten die Briten bei der Operation – ein seltener Moment der Kooperation zwischen den beiden großen griechischen Widerstandsbewegungen.'
                    'Der Angriff begann in der Nacht vom 25. auf den 26. November 1942. Trotz starker Bewachung (rund 100 italienische Soldaten und einige Deutsche), gelang es, die Brücke zu sprengen. Nach Abschluss der Aktion trafen sich alle Beteiligten zur gesicherten Rückfahrt – insgesamt wurden nur vier Personen verletzt. '
                    'Das Ziel, Rommels Nachschub zu behindern, wurde nur begrenzt erreicht – zwischenzeitlich jedoch waren über 2.000 Nachschubzüge unterbrochen. Außerdem war Operation Harling ein großer symbolischer Erfolg und Motivationsschub für den Widerstand. Sie markierte den Anfang der britischen Militärmissionen in Griechenland.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildZoomableImage(
                    'assets/images/greek_timeline/gorgopotamos_bridge.jpg',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '2. Deutsche Vergeltungsaktionen im Jahr 1942',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Im Jahr 1942 intensivierte die deutsche Besatzungsmacht ihre brutale Repressionspolitik – vor allem als Reaktion auf Widerstand und Sabotage.'
                    'Die Politik der Kollektivverantwortung („Sühneaktionen“) führte zur Zerstörung ganzer Dörfer und der Ermordung unschuldiger Zivilisten, darunter Frauen und Kinder.'
                    'Im Jahr 1942 ereigneten sich bereits Razzien und Gewaltakte, auch gegen die jüdische Bevölkerung, wie etwa die Razzia am Eleftherias-Platz in Thessaloniki, bei der jüdische Bürger misshandelt, degradierend behandelt und einige getötet wurden.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildZoomableImage(
                    'assets/images/greek_timeline/thessalonikki_juden.jpg',
                  ),
                  const SizedBox(height: 12),
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
