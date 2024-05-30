import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;

  List<LatLng> get _mapPoints => const [
        LatLng(47.202634, 38.935933),
        LatLng(47.208659, 38.940412),
        LatLng(47.209155, 38.935744),
        LatLng(47.218397, 38.924556),
        LatLng(47.204937, 38.946590),
        LatLng(47.201482, 38.940277),
      ];

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Height of the AppBar
        child: CustomAppBar(),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: const MapOptions(
          initialCenter: LatLng(47.212585, 38.916473),
          initialZoom: 5,
        ),
        children: [
          TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.flutter_map_example'),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              size: const Size(50, 50),
              maxClusterRadius: 50,
              markers: _getMarkers(_mapPoints),
              builder: (_, markers) {
                return _ClusterMarker(
                  markersLength: markers.length.toString(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

List<Marker> _getMarkers(List<LatLng> mapPoints) {
  return List.generate(
    mapPoints.length,
    (index) => Marker(
      point: mapPoints[index],
      child: Image.asset('assets/icons/marker).png'),
      width: 50,
      height: 50,
      alignment: Alignment.center,
    ),
  );
}

class _ClusterMarker extends StatelessWidget {
  const _ClusterMarker({required this.markersLength});

  /// Количество маркеров, объединенных в кластер
  final String markersLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[200],
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.blue,
          width: 3,
        ),
      ),
      child: Center(
        child: Text(
          markersLength,
          style: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Header.png'), // Path to your image
              fit: BoxFit.cover,
            ),
          ),
        ),
        // AppBar content
        AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Define the action to be taken when the back button is pressed
              print("Back button pressed");
            },
          ),
          title: const Text(
            'RecycleME',
            style: TextStyle(
              fontFamily: 'Monospace', // Use the built-in Roboto font
              fontSize: 30, // Adjust the font size as needed
            ),
          ),
          backgroundColor: Colors.transparent, // Make AppBar transparent
          elevation: 0, // Remove shadow
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.login),
              onPressed: () {
                print("Menu button pressed");
              },
            ),
          ],
        ),
      ],
    );
  }
}
