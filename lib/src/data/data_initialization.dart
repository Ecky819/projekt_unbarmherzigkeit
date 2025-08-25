import 'profile.dart';
import 'MockDatabaseRepository.dart';

// Konkrete Implementierungen der abstrakten Klassen
class UserProfileImpl extends UserProfile {
  UserProfileImpl({
    required int id,
    required String name,
    required String surname,
    required String email,
    required String password,
  }) {
    this.id = id;
    this.name = name;
    this.surname = surname;
    this.email = email;
    this.password = password;
  }
}

class VictimImpl extends Victim {
  VictimImpl({
    required int victim_id,
    required String surname,
    required String name,
    int? prisoner_number,
    DateTime? birth,
    String? birthplace,
    DateTime? death,
    String? deathplace,
    required String nationality,
    required String religion,
    required String occupation,
    required bool death_certificate,
    DateTime? env_date,
    required String c_camp,
    required String fate,
    String? imagePath,
    String? imageDescription,
    String? imageSource,
  }) {
    this.victim_id = victim_id;
    this.surname = surname;
    this.name = name;
    this.prisoner_number = prisoner_number;
    this.birth = birth;
    this.birthplace = birthplace;
    this.death = death;
    this.deathplace = deathplace;
    this.nationality = nationality;
    this.religion = religion;
    this.occupation = occupation;
    this.death_certificate = death_certificate;
    this.env_date = env_date;
    this.c_camp = c_camp;
    this.fate = fate;
    this.imagePath = imagePath;
    this.imageDescription = imageDescription;
    this.imageSource = imageSource;
  }
}

class ConcentrationCampImpl extends ConcentrationCamp {
  ConcentrationCampImpl({
    required int camp_id,
    required String name,
    required String location,
    required String country,
    required String description,
    DateTime? date_opened,
    DateTime? liberation_date,
    required String type,
    required String commander,
    String? imagePath,
    String? imageDescription,
    String? imageSource,
  }) {
    this.camp_id = camp_id;
    this.name = name;
    this.location = location;
    this.country = country;
    this.description = description;
    this.date_opened = date_opened;
    this.liberation_date = liberation_date;
    this.type = type;
    this.commander = commander;
    this.imagePath = imagePath;
    this.imageDescription = imageDescription;
    this.imageSource = imageSource;
  }
}

class CommanderImpl extends Commander {
  CommanderImpl({
    required int commander_id,
    required String name,
    required String surname,
    required String rank,
    DateTime? birth,
    String? birthplace,
    DateTime? death,
    String? deathplace,
    required String description,
    String? imagePath,
    String? imageDescription,
    String? imageSource,
  }) {
    this.commander_id = commander_id;
    this.name = name;
    this.surname = surname;
    this.rank = rank;
    this.birth = birth;
    this.birthplace = birthplace;
    this.death = death;
    this.deathplace = deathplace;
    this.description = description;
    this.imagePath = imagePath;
    this.imageDescription = imageDescription;
    this.imageSource = imageSource;
  }
}

/// Dateninitialisierung - NUR für Mock-Repository verwenden
///
/// WICHTIG: Diese Funktion sollte NUR für Tests und Development verwendet werden.
/// In der Produktion werden alle Daten über das Admin Dashboard verwaltet.
///
/// Die Migration zu Firestore ist bereits erfolgt und das Admin-System ist aktiv.
Future<MockDatabaseRepository> initializeMockData() async {
  final repository = MockDatabaseRepository();

  print('╔════════════════════════════════════════════════════════════════╗');
  print('║                        WARNUNG                                 ║');
  print('╠════════════════════════════════════════════════════════════════╣');
  print('║ initializeMockData() wird nur für Tests verwendet.            ║');
  print('║ Produktive Daten werden über das Admin Dashboard verwaltet.   ║');
  print('║ Migration zu Firestore ist bereits abgeschlossen.             ║');
  print('╚════════════════════════════════════════════════════════════════╝');

  // Nur minimale Test-Daten für Mock-Repository erstellen
  await _createMinimalTestData(repository);

  return repository;
}

