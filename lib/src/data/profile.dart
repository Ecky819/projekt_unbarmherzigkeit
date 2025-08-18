abstract class UserProfile {
  int id = 0;
  String name = '';
  String surname = '';
  String email = '';
  String password = '';
}

abstract class Victim {
  int victim_id = 0;
  String surname = '';
  String name = '';
  int? prisoner_number;
  DateTime? birth;
  String? birthplace;
  DateTime? death;
  String? deathplace;
  String nationality = '';
  String religion = '';
  String occupation = '';
  bool death_certificate = false;
  DateTime? env_date;
  String c_camp = '';
  String fate = '';
  String? imagePath; // Neues Feld für Bildpfad
  String? imageDescription; // Bildbeschreibung
  String? imageSource; // Quellenangabe
}

abstract class ConcentrationCamp {
  int camp_id = 0;
  String name = '';
  String location = '';
  String country = '';
  String description = '';
  DateTime? date_opened;
  DateTime? liberation_date;
  String type = '';
  String commander = '';
  String? imagePath; // Neues Feld für Bildpfad
  String? imageDescription; // Bildbeschreibung
  String? imageSource; // Quellenangabe
}

abstract class Commander {
  int commander_id = 0;
  String name = '';
  String surname = '';
  String rank = '';
  DateTime? birth;
  String? birthplace;
  DateTime? death;
  String? deathplace;
  String description = '';
  String? imagePath; // Neues Feld für Bildpfad
  String? imageDescription; // Bildbeschreibung
  String? imageSource; // Quellenangabe
}
