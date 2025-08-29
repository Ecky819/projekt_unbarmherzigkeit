import 'dart:async';
import 'profile.dart';
import 'database_repository.dart';

class MockDatabaseRepository implements DatabaseRepository {
  final List<UserProfile> _userProfiles = [];
  final List<Victim> _victims = [];
  final List<ConcentrationCamp> _concentrationCamps = [];
  final List<Commander> _commanders = [];

  @override
  Future<DatabaseResult<List<UserProfile>>> getUserProfiles() async {
    try {
      // Simuliere Netzwerk-Delay für realistische Bedingungen
      await Future.delayed(const Duration(milliseconds: 100));
      return DatabaseResult.success(List.from(_userProfiles));
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden der Benutzerprofile',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<UserProfile?>> getUserProfileById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));

      final profile = _userProfiles.cast<UserProfile?>().firstWhere(
        (profile) => profile?.id == id,
        orElse: () => null,
      );

      return DatabaseResult.success(profile);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden des Benutzerprofils',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> createUserProfile(UserProfile profile) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      // Prüfe ob ID bereits existiert
      final existingIndex = _userProfiles.indexWhere((p) => p.id == profile.id);
      if (existingIndex != -1) {
        return DatabaseResult.failure(
          DatabaseException(
            'Benutzerprofil mit ID ${profile.id} existiert bereits',
            code: 'DUPLICATE_ID',
          ),
        );
      }

      _userProfiles.add(profile);
      return const DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Erstellen des Benutzerprofils',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> updateUserProfile(UserProfile profile) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final index = _userProfiles.indexWhere((p) => p.id == profile.id);
      if (index == -1) {
        return DatabaseResult.failure(
          DatabaseException(
            'Benutzerprofil mit ID ${profile.id} nicht gefunden',
            code: 'NOT_FOUND',
          ),
        );
      }

      _userProfiles[index] = profile;
      return const DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Aktualisieren des Benutzerprofils',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> deleteUserProfile(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final beforeLength = _userProfiles.length;
      _userProfiles.removeWhere((profile) => profile.id == id);
      final afterLength = _userProfiles.length;
      if (beforeLength == afterLength) {
        return DatabaseResult.failure(
          DatabaseException(
            'Benutzerprofil mit ID $id nicht gefunden',
            code: 'NOT_FOUND',
          ),
        );
      }

      return const DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Löschen des Benutzerprofils',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<List<Victim>>> getVictims() async {
    try {
      await Future.delayed(const Duration(milliseconds: 150));
      return DatabaseResult.success(List.from(_victims));
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException('Fehler beim Laden der Opfer', originalError: e),
      );
    }
  }

