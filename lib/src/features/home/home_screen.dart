import 'package:flutter/material.dart';
import '../../common/news_card.dart';
import '../../common/quicklink_card.dart';

class HomeScreen extends StatelessWidget {
  final Function(String) navigateTo;
  /*final VoidCallback navigateToTimeline;
  final VoidCallback navigateToMap;*/
  final VoidCallback navigateToNews;
  final VoidCallback navigateToDatabase;

  const HomeScreen({
    super.key,
    required this.navigateTo,
    /*
    required this.navigateToTimeline,
    required this.navigateToMap,*/
    required this.navigateToNews,
    required this.navigateToDatabase,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 215),
              child: Column(
                children: [
                  NewsCard(
                    title: '80 Jahre Kriegsende in Athen',
                    imagePath: 'assets/images/athen_home.jpg',
                    articleId: 'article1', // Hinzugefügt: ID für Athen-Artikel
                    navigateToNews: navigateToNews,
                  ),
                  NewsCard(
                    title: '80 Jahre Kriegsende in Thessalonikki',
                    imagePath: 'assets/images/thessaloniki_home.jpg',
                    articleId:
                        'article2', // Hinzugefügt: ID für Thessaloniki-Artikel
                    navigateToNews: navigateToNews,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 167,
                  margin: const EdgeInsets.only(right: 16),
                  child: QuicklinkCard(
                    title: 'TIMELINE',
                    text:
                        'Hier finden sie alle historischen Ereignisse in Griechenland von 1941 bis 1945.',
                    imagePath: 'assets/icons/more_info.png',
                    onTap: () => navigateTo('Timeline'),
                  ),
                ),
                SizedBox(
                  width: 167,
                  child: QuicklinkCard(
                    title: 'KARTE',
                    text:
                        'Hier finden sie unsere Karte auf der alle Lagerstandorte verzeichnet sind.',
                    imagePath: 'assets/icons/more_info.png',
                    onTap: () => navigateTo('Karte'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
