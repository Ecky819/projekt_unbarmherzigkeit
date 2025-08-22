import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection für Favoriten
  static const String _favoritesCollection = 'user_favorites';

  // Aktueller User
  User? get _currentUser => _auth.currentUser;

  // Prüfen ob User eingeloggt ist
  bool get isLoggedIn => _currentUser != null;

  // Favorit hinzufügen
  Future<void> addFavorite({
    required String itemId,
    required String itemType, // 'victim', 'camp', 'commander'
    required String itemTitle,
  }) async {
    if (!isLoggedIn) {
      throw Exception('Sie müssen eingeloggt sein, um Favoriten hinzuzufügen.');
    }

    try {
      final favoriteId = '${_currentUser!.uid}_${itemType}_$itemId';

      // Debug-Informationen
      print('Adding favorite:');
      print('- User UID: ${_currentUser!.uid}');
      print('- User Email: ${_currentUser!.email}');
      print('- Favorite ID: $favoriteId');
      print('- Item Type: $itemType');
      print('- Item ID: $itemId');
      print('- Item Title: $itemTitle');

      await _firestore.collection(_favoritesCollection).doc(favoriteId).set({
        'userId': _currentUser!.uid,
        'userEmail': _currentUser!.email,
        'itemId': itemId,
        'itemType': itemType,
        'itemTitle': itemTitle,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Favorite added successfully!');
    } catch (e) {
      print('Error adding favorite: $e');
      throw Exception('Fehler beim Hinzufügen des Favoriten: $e');
    }
  }

  // Favorit entfernen
  Future<void> removeFavorite({
    required String itemId,
    required String itemType,
  }) async {
    if (!isLoggedIn) {
      throw Exception('Sie müssen eingeloggt sein, um Favoriten zu verwalten.');
    }

    try {
      final favoriteId = '${_currentUser!.uid}_${itemType}_$itemId';

      await _firestore
          .collection(_favoritesCollection)
          .doc(favoriteId)
          .delete();
    } catch (e) {
      throw Exception('Fehler beim Entfernen des Favoriten: $e');
    }
  }

  // Prüfen ob Item favorisiert ist
  Future<bool> isFavorite({
    required String itemId,
    required String itemType,
  }) async {
    if (!isLoggedIn) return false;

    try {
      final favoriteId = '${_currentUser!.uid}_${itemType}_$itemId';

      final doc = await _firestore
          .collection(_favoritesCollection)
          .doc(favoriteId)
          .get();

      return doc.exists;
    } catch (e) {
      print('Fehler beim Prüfen des Favoriten-Status: $e');
      return false;
    }
  }

  // Alle Favoriten des aktuellen Users abrufen
  Future<List<FavoriteItem>> getUserFavorites() async {
    if (!isLoggedIn) {
      return [];
    }

    try {
      // Versuche mit orderBy - falls Index vorhanden
      final querySnapshot = await _firestore
          .collection(_favoritesCollection)
          .where('userId', isEqualTo: _currentUser!.uid)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return FavoriteItem(
          id: doc.id,
          itemId: data['itemId'] ?? '',
          itemType: data['itemType'] ?? '',
          itemTitle: data['itemTitle'] ?? '',
          createdAt: data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
        );
      }).toList();
    } catch (e) {
      print('Error with orderBy query, trying without orderBy: $e');

      // Fallback: Query ohne orderBy
      try {
        final querySnapshot = await _firestore
            .collection(_favoritesCollection)
            .where('userId', isEqualTo: _currentUser!.uid)
            .get();

        final favorites = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return FavoriteItem(
            id: doc.id,
            itemId: data['itemId'] ?? '',
            itemType: data['itemType'] ?? '',
            itemTitle: data['itemTitle'] ?? '',
            createdAt: data['createdAt'] != null
                ? (data['createdAt'] as Timestamp).toDate()
                : DateTime.now(),
          );
        }).toList();

        // Manuell sortieren nach Erstellungsdatum
        favorites.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return favorites;
      } catch (fallbackError) {
        print('Fallback query also failed: $fallbackError');
        throw Exception('Fehler beim Laden der Favoriten: $fallbackError');
      }
    }
  }

  // Stream für Favoriten-Updates
  Stream<List<FavoriteItem>> getFavoritesStream() {
    if (!isLoggedIn) {
      return Stream.value([]);
    }

    try {
      return _firestore
          .collection(_favoritesCollection)
          .where('userId', isEqualTo: _currentUser!.uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              return FavoriteItem(
                id: doc.id,
                itemId: data['itemId'] ?? '',
                itemType: data['itemType'] ?? '',
                itemTitle: data['itemTitle'] ?? '',
                createdAt: data['createdAt'] != null
                    ? (data['createdAt'] as Timestamp).toDate()
                    : DateTime.now(),
              );
            }).toList();
          });
    } catch (e) {
      print('Error with stream orderBy, using fallback: $e');

      // Fallback Stream ohne orderBy
      return _firestore
          .collection(_favoritesCollection)
          .where('userId', isEqualTo: _currentUser!.uid)
          .snapshots()
          .map((snapshot) {
            final favorites = snapshot.docs.map((doc) {
              final data = doc.data();
              return FavoriteItem(
                id: doc.id,
                itemId: data['itemId'] ?? '',
                itemType: data['itemType'] ?? '',
                itemTitle: data['itemTitle'] ?? '',
                createdAt: data['createdAt'] != null
                    ? (data['createdAt'] as Timestamp).toDate()
                    : DateTime.now(),
              );
            }).toList();

            // Manuell sortieren
            favorites.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return favorites;
          });
    }
  }

  // Toggle Favorit
  Future<bool> toggleFavorite({
    required String itemId,
    required String itemType,
    required String itemTitle,
  }) async {
    if (!isLoggedIn) {
      throw Exception('Sie müssen eingeloggt sein, um Favoriten zu verwalten.');
    }

    final isFav = await isFavorite(itemId: itemId, itemType: itemType);

    if (isFav) {
      await removeFavorite(itemId: itemId, itemType: itemType);
      return false;
    } else {
      await addFavorite(
        itemId: itemId,
        itemType: itemType,
        itemTitle: itemTitle,
      );
      return true;
    }
  }

  // Alle Favoriten eines Users löschen (für Account-Löschung)
  Future<void> deleteAllUserFavorites(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_favoritesCollection)
          .where('userId', isEqualTo: userId)
          .get();

      final batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      print('Fehler beim Löschen aller Favoriten: $e');
    }
  }

  // Statistiken für Admin Dashboard
  Future<Map<String, dynamic>> getFavoriteStatistics() async {
    try {
      final querySnapshot = await _firestore
          .collection(_favoritesCollection)
          .get();

      final totalFavorites = querySnapshot.docs.length;
      final favoritesByType = <String, int>{};
      final favoritesByUser = <String, int>{};

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final type = data['itemType'] ?? 'unknown';
        final userId = data['userId'] ?? 'unknown';

        favoritesByType[type] = (favoritesByType[type] ?? 0) + 1;
        favoritesByUser[userId] = (favoritesByUser[userId] ?? 0) + 1;
      }

      return {
        'totalFavorites': totalFavorites,
        'favoritesByType': favoritesByType,
        'uniqueUsers': favoritesByUser.length,
        'avgFavoritesPerUser': favoritesByUser.isNotEmpty
            ? totalFavorites / favoritesByUser.length
            : 0,
      };
    } catch (e) {
      print('Fehler beim Laden der Favoriten-Statistiken: $e');
      return {
        'totalFavorites': 0,
        'favoritesByType': <String, int>{},
        'uniqueUsers': 0,
        'avgFavoritesPerUser': 0,
      };
    }
  }
}

// Favoriten-Item Model
class FavoriteItem {
  final String id;
  final String itemId;
  final String itemType;
  final String itemTitle;
  final DateTime createdAt;

  FavoriteItem({
    required this.id,
    required this.itemId,
    required this.itemType,
    required this.itemTitle,
    required this.createdAt,
  });

  // Helper-Methoden
  String get typeDisplayName {
    switch (itemType) {
      case 'victim':
        return 'Opfer';
      case 'camp':
        return 'Lager';
      case 'commander':
        return 'Kommandant';
      default:
        return 'Unbekannt';
    }
  }

  IconData get typeIcon {
    switch (itemType) {
      case 'victim':
        return Icons.person;
      case 'camp':
        return Icons.location_city;
      case 'commander':
        return Icons.military_tech;
      default:
        return Icons.help_outline;
    }
  }

  Color get typeColor {
    switch (itemType) {
      case 'victim':
        return const Color.fromRGBO(40, 58, 73, 1.0);
      case 'camp':
        return Colors.black54;
      case 'commander':
        return Colors.black87;
      default:
        return Colors.grey;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
