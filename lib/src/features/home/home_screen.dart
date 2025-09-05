import 'package:flutter/material.dart';
import '../../common/news_card.dart';
import '../../common/quicklink_card.dart';
import '../../../l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  final Function(String) navigateTo;
  final VoidCallback navigateToNews;
  final VoidCallback navigateToDatabase;

  const HomeScreen({
    super.key,
    required this.navigateTo,
    required this.navigateToNews,
    required this.navigateToDatabase,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 215),
              child: Column(
                children: [
                  NewsCard(
                    title: l10n.homenewsCard1Title,
                    imagePath: 'assets/images/athen_home.jpg',
                    articleId: 'article1', // Hinzugefügt: ID für Athen-Artikel
                    navigateToNews: navigateToNews,
                  ),
                  NewsCard(
                    title: l10n.homenewsCard2Title,
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
                    title: l10n.hometimelineTitle,
                    text: l10n.hometimelineDescription,
                    imagePath: 'assets/icons/more_info.png',
                    onTap: () => navigateTo(l10n.navigationtimeline),
                  ),
                ),
                SizedBox(
                  width: 167,
                  child: QuicklinkCard(
                    title: l10n.homemapTitle,
                    text: l10n.homemapDescription,
                    imagePath: 'assets/icons/more_info.png',
                    onTap: () => navigateTo(l10n.navigationmap),
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
