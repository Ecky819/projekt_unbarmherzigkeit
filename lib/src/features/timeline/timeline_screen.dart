import 'package:flutter/material.dart';
import '../../common/timeline_entry_widget.dart';

import 'details/detail_28oktober1940.dart';
import 'details/detail_april1941.dart';
import 'details/detail_sommer1941.dart';
import 'details/detail_14september1943.dart';
import 'details/detail_12oktober1944.dart';
import 'details/detail_17august1943.dart';
import 'details/detail_24maerz1943.dart';
import 'details/detail_12februar1945.dart';
import 'details/detail_28dezember1944.dart';
import 'details/detail_29juni1944.dart';
import 'details/detail_september1941a.dart';
import 'details/detail_september1941b.dart';
import 'details/detail_17oktober1943.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        children: [
          TimelineEntry(
            date: '28.Oktober 1940',
            title: 'Der italienische Einmarsch in Griechenland',
            description:
                'Der italienische Einmarsch in Griechenland am 28. Oktober 1940 markierte den Beginn des Balkanfeldzugs im Zweiten Weltkrieg...',
            isFirst: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Detail28Oktober1940(),
                ),
              );
            },
          ),
          TimelineEntry(
            date: 'April 1941',
            title: 'Deutsche Wehrmacht startet den Balkanfeldzug',
            description:
                'Deutsche Wehrmacht startet den Balkanfeldzug: Kapitulation und Besetzung Griechenlands bis Anfang Juni.',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailApril1941(),
                ),
              );
            },
          ),
          TimelineEntry(
            date: 'Sommer 1941',
            title: 'Beginn der Großen Hungersnot',
            description:
                'Beginn der Großen Hungersnot: Die Blockade und Ernteausfälle führen zu Zehntausenden Zivilopfern in Städten wie Athen und Thessaloniki.',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailSommer1941(),
                ),
              );
            },
          ),
          TimelineEntry(
            date: 'September 1941',
            title: 'Gründung der ersten organisierten Widerstandsgruppen',
            description:
                'Gründung der ersten organisierten Widerstandsgruppen (EDES, EAM/ELAS) – Sabotageaktionen beginnen, deutsche Repressalien gegen Zivilbevölkerung folg...',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailSeptember1941a(),
                ),
              );
            },
          ),
          TimelineEntry(
            date: 'September 1941',
            title: 'Operation Harling: Sprengung der Gorgopotamos-Brücke',
            description:
                'Operation Harling: Sprengung der Gorgopotamos-Brücke durch britisch-griechische Partisanen – deutsche Vergeltungsaktionen in umliegenden Dörf...',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailSeptember1941b(),
                ),
              );
            },
          ),
          TimelineEntry(
            date: '24. März 1943',
            title: 'Massaker von Domeniko (Thessalien)',
            description:
                'SS-Einsatzgruppe exekutiert über 150 Männer als Vergeltung für Partisanenangriffe.',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Detail24Maerz1943(),
                ),
              );
            },
          ),
          TimelineEntry(
            date: '17. August 1943',
            title: 'Vernichtung der jüdischen Gemeinde Thessaloniki',
            description:
                'Deportationsbeginn in Thessaloniki: Die umfassende Vernichtung der jüdischen Bevölkerung.',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Detail17August1943(),
                ),
              );
            },
          ),
          TimelineEntry(
            date: '14. September 1943',
            title: 'Italienische Kapitulation',
            description:
                'Viele italienische Besatzungssoldaten wechseln die Seiten und nehmen am griechischen Partisanenkampf gegen deutsche Truppen teil.',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Detail14September1943(),
                ),
              );
            },
          ),
          TimelineEntry(
            date: '17. Oktober 1943',
            title: 'Viannos-Massaker (Kreta)',
            description:
                'Deutsche SS-Einheit tötet über 400 Zivilisten in Viannos, Kreta, als Vergeltung für Partisanenaktivitäten.',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Detail17Oktober1943(),
                ),
              );
            },
          ),
          TimelineEntry(
            date: '29. Juni 1944',
            title: 'Distomo-Massaker',
            description:
                'SS-Einheit tötet über 200 Zivilisten in Distomo, einem der brutalsten Einzelmassaker der Besatzungszeit.',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Detail29Juni1944(),
                ),
              );
            },
          ),
          TimelineEntry(
            date: '12. Oktober 1944',
            title: 'Befreiung Athens',
            description:
                'Truppen und das Ankunft britischer Truppen in der Hauptstadt und der deutschen Besatzung in der Hauptstadt.',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Detail12Oktober1944(),
                ),
              );
            },
          ),
          TimelineEntry(
            date: '28. Dezember 1944',
            title: 'Dekemvriana: Straßenschlachten in Athen',
            description:
                'Konflikt zwischen der griechischen Volksbefreiungsarmee (ELAS) und britisch-griechischen Regierungstruppen.',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Detail28Dezember1944(),
                ),
              );
            },
          ),
          TimelineEntry(
            date: '12. Februar 1945',
            title: 'Varkiza-Abkommen',
            description:
                'Formeller Waffenstillstand zwischen ELAS und der offiziellen griechischen Regierung; jedoch Beginn politis...',
            isLast: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Detail12Februar1945(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
