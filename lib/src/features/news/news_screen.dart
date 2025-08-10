import 'package:flutter/material.dart';
import '../../data/data_news.dart';

class NewsScreen extends StatefulWidget {
  final String? initialArticleId;

  const NewsScreen({super.key, this.initialArticleId});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.initialArticleId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToArticle(widget.initialArticleId!);
      });
    }
  }

  void _scrollToArticle(String articleId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      // Finde den entsprechenden Container mit dem Key
      final RenderObject? renderObject = context.findRenderObject();
      if (renderObject == null) return;

      // Suche nach dem Widget mit dem entsprechenden Key
      BuildContext? targetContext;
      void visitor(Element element) {
        if (element.widget.key == Key(articleId)) {
          targetContext = element;
          return;
        }
        element.visitChildren(visitor);
      }

      if (context.mounted) {
        context.visitChildElements(visitor);

        if (targetContext != null) {
          // Scrolle zum gefundenen Element
          Scrollable.ensureVisible(
            targetContext!,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            alignment:
                -0.05, // Scrolle so, dass der Artikel etwas unter dem oberen Rand ist
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        backgroundColor: Color.fromRGBO(40, 58, 73, 1.0),
        foregroundColor: Colors.white,
        elevation: 1,
        actions: [
          // Artikel-Navigation Button
          PopupMenuButton<String>(
            color: Color.fromRGBO(40, 58, 73, 1.0),
            icon: const Icon(Icons.list_alt, color: Colors.white),
            tooltip: 'Zu Artikel springen',
            onSelected: _scrollToArticle,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'article1',
                child: Row(
                  children: [
                    Icon(
                      Icons.location_city,
                      color: widget.initialArticleId == 'article1'
                          ? Theme.of(context).primaryColor
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Athen',
                            style: TextStyle(
                              fontWeight: widget.initialArticleId == 'article1'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '80 Jahre Befreiung',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'article2',
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance,
                      color: widget.initialArticleId == 'article2'
                          ? Theme.of(context).primaryColor
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Thessaloniki',
                            style: TextStyle(
                              fontWeight: widget.initialArticleId == 'article2'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '80 Jahre Befreiung',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16.0),
          child: DataNewsWidget(highlightSection: widget.initialArticleId),
        ),
      ),

      // Floating Action Button für schnelle Navigation
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.initialArticleId != null)
            FloatingActionButton(
              mini: true,
              heroTag: "scroll_to_top", // Eindeutiger Hero-Tag
              backgroundColor: const Color.fromRGBO(40, 58, 73, 1.0),
              foregroundColor: Colors.white,
              onPressed: () {
                _scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              tooltip: 'Zum Anfang',
              child: const Icon(Icons.vertical_align_top),
            ),
          if (widget.initialArticleId != null) const SizedBox(height: 8),
          FloatingActionButton(
            mini: true,
            heroTag: "toggle_article", // Eindeutiger Hero-Tag
            backgroundColor: const Color.fromRGBO(40, 58, 73, 1.0),
            foregroundColor: Colors.white,
            onPressed: () {
              // Toggle zwischen den Artikeln
              String targetArticle = widget.initialArticleId == 'article1'
                  ? 'article2'
                  : 'article1';
              _scrollToArticle(targetArticle);
            },
            tooltip: 'Zum anderen Artikel',
            child: const Icon(Icons.swap_vert),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