/// Erstellt minimale Test-Daten für das Mock-Repository
/// Diese Daten sind nur für Entwicklung und Tests gedacht
Future<void> _createMinimalTestData(MockDatabaseRepository repository) async {
  print('Erstelle minimale Test-Daten für Mock-Repository...');

  // Ein Test-Opfer
  await repository.createVictim(
    VictimImpl(
      victim_id: 1,
      surname: 'Test',
      name: 'Opfer',
      birth: DateTime(1920, 1, 1),
      birthplace: 'Test-Stadt',
      death: DateTime(1944, 1, 1),
      deathplace: 'Test-Lager',
      nationality: 'Test-Nationalität',
      religion: 'Test-Religion',
      occupation: 'Test-Beruf',
      death_certificate: true,
      c_camp: 'Test-Lager',
      fate: 'Test-Schicksal',
      imagePath: 'assets/images/victims/test.jpg',
      imageDescription: 'Test-Bildbeschreibung',
      imageSource: 'Test-Bildquelle',
    ),
  );

  // Ein Test-Lager
  await repository.createConcentrationCamp(
    ConcentrationCampImpl(
      camp_id: 1,
      name: 'Test-Lager',
      location: 'Test-Ort',
      country: 'Test-Land',
      description: 'Test-Beschreibung für Entwicklungszwecke',
      date_opened: DateTime(1940, 1, 1),
      liberation_date: DateTime(1945, 1, 1),
      type: 'Test-Typ',
      commander: 'Test-Kommandant',
      imagePath: 'assets/images/camps/test.jpg',
      imageDescription: 'Test-Bildbeschreibung',
      imageSource: 'Test-Bildquelle',
    ),
  );

  // Ein Test-Kommandant
  await repository.createCommander(
    CommanderImpl(
      commander_id: 1,
      name: 'Test',
      surname: 'Kommandant',
      rank: 'Test-Rang',
      birth: DateTime(1900, 1, 1),
      birthplace: 'Test-Geburtsort',
      death: DateTime(1946, 1, 1),
      deathplace: 'Test-Sterbeort',
      description: 'Test-Beschreibung für Entwicklungszwecke',
      imagePath: 'assets/images/commanders/test.jpg',
      imageDescription: 'Test-Bildbeschreibung',
      imageSource: 'Test-Bildquelle',
    ),
  );

  print('✓ Minimale Test-Daten erstellt (1 Opfer, 1 Lager, 1 Kommandant)');
}

/// Factory-Methoden für einfache Erstellung von Objekten

/// Erstellt ein neues Victim-Objekt mit den gegebenen Parametern
VictimImpl createVictim({
  required int victimId,
  required String surname,
  required String name,
  int? prisonerNumber,
  DateTime? birth,
  String? birthplace,
  DateTime? death,
  String? deathplace,
  required String nationality,
  required String religion,
  required String occupation,
  bool deathCertificate = false,
  DateTime? envDate,
  required String cCamp,
  required String fate,
  String? imagePath,
  String? imageDescription,
  String? imageSource,
}) {
  return VictimImpl(
    victim_id: victimId,
    surname: surname,
    name: name,
    prisoner_number: prisonerNumber,
    birth: birth,
    birthplace: birthplace,
    death: death,
    deathplace: deathplace,
    nationality: nationality,
    religion: religion,
    occupation: occupation,
    death_certificate: deathCertificate,
    env_date: envDate,
    c_camp: cCamp,
    fate: fate,
    imagePath: imagePath,
    imageDescription: imageDescription,
    imageSource: imageSource,
  );
}

/// Erstellt ein neues ConcentrationCamp-Objekt mit den gegebenen Parametern
ConcentrationCampImpl createConcentrationCamp({
  required int campId,
  required String name,
  required String location,
  required String country,
  required String description,
  DateTime? dateOpened,
  DateTime? liberationDate,
  required String type,
  required String commander,
  String? imagePath,
  String? imageDescription,
  String? imageSource,
}) {
  return ConcentrationCampImpl(
    camp_id: campId,
    name: name,
    location: location,
    country: country,
    description: description,
    date_opened: dateOpened,
    liberation_date: liberationDate,
    type: type,
    commander: commander,
    imagePath: imagePath,
    imageDescription: imageDescription,
    imageSource: imageSource,
  );
}

/// Erstellt ein neues Commander-Objekt mit den gegebenen Parametern
CommanderImpl createCommander({
  required int commanderId,
  required String name,
  required String surname,
  required String rank,
  DateTime? birth,
  String? birthplace,
  DateTime? death,
  String? deathplace,
  required String description,
  String? imagePath,
  String? imageDescription,
  String? imageSource,
}) {
  return CommanderImpl(
    commander_id: commanderId,
    name: name,
    surname: surname,
    rank: rank,
    birth: birth,
    birthplace: birthplace,
    death: death,
    deathplace: deathplace,
    description: description,
    imagePath: imagePath,
    imageDescription: imageDescription,
    imageSource: imageSource,
  );
}

