import 'package:cloud_firestore/cloud_firestore.dart';

class MigrationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Migration ist bereits erfolgt - Service wird nicht mehr benötigt
  @Deprecated('Migration bereits abgeschlossen')
  Future<void> migrateMockDataToFirestore() async {
    throw Exception(
      'Migration bereits abgeschlossen. Verwenden Sie das Admin Dashboard für CRUD-Operationen.',
    );
  }

  Future<bool> isDataMigrated() async {
    try {
      final victimsSnapshot = await _firestore
          .collection('victims')
          .limit(1)
          .get();
      return victimsSnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Statistiken für Admin Dashboard
  Future<Map<String, int>> getDataStatistics() async {
    try {
      final victimsCount = await _firestore.collection('victims').get();
      final campsCount = await _firestore.collection('camps').get();
      final commandersCount = await _firestore.collection('commanders').get();
      final usersCount = await _firestore.collection('users').get();

      return {
        'victims': victimsCount.docs.length,
        'camps': campsCount.docs.length,
        'commanders': commandersCount.docs.length,
        'users': usersCount.docs.length,
      };
    } catch (e) {
      return {'victims': 0, 'camps': 0, 'commanders': 0, 'users': 0};
    }
  }
}
