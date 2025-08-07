import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart'; // Importiert die Farbdefinitionen
import '../theme/app_textstyles.dart'; // Importiert die Textstildefinitionen

/// Ein Widget, das den Inhalt der Nachrichten anzeigt.

/// This widget displays the news content.

class DataNewsWidget extends StatelessWidget {
  const DataNewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.justify,

      text: TextSpan(
        style: AppTextStyles
            .body, // Verwendet den Standard-Fließtextstil aus app_textstyles.dart

        children: <TextSpan>[
          // ABSCHNITT: Athen
          TextSpan(
            text:
                '80 Jahre Befreiung Athens: Feierliches Gedenken auf dem Akropolis-Fels und in der Hauptstadt \n \n',

            style: AppTextStyles.heading, // Verwendet den definierten Titelstil
          ),

          TextSpan(
            text: 'Athen, 12. Oktober 2024 – ',

            style: AppTextStyles
                .heading3, // Verwendet den definierten Untertitelstil
          ),

          TextSpan(
            text:
                'Zum 80. Jahrestag der Befreiung Athens von der nationalsozialistischen Besatzung versammelte sich die griechische Hauptstadt am Wochenende zu einer Reihe von Gedenkveranstaltungen. Traditionell gekleidete Frauen hoben auf dem Akropolis-Fels die „Freiheitsflagge“ empor, während politische und militärische Spitzenvertreter sowie Bürgerinnen und Bürger die Befreiung Athens im Jahr 1944 ehrten',
          ),

          // Quelle 1
          TextSpan(
            text: ' eKathimerini.\n\n',

            style: AppTextStyles.link, // Verwendet den definierten Linkstil

            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final url = Uri.parse(
                  'https://www.ekathimerini.com/',
                ); // Beispiel-URL

                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  print('Could not launch $url');
                }
              },
          ),

          TextSpan(
            text:
                'Bereits am Morgen legten Mitglieder des Stadtrats und Vertreter der Regierung feierlich Kränze am Grab des unbekannten Soldaten am Syntagma-Platz nieder. „Heute gedenken wir all jener, die für Demokratie und Freiheit kämpften. Freiheit wird errungen durch stetigen Einsatz und bewahrt durch unsere Wachsamkeit“, erklärte Bürgermeister Haris Doukas in seiner Ansprache und mahnte, die Ideale der Demokratie gegen aufkeimende Intoleranz zu schützen',
          ),