/// Utility-Funktionen für Admin-Dashboard

/// Validiert Victim-Daten vor dem Speichern
String? validateVictimData(VictimImpl victim) {
  if (victim.surname.trim().isEmpty) return 'Nachname ist erforderlich';
  if (victim.name.trim().isEmpty) return 'Vorname ist erforderlich';
  if (victim.nationality.trim().isEmpty) return 'Nationalität ist erforderlich';
  if (victim.religion.trim().isEmpty) return 'Religion ist erforderlich';
  if (victim.occupation.trim().isEmpty) return 'Beruf ist erforderlich';
  if (victim.c_camp.trim().isEmpty) {
    return 'Konzentrationslager ist erforderlich';
  }
  if (victim.fate.trim().isEmpty) return 'Schicksal ist erforderlich';

  // Datum-Validierung
  if (victim.birth != null && victim.death != null) {
    if (victim.birth!.isAfter(victim.death!)) {
      return 'Geburtsdatum kann nicht nach Sterbedatum liegen';
    }
  }

  return null; // Alle Validierungen bestanden
}

/// Validiert ConcentrationCamp-Daten vor dem Speichern
String? validateCampData(ConcentrationCampImpl camp) {
  if (camp.name.trim().isEmpty) return 'Name ist erforderlich';
  if (camp.location.trim().isEmpty) return 'Ort ist erforderlich';
  if (camp.country.trim().isEmpty) return 'Land ist erforderlich';
  if (camp.description.trim().isEmpty) return 'Beschreibung ist erforderlich';
  if (camp.type.trim().isEmpty) return 'Typ ist erforderlich';
  if (camp.commander.trim().isEmpty) return 'Kommandant ist erforderlich';

  // Datum-Validierung
  if (camp.date_opened != null && camp.liberation_date != null) {
    if (camp.date_opened!.isAfter(camp.liberation_date!)) {
      return 'Eröffnungsdatum kann nicht nach Befreiungsdatum liegen';
    }
  }

  return null; // Alle Validierungen bestanden
}

/// Validiert Commander-Daten vor dem Speichern
String? validateCommanderData(CommanderImpl commander) {
  if (commander.name.trim().isEmpty) return 'Vorname ist erforderlich';
  if (commander.surname.trim().isEmpty) return 'Nachname ist erforderlich';
  if (commander.rank.trim().isEmpty) return 'Rang ist erforderlich';
  if (commander.description.trim().isEmpty) {
    return 'Beschreibung ist erforderlich';
  }

  // Datum-Validierung
  if (commander.birth != null && commander.death != null) {
    if (commander.birth!.isAfter(commander.death!)) {
      return 'Geburtsdatum kann nicht nach Sterbedatum liegen';
    }
  }

  return null; // Alle Validierungen bestanden
}

/// Formatiert ein Datum für die Anzeige
String formatDateForDisplay(DateTime? date) {
  if (date == null) return 'Unbekannt';
  return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
}

/// Berechnet das Alter zum Zeitpunkt des Todes oder heute
int? calculateAge(DateTime? birth, DateTime? death) {
  if (birth == null) return null;

  final endDate = death ?? DateTime.now();
  int age = endDate.year - birth.year;

  if (endDate.month < birth.month ||
      (endDate.month == birth.month && endDate.day < birth.day)) {
    age--;
  }

  return age;
}

/// Generiert eine Zusammenfassung für ein Opfer
String generateVictimSummary(VictimImpl victim) {
  final age = calculateAge(victim.birth, victim.death);
  final ageText = age != null ? ' ($age Jahre)' : '';

  return '${victim.surname}, ${victim.name}$ageText - ${victim.nationality}, ${victim.religion}, ${victim.occupation}';
}

/// Debug-Informationen für Entwicklung
void printDebugInfo() {
  print('\n🔧 DEBUG INFORMATIONEN:');
  print('- Data Initialization ist für Mock-Repository konfiguriert');
  print('- Produktive Daten werden über Admin Dashboard verwaltet');
  print('- Firestore Repository ist der primäre Datenspeicher');
  print('- Migration wurde bereits durchgeführt');
  print('- Admin User: marcoeggert73@gmail.com');
  print('');
}
