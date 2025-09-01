// lib/src/data/firestore_converter.dart
// Helper-Klasse für die Konvertierung zwischen Firestore und Dart-Objekten

import 'package:cloud_firestore/cloud_firestore.dart';
import 'data_initialization.dart';

class FirestoreConverter {
  // Victim Konvertierung
  static VictimImpl victimFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Konvertiere Firestore-Daten (snake_case) zu Dart-Objekt (lowerCamelCase)
    return VictimImpl(
      victimId: doc.id, // Verwende Document ID als victim_id
      surname: data['surname'] ?? '',
      name: data['name'] ?? '',
      prisonerNumber: data['prisoner_number'],
      birth: data['birth'] != null
          ? (data['birth'] as Timestamp).toDate()
          : null,
      birthplace: data['birthplace'],
      death: data['death'] != null
          ? (data['death'] as Timestamp).toDate()
          : null,
      deathplace: data['deathplace'],
      nationality: data['nationality'] ?? '',
      religion: data['religion'] ?? '',
      occupation: data['occupation'] ?? '',
      deathCertificate: data['death_certificate'] ?? false,
      envDate: data['env_date'] != null
          ? (data['env_date'] as Timestamp).toDate()
          : null,
      cCamp: data['c_camp'] ?? '',
      fate: data['fate'] ?? '',
      imagePath: data['imagePath'],
      imageDescription: data['imageDescription'],
      imageSource: data['imageSource'],
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  // Victim zu Firestore Map
  static Map<String, dynamic> victimToFirestore(VictimImpl victim) {
    return {
      'victim_id': victim.victimId,
      'surname': victim.surname,
      'name': victim.name,
      'prisoner_number': victim.prisonerNumber,
      'birth': victim.birth != null ? Timestamp.fromDate(victim.birth!) : null,
      'birthplace': victim.birthplace,
      'death': victim.death != null ? Timestamp.fromDate(victim.death!) : null,
      'deathplace': victim.deathplace,
      'nationality': victim.nationality,
      'religion': victim.religion,
      'occupation': victim.occupation,
      'death_certificate': victim.deathCertificate,
      'env_date': victim.envDate != null
          ? Timestamp.fromDate(victim.envDate!)
          : null,
      'c_camp': victim.cCamp,
      'fate': victim.fate,
      'imagePath': victim.imagePath,
      'imageDescription': victim.imageDescription,
      'imageSource': victim.imageSource,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // ConcentrationCamp Konvertierung
  static ConcentrationCampImpl campFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ConcentrationCampImpl(
      campId: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      country: data['country'] ?? '',
      description: data['description'] ?? '',
      dateOpened: data['date_opened'] != null
          ? (data['date_opened'] as Timestamp).toDate()
          : null,
      liberationDate: data['liberation_date'] != null
          ? (data['liberation_date'] as Timestamp).toDate()
          : null,
      type: data['type'] ?? '',
      commander: data['commander'] ?? '',
      imagePath: data['imagePath'],
      imageDescription: data['imageDescription'],
      imageSource: data['imageSource'],
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  // Camp zu Firestore Map
  static Map<String, dynamic> campToFirestore(ConcentrationCampImpl camp) {
    return {
      'camp_id': camp.campId,
      'name': camp.name,
      'location': camp.location,
      'country': camp.country,
      'description': camp.description,
      'date_opened': camp.dateOpened != null
          ? Timestamp.fromDate(camp.dateOpened!)
          : null,
      'liberation_date': camp.liberationDate != null
          ? Timestamp.fromDate(camp.liberationDate!)
          : null,
      'type': camp.type,
      'commander': camp.commander,
      'imagePath': camp.imagePath,
      'imageDescription': camp.imageDescription,
      'imageSource': camp.imageSource,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Commander Konvertierung
  static CommanderImpl commanderFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CommanderImpl(
      commanderId: doc.id,
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
      rank: data['rank'] ?? '',
      birth: data['birth'] != null
          ? (data['birth'] as Timestamp).toDate()
          : null,
      birthplace: data['birthplace'],
      death: data['death'] != null
          ? (data['death'] as Timestamp).toDate()
          : null,
      deathplace: data['deathplace'],
      description: data['description'] ?? '',
      imagePath: data['imagePath'],
      imageDescription: data['imageDescription'],
      imageSource: data['imageSource'],
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  // Commander zu Firestore Map
  static Map<String, dynamic> commanderToFirestore(CommanderImpl commander) {
    return {
      'commander_id': commander.commanderId,
      'name': commander.name,
      'surname': commander.surname,
      'rank': commander.rank,
      'birth': commander.birth != null
          ? Timestamp.fromDate(commander.birth!)
          : null,
      'birthplace': commander.birthplace,
      'death': commander.death != null
          ? Timestamp.fromDate(commander.death!)
          : null,
      'deathplace': commander.deathplace,
      'description': commander.description,
      'imagePath': commander.imagePath,
      'imageDescription': commander.imageDescription,
      'imageSource': commander.imageSource,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
