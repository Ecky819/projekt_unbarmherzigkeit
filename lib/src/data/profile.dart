// lib/src/data/profile.dart
// WICHTIG: Diese Datei enthält NUR abstrakte Klassen
// KEINE @JsonSerializable Annotations hier!
// Die JSON-Serialisierung erfolgt in data_initialization.dart

abstract class UserProfile {
  String id = '0';
  String name = '';
  String surname = '';
  String email = '';
  String password = ''; // Wird nie serialisiert
  DateTime? createdAt;
  DateTime? updatedAt;

  Map<String, dynamic> toJson();

  UserProfile copyWith({
    String? name,
    String? surname,
    String? email,
    String? password,
  });
}

abstract class Victim {
  // Verwende lowerCamelCase für Dart-Variablen
  String victimId = '0'; // Datenbank: victim_id
  String surname = '';
  String name = '';
  int? prisonerNumber; // Datenbank: prisoner_number
  DateTime? birth;
  String? birthplace;
  DateTime? death;
  String? deathplace;
  String nationality = '';
  String religion = '';
  String occupation = '';
  bool deathCertificate = false; // Datenbank: death_certificate
  DateTime? envDate; // Datenbank: env_date
  String cCamp = ''; // Datenbank: c_camp
  String fate = '';
  String? imagePath;
  String? imageDescription;
  String? imageSource;
  DateTime? createdAt;
  DateTime? updatedAt;

  Map<String, dynamic> toJson();

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
  });

  // Utility methods
  String get fullName => '$surname, $name';

  int? get age {
    if (birth == null) return null;
    final endDate = death ?? DateTime.now();
    int calculatedAge = endDate.year - birth!.year;
    if (endDate.month < birth!.month ||
        (endDate.month == birth!.month && endDate.day < birth!.day)) {
      calculatedAge--;
    }
    return calculatedAge;
  }
}

abstract class ConcentrationCamp {
  String campId = '0'; // Datenbank: camp_id
  String name = '';
  String location = '';
  String country = '';
  String description = '';
  DateTime? dateOpened; // Datenbank: date_opened
  DateTime? liberationDate; // Datenbank: liberation_date
  String type = '';
  String commander = '';
  String? imagePath;
  String? imageDescription;
  String? imageSource;
  DateTime? createdAt;
  DateTime? updatedAt;

  Map<String, dynamic> toJson();

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
  });

  // Utility methods
  String get fullLocation => location.isNotEmpty && country.isNotEmpty
      ? '$location, $country'
      : location.isNotEmpty
      ? location
      : country;

  Duration? get operationDuration {
    if (dateOpened == null || liberationDate == null) return null;
    return liberationDate!.difference(dateOpened!);
  }
}

abstract class Commander {
  String commanderId = '0'; // Datenbank: commander_id
  String name = '';
  String surname = '';
  String rank = '';
  DateTime? birth;
  String? birthplace;
  DateTime? death;
  String? deathplace;
  String description = '';
  String? imagePath;
  String? imageDescription;
  String? imageSource;
  DateTime? createdAt;
  DateTime? updatedAt;

  Map<String, dynamic> toJson();

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
  });

  // Utility methods
  String get fullName => '$surname, $name';
  String get rankAndName =>
      rank.isNotEmpty ? '$rank $surname, $name' : fullName;

  int? get age {
    if (birth == null) return null;
    final endDate = death ?? DateTime.now();
    int calculatedAge = endDate.year - birth!.year;
    if (endDate.month < birth!.month ||
        (endDate.month == birth!.month && endDate.day < birth!.day)) {
      calculatedAge--;
    }
    return calculatedAge;
  }
}

// Result wrapper (bleibt unverändert)
class DatabaseResult<T> {
  final T? data;
  final DatabaseException? error;
  final bool isSuccess;

  const DatabaseResult.success(this.data) : error = null, isSuccess = true;
  const DatabaseResult.failure(this.error) : data = null, isSuccess = false;

  bool get hasData => data != null;
  bool get hasError => error != null;
}

// Custom Exception (bleibt unverändert)
class DatabaseException implements Exception {
  final String message;
  final String? code;
  final Object? originalError;
  final StackTrace? stackTrace;

  const DatabaseException(
    this.message, {
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'DatabaseException: $message';
}

// SearchResult mit Anpassungen für lowerCamelCase
class SearchResult {
  final String id;
  final String title;
  final String subtitle;
  final String type;
  final dynamic item;
  final DateTime? primaryDate;

  SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.item,
    this.primaryDate,
  });

  factory SearchResult.fromVictim(Victim victim) {
    return SearchResult(
      id: victim.victimId, // Neu: victimId statt victim_id
      title: victim.fullName,
      subtitle: victim.birth != null
          ? 'Geboren: ${_formatDate(victim.birth!)}'
          : 'Geburtsdatum unbekannt',
      type: 'victim',
      item: victim,
      primaryDate: victim.birth ?? victim.death,
    );
  }

  factory SearchResult.fromCamp(ConcentrationCamp camp) {
    return SearchResult(
      id: camp.campId, // Neu: campId statt camp_id
      title: camp.name,
      subtitle: camp.type.isNotEmpty ? camp.type : 'Typ unbekannt',
      type: 'camp',
      item: camp,
      primaryDate: camp.dateOpened ?? camp.liberationDate,
    );
  }

  factory SearchResult.fromCommander(Commander commander) {
    return SearchResult(
      id: commander.commanderId, // Neu: commanderId statt commander_id
      title: commander.fullName,
      subtitle: commander.birth != null
          ? 'Geboren: ${_formatDate(commander.birth!)}'
          : 'Geburtsdatum unbekannt',
      type: 'commander',
      item: commander,
      primaryDate: commander.birth ?? commander.death,
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
