import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';
import 'database_repository.dart';
import 'data_initialization.dart';

class FirebaseRepository implements DatabaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collections
  static const String _usersCollection = 'users';
  static const String _victimsCollection = 'victims';
  static const String _campsCollection = 'camps';
  static const String _commandersCollection = 'commanders';

  // UserProfiles CRUD
  @override
  Future<List<UserProfile>> getUserProfiles() async {
    try {
      final querySnapshot = await _firestore.collection(_usersCollection).get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return UserProfileImpl(
          id: data['id'] ?? 0,
          name: data['name'] ?? '',
          surname: data['surname'] ?? '',
          email: data['email'] ?? '',
          password: '', // Passwort aus Sicherheitsgründen nicht laden
        );
      }).toList();
    } catch (e) {
      throw Exception('Fehler beim Laden der Benutzerprofile: $e');
    }
  }

  @override
  Future<UserProfile?> getUserProfileById(String id) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(id).get();
      if (doc.exists) {
        final data = doc.data()!;
        return UserProfileImpl(
          id: data['id'] ?? 0,
          name: data['name'] ?? '',
          surname: data['surname'] ?? '',
          email: data['email'] ?? '',
          password: '',
        );
      }
      return null;
    } catch (e) {
      throw Exception('Fehler beim Laden des Benutzerprofils: $e');
    }
  }

  @override
  Future<void> createUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(profile.id.toString())
          .set({
            'id': profile.id,
            'name': profile.name,
            'surname': profile.surname,
            'email': profile.email,
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Fehler beim Erstellen des Benutzerprofils: $e');
    }
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(profile.id.toString())
          .update({
            'name': profile.name,
            'surname': profile.surname,
            'email': profile.email,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Fehler beim Aktualisieren des Benutzerprofils: $e');
    }
  }

  @override
  Future<void> deleteUserProfile(String id) async {
    try {
      await _firestore.collection(_usersCollection).doc(id).delete();
    } catch (e) {
      throw Exception('Fehler beim Löschen des Benutzerprofils: $e');
    }
  }

  // Victims CRUD
  @override
  Future<List<Victim>> getVictims() async {
    try {
      final querySnapshot = await _firestore
          .collection(_victimsCollection)
          .get();
      return querySnapshot.docs
          .map((doc) => _victimFromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Fehler beim Laden der Opfer: $e');
    }
  }

  @override
  Future<Victim?> getVictimById(String id) async {
    try {
      final doc = await _firestore.collection(_victimsCollection).doc(id).get();
      if (doc.exists) {
        return _victimFromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Fehler beim Laden des Opfers: $e');
    }
  }

  @override
  Future<void> createVictim(Victim victim) async {
    try {
      await _firestore
          .collection(_victimsCollection)
          .doc(victim.victim_id.toString())
          .set({
            'victim_id': victim.victim_id,
            'surname': victim.surname,
            'name': victim.name,
            'prisoner_number': victim.prisoner_number,
            'birth': victim.birth != null
                ? Timestamp.fromDate(victim.birth!)
                : null,
            'birthplace': victim.birthplace,
            'death': victim.death != null
                ? Timestamp.fromDate(victim.death!)
                : null,
            'deathplace': victim.deathplace,
            'nationality': victim.nationality,
            'religion': victim.religion,
            'occupation': victim.occupation,
            'death_certificate': victim.death_certificate,
            'env_date': victim.env_date != null
                ? Timestamp.fromDate(victim.env_date!)
                : null,
            'c_camp': victim.c_camp,
            'fate': victim.fate,
            'imagePath': victim.imagePath,
            'imageDescription': victim.imageDescription,
            'imageSource': victim.imageSource,
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Fehler beim Erstellen des Opfers: $e');
    }
  }

  @override
  Future<void> updateVictim(Victim victim) async {
    try {
      await _firestore
          .collection(_victimsCollection)
          .doc(victim.victim_id.toString())
          .update({
            'surname': victim.surname,
            'name': victim.name,
            'prisoner_number': victim.prisoner_number,
            'birth': victim.birth != null
                ? Timestamp.fromDate(victim.birth!)
                : null,
            'birthplace': victim.birthplace,
            'death': victim.death != null
                ? Timestamp.fromDate(victim.death!)
                : null,
            'deathplace': victim.deathplace,
            'nationality': victim.nationality,
            'religion': victim.religion,
            'occupation': victim.occupation,
            'death_certificate': victim.death_certificate,
            'env_date': victim.env_date != null
                ? Timestamp.fromDate(victim.env_date!)
                : null,
            'c_camp': victim.c_camp,
            'fate': victim.fate,
            'imagePath': victim.imagePath,
            'imageDescription': victim.imageDescription,
            'imageSource': victim.imageSource,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Fehler beim Aktualisieren des Opfers: $e');
    }
  }

  @override
  Future<void> deleteVictim(String id) async {
    try {
      await _firestore.collection(_victimsCollection).doc(id).delete();
    } catch (e) {
      throw Exception('Fehler beim Löschen des Opfers: $e');
    }
  }

  // ConcentrationCamps CRUD
  @override
  Future<List<ConcentrationCamp>> getConcentrationCamps() async {
    try {
      final querySnapshot = await _firestore.collection(_campsCollection).get();
      return querySnapshot.docs.map((doc) => _campFromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Fehler beim Laden der Lager: $e');
    }
  }

  @override
  Future<ConcentrationCamp?> getConcentrationCampById(String id) async {
    try {
      final doc = await _firestore.collection(_campsCollection).doc(id).get();
      if (doc.exists) {
        return _campFromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Fehler beim Laden des Lagers: $e');
    }
  }

  @override
  Future<void> createConcentrationCamp(ConcentrationCamp camp) async {
    try {
      await _firestore
          .collection(_campsCollection)
          .doc(camp.camp_id.toString())
          .set({
            'camp_id': camp.camp_id,
            'name': camp.name,
            'location': camp.location,
            'country': camp.country,
            'description': camp.description,
            'date_opened': camp.date_opened != null
                ? Timestamp.fromDate(camp.date_opened!)
                : null,
            'liberation_date': camp.liberation_date != null
                ? Timestamp.fromDate(camp.liberation_date!)
                : null,
            'type': camp.type,
            'commander': camp.commander,
            'imagePath': camp.imagePath,
            'imageDescription': camp.imageDescription,
            'imageSource': camp.imageSource,
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Fehler beim Erstellen des Lagers: $e');
    }
  }

  @override
  Future<void> updateConcentrationCamp(ConcentrationCamp camp) async {
    try {
      await _firestore
          .collection(_campsCollection)
          .doc(camp.camp_id.toString())
          .update({
            'name': camp.name,
            'location': camp.location,
            'country': camp.country,
            'description': camp.description,
            'date_opened': camp.date_opened != null
                ? Timestamp.fromDate(camp.date_opened!)
                : null,
            'liberation_date': camp.liberation_date != null
                ? Timestamp.fromDate(camp.liberation_date!)
                : null,
            'type': camp.type,
            'commander': camp.commander,
            'imagePath': camp.imagePath,
            'imageDescription': camp.imageDescription,
            'imageSource': camp.imageSource,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Fehler beim Aktualisieren des Lagers: $e');
    }
  }

  @override
  Future<void> deleteConcentrationCamp(String id) async {
    try {
      await _firestore.collection(_campsCollection).doc(id).delete();
    } catch (e) {
      throw Exception('Fehler beim Löschen des Lagers: $e');
    }
  }

  // Commanders CRUD
  @override
  Future<List<Commander>> getCommanders() async {
    try {
      final querySnapshot = await _firestore
          .collection(_commandersCollection)
          .get();
      return querySnapshot.docs
          .map((doc) => _commanderFromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Fehler beim Laden der Kommandanten: $e');
    }
  }

  @override
  Future<Commander?> getCommanderById(String id) async {
    try {
      final doc = await _firestore
          .collection(_commandersCollection)
          .doc(id)
          .get();
      if (doc.exists) {
        return _commanderFromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Fehler beim Laden des Kommandanten: $e');
    }
  }

  @override
  Future<void> createCommander(Commander commander) async {
    try {
      await _firestore
          .collection(_commandersCollection)
          .doc(commander.commander_id.toString())
          .set({
            'commander_id': commander.commander_id,
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
          });
    } catch (e) {
      throw Exception('Fehler beim Erstellen des Kommandanten: $e');
    }
  }

  @override
  Future<void> updateCommander(Commander commander) async {
    try {
      await _firestore
          .collection(_commandersCollection)
          .doc(commander.commander_id.toString())
          .update({
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
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Fehler beim Aktualisieren des Kommandanten: $e');
    }
  }

  @override
  Future<void> deleteCommander(String id) async {
    try {
      await _firestore.collection(_commandersCollection).doc(id).delete();
    } catch (e) {
      throw Exception('Fehler beim Löschen des Kommandanten: $e');
    }
  }

  // Helper Methods
  VictimImpl _victimFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VictimImpl(
      victim_id: data['victim_id'] ?? 0,
      surname: data['surname'] ?? '',
      name: data['name'] ?? '',
      prisoner_number: data['prisoner_number'],
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
      death_certificate: data['death_certificate'] ?? false,
      env_date: data['env_date'] != null
          ? (data['env_date'] as Timestamp).toDate()
          : null,
      c_camp: data['c_camp'] ?? '',
      fate: data['fate'] ?? '',
      imagePath: data['imagePath'],
      imageDescription: data['imageDescription'],
      imageSource: data['imageSource'],
    );
  }

  ConcentrationCampImpl _campFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConcentrationCampImpl(
      camp_id: data['camp_id'] ?? 0,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      country: data['country'] ?? '',
      description: data['description'] ?? '',
      date_opened: data['date_opened'] != null
          ? (data['date_opened'] as Timestamp).toDate()
          : null,
      liberation_date: data['liberation_date'] != null
          ? (data['liberation_date'] as Timestamp).toDate()
          : null,
      type: data['type'] ?? '',
      commander: data['commander'] ?? '',
      imagePath: data['imagePath'],
      imageDescription: data['imageDescription'],
      imageSource: data['imageSource'],
    );
  }

  CommanderImpl _commanderFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommanderImpl(
      commander_id: data['commander_id'] ?? 0,
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
    );
  }
}
