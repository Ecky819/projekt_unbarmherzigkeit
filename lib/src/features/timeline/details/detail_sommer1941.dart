import 'package:flutter/material.dart';

class DetailSommer1941 extends StatefulWidget {
  const DetailSommer1941({super.key});

  @override
  State<DetailSommer1941> createState() => _DetailSommer1941State();
}

class _DetailSommer1941State extends State<DetailSommer1941> {
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
        title: const Text('Sommer 1941'),
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
                    '1. Hintergrund & Ursachen der Hungersnot',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '1.1 Zusammenbruch der Ernährungslage',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Bereits mit Beginn des Kriegs 1939 und des griechisch-italienischen Kriegs 1940 gingen wichtige Nahrungsmittelimporte verloren.'
                    'Die Situation spitzte sich 1941 mit Missernten und der Abtretung fruchtbarer Gebiete wie Ostmakedonien an Bulgarien drastisch zu.'
                    'In der Folge brach die landwirtschaftliche Produktion in vielen Bereichen zusammen: 1942 lagen die Rückgänge beim Weizen,'
                    'Linsen und Gerste bei 62–72 %, bei Olivenöl, Tabak und Baumwolle gar bei bis zu 90 %:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildZoomableImage(
                    'assets/images/greek_timeline/greek_hunger.jpg',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '1.2 Zerrissene Infrastruktur und Plünderung',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Die Besatzung zerschnitt das Land in verschiedene Zonen, während Transportwege kollabierten. Die Briten verhängten eine Seeblockade,'
                    'die alle lebenswichtigen Lieferungen verhinderte. Gleichzeitig entzogen die Besatzer dem Land massive Mengen an Nahrung'
                    '– darunter Kartoffeln, Rosinen, Olivenöl – und nutzten sie für Exporte ins Deutsche Reich',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '1.3 Staatsversagen & Schwarzmarkt',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Im Juni 1941 begann die Lebensmittelrationierung in Athen, was den Schwarzmarkt beflügelte.'
                    'Hunger und Chaos dominierten urbane Zentren, während ländliche Regionen teilweise noch überlebensfähige Standards halten konnten.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '2. Ernteausfälle & drohende Hungersnot',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Schon im Sommer 1941 war die Ernährungslage in Griechenland alarmierend: Die Sommerernte war gegenüber Friedenszeiten'
                    'um rund ein Drittel schlechter ausgefallen. Gebiete wie Ostmakedonien und Thrazien unter bulgarischer Kontrolle konnten'
                    'ihre Ernte nicht mehr ins übrige Griechenland liefern. Die griechische Regierung versuchte vergeblich, Vorräte anzulegen'
                    '– Landwirte horteten heimlich ihre Ernte, in der Hoffnung auf bessere Preise.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '3. Herbst/Winter 1941–1942: Die Große Hungersnot',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '3.1 Todeszahlen & Demografische Folgen',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Die Hungersnot entwickelte sich zur größten Katastrophe Griechenlands im 20. Jahrhundert: Schätzungen der Opferzahlen variieren stark:'
                    'Zwischen 100.000 und 450.000 Tote insgesamt'
                    'Die Wikipedia (engl.) schätzt etwa 300.000 Tote, davon 150.000 allein 1941'
                    'In Athen wurden im Winter 1941/42 allein 30.000–40.000 Hungertote verzeichnet'
                    'Auch die Kindersterblichkeit stieg dramatisch vor allem in urbanen Gebieten',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildZoomableImage(
                    'assets/images/greek_timeline/greek_children.jpg',
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
