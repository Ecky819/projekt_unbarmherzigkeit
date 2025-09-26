import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import '../../data/profile.dart';
import '../../data/database_repository.dart';
import '../database/widgets/camp_detail_view.dart';
import '../../../l10n/app_localizations.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, DatabaseRepository? repository});

  String get desc => 'Map';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(48.12533866712736, 11.550006961180008),
    zoom: 4,
  );

  final Set<Marker> _markers = {};
  final TextEditingController _searchController = TextEditingController();

  // Custom Icons
  late BitmapDescriptor _customIcon;
  late BitmapDescriptor _secondaryIcon;
  late BitmapDescriptor _memoryIcon;

  // Mapping von Marker-IDs zu Camp-Namen für Suche in der Datenbank
  // WICHTIG: Diese Namen müssen exakt mit den Namen in der Datenbank übereinstimmen!
  final Map<String, String> _markerToCampName = {
    '1': 'Neuengamme',
    '2': 'Dachau',
    '3': 'Chaidari',
    '7': 'Mauthausen',
    '8': 'Ravensbrück',
    '9': 'Sachsenhausen',
    '10': 'Buchenwald',
    '16': 'Pavlos Melas',
    '18': 'Lublin-Majdanek',
    // Außenlager zum KZ Neuengamme
    '5': 'Salzgitter-Drütte',
    '6': 'Hannover-Stöcken',
    '11': 'Bremen-Schützenhof',
    '12': 'Bremen-Farge',
    '13': 'Hamburg-Veddel',
    '14': 'Hamburg-Hammerbrook',
    '15': 'Ladelund',
    '17': 'Hamburg-Hammerbrook',
  };

  @override
  void initState() {
    super.initState();
    _loadCustomMarkers().then((_) => _addFixedMarkers());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomMarkers() async {
    try {
      _customIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(41, 58)),
        'assets/icons/custom_marker.png',
      );
    } catch (e) {
      //print('Error loading custom marker: $e');
      _customIcon = BitmapDescriptor.defaultMarker;
    }

    try {
      _secondaryIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(41, 58)),
        'assets/icons/secondary_marker.png',
      );
    } catch (e) {
      //print('Error loading secondary marker: $e');
      _secondaryIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      );
    }

    try {
      _memoryIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(41, 58)),
        'assets/icons/memory_marker.png',
      );
    } catch (e) {
      //print('Error loading memory marker: $e');
      _memoryIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      );
    }
  }

  void _loadCampFromDatabase(String markerId) async {
    final campName = _markerToCampName[markerId];
    if (campName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keine Detailinformationen verfügbar')),
      );
      return;
    }

    // Repository aus dem Provider holen
    final repository = Provider.of<DatabaseRepository>(context, listen: false);

    // Debug-Ausgabe um zu sehen welches Repository verwendet wird
    //print('Using repository: ${repository.runtimeType}');
    //print('Searching for camp: $campName');

    // Zeige Ladeindikator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Versuche zuerst die direkte Suche mit verschiedenen Namensformaten
      final searchVariants = [
        campName,
        'KZ $campName',
        'Außenlager $campName',
        'Konzentrationslager $campName',
      ];

      SearchResult? foundResult;

      // Durchsuche mit verschiedenen Namensvarianten
      for (final searchName in searchVariants) {
        //print('Trying search variant: $searchName');
        final searchResult = await repository.search(nameQuery: searchName);

        if (searchResult.isSuccess &&
            searchResult.data != null &&
            searchResult.data!.isNotEmpty) {
          //print('Found ${searchResult.data!.length} results for "$searchName"');
          // Prüfe ob ein Camp gefunden wurde
          for (final result in searchResult.data!) {
            if (result.type == 'camp') {
              foundResult = result;
              //print('Found camp: ${result.title}');
              break;
            }
          }
          if (foundResult != null) break;
        }
      }

      // Wenn nichts gefunden, versuche Teilstring-Suche
      if (foundResult == null) {
        //print('No exact match found, trying partial search...');
        // Suche auch nach Teilstrings (für den Fall von Rechtschreibunterschieden)
        final allCampsResult = await repository.getConcentrationCamps();

        if (allCampsResult.isSuccess && allCampsResult.data != null) {
          //print('Searching through ${allCampsResult.data!.length} camps');
          for (final camp in allCampsResult.data!) {
            // Case-insensitive Suche mit contains
            if (camp.name.toLowerCase().contains(campName.toLowerCase()) ||
                campName.toLowerCase().contains(camp.name.toLowerCase())) {
              foundResult = SearchResult.fromCamp(camp);
              //print('Found camp by partial match: ${camp.name}');
              break;
            }
          }
        }
      }

      // Verstecke Ladeindikator
      if (mounted) {
        Navigator.pop(context);
      }

      if (foundResult != null && foundResult.item is ConcentrationCamp) {
        final camp = foundResult.item as ConcentrationCamp;

        if (mounted) {
          // Wichtig: Übergebe das Repository an CampDetailScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CampDetailScreen(
                camp: camp,
                repository: repository, // Repository übergeben!
              ),
            ),
          );
        }
      } else if (mounted) {
        // Keine Ergebnisse gefunden
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lager "$campName" nicht in der Datenbank gefunden'),
            action: SnackBarAction(
              label: 'Details',
              onPressed: () {
                // Zeige Dialog mit Debug-Informationen
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Keine Daten gefunden'),
                    content: Text(
                      'Das Lager "$campName" konnte nicht in der Datenbank gefunden werden.\n\n'
                      'Verwendetes Repository: ${repository.runtimeType}\n'
                      'Hinweis: Stellen Sie sicher, dass die Datenbank initialisiert wurde.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }
    } catch (e) {
      // Verstecke Ladeindikator bei Fehler
      if (mounted) {
        Navigator.pop(context);
      }

      if (mounted) {
        //print('Error loading camp: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Laden: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addFixedMarkers() {
    setState(() {
      _markers.addAll([
        // Hauptgedenkstätten
        Marker(
          markerId: const MarkerId('1'),
          position: const LatLng(53.44533791501996, 10.231914427627382),
          icon: _customIcon,
          infoWindow: const InfoWindow(title: 'KZ Neuengamme'),
          onTap: () => _loadCampFromDatabase('1'),
        ),
        Marker(
          markerId: const MarkerId('2'),
          position: const LatLng(48.26803027293752, 11.468799470140294),
          icon: _customIcon,
          infoWindow: const InfoWindow(title: 'KZ Dachau'),
          onTap: () => _loadCampFromDatabase('2'),
        ),
        Marker(
          markerId: const MarkerId('3'),
          position: const LatLng(38.017, 23.657),
          icon: _customIcon,
          infoWindow: const InfoWindow(title: 'KZ Chaidari'),
          onTap: () => _loadCampFromDatabase('3'),
        ),
        Marker(
          markerId: const MarkerId('7'),
          position: const LatLng(48.2572730983791, 14.50011983452205),
          icon: _customIcon,
          infoWindow: const InfoWindow(title: 'KZ Mauthausen'),
          onTap: () => _loadCampFromDatabase('7'),
        ),
        Marker(
          markerId: const MarkerId('8'),
          position: const LatLng(53.191261740815285, 13.166822194955147),
          icon: _customIcon,
          infoWindow: const InfoWindow(title: 'KZ Ravensbrück'),
          onTap: () => _loadCampFromDatabase('8'),
        ),
        Marker(
          markerId: const MarkerId('9'),
          position: const LatLng(52.76603986508148, 13.264222206697125),
          icon: _customIcon,
          infoWindow: const InfoWindow(title: 'KZ Sachsenhausen'),
          onTap: () => _loadCampFromDatabase('9'),
        ),
        Marker(
          markerId: const MarkerId('10'),
          position: const LatLng(51.09989118661302, 11.2670648585419),
          icon: _customIcon,
          infoWindow: const InfoWindow(title: 'KZ Buchenwald'),
          onTap: () => _loadCampFromDatabase('10'),
        ),
        Marker(
          markerId: const MarkerId('16'),
          position: const LatLng(40.662292, 22.936237),
          icon: _customIcon,
          infoWindow: const InfoWindow(title: 'KZ Pavlos Melas'),
          onTap: () => _loadCampFromDatabase('16'),
        ),

        Marker(
          markerId: const MarkerId('18'),
          position: const LatLng(51.219167, 22.605833),
          icon: _customIcon,
          infoWindow: const InfoWindow(title: 'KZ Lublin-Majdanek'),
          onTap: () => _loadCampFromDatabase('18'),
        ),

        // Außenlager
        Marker(
          markerId: const MarkerId('5'),
          position: const LatLng(52.15831978059626, 10.418884460728652),
          icon: _secondaryIcon,
          infoWindow: const InfoWindow(title: 'Außenlager Salzgitter-Drütte'),
          onTap: () => _loadCampFromDatabase('5'),
        ),
        Marker(
          markerId: const MarkerId('6'),
          position: const LatLng(52.41109774125131, 9.632497590344874),
          icon: _secondaryIcon,
          infoWindow: const InfoWindow(title: 'Außenlager Hannover-Stöcken'),
          onTap: () => _loadCampFromDatabase('6'),
        ),
        Marker(
          markerId: const MarkerId('11'),
          position: const LatLng(53.11853532824218, 8.767580978044537),
          icon: _secondaryIcon,
          infoWindow: const InfoWindow(title: 'Außenlager Bremen-Schützenhof'),
          onTap: () => _loadCampFromDatabase('11'),
        ),
        Marker(
          markerId: const MarkerId('12'),
          position: const LatLng(53.217068047232104, 8.506245553092445),
          icon: _secondaryIcon,
          infoWindow: const InfoWindow(title: 'Außenlager Bremen-Farge'),
          onTap: () => _loadCampFromDatabase('12'),
        ),
        Marker(
          markerId: const MarkerId('13'),
          position: const LatLng(53.52476449769444, 10.009821352971022),
          icon: _secondaryIcon,
          infoWindow: const InfoWindow(title: 'Außenlager Hamburg-Veddel'),
          onTap: () => _loadCampFromDatabase('13'),
        ),
        Marker(
          markerId: const MarkerId('14'),
          position: const LatLng(53.5508921939367, 10.022469180968752),
          icon: _secondaryIcon,
          infoWindow: const InfoWindow(title: 'Außenlager Hamburg-Hammerbrook'),
          onTap: () => _loadCampFromDatabase('14'),
        ),
        Marker(
          markerId: const MarkerId('15'),
          position: const LatLng(54.84776339877242, 9.036395587840683),
          icon: _secondaryIcon,
          infoWindow: const InfoWindow(title: 'Außenlager Ladelund'),
          onTap: () => _loadCampFromDatabase('15'),
        ),
        Marker(
          markerId: const MarkerId('17'),
          position: const LatLng(53.550936023637625, 10.022374851112998),
          icon: _secondaryIcon,
          infoWindow: const InfoWindow(title: 'Außenlager Hamburg-Hammerbrook'),
          onTap: () => _loadCampFromDatabase('17'),
        ),

        // Mahnmale
        Marker(
          markerId: const MarkerId('4'),
          position: const LatLng(54.09143087671109, 10.818427949630182),
          icon: _memoryIcon,
          infoWindow: const InfoWindow(title: 'Cap Arcona Mahnmal'),
          onTap: () => _showMemorialInfo('Cap Arcona Mahnmal'),
        ),
      ]);
    });
  }

  void _showMemorialInfo(String memorialName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(memorialName),
        content: const Text(
          'Dieses Mahnmal erinnert an die Opfer der Cap Arcona Tragödie. '
          'Für detaillierte Informationen besuchen Sie bitte die Gedenkstätte.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _zoomIn() {
    mapController.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    mapController.animateCamera(CameraUpdate.zoomOut());
  }

  Future<void> _searchLocation(BuildContext context, String location) async {
    if (location.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte geben Sie einen Ort ein.')),
      );
      return;
    }

    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        final LatLng newPosition = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: newPosition, zoom: 12),
          ),
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Ort nicht gefunden.')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler bei der Ortssuche: ${e.toString()}')),
        );
      }
    }
  }

  void _resetCameraPosition() {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(_initialCameraPosition),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            markers: _markers,
            onMapCreated: (controller) => mapController = controller,
            zoomControlsEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: true,
            mapToolbarEnabled: false,
          ),

          // Suchleiste
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: (value) {
                  _searchLocation(context, value);
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  hintText: l10n?.mapsearchHint ?? 'Ort suchen...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.mic, color: Colors.grey),
                          onPressed: () {
                            // Mikrofon-Funktion (optional zu implementieren)
                          },
                        ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ),

          // Zoom-Kontrollen und Reset-Button
          Positioned(
            right: 15,
            bottom: 100,
            child: Column(
              children: [
                // Reset Camera Position Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: _resetCameraPosition,
                      child: const SizedBox(
                        width: 45,
                        height: 45,
                        child: Icon(
                          Icons.my_location,
                          color: Colors.black87,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Zoom In Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: _zoomIn,
                      child: const SizedBox(
                        width: 45,
                        height: 45,
                        child: Icon(Icons.add, color: Colors.black87, size: 24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Zoom Out Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: _zoomOut,
                      child: const SizedBox(
                        width: 45,
                        height: 45,
                        child: Icon(
                          Icons.remove,
                          color: Colors.black87,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Legende
          Positioned(
            left: 10,
            bottom: 30,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n?.mapLegend ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFFA45F37),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n?.mapMainCamp ?? '',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFFF08547),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n?.mapAuxCamp ?? '',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF74683A),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n?.mapReminder ?? '',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
