import 'profile.dart';

abstract class DatabaseRepository {
  // UserProfiles CRUD - Verwende DatabaseResult für besseres Error Handling
  Future<DatabaseResult<List<UserProfile>>> getUserProfiles();
  Future<DatabaseResult<UserProfile?>> getUserProfileById(String id);
  Future<DatabaseResult<void>> createUserProfile(UserProfile profile);
  Future<DatabaseResult<void>> updateUserProfile(UserProfile profile);
  Future<DatabaseResult<void>> deleteUserProfile(String id);

  // Victims CRUD
  Future<DatabaseResult<List<Victim>>> getVictims();
  Future<DatabaseResult<Victim?>> getVictimById(String id);
  Future<DatabaseResult<void>> createVictim(Victim victim);
  Future<DatabaseResult<void>> updateVictim(Victim victim);
  Future<DatabaseResult<void>> deleteVictim(String id);

  // ConcentrationCamps CRUD
  Future<DatabaseResult<List<ConcentrationCamp>>> getConcentrationCamps();
  Future<DatabaseResult<ConcentrationCamp?>> getConcentrationCampById(
    String id,
  );
  Future<DatabaseResult<void>> createConcentrationCamp(ConcentrationCamp camp);
  Future<DatabaseResult<void>> updateConcentrationCamp(ConcentrationCamp camp);
  Future<DatabaseResult<void>> deleteConcentrationCamp(String id);

  // Commanders CRUD
  Future<DatabaseResult<List<Commander>>> getCommanders();
  Future<DatabaseResult<Commander?>> getCommanderById(String id);
  Future<DatabaseResult<void>> createCommander(Commander commander);
  Future<DatabaseResult<void>> updateCommander(Commander commander);
  Future<DatabaseResult<void>> deleteCommander(String id);

  // Erweiterte Such- und Query-Methoden
  Future<DatabaseResult<List<SearchResult>>> search({
    String? nameQuery,
    String? locationQuery,
    String? yearQuery,
    String? eventQuery,
    int? limit,
    String? lastDocumentId,
  });

  // Paginierte Abfragen für bessere Performance
  Future<DatabaseResult<List<Victim>>> getVictimsPaginated({
    int limit = 20,
    String? lastDocumentId,
  });

  Future<DatabaseResult<List<ConcentrationCamp>>> getCampsPaginated({
    int limit = 20,
    String? lastDocumentId,
  });

  Future<DatabaseResult<List<Commander>>> getCommandersPaginated({
    int limit = 20,
    String? lastDocumentId,
  });

  // Statistik-Methoden für Dashboard
  Future<DatabaseResult<int>> getVictimsCount();
  Future<DatabaseResult<int>> getCampsCount();
  Future<DatabaseResult<int>> getCommandersCount();

  // Batch-Operationen für bessere Performance bei mehreren Updates
  Future<DatabaseResult<void>> batchCreateVictims(List<Victim> victims);
  Future<DatabaseResult<void>> batchUpdateVictims(List<Victim> victims);
  Future<DatabaseResult<void>> batchDeleteVictims(List<String> ids);
}
