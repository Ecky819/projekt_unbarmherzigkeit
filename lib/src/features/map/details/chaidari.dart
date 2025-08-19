import 'package:flutter/material.dart';
import '../../auth/auth_guard.dart'; // Adjust the import path as needed
import '../../database/database_screen.dart'; // Import your actual database screen
//  import '../../theme/app_colors.dart';

class DetailScreen3 extends StatelessWidget {
  const DetailScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KZ Chaidari')),
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
                ],
              ),
              const SizedBox(height: 16), // Abstand zwischen Buttons und Text
              const Text(
                'Einleitung',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Das Konzentrationslager Chaidari, gelegen im gleichnamigen Athener Vorort, war während der deutschen Besatzung Griechenlands (1941–1944) das größte und berüchtigtste Lager des Landes.'
                'Es diente als Haft-, Folter- und Durchgangsstation für politische Gefangene, Widerstandskämpfer und jüdische Bürger, die später in Vernichtungslager deportiert wurden.'
                'Chaidari wurde zum Symbol für Repression, Leid und den Widerstand gegen die nationalsozialistische Besatzung.([Gedenkorte Europa][1], [Wikipedia – Die freie Enzyklopädie][2])',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              const Text(
                'Entstehung und Struktur',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ursprünglich als Kaserne unter der Metaxas-Diktatur errichtet, übernahmen italienische Besatzungstruppen nach der Kapitulation Griechenlands 1941 das Gelände.'
                'Nach dem italienischen Waffenstillstand im September 1943 übernahm die deutsche Wehrmacht das Lager, bevor es am 20. Oktober 1943 unter die Kontrolle der SS'
                'und des Sicherheitsdienstes (SD) unter SS-Standartenführer Walter Blume gestellt wurde. Erster Lagerkommandant war SS-Sturmbannführer Paul Radomski, bekannt für seine Brutalität.'
                'Nach seiner Absetzung im Februar 1944 übernahm SS-Untersturmführer Karl Fischer die Leitung'
                '([DER SPIEGEL | Online-Nachrichten][3], [Gedenkorte Europa][1], [occupation-memories.org][4],'
                '[Wikipedia – Die freie Enzyklopädie][5])Das Lager bestand aus mehreren Blöcken, darunter der berüchtigte Block 15, der für Einzelhaft und Folterungen genutzt wurde.'
                'Die durchschnittliche Zahl der Inhaftierten lag zwischen 2.000 und 3.000 Personen, insgesamt wurden etwa 20.000 bis 25.000 Menschen dort festgehalten.([Gedenkorte Europa][1])',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              const Text(
                'Alltag und Bedingungen',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Die Lebensbedingungen im Lager waren katastrophal. Unterernährung, Zwangsarbeit und systematische Folterungen gehörten zum Alltag.'
                'Häftlinge wurden gezwungen, sinnlose Arbeiten wie das ständige Umhertragen von Steinen zu verrichten. Block 15 war besonders gefürchtet:'
                'Häftlinge wurden dort isoliert, durften nicht sprechen und waren ständiger psychischer und physischer Gewalt ausgesetzt.'
                'Viele Gefangene starben an den Folgen der Misshandlungen oder wurden hingerichtet.'
                '([Academia][6], [occupation-memories.org][4], [Wikipedia – Die freie Enzyklopädie][7])',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              const Text(
                'Deportationen und Hinrichtungen',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Chaidari diente auch als Durchgangslager für die Deportation von Juden aus ganz Griechenland. Am 2. April 1944 wurden beispielsweise etwa 1.900 Juden nach Auschwitz-Birkenau deportiert.'
                'Am 25. Mai 1944 verließen 850 Männer und 61 Frauen das Lager in Richtung der Konzentrationslager Neuengamme und Ravensbrück.([Gedenkorte Europa][1])Ein besonders tragisches Ereignis war'
                'die Exekution von 200 politischen Gefangenen am 1. Mai 1944 am Schießstand von Kesariani als Vergeltungsmaßnahme für ein Attentat auf einen deutschen General.'
                '([Wikipedia – Die freie Enzyklopädie][2])',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              const Text(
                'Bekannte Häftlinge',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Unter den Inhaftierten befanden sich zahlreiche prominente Persönlichkeiten, darunter: Lela Karagianni: Widerstandskämpferin und Gründerin der Untergrundorganisation „Bouboulina",'
                'wurde am 8. September 1944 hingerichtet.([Wikipedia – Die freie Enzyklopädie][8])Marcel Nadjari: Griechischer Jude, der nach Auschwitz deportiert wurde und dort dem Sonderkommando angehörte.'
                '([Wikipedia – Die freie Enzyklopädie][9]) Rena Dor: Schauspielerin, die in Block 15 inhaftiert war.([Academia][6]) Nikos Skalkottas: Komponist, der ebenfalls zu den Gefangenen zählte.([Academia][6])',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              const Text(
                'Nachkriegszeit und Gedenken',
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
                'Das Konzentrationslager Chaidari steht exemplarisch für die Brutalität der nationalsozialistischen Besatzung in Griechenland.'
                'Es war ein Ort des Schreckens, aber auch des Widerstands. Die Erinnerung an die Opfer und die Aufarbeitung der Verbrechen sind'
                'essenziell für das historische Bewusstsein und die Mahnung an zukünftige Generationen.([Wikipedia][11])',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              const Text(
                'Quellen',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Wikipedia: Konzentrationslager Chaidari Gedenkorte Europa: KZ Chaidari([Gedenkorte Europa][1]) Erinnerungen an die Okkupation in Griechenland:'
                'Konzentrationslager Chaidari([Academia][6]) Wikipedia: Lela Karagianni([Wikipedia – Die freie Enzyklopädie][8])'
                'Wikipedia: Marcel Nadjari([Wikipedia – Die freie Enzyklopädie][9]) Spiegel Online: Griechenland unter deutscher Besatzung – Spurensuche([DER SPIEGEL | Online-Nachrichten][3])',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
