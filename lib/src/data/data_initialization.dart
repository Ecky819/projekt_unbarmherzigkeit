import 'profile.dart';
import 'mockdatabase_repository.dart';

// Konkrete Implementierungen der abstrakten Klassen
class UserProfileImpl extends UserProfile {
  UserProfileImpl({
    required String id,
    required String name,
    required String surname,
    required String email,
    required String password,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    this.id = id;
    this.name = name;
    this.surname = surname;
    this.email = email;
    this.password = password;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }

  // Factory constructor für Firestore Document
  factory UserProfileImpl.fromJson(Map<String, dynamic> json) {
    return UserProfileImpl(
      id: json['id']?.toString() ?? '0',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      email: json['email'] ?? '',
      password: '', // Passwort aus Sicherheitsgründen nicht laden
      createdAt: json['createdAt']?.toDate(),
      updatedAt: json['updatedAt']?.toDate(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  UserProfile copyWith({
    String? name,
    String? surname,
    String? email,
    String? password,
  }) {
    return UserProfileImpl(
      id: id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class VictimImpl extends Victim {
  VictimImpl({
    required String victim_id,
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
    DateTime? createdAt,
    DateTime? updatedAt,
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
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }

  // Factory constructor für Firestore Document
  factory VictimImpl.fromJson(Map<String, dynamic> json) {
    return VictimImpl(
      victim_id: json['victim_id']?.toString() ?? '0',
      surname: json['surname'] ?? '',
      name: json['name'] ?? '',
      prisoner_number: json['prisoner_number'],
      birth: json['birth']?.toDate(),
      birthplace: json['birthplace'],
      death: json['death']?.toDate(),
      deathplace: json['deathplace'],
      nationality: json['nationality'] ?? '',
      religion: json['religion'] ?? '',
      occupation: json['occupation'] ?? '',
      death_certificate: json['death_certificate'] ?? false,
      env_date: json['env_date']?.toDate(),
      c_camp: json['c_camp'] ?? '',
      fate: json['fate'] ?? '',
      imagePath: json['imagePath'],
      imageDescription: json['imageDescription'],
      imageSource: json['imageSource'],
      createdAt: json['createdAt']?.toDate(),
      updatedAt: json['updatedAt']?.toDate(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'victim_id': victim_id,
      'surname': surname,
      'name': name,
      'prisoner_number': prisoner_number,
      'birth': birth,
      'birthplace': birthplace,
      'death': death,
      'deathplace': deathplace,
      'nationality': nationality,
      'religion': religion,
      'occupation': occupation,
      'death_certificate': death_certificate,
      'env_date': env_date,
      'c_camp': c_camp,
      'fate': fate,
      'imagePath': imagePath,
      'imageDescription': imageDescription,
      'imageSource': imageSource,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  Victim copyWith({
    String? surname,
    String? name,
    int? prisoner_number,
    DateTime? birth,
    String? birthplace,
    DateTime? death,
    String? deathplace,
    String? nationality,
    String? religion,
    String? occupation,
    bool? death_certificate,
    DateTime? env_date,
    String? c_camp,
    String? fate,
    String? imagePath,
    String? imageDescription,
    String? imageSource,
  }) {
    return VictimImpl(
      victim_id: victim_id,
      surname: surname ?? this.surname,
      name: name ?? this.name,
      prisoner_number: prisoner_number ?? this.prisoner_number,
      birth: birth ?? this.birth,
      birthplace: birthplace ?? this.birthplace,
      death: death ?? this.death,
      deathplace: deathplace ?? this.deathplace,
      nationality: nationality ?? this.nationality,
      religion: religion ?? this.religion,
      occupation: occupation ?? this.occupation,
      death_certificate: death_certificate ?? this.death_certificate,
      env_date: env_date ?? this.env_date,
      c_camp: c_camp ?? this.c_camp,
      fate: fate ?? this.fate,
      imagePath: imagePath ?? this.imagePath,
      imageDescription: imageDescription ?? this.imageDescription,
      imageSource: imageSource ?? this.imageSource,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class ConcentrationCampImpl extends ConcentrationCamp {
  ConcentrationCampImpl({
    required String camp_id,
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
    DateTime? createdAt,
    DateTime? updatedAt,
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
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }

  // Factory constructor für Firestore Document
  factory ConcentrationCampImpl.fromJson(Map<String, dynamic> json) {
    return ConcentrationCampImpl(
      camp_id: json['camp_id']?.toString() ?? '0',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      country: json['country'] ?? '',
      description: json['description'] ?? '',
      date_opened: json['date_opened']?.toDate(),
      liberation_date: json['liberation_date']?.toDate(),
      type: json['type'] ?? '',
      commander: json['commander'] ?? '',
      imagePath: json['imagePath'],
      imageDescription: json['imageDescription'],
      imageSource: json['imageSource'],
      createdAt: json['createdAt']?.toDate(),
      updatedAt: json['updatedAt']?.toDate(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'camp_id': camp_id,
      'name': name,
      'location': location,
      'country': country,
      'description': description,
      'date_opened': date_opened,
      'liberation_date': liberation_date,
      'type': type,
      'commander': commander,
      'imagePath': imagePath,
      'imageDescription': imageDescription,
      'imageSource': imageSource,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  ConcentrationCamp copyWith({
    String? name,
    String? location,
    String? country,
    String? description,
    DateTime? date_opened,
    DateTime? liberation_date,
    String? type,
    String? commander,
    String? imagePath,
    String? imageDescription,
    String? imageSource,
  }) {
    return ConcentrationCampImpl(
      camp_id: camp_id,
      name: name ?? this.name,
      location: location ?? this.location,
      country: country ?? this.country,
      description: description ?? this.description,
      date_opened: date_opened ?? this.date_opened,
      liberation_date: liberation_date ?? this.liberation_date,
      type: type ?? this.type,
      commander: commander ?? this.commander,
      imagePath: imagePath ?? this.imagePath,
      imageDescription: imageDescription ?? this.imageDescription,
      imageSource: imageSource ?? this.imageSource,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class CommanderImpl extends Commander {
  CommanderImpl({
    required String commander_id,
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
    DateTime? createdAt,
    DateTime? updatedAt,
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
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }

  // Factory constructor für Firestore Document
  factory CommanderImpl.fromJson(Map<String, dynamic> json) {
    return CommanderImpl(
      commander_id: json['commander_id']?.toString() ?? '0',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      rank: json['rank'] ?? '',
      birth: json['birth']?.toDate(),
      birthplace: json['birthplace'],
      death: json['death']?.toDate(),
      deathplace: json['deathplace'],
      description: json['description'] ?? '',
      imagePath: json['imagePath'],
      imageDescription: json['imageDescription'],
      imageSource: json['imageSource'],
      createdAt: json['createdAt']?.toDate(),
      updatedAt: json['updatedAt']?.toDate(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'commander_id': commander_id,
      'name': name,
      'surname': surname,
      'rank': rank,
      'birth': birth,
      'birthplace': birthplace,
      'death': death,
      'deathplace': deathplace,
      'description': description,
      'imagePath': imagePath,
      'imageDescription': imageDescription,
      'imageSource': imageSource,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  Commander copyWith({
    String? name,
    String? surname,
    String? rank,
    DateTime? birth,
    String? birthplace,
    DateTime? death,
    String? deathplace,
    String? description,
    String? imagePath,
    String? imageDescription,
    String? imageSource,
  }) {
    return CommanderImpl(
      commander_id: commander_id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      rank: rank ?? this.rank,
      birth: birth ?? this.birth,
      birthplace: birthplace ?? this.birthplace,
      death: death ?? this.death,
      deathplace: deathplace ?? this.deathplace,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      imageDescription: imageDescription ?? this.imageDescription,
      imageSource: imageSource ?? this.imageSource,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
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

  final now = DateTime.now();

  // Ein Test-Opfer
  final testVictim = VictimImpl(
    victim_id: '1',
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
    createdAt: now,
    updatedAt: now,
  );

  await repository.createVictim(testVictim);

  // Ein Test-Lager
  final testCamp = ConcentrationCampImpl(
    camp_id: '1',
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
    createdAt: now,
    updatedAt: now,
  );

  await repository.createConcentrationCamp(testCamp);

  // Ein Test-Kommandant
  final testCommander = CommanderImpl(
    commander_id: '1',
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
    createdAt: now,
    updatedAt: now,
  );

  await repository.createCommander(testCommander);

  print('✓ Minimale Test-Daten erstellt (1 Opfer, 1 Lager, 1 Kommandant)');
}

/// Factory-Methoden für einfache Erstellung von Objekten

/// Erstellt ein neues Victim-Objekt mit den gegebenen Parametern
VictimImpl createVictim({
  required String victimId,
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
  final now = DateTime.now();
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
    createdAt: now,
    updatedAt: now,
  );
}

/// Erstellt ein neues ConcentrationCamp-Objekt mit den gegebenen Parametern
ConcentrationCampImpl createConcentrationCamp({
  required String campId,
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
  final now = DateTime.now();
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
    createdAt: now,
    updatedAt: now,
  );
}

/// Erstellt ein neues Commander-Objekt mit den gegebenen Parametern
CommanderImpl createCommander({
  required String commanderId,
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
  final now = DateTime.now();
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
    createdAt: now,
    updatedAt: now,
  );
}

/// Utility-Funktionen für Admin-Dashboard

/// Validiert Victim-Daten vor dem Speichern
DatabaseResult<void> validateVictimData(VictimImpl victim) {
  if (victim.surname.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException('Nachname ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (victim.name.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException('Vorname ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (victim.nationality.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException(
        'Nationalität ist erforderlich',
        code: 'VALIDATION_ERROR',
      ),
    );
  }
  if (victim.religion.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException('Religion ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (victim.occupation.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException('Beruf ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (victim.c_camp.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException(
        'Konzentrationslager ist erforderlich',
        code: 'VALIDATION_ERROR',
      ),
    );
  }
  if (victim.fate.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException('Schicksal ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }

  // Datum-Validierung
  if (victim.birth != null && victim.death != null) {
    if (victim.birth!.isAfter(victim.death!)) {
      return DatabaseResult.failure(
        DatabaseException(
          'Geburtsdatum kann nicht nach Sterbedatum liegen',
          code: 'VALIDATION_ERROR',
        ),
      );
    }
  }

  return const DatabaseResult.success(null);
}

/// Validiert ConcentrationCamp-Daten vor dem Speichern
DatabaseResult<void> validateCampData(ConcentrationCampImpl camp) {
  if (camp.name.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException('Name ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (camp.location.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException('Ort ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (camp.country.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException('Land ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (camp.description.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException(
        'Beschreibung ist erforderlich',
        code: 'VALIDATION_ERROR',
      ),
    );
  }
  if (camp.type.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException('Typ ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (camp.commander.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException(
        'Kommandant ist erforderlich',
        code: 'VALIDATION_ERROR',
      ),
    );
  }

  // Datum-Validierung
  if (camp.date_opened != null && camp.liberation_date != null) {
    if (camp.date_opened!.isAfter(camp.liberation_date!)) {
      return DatabaseResult.failure(
        DatabaseException(
          'Eröffnungsdatum kann nicht nach Befreiungsdatum liegen',
          code: 'VALIDATION_ERROR',
        ),
      );
    }
  }

  return const DatabaseResult.success(null);
}

/// Validiert Commander-Daten vor dem Speichern
DatabaseResult<void> validateCommanderData(CommanderImpl commander) {
  if (commander.name.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException('Vorname ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (commander.surname.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException('Nachname ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (commander.rank.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException('Rang ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (commander.description.trim().isEmpty) {
    return DatabaseResult.failure(
      DatabaseException(
        'Beschreibung ist erforderlich',
        code: 'VALIDATION_ERROR',
      ),
    );
  }

  // Datum-Validierung
  if (commander.birth != null && commander.death != null) {
    if (commander.birth!.isAfter(commander.death!)) {
      return DatabaseResult.failure(
        DatabaseException(
          'Geburtsdatum kann nicht nach Sterbedatum liegen',
          code: 'VALIDATION_ERROR',
        ),
      );
    }
  }

  return const DatabaseResult.success(null);
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
