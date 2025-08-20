import 'package:flutter/material.dart';
import '../../auth/auth_guard.dart'; // KORREKTER IMPORT HINZUGEFÜGT
import '../../database/database_screen.dart';

class DetailScreen1 extends StatelessWidget {
  const DetailScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KZ Neuengamme')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Database Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to database with authentication check
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthGuard(
                            // KORREKTE VERWENDUNG
                            redirectMessage:
                                'Sie müssen sich anmelden, um auf die Datenbank zugreifen zu können.',
                            child: DatabaseScreen(),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(40, 58, 73, 1.0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Datenbank',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Rest des Inhalts bleibt gleich...
              const Text(
                'Einleitung',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Das Konzentrationslager Neuengamme wurde im Dezember 1938 als Außenlager von Sachsenhausen errichtet und entwickelte sich bis 1945 zu einem eigenständigen '
                'Stammlager mit weit verzweigtem System von rund 85 bis 96 Außenlagern. Es diente der „Vernichtung durch Arbeit" in der SS-eigenen Ziegelproduktion und später '
                'der Rüstungsindustrie. Etwa 106.000 Häftlinge aus über 28 Nationen — darunter zahlreiche Sowjet­kriegsgefangene, politische Gefangene, Juden und andere Verfolgte '
                '— wurden hier inhaftiert, von denen mindestens 42.900 bis 56.000 den unmenschlichen Bedingungen zum Opfer fielen. Bei der Evakuierung im Frühjahr 1945 endeten Tausende '
                'in der Katastrophe der Schiffsangriffe auf die Cap Arcona und Thielbek. Das Lager wurde am 4. Mai 1945 von britischen Truppen befreit. Heute erinnert die Gedenkstätte Neuengamme '
                'mit Ausstellungen, Mahnmalen und einem Begegnungszentrum an die NS-Verbrechen und wird aktuell mit Millionenbeträgen modernisiert, um inklusive und interaktive Lernangebote bereitzustellen.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              // ... (Rest des Inhalts bleibt unverändert)
            ],
          ),
        ),
      ),
    );
  }
}
