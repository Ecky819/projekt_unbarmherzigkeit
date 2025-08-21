import 'package:flutter/material.dart';

class DetailSeptember1941 extends StatefulWidget {
  const DetailSeptember1941({super.key});

  @override
  State<DetailSeptember1941> createState() => _DetailSeptember1941State();
}

class _DetailSeptember1941State extends State<DetailSeptember1941> {
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
        title: const Text('September 1941'),
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
                    '1. Gründung von EDES – 9. September 1941',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Der National Republican Greek League (EDES) wurde am 9. September 1941 von Oberst Napoleon Zervas gegründet, gemeinsam mit Leonidas Spais und Ilias Stamatopoulos. Die Gruppe war republikanisch und sozialistisch orientiert, mit starkem antimonarchistischem Impetus. Sie forderte eine „Republikanische Regierung sozialistischer Art“, die Verurteilung der bisherigen monarchistischen Strukturen und eine Reinigung des Staates von nicht-nationalen Kräften.'
                    'Später entwickelte sich EDES unter britischem Einfluss in eine eher monarchistisch orientierte Position und stand im Wettbewerb oder gar Konflikt mit der kommunistischen EAM/ELAS:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildZoomableImage(
                    'assets/images/greek_timeline/edes_founder.jpg',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '2. Gründung von EAM (27. September 1941) & Vorbereitung auf ELAS',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Am 27. September 1941 wurde die Nationale Befreiungsfront (EAM) gegründet – initiiert von der Kommunistischen Partei (KKE) gemeinsam mit kleineren linken Parteien wie ELD, SKE und AKE. Ziele waren: nationale Befreiung, Aufbau einer Übergangsregierung und Vorbereitung freier Wahlen nach Ende der Besatzung'
                    'Erst später, im Februar 1942, folgte die Gründung des bewaffneten Arms, der ELAS (Ellinikós Laïkós Apelevtherotikós Strátos). Die Vorbereitungen für den bewaffneten Widerstand begannen jedoch bereits im Spätsommer/Herbst 1941',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildZoomableImage('assets/images/greek_timeline/elas.jpg'),
                  const SizedBox(height: 12),
                  const Text(
                    '3. Erste Sabotageaktionen – Indirekte Symbolkraft im September?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Für September 1941 sind keine konkreten großen Sabotageakte belegt. Die Zeit war eher geprägt von der Organisation und Koordination der Widerstandsgruppen (EAM & EDES), nicht von ausgeprägten Aktionen. Bedeutende Aktionen, etwa die Sprengung der Gorgopotamos-Brücke, folgten erst 1942/1943',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '4. Repressalien gegen (deutsche bzw. besatzungsnahe) Zivilbevölkerung',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'In Reaktion auf wachsenden Widerstand gingen Besatzungstruppen mit brutaler Härte vor. Bereits im September 1941 wurde der sogenannte Sühnebefehl ausgegeben: Für jeden getöteten deutschen Soldaten sollten 50 bis 100 griechische Zivilisten hingerichtet werden. In den folgenden Jahren wurden etwa 1.700 Dörfer zerstört, Männer ermordet und Städte terrorisiert.'
                    'Ein besonders grausames Beispiel: In Drama (Nordgriechenland) eskalierte Ende September 1941 ein Aufstand. Die Bulgaren reagierten mit Massenhinrichtungen – über 3.000 Tote allein in Drama, etwa 15.000 Opfer insgesamt, sowie zahlreiche zerstörte Dörfer.'
                    'Auch in Nordgriechenland wurden Dörfer wie Ano und Kato Kerdylia bereits im Herbst 1941 zerstört, dabei über 200 männliche Bewohner erschossen – erste systematische Grassroot-Massaker der Wehrmacht gegen Zivilbevölkerung',
                    style: TextStyle(fontSize: 16),
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
