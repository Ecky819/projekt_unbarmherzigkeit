import 'package:flutter/material.dart';
import '../../auth/auth_guard.dart'; // Adjust the import path as needed
import '../../database/database_screen.dart'; // Import your actual database screen

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
              // Die zwei Buttons wurden hier hinzugefügt
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to database with authentication check
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthGuard(
                            redirectMessage:
                                'Sie müssen sich anmelden, um auf die Datenbank zugreifen zu können.',
                            child:
                                const DatabaseScreen(), // Your actual database screen
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(
                        40,
                        58,
                        73,
                        1.0,
                      ), // Hintergrundfarbe
                      foregroundColor: Colors.white, // Textfarbe
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ), // Abgerundete Ecken
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
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Aktion für den "Biografien" Button
                  //     print('Biografien Button gedrückt');
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: const Color.fromRGBO(
                  //       40,
                  //       58,
                  //       73,
                  //       1.0,
                  //     ), // Hintergrundfarbe
                  //     foregroundColor: Colors.white, // Textfarbe
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(
                  //         8.0,
                  //       ), // Abgerundete Ecken
                  //     ),
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 24,
                  //       vertical: 12,
                  //     ),
                  //   ),
                  //   child: const Text(
                  //     'Biografien',
                  //     style: TextStyle(fontSize: 16),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 16), // Abstand zwischen Buttons und Text
              const Text(
                'Einleitung',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Das Konzentrationslager Neuengamme wurde im Dezember 1938 als Außenlager von Sachsenhausen errichtet und entwickelte sich bis 1945 zu einem eigenständigen'
                'Stammlager mit weit verzweigtem System von rund 85 bis 96 Außenlagern. Es diente der „Vernichtung durch Arbeit" in der SS-eigenen Ziegelproduktion und später'
                'der Rüstungsindustrie. Etwa 106.000 Häftlinge aus über 28 Nationen — darunter zahlreiche Sowjet­kriegsgefangene, politische Gefangene, Juden und andere Verfolgte'
                '— wurden hier inhaftiert, von denen mindestens 42.900 bis 56.000 den unmenschlichen Bedingungen zum Opfer fielen. Bei der Evakuierung im Frühjahr 1945 endeten Tausende'
                'in der Katastrophe der Schiffsangriffe auf die Cap Arcona und Thielbek. Das Lager wurde am 4. Mai 1945 von britischen Truppen befreit. Heute erinnert die Gedenkstätte Neuengamme'
                'mit Ausstellungen, Mahnmalen und einem Begegnungszentrum an die NS-Verbrechen und wird aktuell mit Millionenbeträgen modernisiert, um inklusive und interaktive Lernangebote bereitzustellen.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              const Text(
                '1. Gründung und Ausbau',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Das Lager Neuengamme entstand am 13. Dezember 1938, als rund 100 Häftlinge aus Sachsenhausen zur Reaktivierung eines aufgegebenen Ziegelwerks an die Dove-Elbe gebracht wurden (Wikipedia). Im Juni 1940 wurde Neuengamme zum eigenständigen Stammlager erklärt, gleichzeitig begannen Transporte aus ganz Deutschland und Europa (Wikipedia). Unter Leitung der SS-Tochter „Deutsche Erd- und Steinwerke" wurde die Ziegelproduktion zum wirtschaftlichen Schwerpunkt, später richteten auch Rüstungsfirmen wie Messap, Jastram und Walter-Werke Produktionsstätten im Lager ein (Holocaust-Enzyklopädie).',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              const Text(
                '2. Alltag und Bedingungen',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Hunger, Überbelegung und mangelnde Hygiene bestimmten den Lageralltag. Die tägliche Zwangsarbeit dauerte 10—12 Stunden, häufig in Tongruben und beim Ausbau eines Kanals für den Materialtransport, den „Todeskadern" (Wikipedia). Schlafplätze waren eng in überfüllten Holzbaracken, sanitäre Anlagen überlastet. Krankheiten wie Dysenterie und Typhus breiteten sich rasch aus, die Lagerkrankenhäuser waren überfüllt und kaum medizinisch versorgt (Wikipedia).',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              const Text(
                '3. „Vernichtung durch Arbeit"',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Die SS verfolgte das Prinzip der „Vernichtung durch Arbeit": Unterernährung und Erschöpfung führten zu einer Todesrate von teils über 10 % pro Monat (Wikipedia). Bis Ende 1944 wuchs die Häftlingszahl auf rund 49.000 im Stammlager und 37.000 in den Außenlagern, darunter fast 10.000 Frauen (Wikipedia). Insgesamt sind über 85 Außenlager belegt, die von Salzgitter-Drütte bis zur Kanalinsel Alderney reichten (DIE WELT).',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              const Text(
                '4. Evakuierung und Befreiung',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Im Frühjahr 1945 begann die Zwangs­evakuierung: Mitte April mussten etwa 10.000 Häftlinge auf Todesmärsche Richtung Lübeck, viele endeten auf den Schiffen Cap Arcona, Thielbek, Deutschland und Athen in der Lübecker Bucht (Wikipedia). Am 3. Mai 1945 bombardierte die RAF irrtümlich die gefüllten Schiffe und tötete rund 7.100 Häftlinge (Wikipedia). Am 4. Mai befreiten britische Truppen das Lager selbst; etwa 600—700 verbliebene Häftlinge fanden sie noch vor Ort (Holocaust-Enzyklopädie).',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              const Text(
                '5. Opferzahlen und Erinnerung',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nach der Befreiung Griechenlands wurde das Lagergelände weiterhin militärisch genutzt, und der Zugang war lange Zeit eingeschränkt.'
                'Erst in den 1980er Jahren wurde Block 15 als nationales Denkmal anerkannt. Heute ist er das einzige erhaltene Gebäude des Lagers und dient als Gedenkstätte.'
                'Dennoch bleibt der Zugang beschränkt, und viele Opfergruppen, insbesondere die jüdischen Häftlinge, finden in der offiziellen Erinnerung wenig Beachtung.'
                '([occupation-memories.org][4], [occupation-memories.org][10], [Gedenkorte Europa][1])',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              const Text(
                'Fazit',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Von den geschätzten 106.000 Inhaftierten starben mindestens 42.900 bis 56.000 in Neuengamme oder bei Evakuierung und Todesmärschen (JewishGen). Die Gedenkstätte Neuengamme dokumentiert Namen und Biografien von über 23.394 Opfern in ihrem Haus der Erinnerung und bietet Führungen, Ausstellungen und Bildungsprogramme an (KZ Gedenkstätte Neuengamme).',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              const Text(
                '6. Gedenkstätte heute',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Die KZ-Gedenkstätte Neuengamme in Hamburg-Bergedorf ist ein Lernort nationaler Bedeutung. Seit 2024 fördert der Bund mit rund 6 Mio. € (weitere 6 Mio. von der Stadt Hamburg) die Neukonzeption der Dauerausstellungen und den Ausbau digitaler und inklusiver Angebote (DIE WELT). Ziel ist es, das Bewusstsein für NS-Verbrechen zu schärfen und im Kontext aktueller gesellschaftlicher Herausforderungen zu reflektieren.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
