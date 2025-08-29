import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';
import 'database_repository.dart';
import 'data_initialization.dart';

class FirebaseRepository implements DatabaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  static const String _usersCollection = 'users';
  static const String _victimsCollection = 'victims';
  static const String _campsCollection = 'camps';
  static const String _commandersCollection = 'commanders';

  // UserProfiles CRUD
  @override
  Future<DatabaseResult<List<UserProfile>>> getUserProfiles() async {
    try {
      final querySnapshot = await _firestore.collection(_usersCollection).get();
      final profiles = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return UserProfileImpl.fromJson(data);
      }).toList();

      return DatabaseResult.success(profiles);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden der Benutzerprofile',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<UserProfile?>> getUserProfileById(String id) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(id).get();
      if (!doc.exists) {
        return const DatabaseResult.success(null);
      }

      final data = doc.data()!;
      final profile = UserProfileImpl.fromJson(data);
      return DatabaseResult.success(profile);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden des Benutzerprofils',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> createUserProfile(UserProfile profile) async {
    try {
      await _firestore.collection(_usersCollection).doc(profile.id).set({
        ...profile.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return const DatabaseResult.success(null);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Erstellen des Benutzerprofils',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> updateUserProfile(UserProfile profile) async {
    try {
      await _firestore.collection(_usersCollection).doc(profile.id).update({
        ...profile.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return const DatabaseResult.success(null);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Aktualisieren des Benutzerprofils',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> deleteUserProfile(String id) async {
    try {
      await _firestore.collection(_usersCollection).doc(id).delete();
      return const DatabaseResult.success(null);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Löschen des Benutzerprofils',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // Victims CRUD
  @override
  Future<DatabaseResult<List<Victim>>> getVictims() async {
    try {
      final querySnapshot = await _firestore
          .collection(_victimsCollection)
          .orderBy('surname')
          .get();

      final victims = querySnapshot.docs
          .map((doc) => _victimFromFirestore(doc))
          .toList();

      return DatabaseResult.success(victims);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden der Opfer',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<Victim?>> getVictimById(String id) async {
    try {
      final doc = await _firestore.collection(_victimsCollection).doc(id).get();
      if (!doc.exists) {
        return const DatabaseResult.success(null);
      }

      final victim = _victimFromFirestore(doc);
      return DatabaseResult.success(victim);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden des Opfers',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> createVictim(Victim victim) async {
    try {
      await _firestore
          .collection(_victimsCollection)
          .doc(victim.victim_id)
          .set({
            ...victim.toJson(),
            'birth': victim.birth != null
                ? Timestamp.fromDate(victim.birth!)
                : null,
            'death': victim.death != null
                ? Timestamp.fromDate(victim.death!)
                : null,
            'env_date': victim.env_date != null
                ? Timestamp.fromDate(victim.env_date!)
                : null,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

      return const DatabaseResult.success(null);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Erstellen des Opfers',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> updateVictim(Victim victim) async {
    try {
      await _firestore
          .collection(_victimsCollection)
          .doc(victim.victim_id)
          .update({
            ...victim.toJson(),
            'birth': victim.birth != null
                ? Timestamp.fromDate(victim.birth!)
                : null,
            'death': victim.death != null
                ? Timestamp.fromDate(victim.death!)
                : null,
            'env_date': victim.env_date != null
                ? Timestamp.fromDate(victim.env_date!)
                : null,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      return const DatabaseResult.success(null);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Aktualisieren des Opfers',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> deleteVictim(String id) async {
    try {
      await _firestore.collection(_victimsCollection).doc(id).delete();
      return const DatabaseResult.success(null);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Löschen des Opfers',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // ConcentrationCamps CRUD
  @override
  Future<DatabaseResult<List<ConcentrationCamp>>>
  getConcentrationCamps() async {
    try {
      final querySnapshot = await _firestore
          .collection(_campsCollection)
          .orderBy('name')
          .get();

      final camps = querySnapshot.docs
          .map((doc) => _campFromFirestore(doc))
          .toList();

      return DatabaseResult.success(camps);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden der Lager',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<ConcentrationCamp?>> getConcentrationCampById(
    String id,
  ) async {
    try {
      final doc = await _firestore.collection(_campsCollection).doc(id).get();
      if (!doc.exists) {
        return const DatabaseResult.success(null);
      }

      final camp = _campFromFirestore(doc);
      return DatabaseResult.success(camp);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden des Lagers',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> createConcentrationCamp(
    ConcentrationCamp camp,
  ) async {
    try {
      await _firestore.collection(_campsCollection).doc(camp.camp_id).set({
        ...camp.toJson(),
        'date_opened': camp.date_opened != null
            ? Timestamp.fromDate(camp.date_opened!)
            : null,
        'liberation_date': camp.liberation_date != null
            ? Timestamp.fromDate(camp.liberation_date!)
            : null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return const DatabaseResult.success(null);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Erstellen des Lagers',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> updateConcentrationCamp(
    ConcentrationCamp camp,
  ) async {
    try {
      await _firestore.collection(_campsCollection).doc(camp.camp_id).update({
        ...camp.toJson(),
        'date_opened': camp.date_opened != null
            ? Timestamp.fromDate(camp.date_opened!)
            : null,
        'liberation_date': camp.liberation_date != null
            ? Timestamp.fromDate(camp.liberation_date!)
            : null,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return const DatabaseResult.success(null);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Aktualisieren des Lagers',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> deleteConcentrationCamp(String id) async {
    try {
      await _firestore.collection(_campsCollection).doc(id).delete();
      return const DatabaseResult.success(null);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Löschen des Lagers',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // Commanders CRUD
  @override
  Future<DatabaseResult<List<Commander>>> getCommanders() async {
    try {
      final querySnapshot = await _firestore
          .collection(_commandersCollection)
          .orderBy('surname')
          .get();

      final commanders = querySnapshot.docs
          .map((doc) => _commanderFromFirestore(doc))
          .toList();

      return DatabaseResult.success(commanders);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden der Kommandanten',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<Commander?>> getCommanderById(String id) async {
    try {
      final doc = await _firestore
          .collection(_commandersCollection)
          .doc(id)
          .get();

      if (!doc.exists) {
        return const DatabaseResult.success(null);
      }

      final commander = _commanderFromFirestore(doc);
      return DatabaseResult.success(commander);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden des Kommandanten',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> createCommander(Commander commander) async {
    try {
      await _firestore
          .collection(_commandersCollection)
          .doc(commander.commander_id)
          .set({
            ...commander.toJson(),
            'birth': commander.birth != null
                ? Timestamp.fromDate(commander.birth!)
                : null,
            'death': commander.death != null
                ? Timestamp.fromDate(commander.death!)
                : null,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

      return const DatabaseResult.success(null);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Erstellen des Kommandanten',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> updateCommander(Commander commander) async {
    try {
      await _firestore
          .collection(_commandersCollection)
          .doc(commander.commander_id)
          .update({
            ...commander.toJson(),
            'birth': commander.birth != null
                ? Timestamp.fromDate(commander.birth!)
                : null,
            'death': commander.death != null
                ? Timestamp.fromDate(commander.death!)
                : null,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      return const DatabaseResult.success(null);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Aktualisieren des Kommandanten',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> deleteCommander(String id) async {
    try {
      await _firestore.collection(_commandersCollection).doc(id).delete();
      return const DatabaseResult.success(null);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Löschen des Kommandanten',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // Erweiterte Such- und Query-Methoden
  @override
  Future<DatabaseResult<List<SearchResult>>> search({
    String? nameQuery,
    String? locationQuery,
    String? yearQuery,
    String? eventQuery,
    int? limit,
    String? lastDocumentId,
  }) async {
    try {
      final results = <SearchResult>[];

      // Parallel suchen für bessere Performance
      final futures = await Future.wait([
        _searchVictims(nameQuery, locationQuery, yearQuery, eventQuery),
        _searchCamps(nameQuery, locationQuery, yearQuery, eventQuery),
        _searchCommanders(nameQuery, locationQuery, yearQuery, eventQuery),
      ]);

      for (final futureResult in futures) {
        if (futureResult.isSuccess && futureResult.data != null) {
          results.addAll(futureResult.data!);
        }
      }

      // Sortiere und limitiere Ergebnisse
      results.sort((a, b) => a.title.compareTo(b.title));

      if (limit != null && results.length > limit) {
        return DatabaseResult.success(results.take(limit).toList());
      }

      return DatabaseResult.success(results);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler bei der Suche',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<DatabaseResult<List<SearchResult>>> _searchVictims(
    String? nameQuery,
    String? locationQuery,
    String? yearQuery,
    String? eventQuery,
  ) async {
    try {
      Query query = _firestore.collection(_victimsCollection);

      // Einfache Textsuche (Firebase hat Limitationen bei komplexer Textsuche)
      if (nameQuery != null && nameQuery.trim().isNotEmpty) {
        // Suche nach Namen - Firebase unterstützt nur einfache where-Queries
        query = query
            .where('surname', isGreaterThanOrEqualTo: nameQuery.trim())
            .where('surname', isLessThan: '${nameQuery.trim()}z');
      }

      final querySnapshot = await query.get();
      final results = <SearchResult>[];

      for (final doc in querySnapshot.docs) {
        final victim = _victimFromFirestore(doc);

        // Client-side Filterung für komplexere Suchanfragen
        if (_victimMatchesFilters(
          victim,
          nameQuery,
          locationQuery,
          yearQuery,
          eventQuery,
        )) {
          results.add(SearchResult.fromVictim(victim));
        }
      }

      return DatabaseResult.success(results);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException('Fehler bei der Opfer-Suche', originalError: e),
      );
    }
  }

  Future<DatabaseResult<List<SearchResult>>> _searchCamps(
    String? nameQuery,
    String? locationQuery,
    String? yearQuery,
    String? eventQuery,
  ) async {
    try {
      Query query = _firestore.collection(_campsCollection);

      if (nameQuery != null && nameQuery.trim().isNotEmpty) {
        query = query
            .where('name', isGreaterThanOrEqualTo: nameQuery.trim())
            .where('name', isLessThan: '${nameQuery.trim()}z');
      }

      final querySnapshot = await query.get();
      final results = <SearchResult>[];

      for (final doc in querySnapshot.docs) {
        final camp = _campFromFirestore(doc);

        if (_campMatchesFilters(
          camp,
          nameQuery,
          locationQuery,
          yearQuery,
          eventQuery,
        )) {
          results.add(SearchResult.fromCamp(camp));
        }
      }

      return DatabaseResult.success(results);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException('Fehler bei der Lager-Suche', originalError: e),
      );
    }
  }

  Future<DatabaseResult<List<SearchResult>>> _searchCommanders(
    String? nameQuery,
    String? locationQuery,
    String? yearQuery,
    String? eventQuery,
  ) async {
    try {
      Query query = _firestore.collection(_commandersCollection);

      if (nameQuery != null && nameQuery.trim().isNotEmpty) {
        query = query
            .where('surname', isGreaterThanOrEqualTo: nameQuery.trim())
            .where('surname', isLessThan: '${nameQuery.trim()}z');
      }

      final querySnapshot = await query.get();
      final results = <SearchResult>[];

      for (final doc in querySnapshot.docs) {
        final commander = _commanderFromFirestore(doc);

        if (_commanderMatchesFilters(
          commander,
          nameQuery,
          locationQuery,
          yearQuery,
          eventQuery,
        )) {
          results.add(SearchResult.fromCommander(commander));
        }
      }

      return DatabaseResult.success(results);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler bei der Kommandanten-Suche',
          originalError: e,
        ),
      );
    }
  }

  // Paginierte Abfragen
  @override
  Future<DatabaseResult<List<Victim>>> getVictimsPaginated({
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      Query query = _firestore
          .collection(_victimsCollection)
          .orderBy('surname')
          .limit(limit);

      if (lastDocumentId != null) {
        final lastDoc = await _firestore
            .collection(_victimsCollection)
            .doc(lastDocumentId)
            .get();
        query = query.startAfterDocument(lastDoc);
      }

      final querySnapshot = await query.get();
      final victims = querySnapshot.docs
          .map((doc) => _victimFromFirestore(doc))
          .toList();

      return DatabaseResult.success(victims);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden der Opfer (paginiert)',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<List<ConcentrationCamp>>> getCampsPaginated({
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      Query query = _firestore
          .collection(_campsCollection)
          .orderBy('name')
          .limit(limit);

      if (lastDocumentId != null) {
        final lastDoc = await _firestore
            .collection(_campsCollection)
            .doc(lastDocumentId)
            .get();
        query = query.startAfterDocument(lastDoc);
      }

      final querySnapshot = await query.get();
      final camps = querySnapshot.docs
          .map((doc) => _campFromFirestore(doc))
          .toList();

      return DatabaseResult.success(camps);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden der Lager (paginiert)',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<List<Commander>>> getCommandersPaginated({
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      Query query = _firestore
          .collection(_commandersCollection)
          .orderBy('surname')
          .limit(limit);

      if (lastDocumentId != null) {
        final lastDoc = await _firestore
            .collection(_commandersCollection)
            .doc(lastDocumentId)
            .get();
        query = query.startAfterDocument(lastDoc);
      }

      final querySnapshot = await query.get();
      final commanders = querySnapshot.docs
          .map((doc) => _commanderFromFirestore(doc))
          .toList();

      return DatabaseResult.success(commanders);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden der Kommandanten (paginiert)',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // Statistik-Methoden
  @override
  Future<DatabaseResult<int>> getVictimsCount() async {
    try {
      final snapshot = await _firestore
          .collection(_victimsCollection)
          .count()
          .get();
      return DatabaseResult.success(snapshot.count);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Zählen der Opfer',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<int>> getCampsCount() async {
    try {
      final snapshot = await _firestore
          .collection(_campsCollection)
          .count()
          .get();
      return DatabaseResult.success(snapshot.count);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Zählen der Lager',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<int>> getCommandersCount() async {
    try {
      final snapshot = await _firestore
          .collection(_commandersCollection)
          .count()
          .get();
      return DatabaseResult.success(snapshot.count);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Zählen der Kommandanten',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // Batch-Operationen
  @override
  Future<DatabaseResult<void>> batchCreateVictims(List<Victim> victims) async {
    try {
      final batch = _firestore.batch();

      for (final victim in victims) {
        final docRef = _firestore
            .collection(_victimsCollection)
            .doc(victim.victim_id);
        batch.set(docRef, {
          ...victim.toJson(),
          'birth': victim.birth != null
              ? Timestamp.fromDate(victim.birth!)
              : null,
          'death': victim.death != null
              ? Timestamp.fromDate(victim.death!)
              : null,
          'env_date': victim.env_date != null
              ? Timestamp.fromDate(victim.env_date!)
              : null,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      return const DatabaseResult.success(null);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Batch-Erstellen der Opfer',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> batchUpdateVictims(List<Victim> victims) async {
    try {
      final batch = _firestore.batch();

      for (final victim in victims) {
        final docRef = _firestore
            .collection(_victimsCollection)
            .doc(victim.victim_id);
        batch.update(docRef, {
          ...victim.toJson(),
          'birth': victim.birth != null
              ? Timestamp.fromDate(victim.birth!)
              : null,
          'death': victim.death != null
              ? Timestamp.fromDate(victim.death!)
              : null,
          'env_date': victim.env_date != null
              ? Timestamp.fromDate(victim.env_date!)
              : null,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      return const DatabaseResult.success(null);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Batch-Aktualisieren der Opfer',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> batchDeleteVictims(List<String> ids) async {
    try {
      final batch = _firestore.batch();

      for (final id in ids) {
        final docRef = _firestore.collection(_victimsCollection).doc(id);
        batch.delete(docRef);
      }

      await batch.commit();
      return const DatabaseResult.success(null);
    } catch (e, stackTrace) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Batch-Löschen der Opfer',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // Helper Methods
  VictimImpl _victimFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VictimImpl(
      victim_id: doc.id, // Verwende Document ID als victim_id
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
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  ConcentrationCampImpl _campFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConcentrationCampImpl(
      camp_id: doc.id, // Verwende Document ID als camp_id
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
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  CommanderImpl _commanderFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommanderImpl(
      commander_id: doc.id, // Verwende Document ID als commander_id
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

  // Client-side Filtering Helper Methods
  bool _victimMatchesFilters(
    VictimImpl victim,
    String? nameQuery,
    String? locationQuery,
    String? yearQuery,
    String? eventQuery,
  ) {
    // Name filter
    if (nameQuery != null && nameQuery.trim().isNotEmpty) {
      final query = nameQuery.toLowerCase().trim();
      final nameMatch =
          victim.name.toLowerCase().contains(query) ||
          victim.surname.toLowerCase().contains(query);
      if (!nameMatch) return false;
    }

    // Location filter
    if (locationQuery != null && locationQuery.trim().isNotEmpty) {
      final query = locationQuery.toLowerCase().trim();
      bool locationMatch = false;

      if (victim.birthplace != null &&
          victim.birthplace!.toLowerCase().contains(query)) {
        locationMatch = true;
      }
      if (!locationMatch &&
          victim.deathplace != null &&
          victim.deathplace!.toLowerCase().contains(query)) {
        locationMatch = true;
      }
      if (!locationMatch && victim.c_camp.toLowerCase().contains(query)) {
        locationMatch = true;
      }

      if (!locationMatch) return false;
    }

    // Year filter
    if (yearQuery != null && yearQuery.trim().isNotEmpty) {
      final searchYear = int.tryParse(yearQuery.trim());
      if (searchYear != null) {
        bool yearMatch = false;

        if (victim.birth != null && victim.birth!.year == searchYear) {
          yearMatch = true;
        }
        if (!yearMatch &&
            victim.death != null &&
            victim.death!.year == searchYear) {
          yearMatch = true;
        }

        if (!yearMatch) return false;
      }
    }

    // Event filter
    if (eventQuery != null && eventQuery.trim().isNotEmpty) {
      final query = eventQuery.toLowerCase().trim();
      final eventMatch =
          victim.fate.toLowerCase().contains(query) ||
          victim.occupation.toLowerCase().contains(query) ||
          victim.religion.toLowerCase().contains(query);
      if (!eventMatch) return false;
    }

    return true;
  }

  bool _campMatchesFilters(
    ConcentrationCampImpl camp,
    String? nameQuery,
    String? locationQuery,
    String? yearQuery,
    String? eventQuery,
  ) {
    // Name filter
    if (nameQuery != null && nameQuery.trim().isNotEmpty) {
      final query = nameQuery.toLowerCase().trim();
      final nameMatch =
          camp.name.toLowerCase().contains(query) ||
          camp.commander.toLowerCase().contains(query);
      if (!nameMatch) return false;
    }

    // Location filter
    if (locationQuery != null && locationQuery.trim().isNotEmpty) {
      final query = locationQuery.toLowerCase().trim();
      final locationMatch =
          camp.location.toLowerCase().contains(query) ||
          camp.country.toLowerCase().contains(query) ||
          camp.name.toLowerCase().contains(query);
      if (!locationMatch) return false;
    }

    // Year filter
    if (yearQuery != null && yearQuery.trim().isNotEmpty) {
      final searchYear = int.tryParse(yearQuery.trim());
      if (searchYear != null) {
        bool yearMatch = false;

        if (camp.date_opened != null && camp.date_opened!.year == searchYear) {
          yearMatch = true;
        }
        if (!yearMatch &&
            camp.liberation_date != null &&
            camp.liberation_date!.year == searchYear) {
          yearMatch = true;
        }

        if (!yearMatch) return false;
      }
    }

    // Event filter
    if (eventQuery != null && eventQuery.trim().isNotEmpty) {
      final query = eventQuery.toLowerCase().trim();
      final eventMatch =
          camp.type.toLowerCase().contains(query) ||
          camp.description.toLowerCase().contains(query);
      if (!eventMatch) return false;
    }

    return true;
  }

  bool _commanderMatchesFilters(
    CommanderImpl commander,
    String? nameQuery,
    String? locationQuery,
    String? yearQuery,
    String? eventQuery,
  ) {
    // Name filter
    if (nameQuery != null && nameQuery.trim().isNotEmpty) {
      final query = nameQuery.toLowerCase().trim();
      final nameMatch =
          commander.name.toLowerCase().contains(query) ||
          commander.surname.toLowerCase().contains(query);
      if (!nameMatch) return false;
    }

    // Location filter
    if (locationQuery != null && locationQuery.trim().isNotEmpty) {
      final query = locationQuery.toLowerCase().trim();
      bool locationMatch = false;

      if (commander.birthplace != null &&
          commander.birthplace!.toLowerCase().contains(query)) {
        locationMatch = true;
      }
      if (!locationMatch &&
          commander.deathplace != null &&
          commander.deathplace!.toLowerCase().contains(query)) {
        locationMatch = true;
      }

      if (!locationMatch) return false;
    }

    // Year filter
    if (yearQuery != null && yearQuery.trim().isNotEmpty) {
      final searchYear = int.tryParse(yearQuery.trim());
      if (searchYear != null) {
        bool yearMatch = false;

        if (commander.birth != null && commander.birth!.year == searchYear) {
          yearMatch = true;
        }
        if (!yearMatch &&
            commander.death != null &&
            commander.death!.year == searchYear) {
          yearMatch = true;
        }

        if (!yearMatch) return false;
      }
    }

    // Event filter
    if (eventQuery != null && eventQuery.trim().isNotEmpty) {
      final query = eventQuery.toLowerCase().trim();
      final eventMatch =
          commander.rank.toLowerCase().contains(query) ||
          commander.description.toLowerCase().contains(query);
      if (!eventMatch) return false;
    }

    return true;
  }
}