          // Quelle 2
          TextSpan(
            text: ' NEOS KOSMOS.\n\n',

            style: AppTextStyles.link, // Verwendet den definierten Linkstil

            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final url = Uri.parse(
                  'https://neoskosmos.com/',
                ); // Beispiel-URL

                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  print('Could not launch $url');
                }
              },
          ),

          TextSpan(
            text:
                'Die Stadt Athen lud zudem zu historischen Führungen ein: Ein Rundgang durch das Dritte Friedhofsgelände – Ruhestätte tausender Hungertoter von 1941/42 und Opfer nationalsozialistischer Hinrichtungen – sowie Erkundungen in den Quartieren Pangrati und ehemaliger Luftschutzbunker gaben Einblicke in das Leid und den Widerstand während der Besatzungsjahre',
          ),

          // Quelle 3
          TextSpan(
            text: ' eKathimeriniFrance 24.\n\n',

            style: AppTextStyles.link, // Verwendet den definierten Linkstil

            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final url = Uri.parse(
                  'https://www.france24.com/en/tag/greece/',
                ); // Beispiel-URL

                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  print('Could not launch $url');
                }
              },
          ),

          TextSpan(
            text:
                'Historiker Menelaos Charalampidis wies darauf hin, dass trotz der immensen Opfer – allein in Athen und Piräus starben schätzungsweise 45.000 Menschen an Hunger und Repression – viele Erinnerungsorte bis heute kaum sichtbar sind. Mit seiner Initiative „Athens History Walks“ macht er bislang versteckte Orte der Erinnerung zugänglich und fordert eine stärkere museale Aufarbeitung der Besatzungszeit',
          ),

          // Quelle 4
          TextSpan(
            text: ' France 24The Jakarta Post.\n\n',

            style: AppTextStyles.link, // Verwendet den definierten Linkstil

            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final url = Uri.parse(
                  'https://www.thejakartapost.com/',
                ); // Beispiel-URL

                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  print('Could not launch $url');
                }
              },
          ),

          // Hintergrund
          TextSpan(
            text: 'Hintergrund:\n\n',

            style: AppTextStyles
                .heading2, // Verwendet den definierten Stil für Überschriften
          ),

          TextSpan(
            text:
                '– Am 12. Oktober 1944 ging die Wehrmacht kapituliert, und die deutsche Besatzung Griechenlands endete nach knapp dreieinhalb Jahren.\n\n',
          ),

          TextSpan(
            text:
                '– Während der Besatzungszeit starben in Griechenland insgesamt rund 250.000 Menschen an den Folgen der Hungerblockade; über 86 % der griechischen Juden wurden in Vernichtungslager deportiert.\n\n',
          ),

          TextSpan(
            text:
                '– Die offizielle Erinnerungskultur in Griechenland erlitt besonders durch den anschließenden Bürgerkrieg bis in die 1980er Jahre Tabuisierungen, die eine umfassende Aufarbeitung lange behinderten.\n\n',
          ),

          // Kontakt
          TextSpan(
            text: 'Kontakt:\n\n',

            style: AppTextStyles
                .heading2, // Verwendet den definierten Stil für Überschriften
          ),

          TextSpan(text: 'Stadt Athen – Kulturamt\n'),

          TextSpan(
            text: 'Tel.: +30 210 324 xxx\n',

            style: AppTextStyles.link, // Verwendet den definierten Linkstil

            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final url = Uri.parse('tel:+30210324xxx'); // Telefonnummer

                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  print('Could not launch $url');
                }
              },
          ),

          TextSpan(
            text: 'E-Mail: presse@athens.gov.gr',

            style: AppTextStyles.link, // Verwendet den definierten Linkstil

            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final url = Uri.parse(
                  'mailto:presse@athens.gov.gr',
                ); // E-Mail-Adresse

                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  print('Could not launch $url');
                }
              },
          ),

          // ABSCHNITT: Thessaloniki
          TextSpan(
            text: '\n\n---\n\n', // Trennlinie für den neuen Abschnitt

            style: TextStyle(
              color: AppColors.accent,

              fontWeight: FontWeight.bold,

              fontSize: 18,
            ),
          ),

          TextSpan(
            text:
                '80 Jahre Befreiung Thessalonikkis: Feierliches Gedenken in der Hauptstadt des Nordens \n \n',

            style: AppTextStyles.heading, // Gleicher Stil wie der Haupttitel
          ),

          TextSpan(
            text: 'Thessaloniki, 8. Mai 2025 – ',

            style:
                AppTextStyles.heading3, // Gleicher Stil wie das Datum in Athen
          ),

          TextSpan(
            text:
                'Heute jährt sich zum 80. Mal das Ende des Zweiten Weltkriegs in Griechenland und damit auch die Befreiung Thessalonikkis von der nationalsozialistischen Besatzung. An diesem denkwürdigen Tag versammelten sich Vertreter der Stadtverwaltung, der griechisch-orthodoxen Kirche, Überlebende und junge Generationen der Stadt in der Altstadt, um der Befreiung und der Erinnerung an die Opfer zu gedenken.\n\n',
          ),

          TextSpan(
            text: 'Erinnerung an die Befreiung und die Opfer\n',

            style: AppTextStyles
                .heading2, // Gleicher Stil wie die Hintergrund/Kontakt-Überschriften
          ),

          TextSpan(
            text:
                'Am 8. Mai 1945, zeitgleich mit der offiziellen Kapitulation der Wehrmacht in Europa, endete für Thessaloniki eine Zeit der Unterdrückung und des Verlustes. Über drei Jahre lang hatte die jüdische Bevölkerung, einst größter jüdischer Ballungsraum auf dem europäischen Kontinent, unter den Schrecken der Deportationen und Massendeportationen in Vernichtungslager wie Auschwitz gelitten. Schätzungen zufolge wurden damals nahezu 96 % der rund 50.000 jüdischen Bürger Thessalonikkis ermordet. Erst mit dem Einmarsch alliierter Truppen – angeführt von britischen Einheiten – und dem Aufbruch der deutschen Besatzungskräfte kehrte 1945 ein Funke Hoffnung zurück.\n\n',
          ),

          TextSpan(
            text: 'Feierliches Gedenken heute\n',

            style: AppTextStyles.heading2,
          ),

          TextSpan(
            text:
                'Oberbürgermeisterin Maria Galanakis erklärte bei der Gedenkfeier auf dem Freiheitsplatz (Plateía Eleftherías), es sei „unsere heilige Pflicht, die Geschichte zu bewahren und jungen Menschen weiterzugeben, damit sich solche Gräuel nie wiederholen“. In ihrer Ansprache hob sie hervor, dass das kollektive Gedächtnis Thessalonikkis durch das wechselvolle Schicksal der Stadt geprägt sei – von römischer Metropole über byzantinischen Knotenpunkt bis zur modernen Hafenstadt.\n\n',
          ),

          TextSpan(
            text:
                'Die griechisch-orthodoxe Kirche hielt in der Kirche Agios Dimitrios einen ökumenischen Gottesdienst ab, in dem Bischof Theodoros die Rolle des Glaubens in Zeiten der Not betonte. „In dunkelster Stunde lehrte uns der Glaube die Kraft der Gemeinschaft“, so Theodoros. Hymnen und Kerzenlichter erinnerten an die Ortsansässigen, die in den Konzentrationslagern ihr Leben verloren, und mahnten zugleich zur Wachsamkeit gegen Antisemitismus und Fremdenfeindlichkeit.\n\n',
          ),

          TextSpan(
            text: 'Blick in die Zukunft: Versöhnung und Bildung\n',

            style: AppTextStyles.heading2,
          ),

          TextSpan(
            text:
                'Auch internationale Gäste nahmen an der Zeremonie teil, darunter der israelische Generalkonsul in Thessaloniki, David Levy. Er betonte die Bedeutung der Aussöhnung zwischen Deutschland und Griechenland nach dem Krieg und die Rolle von Bildung in der Erinnerungskultur: „Gedenken allein reicht nicht aus – wir müssen junge Menschen befähigen, aus der Geschichte zu lernen.“ Gemeinsam mit lokalen NGOs kündigte Levy Workshops und Austauschprogramme für Schüler an, um die Vergangenheit umfassend zu erforschen.\n\n',
          ),

          TextSpan(
            text: 'Stadtentwicklung im Zeichen der Erinnerung\n',

            style: AppTextStyles.heading2,
          ),

          TextSpan(
            text:
                'In den vergangenen Jahren hat Thessaloniki mit dem Bau eines neuen jüdischen Museums und der Restaurierung historischer Synagogen wichtige Schritte unternommen, die jüdische Kultur und Geschichte der Stadt sichtbar zu machen. Kulturministerin Eleni Papadopoulou wies darauf hin, dass das Museumsprojekt nicht nur der Gedenkarbeit diene, sondern auch den Tourismus beflügele und die lokale Wirtschaft stärke.\n\n',
          ),

          TextSpan(text: 'Fazit\n', style: AppTextStyles.heading2),

          TextSpan(
            text:
                'Der 80. Jahrestag des Kriegsendes in Thessaloniki ist mehr als eine historische Reminiszenz: Er ist ein Aufruf zur Wachsamkeit gegen jede Form von Intoleranz und ein Bekenntnis zur lebendigen Erinnerungskultur. Während die Stadt heute feiert, bleibt das Vermächtnis jener, die litten und starben, ein Mahnmal gegen das Vergessen – und gleichzeitig ein Symbol der Hoffnung, die sich aus Versöhnung und Bildung nährt.',
          ),
        ],
      ),
    );
  }
}