  @override
  Future<DatabaseResult<Victim?>> getVictimById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));

      final victim = _victims.cast<Victim?>().firstWhere(
        (victim) => victim?.victim_id == id,
        orElse: () => null,
      );

      return DatabaseResult.success(victim);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException('Fehler beim Laden des Opfers', originalError: e),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> createVictim(Victim victim) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      // Prüfe ob ID bereits existiert
      final existingIndex = _victims.indexWhere(
        (v) => v.victim_id == victim.victim_id,
      );
      if (existingIndex != -1) {
        return DatabaseResult.failure(
          DatabaseException(
            'Opfer mit ID ${victim.victim_id} existiert bereits',
            code: 'DUPLICATE_ID',
          ),
        );
      }

      _victims.add(victim);
      return const DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException('Fehler beim Erstellen des Opfers', originalError: e),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> updateVictim(Victim victim) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final index = _victims.indexWhere((v) => v.victim_id == victim.victim_id);
      if (index == -1) {
        return DatabaseResult.failure(
          DatabaseException(
            'Opfer mit ID ${victim.victim_id} nicht gefunden',
            code: 'NOT_FOUND',
          ),
        );
      }

      _victims[index] = victim;
      return const DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Aktualisieren des Opfers',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> deleteVictim(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final beforeLength = _victims.length;
      _victims.removeWhere((victim) => victim.victim_id == id);
      final afterLength = _victims.length;
      if (beforeLength == afterLength) {
        return DatabaseResult.failure(
          DatabaseException(
            'Opfer mit ID $id nicht gefunden',
            code: 'NOT_FOUND',
          ),
        );
      }

      return const DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException('Fehler beim Löschen des Opfers', originalError: e),
      );
    }
  }

  @override
  Future<DatabaseResult<List<ConcentrationCamp>>>
  getConcentrationCamps() async {
    try {
      await Future.delayed(const Duration(milliseconds: 150));
      return DatabaseResult.success(List.from(_concentrationCamps));
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException('Fehler beim Laden der Lager', originalError: e),
      );
    }
  }

  @override
  Future<DatabaseResult<ConcentrationCamp?>> getConcentrationCampById(
    String id,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));

      final camp = _concentrationCamps.cast<ConcentrationCamp?>().firstWhere(
        (camp) => camp?.camp_id == id,
        orElse: () => null,
      );

      return DatabaseResult.success(camp);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException('Fehler beim Laden des Lagers', originalError: e),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> createConcentrationCamp(
    ConcentrationCamp camp,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      // Prüfe ob ID bereits existiert
      final existingIndex = _concentrationCamps.indexWhere(
        (c) => c.camp_id == camp.camp_id,
      );
      if (existingIndex != -1) {
        return DatabaseResult.failure(
          DatabaseException(
            'Lager mit ID ${camp.camp_id} existiert bereits',
            code: 'DUPLICATE_ID',
          ),
        );
      }

      _concentrationCamps.add(camp);
      return const DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException('Fehler beim Erstellen des Lagers', originalError: e),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> updateConcentrationCamp(
    ConcentrationCamp camp,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final index = _concentrationCamps.indexWhere(
        (c) => c.camp_id == camp.camp_id,
      );
      if (index == -1) {
        return DatabaseResult.failure(
          DatabaseException(
            'Lager mit ID ${camp.camp_id} nicht gefunden',
            code: 'NOT_FOUND',
          ),
        );
      }

      _concentrationCamps[index] = camp;
      return const DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Aktualisieren des Lagers',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> deleteConcentrationCamp(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final beforeLength = _concentrationCamps.length;
      _concentrationCamps.removeWhere((camp) => camp.camp_id == id);
      final afterLength = _concentrationCamps.length;
      if (beforeLength == afterLength) {
        return DatabaseResult.failure(
          DatabaseException(
            'Lager mit ID $id nicht gefunden',
            code: 'NOT_FOUND',
          ),
        );
      }

      return const DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException('Fehler beim Löschen des Lagers', originalError: e),
      );
    }
  }

  @override
  Future<DatabaseResult<List<Commander>>> getCommanders() async {
    try {
      await Future.delayed(const Duration(milliseconds: 150));
      return DatabaseResult.success(List.from(_commanders));
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden der Kommandanten',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<Commander?>> getCommanderById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));

      final commander = _commanders.cast<Commander?>().firstWhere(
        (commander) => commander?.commander_id == id,
        orElse: () => null,
      );

      return DatabaseResult.success(commander);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden des Kommandanten',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> createCommander(Commander commander) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      // Prüfe ob ID bereits existiert
      final existingIndex = _commanders.indexWhere(
        (c) => c.commander_id == commander.commander_id,
      );
      if (existingIndex != -1) {
        return DatabaseResult.failure(
          DatabaseException(
            'Kommandant mit ID ${commander.commander_id} existiert bereits',
            code: 'DUPLICATE_ID',
          ),
        );
      }

      _commanders.add(commander);
      return const DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Erstellen des Kommandanten',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> updateCommander(Commander commander) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final index = _commanders.indexWhere(
        (c) => c.commander_id == commander.commander_id,
      );
      if (index == -1) {
        return DatabaseResult.failure(
          DatabaseException(
            'Kommandant mit ID ${commander.commander_id} nicht gefunden',
            code: 'NOT_FOUND',
          ),
        );
      }

      _commanders[index] = commander;
      return const DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Aktualisieren des Kommandanten',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> deleteCommander(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final beforeLength = _commanders.length;
      _commanders.removeWhere((commander) => commander.commander_id == id);
      final afterLength = _commanders.length;
      if (beforeLength == afterLength) {
        return DatabaseResult.failure(
          DatabaseException(
            'Kommandant mit ID $id nicht gefunden',
            code: 'NOT_FOUND',
          ),
        );
      }

      return const DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Löschen des Kommandanten',
          originalError: e,
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
      await Future.delayed(const Duration(milliseconds: 200));

      final results = <SearchResult>[];

      // Durchsuche Victims
      for (final victim in _victims) {
        if (_matchesSearchCriteria(
          item: victim,
          nameQuery: nameQuery,
          locationQuery: locationQuery,
          yearQuery: yearQuery,
          eventQuery: eventQuery,
        )) {
          results.add(SearchResult.fromVictim(victim));
        }
      }

      // Durchsuche Camps
      for (final camp in _concentrationCamps) {
        if (_matchesSearchCriteria(
          item: camp,
          nameQuery: nameQuery,
          locationQuery: locationQuery,
          yearQuery: yearQuery,
          eventQuery: eventQuery,
        )) {
          results.add(SearchResult.fromCamp(camp));
        }
      }

      // Durchsuche Commanders
      for (final commander in _commanders) {
        if (_matchesSearchCriteria(
          item: commander,
          nameQuery: nameQuery,
          locationQuery: locationQuery,
          yearQuery: yearQuery,
          eventQuery: eventQuery,
        )) {
          results.add(SearchResult.fromCommander(commander));
        }
      }

      // Begrenze Ergebnisse wenn limit gesetzt
      if (limit != null && results.length > limit) {
        return DatabaseResult.success(results.take(limit).toList());
      }

      return DatabaseResult.success(results);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException('Fehler bei der Suche', originalError: e),
      );
    }
  }

  bool _matchesSearchCriteria({
    required dynamic item,
    String? nameQuery,
    String? locationQuery,
    String? yearQuery,
    String? eventQuery,
  }) {
    // Name-Filter
    if (nameQuery != null && nameQuery.trim().isNotEmpty) {
      final query = nameQuery.toLowerCase().trim();
      bool nameMatch = false;

      if (item is Victim) {
        nameMatch =
            item.name.toLowerCase().contains(query) ||
            item.surname.toLowerCase().contains(query);
      } else if (item is Commander) {
        nameMatch =
            item.name.toLowerCase().contains(query) ||
            item.surname.toLowerCase().contains(query);
      } else if (item is ConcentrationCamp) {
        nameMatch =
            item.name.toLowerCase().contains(query) ||
            item.commander.toLowerCase().contains(query);
      }

      if (!nameMatch) return false;
    }

    // Ort-Filter
    if (locationQuery != null && locationQuery.trim().isNotEmpty) {
      final query = locationQuery.toLowerCase().trim();
      bool locationMatch = false;

      if (item is ConcentrationCamp) {
        locationMatch =
            item.location.toLowerCase().contains(query) ||
            item.country.toLowerCase().contains(query) ||
            item.name.toLowerCase().contains(query);
      } else if (item is Victim) {
        if (item.birthplace != null) {
          locationMatch = item.birthplace!.toLowerCase().contains(query);
        }
        if (!locationMatch && item.deathplace != null) {
          locationMatch = item.deathplace!.toLowerCase().contains(query);
        }
        if (!locationMatch && item.c_camp.isNotEmpty) {
          locationMatch = item.c_camp.toLowerCase().contains(query);
        }
      } else if (item is Commander) {
        if (item.birthplace != null) {
          locationMatch = item.birthplace!.toLowerCase().contains(query);
        }
        if (!locationMatch && item.deathplace != null) {
          locationMatch = item.deathplace!.toLowerCase().contains(query);
        }
      }

      if (!locationMatch) return false;
    }

    // Jahr-Filter
    if (yearQuery != null && yearQuery.trim().isNotEmpty) {
      final searchYear = int.tryParse(yearQuery.trim());
      if (searchYear != null) {
        bool yearMatch = false;

        if (item is Victim) {
          if (item.birth != null && item.birth!.year == searchYear) {
            yearMatch = true;
          }
          if (!yearMatch &&
              item.death != null &&
              item.death!.year == searchYear) {
            yearMatch = true;
          }
        } else if (item is ConcentrationCamp) {
          if (item.date_opened != null &&
              item.date_opened!.year == searchYear) {
            yearMatch = true;
          }
          if (!yearMatch &&
              item.liberation_date != null &&
              item.liberation_date!.year == searchYear) {
            yearMatch = true;
          }
        } else if (item is Commander) {
          if (item.birth != null && item.birth!.year == searchYear) {
            yearMatch = true;
          }
          if (!yearMatch &&
              item.death != null &&
              item.death!.year == searchYear) {
            yearMatch = true;
          }
        }

        if (!yearMatch) return false;
      }
    }

    // Ereignis-Filter
    if (eventQuery != null && eventQuery.trim().isNotEmpty) {
      final query = eventQuery.toLowerCase().trim();
      bool eventMatch = false;

      if (item is ConcentrationCamp) {
        eventMatch =
            item.type.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query);
      } else if (item is Victim) {
        eventMatch =
            item.fate.toLowerCase().contains(query) ||
            item.occupation.toLowerCase().contains(query) ||
            item.religion.toLowerCase().contains(query);
      } else if (item is Commander) {
        eventMatch =
            item.rank.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query);
      }

      if (!eventMatch) return false;
    }

    return true;
  }

  // Paginierte Abfragen
  @override
  Future<DatabaseResult<List<Victim>>> getVictimsPaginated({
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      // Simuliere Paginierung
      var victims = List.from(_victims);
      if (lastDocumentId != null) {
        final lastIndex = victims.indexWhere(
          (v) => v.victim_id == lastDocumentId,
        );
        if (lastIndex != -1) {
          victims = victims.skip(lastIndex + 1).toList();
        }
      }

      return DatabaseResult.success(
        victims.take(limit).toList().cast<Victim>(),
      );
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden der Opfer (paginiert)',
          originalError: e,
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
      await Future.delayed(const Duration(milliseconds: 100));

      var camps = List.from(_concentrationCamps);
      if (lastDocumentId != null) {
        final lastIndex = camps.indexWhere((c) => c.camp_id == lastDocumentId);
        if (lastIndex != -1) {
          camps = camps.skip(lastIndex + 1).toList();
        }
      }

      return DatabaseResult.success(
        camps.take(limit).toList().cast<ConcentrationCamp>(),
      );
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden der Lager (paginiert)',
          originalError: e,
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
      await Future.delayed(const Duration(milliseconds: 100));

      var commanders = List.from(_commanders);
      if (lastDocumentId != null) {
        final lastIndex = commanders.indexWhere(
          (c) => c.commander_id == lastDocumentId,
        );
        if (lastIndex != -1) {
          commanders = commanders.skip(lastIndex + 1).toList();
        }
      }

      return DatabaseResult.success(
        commanders.take(limit).toList().cast<Commander>(),
      );
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Laden der Kommandanten (paginiert)',
          originalError: e,
        ),
      );
    }
  }

  // Statistik-Methoden
  @override
  Future<DatabaseResult<int>> getVictimsCount() async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));
      return DatabaseResult.success(_victims.length);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException('Fehler beim Zählen der Opfer', originalError: e),
      );
    }
  }

  @override
  Future<DatabaseResult<int>> getCampsCount() async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));
      return DatabaseResult.success(_concentrationCamps.length);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException('Fehler beim Zählen der Lager', originalError: e),
      );
    }
  }

  @override
  Future<DatabaseResult<int>> getCommandersCount() async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));
      return DatabaseResult.success(_commanders.length);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Zählen der Kommandanten',
          originalError: e,
        ),
      );
    }
  }

  // Batch-Operationen
  @override
  Future<DatabaseResult<void>> batchCreateVictims(List<Victim> victims) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      // Prüfe auf doppelte IDs
      for (final victim in victims) {
        final existingIndex = _victims.indexWhere(
          (v) => v.victim_id == victim.victim_id,
        );
        if (existingIndex != -1) {
          return DatabaseResult.failure(
            DatabaseException(
              'Opfer mit ID ${victim.victim_id} existiert bereits',
              code: 'DUPLICATE_ID',
            ),
          );
        }
      }

      _victims.addAll(victims);
      return const DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Batch-Erstellen der Opfer',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> batchUpdateVictims(List<Victim> victims) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      for (final victim in victims) {
        final index = _victims.indexWhere(
          (v) => v.victim_id == victim.victim_id,
        );
        if (index == -1) {
          return DatabaseResult.failure(
            DatabaseException(
              'Opfer mit ID ${victim.victim_id} nicht gefunden',
              code: 'NOT_FOUND',
            ),
          );
        }
        _victims[index] = victim;
      }

      return const DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Batch-Aktualisieren der Opfer',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<DatabaseResult<void>> batchDeleteVictims(List<String> ids) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      int removedCount = 0;
      for (final id in ids) {
        final beforeLength = _victims.length;
        _victims.removeWhere((victim) => victim.victim_id == id);
        final afterLength = _victims.length;
        removedCount += (beforeLength - afterLength);
      }

      if (removedCount != ids.length) {
        return const DatabaseResult.failure(
          DatabaseException(
            'Nicht alle Opfer konnten gelöscht werden',
            code: 'PARTIAL_DELETE',
          ),
        );
      }

      return const DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.failure(
        DatabaseException(
          'Fehler beim Batch-Löschen der Opfer',
          originalError: e,
        ),
      );
    }
  }
}
