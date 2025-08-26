import 'profile.dart';

abstract class DatabaseRepository {
  // UserProfiles CRUD
  Future<List<UserProfile>> getUserProfiles();
  Future<UserProfile?> getUserProfileById(String id);
  Future<void> createUserProfile(UserProfile profile);
  Future<void> updateUserProfile(UserProfile profile);
  Future<void> deleteUserProfile(String id);

  // Victims CRUD
  Future<List<Victim>> getVictims();
  Future<Victim?> getVictimById(String id);
  Future<void> createVictim(Victim victim);
  Future<void> updateVictim(Victim victim);
  Future<void> deleteVictim(String id);

  // ConcentrationCamps CRUD
  Future<List<ConcentrationCamp>> getConcentrationCamps();
  Future<ConcentrationCamp?> getConcentrationCampById(String id);
  Future<void> createConcentrationCamp(ConcentrationCamp camp);
  Future<void> updateConcentrationCamp(ConcentrationCamp camp);
  Future<void> deleteConcentrationCamp(String id);

  // Commanders CRUD
  Future<List<Commander>> getCommanders();
  Future<Commander?> getCommanderById(String id);
  Future<void> createCommander(Commander commander);
  Future<void> updateCommander(Commander commander);
  Future<void> deleteCommander(String id);
}
