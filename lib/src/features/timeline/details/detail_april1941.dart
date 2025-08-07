import 'package:flutter/material.dart';

class DetailApril1941 extends StatefulWidget {
  const DetailApril1941({super.key});

  @override
  State<DetailApril1941> createState() => _DetailApril1941State();
}

class _DetailApril1941State extends State<DetailApril1941>
    with SingleTickerProviderStateMixin {
  bool _showOverlay = false;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleOverlay() {
    setState(() => _showOverlay = !_showOverlay);
    if (_showOverlay) {
      _controller.forward(from: 0);
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double imageWidth = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      appBar: AppBar(title: const Text('April 1941 – Balkanfeldzug')),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Im April 1941 leitete Adolf Hitler die Operation “Marita” ein, um die militärische Lage in Südosteuropa zu stabilisieren und das geschwächte Italien in seinem unglücklichen Feldzug gegen Griechenland zu unterstützen. Binnen weniger Wochen besetzten deutsche Einheiten weite Teile Griechenlands und zwangen das Land zur Kapitulation. Dieser Text richtet sich an Amateurhistoriker und bietet einen kompakten Überblick über Hintergründe, Verlauf und Folgen des Einmarsches.',
                    style: TextStyle(fontSize: 16.0, height: 1.5),
                  ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: _toggleOverlay,
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Hero(
                          tag: 'map',
                          child: Image.asset(
                            'assets/images/balkan_feldzug_map.jpg',
                            width: imageWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const SizedBox(height: 16.0),
                  const Text(
                    '1. Vorgeschichte und strategische Ausgangslage',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Nach der gescheiterten italienischen Invasion im Herbst 1940 ...',
                    style: TextStyle(fontSize: 16.0, height: 1.5),
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    'Ziele Deutschlands:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'a. Unterstützung Italiens und Neutralisierung Griechenlands als Frontland.',
                        ),
                        Text(
                          'b. Sicherung der südlichen Flanke vor der Operation Barbarossa.',
                        ),
                        Text(
                          'c. Verhinderung einer alliierten Basis in der östlichen Ägäis und Kontrolle wichtiger Seewege.',
                        ),
                        Text(
                          'd. Schutz der rumänischen Ölfquellen vor alliierten Angriffen.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    '2. Vorbereitung der Operation „Marita“',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Die Wehrmacht sammelte im Frühjahr 1941 in Bulgarien und im besetzten Jugoslawien fast 17 Divisionen sowie überwiegend motorisierte Einheiten. Generalfeldmarschall Wilhelm List erhielt den Auftrag, die Metaxas-Linie im Norden Griechenlands zu umgehen, während Panzerverbände den zentralen Bergpaß bei Servia durchbrechen sollten. Parallel dazu landeten deutsche Fallschirmjäger auf Kreta – ein Vorbote der folgenden Invasion der Insel.',
                    style: TextStyle(fontSize: 16.0, height: 1.5),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    '3. Verlauf des Feldzugs',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text('1. Angriffsbeginn am 6. April 1941'),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      '– Von Bulgarien und Nordjugoslawien stießen Panzereinheiten in südwestlicher Richtung vor.\n– Die Metaxas-Linie wurde mittels Umgehung schnell überwunden, Verteidigungsstellungen durchbrochen.',
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text('2. Durchbruch bei Servia'),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      '– Am 8. April gelang die größte Panzeroperation des Feldzugs: Die 5. Panzerdivision durchstieß die griechischen Stellungen und setzte Kurs auf Thessaloniki.',
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text('3. Besetzung Nordgriechenlands'),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      '– Binnen weniger Tage fielen Thessaloniki und Gebiete bis zur Spercheios-Ebene. Die griechischen Truppen leisteten vereinzelt erbitterten Widerstand, mussten aber letztlich zurückweichen.',
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text('4. Vormarsch nach Athen'),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      '– Am 20. April erreichten deutsche Einheiten die Ebene von Theben. Am 27. April wurde Athen eingenommen, die deutsche Wehrmacht hisste die Flagge über der Akropolis.',
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text('5. Evakuierung der Alliierten'),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      '– Rund 50.000 britische, australische und neuseeländische Soldaten wurden während der Operation „Dynamo“ von Häfen in der Peloponnes nach Nordafrika ausgeflogen.',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    '4. Bedeutung und Folgen',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text('• Militärisch-strategisch'),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      '– Die deutsche Überlegenheit an Mobilität und Luftunterstützung erwies sich als entscheidend.\n– Verzögerungen der Operation Barbarossa um ca. drei Wochen, was in der Forschung als ein Faktor für den Misserfolg vor Moskau diskutiert wird.',
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text('• Politisch-wirtschaftlich'),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      '– Errichtung einer dreigeteilten Besatzungsstruktur (deutsch, italienisch, bulgarisch).\n– Ausbeutung von Ressourcen und Zwangsarbeit führten zu massiver Not in der griechischen Bevölkerung.',
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text('• Gesellschaftlich'),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      '– Beginn eines harten Besatzungsregimes mit willkürlichen Erschießungen, Deportationen und Hilfeleistungen an die Partisanen.\n– Langfristige Auswirkungen auf die griechische Nachkriegsordnung und das nationale Gedächtnis.',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    '5. Literatur- und Quellenhinweise',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text('1. Wikipedia: "German invasion of Greece"'),
                  const Text(
                    '2. Erickson, John: The Greek Campaign 1941, London 1952.',
                  ),
                  const Text(
                    '3. Beevor, Antony: Crete: The Battle and the Resistance, Penguin 1991.',
                  ),
                  const Text(
                    '4. Official Histories, British Government: The Mediterranean and Middle East, Bd. 2, HMSO 1954.',
                  ),
                  const Text(
                    '5. Forscherartikel: Kater, Michael: „Operation Marita und ihr Einfluss auf Barbarossa“, Militärhistorische Zeitschrift, 2018.',
                  ),
                ],
              ),
            ),
            if (_showOverlay)
              GestureDetector(
                onTap: _toggleOverlay,
                child: Container(
                  color: Colors.black54,
                  alignment: Alignment.center,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Hero(
                      tag: 'map',
                      child: Material(
                        color: Colors.transparent,
                        elevation: 4.0,
                        child: Image.asset(
                          'assets/images/balkan_feldzug_map.png',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
