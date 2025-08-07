import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import 'details/neuengamme.dart';
import 'details/dachau.dart';
import 'details/chaidari.dart';
import 'details/cap_arcona.dart';
import 'details/salzgitter_druette.dart';
import 'details/hannover_stoecken.dart';
import 'details/mauthausen.dart';
import 'details/ravensbrueck.dart';
import 'details/sachsenhausen.dart';
import 'details/buchenwald.dart';
import 'details/bremen_schuetzenhof.dart';
import 'details/bremen_farge.dart';
import 'details/hamburg_veddel.dart';
import 'details/hamburg_hammerbrook.dart';
import 'details/ladelund.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

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

  // Drei verschiedene Custom Icons
  late BitmapDescriptor _customIcon;
  late BitmapDescriptor _secondaryIcon;
  late BitmapDescriptor _memoryIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomMarkers().then((_) => _addFixedMarkers());
  }

  Future<void> _loadCustomMarkers() async {
    try {
      // Laden des ersten Custom Icons
      _customIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(41, 58)),
        'assets/icons/custom_marker.png',
      );
    } catch (e) {
      _customIcon = BitmapDescriptor.defaultMarker;
    }

    try {
      // Laden des zweiten Custom Icons
      _secondaryIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(41, 58)),
        'assets/icons/secondary_marker.png',
      );
    } catch (e) {
      _secondaryIcon = BitmapDescriptor.defaultMarker;
    }

    try {
      // Laden des dritten Custom Icons
      _memoryIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(41, 58)),
        'assets/icons/memory_marker.png',
      );
    } catch (e) {
      _memoryIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      );
    }
  }

  void _addFixedMarkers() {
    setState(() {
      _markers.addAll([
        // Hauptgedenkstätten mit _customIcon
        Marker(
          markerId: const MarkerId('1'),
          position: const LatLng(53.44533791501996, 10.231914427627382),
          icon: _customIcon,
          infoWindow: const InfoWindow(title: 'KZ Neuengamme'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailScreen1()),
          ),
        ),
        Marker(
          markerId: const MarkerId('2'),
          position: const LatLng(48.26803027293752, 11.468799470140294),
          icon: _customIcon,
          infoWindow: const InfoWindow(title: 'KZ Dachau'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailScreen2()),
          ),
        ),
        Marker(
          markerId: const MarkerId('3'),
          position: const LatLng(38.017, 23.657),
          icon: _customIcon,
          infoWindow: const InfoWindow(title: 'KZ Chaidari'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailScreen3()),
          ),
        ),
        Marker(
          markerId: const MarkerId('7'),
          position: const LatLng(48.2572730983791, 14.50011983452205),
          icon: _customIcon,
          infoWindow: const InfoWindow(title: 'KZ Mauthausen'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailScreen7()),
          ),
        ),
        Marker(
          markerId: const MarkerId('8'),
          position: const LatLng(53.191261740815285, 13.166822194955147),
          icon: _customIcon,
          infoWindow: const InfoWindow(title: 'KZ Ravensbrück'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailScreen8()),
          ),
        ),
        Marker(
          markerId: const MarkerId('9'),
          position: const LatLng(52.76603986508148, 13.264222206697125),
          icon: _customIcon,
          infoWindow: const InfoWindow(title: 'KZ Sachsenhausen'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailScreen9()),
          ),
        ),
        Marker(
          markerId: const MarkerId('10'),
          position: const LatLng(51.09989118661302, 11.2670648585419),
          icon: _customIcon,
          infoWindow: const InfoWindow(title: 'KZ Buchenwald'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailScreen10()),
          ),
        ),

        // Außenlager mit _secondaryIcon
        Marker(
          markerId: const MarkerId('5'),
          position: const LatLng(52.15831978059626, 10.418884460728652),
          icon: _secondaryIcon,
          infoWindow: const InfoWindow(title: 'Außenlager Salzgitter-Drütte'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailScreen5()),
          ),
        ),
        Marker(
          markerId: const MarkerId('6'),
          position: const LatLng(52.41109774125131, 9.632497590344874),
          icon: _secondaryIcon,
          infoWindow: const InfoWindow(title: 'Außenlager Hannover-Stöcken'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailScreen6()),
          ),
        ),
        Marker(
          markerId: const MarkerId('11'),
          position: const LatLng(53.11853532824218, 8.767580978044537),
          icon: _secondaryIcon,
          infoWindow: const InfoWindow(title: 'Außenlager Bremen-Schützenhof'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailScreen11()),
          ),
        ),
        Marker(
          markerId: const MarkerId('12'),
          position: const LatLng(53.217068047232104, 8.506245553092445),
          icon: _secondaryIcon,
          infoWindow: const InfoWindow(title: 'Außenlager Bremen-Farge'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailScreen12()),
          ),
        ),
        Marker(
          markerId: const MarkerId('13'),
          position: const LatLng(53.52476449769444, 10.009821352971022),
          icon: _secondaryIcon,
          infoWindow: const InfoWindow(title: 'Außenlager Hamburg-Veddel'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailScreen13()),
          ),
        ),
        Marker(
          markerId: const MarkerId('14'),
          position: const LatLng(53.5508921939367, 10.022469180968752),
          icon: _secondaryIcon,
          infoWindow: const InfoWindow(title: 'Außenlager Hamburg-Hammerbrook'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailScreen14()),
          ),
        ),
        Marker(
          markerId: const MarkerId('15'),
          position: const LatLng(54.84776339877242, 9.036395587840683),
          icon: _secondaryIcon,
          infoWindow: const InfoWindow(title: 'Außenlager Ladelund'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailScreen15()),
          ),
        ),

        // Mahnmale mit _memoryIcon
        Marker(
          markerId: const MarkerId('4'),
          position: const LatLng(54.09143087671109, 10.818427949630182),
          icon: _memoryIcon,
          infoWindow: const InfoWindow(title: 'Cap Arcona Mahnmal'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailScreen4()),
          ),
        ),
      ]);
    });
  }

  void _zoomIn() {
    mapController.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    mapController.animateCamera(CameraUpdate.zoomOut());
  }

  Future<void> _searchLocation(BuildContext context, String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        final LatLng newPosition = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );
        mapController.animateCamera(CameraUpdate.newLatLng(newPosition));
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
          const SnackBar(content: Text('Fehler bei der Ortssuche.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            markers: _markers,
            onMapCreated: (controller) => mapController = controller,
            zoomControlsEnabled: false,
          ),
          Positioned(
            top: 10,
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
                  hintText: 'Suche',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.mic, color: Colors.grey),
                    onPressed: () {},
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 15,
            bottom: 100,
            child: Column(
              children: [
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
        ],
      ),
    );
  }
}
