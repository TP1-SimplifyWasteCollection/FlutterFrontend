import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:permission_handler/permission_handler.dart';

class FullScMap extends StatefulWidget {
  const FullScMap({super.key});

  @override
  State createState() => FullScMapState();
}

class FullScMapState extends State<FullScMap> {
  MapboxMapController? mapController;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.request();
    setState(() {
      _hasPermission = status == PermissionStatus.granted;
    });
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _hasPermission
          ? MapboxMap(
              accessToken: 'pk.eyJ1IjoicHJvamVjdGZmb2tpbGRhbSIsImEiOiJjbHVnc2dueGQxMGZqMmpyb3M4M3Zta3diIn0.Wt5JARj1tQmWb4rInzhKBg',
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationRenderMode: MyLocationRenderMode.NORMAL,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 10,
              ),
              styleString: 'mapbox://styles/projectffokildam/clz8b3xp4001h01qr406t8mkq',
            )
          : Center(child: Text('Location permission required')),
    );
  }
}
