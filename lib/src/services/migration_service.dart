import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/data_initialization.dart';
import '../data/FirebaseRepository.dart';

class MigrationService {
  final FirebaseRepository _repository = FirebaseRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> migrateMockDataToFirestore() async {
    try {
      // Check if data already exists
      final victimsSnapshot = await _firestore
          .collection('victims')
          .limit(1)
          .get();
      if (victimsSnapshot.docs.isNotEmpty) {
        print('Daten bereits in Firestore vorhanden');
        return;
      }

      print('Starte Migration der Mock-Daten zu Firestore...');

      // Initialize mock data
      final mockRepo = await initializeMockData();

      // Migrate Victims
      final victims = await mockRepo.getVictims();
      for (final victim in victims) {
        await _repository.createVictim(victim);
        print('Opfer migriert: ${victim.name} ${victim.surname}');
      }

      // Migrate Concentration Camps
      final camps = await mockRepo.getConcentrationCamps();
      for (final camp in camps) {
        await _repository.createConcentrationCamp(camp);
        print('Lager migriert: ${camp.name}');
      }

      // Migrate Commanders
      final commanders = await mockRepo.getCommanders();
      for (final commander in commanders) {
        await _repository.createCommander(commander);
        print('Kommandant migriert: ${commander.name} ${commander.surname}');
      }

      print('Migration abgeschlossen!');
    } catch (e) {
      print('Fehler bei der Migration: $e');
      throw Exception('Migration fehlgeschlagen: $e');
    }
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
}
