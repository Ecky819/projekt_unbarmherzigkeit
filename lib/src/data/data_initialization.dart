import 'package:json_annotation/json_annotation.dart';
import 'profile.dart';
import 'mockdatabase_repository.dart';

class UserProfileImpl extends UserProfile {
  UserProfileImpl({
    required String id,
    required String name,
    required String surname,
    required String email,
    String password = '',
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

  factory UserProfileImpl.fromJson(Map<String, dynamic> json) {
    return UserProfileImpl(
      id: json['id']?.toString() ?? '0',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      email: json['email'] ?? '',
      password: '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
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

@JsonSerializable()
class VictimImpl extends Victim {
  VictimImpl({
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
    required bool deathCertificate,
    DateTime? envDate,
    required String cCamp,
    required String fate,
    String? imagePath,
    String? imageDescription,
    String? imageSource,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    this.victimId = victimId;
    this.surname = surname;
    this.name = name;
    this.prisonerNumber = prisonerNumber;
    this.birth = birth;
    this.birthplace = birthplace;
    this.death = death;
    this.deathplace = deathplace;
    this.nationality = nationality;
    this.religion = religion;
    this.occupation = occupation;
    this.deathCertificate = deathCertificate;
    this.envDate = envDate;
    this.cCamp = cCamp;
    this.fate = fate;
    this.imagePath = imagePath;
    this.imageDescription = imageDescription;
    this.imageSource = imageSource;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }

  factory VictimImpl.fromJson(Map<String, dynamic> json) {
    return VictimImpl(
      victimId: json['victim_id']?.toString() ?? '0',
      surname: json['surname'] ?? '',
      name: json['name'] ?? '',
      prisonerNumber: json['prisoner_number'],
      birth: json['birth'] != null
          ? DateTime.parse(json['birth'].toString())
          : null,
      birthplace: json['birthplace'],
      death: json['death'] != null
          ? DateTime.parse(json['death'].toString())
          : null,
      deathplace: json['deathplace'],
      nationality: json['nationality'] ?? '',
      religion: json['religion'] ?? '',
      occupation: json['occupation'] ?? '',
      deathCertificate: json['death_certificate'] ?? false,
      envDate: json['env_date'] != null
          ? DateTime.parse(json['env_date'].toString())
          : null,
      cCamp: json['c_camp'] ?? '',
      fate: json['fate'] ?? '',
      imagePath: json['imagePath'],
      imageDescription: json['imageDescription'],
      imageSource: json['imageSource'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'victim_id': victimId,
      'surname': surname,
      'name': name,
      'prisoner_number': prisonerNumber,
      'birth': birth?.toIso8601String(),
      'birthplace': birthplace,
      'death': death?.toIso8601String(),
      'deathplace': deathplace,
      'nationality': nationality,
      'religion': religion,
      'occupation': occupation,
      'death_certificate': deathCertificate,
      'env_date': envDate?.toIso8601String(),
      'c_camp': cCamp,
      'fate': fate,
      'imagePath': imagePath,
      'imageDescription': imageDescription,
      'imageSource': imageSource,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  Victim copyWith({
    String? surname,
    String? name,
    int? prisonerNumber,
    DateTime? birth,
    String? birthplace,
    DateTime? death,
    String? deathplace,
    String? nationality,
    String? religion,
    String? occupation,
    bool? deathCertificate,
    DateTime? envDate,
    String? cCamp,
    String? fate,
    String? imagePath,
    String? imageDescription,
    String? imageSource,
  }) {
    return VictimImpl(
      victimId: victimId,
      surname: surname ?? this.surname,
      name: name ?? this.name,
      prisonerNumber: prisonerNumber ?? this.prisonerNumber,
      birth: birth ?? this.birth,
      birthplace: birthplace ?? this.birthplace,
      death: death ?? this.death,
      deathplace: deathplace ?? this.deathplace,
      nationality: nationality ?? this.nationality,
      religion: religion ?? this.religion,
      occupation: occupation ?? this.occupation,
      deathCertificate: deathCertificate ?? this.deathCertificate,
      envDate: envDate ?? this.envDate,
      cCamp: cCamp ?? this.cCamp,
      fate: fate ?? this.fate,
      imagePath: imagePath ?? this.imagePath,
      imageDescription: imageDescription ?? this.imageDescription,
      imageSource: imageSource ?? this.imageSource,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

// ============================================
// ConcentrationCampImpl mit json_serializable
// ============================================
@JsonSerializable()
class ConcentrationCampImpl extends ConcentrationCamp {
  ConcentrationCampImpl({
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    // Setze die geerbten Felder (bereits in ConcentrationCamp definiert)
    this.campId = campId;
    this.name = name;
    this.location = location;
    this.country = country;
    this.description = description;
    this.dateOpened = dateOpened;
    this.liberationDate = liberationDate;
    this.type = type;
    this.commander = commander;
    this.imagePath = imagePath;
    this.imageDescription = imageDescription;
    this.imageSource = imageSource;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }

  // Manuelle fromJson mit snake_case zu lowerCamelCase Mapping
  factory ConcentrationCampImpl.fromJson(Map<String, dynamic> json) {
    return ConcentrationCampImpl(
      campId: json['camp_id']?.toString() ?? '0',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      country: json['country'] ?? '',
      description: json['description'] ?? '',
      dateOpened: json['date_opened'] != null
          ? DateTime.parse(json['date_opened'].toString())
          : null,
      liberationDate: json['liberation_date'] != null
          ? DateTime.parse(json['liberation_date'].toString())
          : null,
      type: json['type'] ?? '',
      commander: json['commander'] ?? '',
      imagePath: json['imagePath'] as String?,
      imageDescription: json['imageDescription'] as String?,
      imageSource: json['imageSource'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'camp_id': campId,
      'name': name,
      'location': location,
      'country': country,
      'description': description,
      'date_opened': dateOpened?.toIso8601String(),
      'liberation_date': liberationDate?.toIso8601String(),
      'type': type,
      'commander': commander,
      'imagePath': imagePath,
      'imageDescription': imageDescription,
      'imageSource': imageSource,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  ConcentrationCamp copyWith({
    String? name,
    String? location,
    String? country,
    String? description,
    DateTime? dateOpened,
    DateTime? liberationDate,
    String? type,
    String? commander,
    String? imagePath,
    String? imageDescription,
    String? imageSource,
  }) {
    return ConcentrationCampImpl(
      campId: campId,
      name: name ?? this.name,
      location: location ?? this.location,
      country: country ?? this.country,
      description: description ?? this.description,
      dateOpened: dateOpened ?? this.dateOpened,
      liberationDate: liberationDate ?? this.liberationDate,
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

// ============================================
// CommanderImpl mit json_serializable
// ============================================
@JsonSerializable()
class CommanderImpl extends Commander {
  CommanderImpl({
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    // Setze die geerbten Felder (bereits in Commander definiert)
    this.commanderId = commanderId;
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

  // Manuelle fromJson mit snake_case zu lowerCamelCase Mapping
  factory CommanderImpl.fromJson(Map<String, dynamic> json) {
    return CommanderImpl(
      commanderId: json['commander_id']?.toString() ?? '0',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      rank: json['rank'] ?? '',
      birth: json['birth'] != null
          ? DateTime.parse(json['birth'].toString())
          : null,
      birthplace: json['birthplace'] as String?,
      death: json['death'] != null
          ? DateTime.parse(json['death'].toString())
          : null,
      deathplace: json['deathplace'] as String?,
      description: json['description'] ?? '',
      imagePath: json['imagePath'] as String?,
      imageDescription: json['imageDescription'] as String?,
      imageSource: json['imageSource'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'commander_id': commanderId,
      'name': name,
      'surname': surname,
      'rank': rank,
      'birth': birth?.toIso8601String(),
      'birthplace': birthplace,
      'death': death?.toIso8601String(),
      'deathplace': deathplace,
      'description': description,
      'imagePath': imagePath,
      'imageDescription': imageDescription,
      'imageSource': imageSource,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
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
      commanderId: commanderId,
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

// ============================================
// Helper Factory Functions
// ============================================
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
    victimId: victimId,
    surname: surname,
    name: name,
    prisonerNumber: prisonerNumber,
    birth: birth,
    birthplace: birthplace,
    death: death,
    deathplace: deathplace,
    nationality: nationality,
    religion: religion,
    occupation: occupation,
    deathCertificate: deathCertificate,
    envDate: envDate,
    cCamp: cCamp,
    fate: fate,
    imagePath: imagePath,
    imageDescription: imageDescription,
    imageSource: imageSource,
    createdAt: now,
    updatedAt: now,
  );
}

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
    campId: campId,
    name: name,
    location: location,
    country: country,
    description: description,
    dateOpened: dateOpened,
    liberationDate: liberationDate,
    type: type,
    commander: commander,
    imagePath: imagePath,
    imageDescription: imageDescription,
    imageSource: imageSource,
    createdAt: now,
    updatedAt: now,
  );
}

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
    commanderId: commanderId,
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

// ============================================
// Validation Functions
// ============================================
DatabaseResult<void> validateVictimData(VictimImpl victim) {
  if (victim.surname.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException('Nachname ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (victim.name.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException('Vorname ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (victim.nationality.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException(
        'Nationalität ist erforderlich',
        code: 'VALIDATION_ERROR',
      ),
    );
  }
  if (victim.religion.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException('Religion ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (victim.occupation.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException('Beruf ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (victim.cCamp.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException(
        'Konzentrationslager ist erforderlich',
        code: 'VALIDATION_ERROR',
      ),
    );
  }
  if (victim.fate.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException('Schicksal ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }

  // Datum-Validierung
  if (victim.birth != null && victim.death != null) {
    if (victim.birth!.isAfter(victim.death!)) {
      return const DatabaseResult.failure(
        DatabaseException(
          'Geburtsdatum kann nicht nach Sterbedatum liegen',
          code: 'VALIDATION_ERROR',
        ),
      );
    }
  }

  return const DatabaseResult.success(null);
}

DatabaseResult<void> validateCampData(ConcentrationCampImpl camp) {
  if (camp.name.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException('Name ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (camp.location.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException('Ort ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (camp.country.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException('Land ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (camp.description.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException(
        'Beschreibung ist erforderlich',
        code: 'VALIDATION_ERROR',
      ),
    );
  }
  if (camp.type.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException('Typ ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (camp.commander.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException(
        'Kommandant ist erforderlich',
        code: 'VALIDATION_ERROR',
      ),
    );
  }

  // Datum-Validierung
  if (camp.dateOpened != null && camp.liberationDate != null) {
    if (camp.dateOpened!.isAfter(camp.liberationDate!)) {
      return const DatabaseResult.failure(
        DatabaseException(
          'Eröffnungsdatum kann nicht nach Befreiungsdatum liegen',
          code: 'VALIDATION_ERROR',
        ),
      );
    }
  }

  return const DatabaseResult.success(null);
}

DatabaseResult<void> validateCommanderData(CommanderImpl commander) {
  if (commander.name.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException('Vorname ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (commander.surname.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException('Nachname ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (commander.rank.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException('Rang ist erforderlich', code: 'VALIDATION_ERROR'),
    );
  }
  if (commander.description.trim().isEmpty) {
    return const DatabaseResult.failure(
      DatabaseException(
        'Beschreibung ist erforderlich',
        code: 'VALIDATION_ERROR',
      ),
    );
  }

  // Datum-Validierung
  if (commander.birth != null && commander.death != null) {
    if (commander.birth!.isAfter(commander.death!)) {
      return const DatabaseResult.failure(
        DatabaseException(
          'Geburtsdatum kann nicht nach Sterbedatum liegen',
          code: 'VALIDATION_ERROR',
        ),
      );
    }
  }

  return const DatabaseResult.success(null);
}

// ============================================
// Utility Functions
// ============================================
String formatDateForDisplay(DateTime? date) {
  if (date == null) return 'Unbekannt';
  return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
}

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

String generateVictimSummary(VictimImpl victim) {
  final age = calculateAge(victim.birth, victim.death);
  final ageText = age != null ? ' ($age Jahre)' : '';
  return '${victim.surname}, ${victim.name}$ageText - ${victim.nationality}, ${victim.religion}, ${victim.occupation}';
}

// ============================================
// Mock Data Initialization
// ============================================
Future<MockDatabaseRepository> initializeMockData() async {
  final repository = MockDatabaseRepository();

  // print('╔════════════════════════════════════════════════════════════════╗');
  // print('║                        WARNUNG                                 ║');
  // print('╠════════════════════════════════════════════════════════════════╣');
  // print('║ initializeMockData() wird nur für Tests verwendet.            ║');
  // print('║ Produktive Daten werden über das Admin Dashboard verwaltet.   ║');
  // print('║ Migration zu Firestore ist bereits abgeschlossen.             ║');
  // print('╚════════════════════════════════════════════════════════════════╝');

  await _createMinimalTestData(repository);
  return repository;
}

Future<void> _createMinimalTestData(MockDatabaseRepository repository) async {
  //print('Erstelle minimale Test-Daten für Mock-Repository...');

  final now = DateTime.now();

  final testVictim = VictimImpl(
    victimId: '1',
    surname: 'Test',
    name: 'Opfer',
    birth: DateTime(1920, 1, 1),
    birthplace: 'Test-Stadt',
    death: DateTime(1944, 1, 1),
    deathplace: 'Test-Lager',
    nationality: 'Test-Nationalität',
    religion: 'Test-Religion',
    occupation: 'Test-Beruf',
    deathCertificate: true,
    cCamp: 'Test-Lager',
    fate: 'Test-Schicksal',
    imagePath: 'assets/images/victims/test.jpg',
    imageDescription: 'Test-Bildbeschreibung',
    imageSource: 'Test-Bildquelle',
    createdAt: now,
    updatedAt: now,
  );

  await repository.createVictim(testVictim);

  final testCamp = ConcentrationCampImpl(
    campId: '1',
    name: 'Test-Lager',
    location: 'Test-Ort',
    country: 'Test-Land',
    description: 'Test-Beschreibung für Entwicklungszwecke',
    dateOpened: DateTime(1940, 1, 1),
    liberationDate: DateTime(1945, 1, 1),
    type: 'Test-Typ',
    commander: 'Test-Kommandant',
    imagePath: 'assets/images/camps/test.jpg',
    imageDescription: 'Test-Bildbeschreibung',
    imageSource: 'Test-Bildquelle',
    createdAt: now,
    updatedAt: now,
  );

  await repository.createConcentrationCamp(testCamp);

  final testCommander = CommanderImpl(
    commanderId: '1',
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

  //print('✓ Minimale Test-Daten erstellt (1 Opfer, 1 Lager, 1 Kommandant)');
}

// Debug-Informationen für Entwicklung
void printDebugInfo() {
  // print('\n🔧 DEBUG INFORMATIONEN:');
  // print('- Data Initialization ist für Mock-Repository konfiguriert');
  // print('- Produktive Daten werden über Admin Dashboard verwaltet');
  // print('- Firestore Repository ist der primäre Datenspeicher');
  // print('- Migration wurde bereits durchgeführt');
  // print('- Admin User: marcoeggert73@gmail.com');
  // print('');
}
