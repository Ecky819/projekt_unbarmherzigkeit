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
    String? imagePath, // Neuer Parameter
    String? imageDescription, // Bildbeschreibung
    String? imageSource, // Quellenangabe
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
    this.imagePath = imagePath; // Neues Feld setzen
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
    String? imagePath, // Neuer Parameter
    String? imageDescription, // Bildbeschreibung
    String? imageSource, // Quellenangabe
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
    this.imagePath = imagePath; // Neues Feld setzen
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
    String? imagePath, // Neuer Parameter
    String? imageDescription, // Bildbeschreibung
    String? imageSource, // Quellenangabe
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
    this.imagePath = imagePath; // Neues Feld setzen
    this.imageDescription = imageDescription;
    this.imageSource = imageSource;
  }
}

// Beispiel für Dateninitialisierung mit Bildpfaden
Future<MockDatabaseRepository> initializeMockData() async {
  final repository = MockDatabaseRepository();

  // Beispiel-Opfer mit Bildpfaden hinzufügen
  await repository.createVictim(
    VictimImpl(
      victim_id: 1,
      surname: 'Müller',
      name: 'Anna',
      birth: DateTime(1920, 3, 15),
      birthplace: 'Berlin',
      death: DateTime(1943, 8, 20),
      deathplace: 'Auschwitz',
      nationality: 'Deutsch',
      religion: 'Jüdisch',
      occupation: 'Lehrerin',
      death_certificate: true,
      c_camp: 'Auschwitz',
      fate: 'Deportiert und ermordet',
      imagePath: 'assets/images/victims/anna_mueller.jpg',
      imageDescription:
          'Porträtfoto von Anna Müller aus dem Jahr 1939, aufgenommen in Berlin.',
      imageSource: 'Privatarchiv Familie Müller, Berlin',
    ),
  );

  await repository.createVictim(
    VictimImpl(
      victim_id: 3,
      surname: 'Nowak',
      name: 'Jan',
      birth: DateTime(1918, 7, 22),
      birthplace: 'Warschau',
      death: DateTime(1942, 11, 15),
      deathplace: 'Mauthausen',
      nationality: 'Polnisch',
      religion: 'Katholisch',
      occupation: 'Arbeiter',
      death_certificate: true,
      c_camp: 'Mauthausen',
      fate: 'Politischer Häftling',
    ),
  );

  await repository.createVictim(
    VictimImpl(
      victim_id: 4,
      surname: 'Agapitos',
      name: 'Euthymios',
      prisoner_number: 33006,
      birth: DateTime(1900, 01, 01),
      birthplace: 'Agia Euthymia',
      death: DateTime(1945, 03, 02),
      deathplace: 'Neuengamme',
      nationality: 'Griechisch',
      religion: 'orthodox',
      occupation: 'Gutsbesitzer',
      death_certificate: true,
      c_camp: 'Neuengamme',
      fate: 'offizielle Todesursache: Lungentuberkolose',
      imagePath: 'assets/images/victims/greek_default.jpg',
      imageDescription: 'Platzhalterbild',
      imageSource: 'Marco Eggert mit ChatGPT, Stockelsdorf',
    ),
  );

  await repository.createVictim(
    VictimImpl(
      victim_id: 5,
      surname: 'Anastasiades',
      name: 'Gregoire',
      prisoner_number: 44532,
      birth: DateTime(1898, 12, 23),
      birthplace: '',
      death: DateTime(1944, 12, 14),
      deathplace: 'Neuengamme',
      nationality: 'Griechisch',
      religion: 'orthodox',
      occupation: '',
      death_certificate: false,
      c_camp: '',
      fate: 'offizielle Todesursache: Lungentuberkolose',
      imagePath: 'assets/images/victims/greek_default.jpg',
      imageDescription: 'Platzhalterbild',
      imageSource: 'Marco Eggert mit ChatGPT, Stockelsdorf',
    ),
  );

  await repository.createVictim(
    VictimImpl(
      victim_id: 6,
      surname: 'Andreu',
      name: 'Georg',
      prisoner_number: null,
      birth: null,
      birthplace: '',
      death: DateTime(1945, 02, 23),
      deathplace: 'Neuengamme',
      nationality: 'Griechisch',
      religion: 'orthodox',
      occupation: '',
      death_certificate: true,
      c_camp: '',
      fate: '',
      imagePath: 'assets/images/victims/greek_default.jpg',
      imageDescription: 'Platzhalterbild',
      imageSource: 'Marco Eggert mit ChatGPT, Stockelsdorf',
    ),
  );

  await repository.createVictim(
    VictimImpl(
      victim_id: 7,
      surname: 'Awramides',
      name: 'Georgius',
      prisoner_number: null,
      birth: null,
      birthplace: '',
      death: DateTime(1945, 01, 07),
      deathplace: 'Neuengamme',
      nationality: 'Griechisch',
      religion: 'orthodox',
      occupation: '',
      death_certificate: true,
      c_camp: '',
      fate: '',
      imagePath: 'assets/images/victims/greek_default.jpg',
      imageDescription: 'Platzhalterbild',
      imageSource: 'Marco Eggert mit ChatGPT, Stockelsdorf',
    ),
  );

  await repository.createVictim(
    VictimImpl(
      victim_id: 8,
      surname: 'Barsukas',
      name: 'Johann',
      prisoner_number: null,
      birth: DateTime(1918, 06, 30),
      birthplace: 'Athen',
      death: DateTime(1945, 02, 28),
      deathplace: 'Außenlager Bremen-Farge',
      nationality: 'Griechisch',
      religion: 'orthodox',
      occupation: 'Offizier',
      death_certificate: true,
      env_date: null,
      c_camp: 'Neuengamme',
      fate:
          'offizielle Todesursache: Herz- Kreislaufschwäche; Wohnort: Lamia; Vater: Gerassimos Barsukas, Mutter Maragarita geborene Malawasi',
      imagePath: 'assets/images/victims/greek_default.jpg',
      imageDescription: 'Platzhalterbild',
      imageSource: 'Marco Eggert mit ChatGPT, Stockelsdorf',
    ),
  );
  await repository.createVictim(
    VictimImpl(
      victim_id: 9,
      surname: 'Bolijanitis',
      name: 'Lassarus',
      prisoner_number: 32466,
      birth: DateTime(1920),
      birthplace: '',
      death: DateTime(1945, 01, 10),
      deathplace: 'Außenlager Bremen-Farge',
      nationality: 'Griechisch',
      religion: 'orthodox',
      occupation: 'Bauer',
      death_certificate: true,
      env_date: DateTime(1944, 06, 30),
      c_camp: 'Neuengamme',
      fate:
          'offizielle Todesursache: Herzmuskelschwäche bei Pleuropneumonie und Cholecystilis; Persönlicher Besitz: eine weisse Uhr mit weisser Kette',
      imagePath: 'assets/images/victims/greek_default.jpg',
      imageDescription: 'Platzhalterbild',
      imageSource: 'Marco Eggert mit ChatGPT, Stockelsdorf',
    ),
  );

  await repository.createVictim(
    VictimImpl(
      victim_id: 10,
      surname: 'Bulikian',
      name: 'Vartivar',
      prisoner_number: null,
      birth: null,
      birthplace: 'Kaukasus',
      death: DateTime(1945, 01, 09),
      deathplace: 'Neuengamme',
      nationality: 'Griechisch',
      religion: 'orthodox',
      occupation: '',
      death_certificate: true,
      c_camp: 'Neuengamme',
      fate: '',
      imagePath: 'assets/images/victims/greek_default.jpg',
      imageDescription: 'Platzhalterbild',
      imageSource: 'Marco Eggert mit ChatGPT, Stockelsdorf',
    ),
  );
  // Beispiel-Konzentrationslager hinzufügen
  await repository.createConcentrationCamp(
    ConcentrationCampImpl(
      camp_id: 1,
      name: 'Auschwitz-Birkenau',
      location: 'Oświęcim',
      country: 'Polen',
      description: 'Größtes deutsches Vernichtungs- und Konzentrationslager',
      date_opened: DateTime(1940, 5, 20),
      liberation_date: DateTime(1945, 1, 27),
      type: 'Vernichtungslager',
      commander: 'Rudolf Höß',
      imagePath: 'assets/images/camps/haupttor_auschwitz.webp',
      imageDescription:
          'Das Haupttor von Auschwitz I mit der zynischen Aufschrift "Arbeit macht frei", fotografiert nach der Befreiung 1945.',
      imageSource: 'Staatliches Museum Auschwitz-Birkenau',
    ),
  );

  await repository.createConcentrationCamp(
    ConcentrationCampImpl(
      camp_id: 2,
      name: 'Treblinka',
      location: 'Treblinka',
      country: 'Polen',
      description: 'Vernichtungslager in der Nähe von Warschau',
      date_opened: DateTime(1942, 7, 23),
      liberation_date: DateTime(1943, 10, 19),
      type: 'Vernichtungslager',
      commander: 'Irmfried Eberl',
    ),
  );

  await repository.createConcentrationCamp(
    ConcentrationCampImpl(
      camp_id: 3,
      name: 'Mauthausen',
      location: 'Mauthausen',
      country: 'Österreich',
      description: 'Konzentrationslager in Oberösterreich',
      date_opened: DateTime(1938, 8, 8),
      liberation_date: DateTime(1945, 5, 5),
      type: 'Konzentrationslager',
      commander: 'Franz Ziereis',
    ),
  );

  await repository.createConcentrationCamp(
    ConcentrationCampImpl(
      camp_id: 4,
      name: 'Bergen-Belsen',
      location: 'Bergen',
      country: 'Deutschland',
      description: 'Konzentrationslager in Niedersachsen',
      date_opened: DateTime(1943, 4, 1),
      liberation_date: DateTime(1945, 4, 15),
      type: 'Konzentrationslager',
      commander: 'Josef Kramer',
    ),
  );

  await repository.createConcentrationCamp(
    ConcentrationCampImpl(
      camp_id: 5,
      name: 'Neuengamme',
      location: 'Neuengamme',
      country: 'Deutschland',
      description: 'Konzentrationslager in Hamburg',
      date_opened: DateTime(1938, 12, 12),
      liberation_date: DateTime(1945, 5, 2),
      type: 'Konzentrationslager',
      commander: 'Max Pauly',
      imagePath: 'assets/images/camps/KZ_Neuengamme_-_Luftbild_-_1945.jpg',
      imageDescription:
          'Luftbild, aufgenommen im April 1945 durch die Royal Air Force.',
      imageSource: 'KZ-Gedenkstätte Neuengamme',
    ),
  );

  await repository.createConcentrationCamp(
    ConcentrationCampImpl(
      camp_id: 6,
      name: 'Bremen-Farge',
      location: 'Bremen-Farge',
      country: 'Deutschland',
      description:
          'Arbeitslager in Bremen für den U-Bootbunker Valentin; Ab 7. April wurde das Außenlager Bremen-Farge zu einer wichtigen Durchgangsstation bei der Räumung der Außenlager des KZ Neuengamme im nordwestdeutschen Raum. Häftlinge aus den anderen Bremer Außenlagern Schützenhof, Blumenthal und Osterort, aus Meppen und aus Wilhelmshaven wurden zunächst nach Farge überstellt, sodass sich dort bis zu 5000 Häftlinge befanden. Am 10. April wurde das Lager geräumt. Eine erste Gruppe von Häftlingen musste direkt zum Auffanglager Sandbostel marschieren. Die kranken Häftlinge wurden in einen Zug verladen, dessen Ziel vermutlich Bergen-Belsen war. Er erreichte das Lager jedoch nicht und endete nach einer Woche Fahrt im Raum zwischen Bremen und Hamburg in Bremervörde. Von hier aus wurden die Häftlinge, die den Transport überlebt hatten, nach Sandbostel gebracht. Ein weiterer Teil der Häftlinge erreichte nach einem dreitägigen Marsch Bremervörde, wo die Männer in Viehwaggons verladen und über Winsen/Luhe ins Stammlager Neuengamme zurückgebracht wurden.',
      date_opened: DateTime(1943, 10, 01),
      liberation_date: DateTime(1945, 4, 10),
      type: 'Außenlager von Neuengamme',
      commander: 'Ulrich Wahl',
      imagePath:
          'assets/images/camps/Bundesarchiv_Bild_185-12-10,_Bremen,_U-Bootbunker__Valentin_,_Bau.jpg',
    ),
  );

  // Beispiel-Kommandanten mit Bildpfaden
  await repository.createCommander(
    CommanderImpl(
      commander_id: 1,
      name: 'Rudolf Franz Ferdinand',
      surname: 'Höß',
      rank: 'SS-Obersturmbannführer',
      birth: DateTime(1901, 11, 25),
      birthplace: 'Baden-Baden',
      death: DateTime(1947, 4, 16),
      deathplace: 'Auschwitz (hingerichtet)',
      description: 'Kommandant von Auschwitz von 1940 bis 1943',
      imagePath: 'assets/images/commanders/rudolf_hoess.jpg',
      imageDescription: 'Rudolf Höß, fotografiert während seines Prozesses',
      imageSource: 'Bundesarchiv, Bild 183-R99621',
    ),
  );

  await repository.createCommander(
    CommanderImpl(
      commander_id: 2,
      name: 'Franz',
      surname: 'Ziereis',
      rank: 'SS-Standartenführer',
      birth: DateTime(1905, 8, 13),
      birthplace: 'München',
      death: DateTime(1945, 5, 23),
      deathplace: 'Mauthausen',
      description: 'Kommandant von Mauthausen von 1939 bis 1945',
    ),
  );

  await repository.createCommander(
    CommanderImpl(
      commander_id: 3,
      name: 'Josef',
      surname: 'Kramer',
      rank: 'SS-Hauptsturmführer',
      birth: DateTime(1906, 11, 10),
      birthplace: 'München',
      death: DateTime(1945, 12, 13),
      deathplace: 'Hameln (hingerichtet)',
      description: 'Kommandant verschiedener Lager, zuletzt Bergen-Belsen',
    ),
  );

  await repository.createCommander(
    CommanderImpl(
      commander_id: 4,
      name: 'Max',
      surname: 'Pauly',
      rank: 'SS-Standartenführer',
      birth: DateTime(1906, 06, 1),
      birthplace: 'Wesselburen',
      death: DateTime(1946, 10, 8),
      deathplace: 'Hameln (hingerichtet)',
      description:
          'Kommandant verschiedener Lager, ab 1942 Kommandant in Neuengamme',
      imagePath: 'assets/images/commanders/max_pauly.jpg',
      imageDescription:
          'Max Pauly in SS-Uniform, Aufnahme aus den Prozessakten der Nürnberger Nachfolgeprozesse, 1946.',
      imageSource: 'National Archives, Washington D.C.',
    ),
  );

  // Beispiel-Benutzerprofile hinzufügen
  await repository.createUserProfile(
    UserProfileImpl(
      id: 1,
      name: 'Max',
      surname: 'Mustermann',
      email: 'max@example.com',
      password: 'password123',
    ),
  );

  return repository;
}
