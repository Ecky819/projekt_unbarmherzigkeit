import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../services/auth_service.dart';

class FavoriteButton extends StatefulWidget {
  final String itemId;
  final String itemType;
  final String itemTitle;
  final double size;
  final Color? favoriteColor;
  final Color? notFavoriteColor;
  final bool showLoginMessage;

  const FavoriteButton({
    super.key,
    required this.itemId,
    required this.itemType,
    required this.itemTitle,
    this.size = 24.0,
    this.favoriteColor,
    this.notFavoriteColor,
    this.showLoginMessage = true,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  final FavoritesService _favoritesService = FavoritesService();
  final AuthService _authService = AuthService();

  bool _isFavorite = false;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _checkFavoriteStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkFavoriteStatus() async {
    if (!_authService.isLoggedIn) {
      setState(() => _isFavorite = false);
      return;
    }

    try {
      final isFav = await _favoritesService.isFavorite(
        itemId: widget.itemId,
        itemType: widget.itemType,
      );
      if (mounted) {
        setState(() => _isFavorite = isFav);
      }
    } catch (e) {
      //print('Fehler beim Prüfen des Favoriten-Status: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    // Prüfe ob User eingeloggt ist
    if (!_authService.isLoggedIn) {
      if (widget.showLoginMessage && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Sie müssen sich anmelden, um Favoriten hinzuzufügen.',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final newFavoriteStatus = await _favoritesService.toggleFavorite(
        itemId: widget.itemId,
        itemType: widget.itemType,
        itemTitle: widget.itemTitle,
      );

      if (mounted) {
        setState(() {
          _isFavorite = newFavoriteStatus;
          _isLoading = false;
        });

        // Animiere das Icon
        _animationController.forward().then((_) {
          _animationController.reverse();
        });

        // Zeige Feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newFavoriteStatus
                  ? 'Zu Favoriten hinzugefügt'
                  : 'Von Favoriten entfernt',
            ),
            backgroundColor: newFavoriteStatus
                ? Colors.green
                : Colors.grey[600],
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        onPressed: _isLoading ? null : _toggleFavorite,
        icon: _isLoading
            ? SizedBox(
                width: widget.size * 0.8,
                height: widget.size * 0.8,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: widget.favoriteColor ?? Colors.red,
                ),
              )
            : Icon(
                _isFavorite ? Icons.bookmark : Icons.bookmark_border,
                size: widget.size,
                color: _isFavorite
                    ? (widget.favoriteColor ?? Colors.red)
                    : (widget.notFavoriteColor ?? Colors.grey),
              ),
        tooltip: _isFavorite
            ? 'Von Favoriten entfernen'
            : _authService.isLoggedIn
            ? 'Zu Favoriten hinzufügen'
            : 'Anmelden für Favoriten',
      ),
    );
  }
}

// Kompakte Version für Listen-Items
class FavoriteIconButton extends StatefulWidget {
  final String itemId;
  final String itemType;
  final String itemTitle;
  final double size;
  final EdgeInsets padding;

  const FavoriteIconButton({
    super.key,
    required this.itemId,
    required this.itemType,
    required this.itemTitle,
    this.size = 20.0,
    this.padding = const EdgeInsets.all(4.0),
  });

  @override
  State<FavoriteIconButton> createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends State<FavoriteIconButton> {
  final FavoritesService _favoritesService = FavoritesService();
  final AuthService _authService = AuthService();

  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    if (!_authService.isLoggedIn) {
      setState(() => _isFavorite = false);
      return;
    }

    try {
      final isFav = await _favoritesService.isFavorite(
        itemId: widget.itemId,
        itemType: widget.itemType,
      );
      if (mounted) {
        setState(() => _isFavorite = isFav);
      }
    } catch (e) {
      //print('Fehler beim Prüfen des Favoriten-Status: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    if (!_authService.isLoggedIn || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final newStatus = await _favoritesService.toggleFavorite(
        itemId: widget.itemId,
        itemType: widget.itemType,
        itemTitle: widget.itemTitle,
      );

      if (mounted) {
        setState(() {
          _isFavorite = newStatus;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: InkWell(
        onTap: _isLoading ? null : _toggleFavorite,
        borderRadius: BorderRadius.circular(widget.size),
        child: Container(
          width: widget.size * 1.5,
          height: widget.size * 1.5,
          alignment: Alignment.center,
          child: _isLoading
              ? SizedBox(
                  width: widget.size * 0.7,
                  height: widget.size * 0.7,
                  child: const CircularProgressIndicator(strokeWidth: 1.5),
                )
              : Icon(
                  _isFavorite ? Icons.bookmark : Icons.bookmark_border_outlined,
                  size: widget.size,
                  color: _isFavorite ? Colors.red : Colors.grey[600],
                ),
        ),
      ),
    );
  }
}
