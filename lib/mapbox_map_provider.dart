import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:permission_handler/permission_handler.dart';

class MapboxMapProvider extends ChangeNotifier {
  MapboxMap? mapboxMap;
  bool _isMarkerVisible = false;
  geolocator.Position? currentUserLocation;
  

  void setMapboxMap(MapboxMap map) {
    mapboxMap = map;
    notifyListeners();
  }

  void easeCamera(LatLng position) {
    mapboxMap?.easeTo(
      CameraOptions(
        center: Point(
          coordinates: Position(
              position.longitude, position.latitude),
        ),
        zoom: 14,
        bearing: 0,
        pitch: 5,
      ),
      MapAnimationOptions(duration: 500, startDelay: 0),
    );


  }

  Future<LatLng?> getCurrentCameraPosition() async {
    CameraState? cameraState = await mapboxMap?.getCameraState();
    if (cameraState != null && cameraState.center != null) {
      // Extract the current camera position (longitude and latitude)
      Position position = cameraState.center!.coordinates;
      return LatLng(position.lat.toDouble(), position.lng.toDouble());
    }
    return null; // Return null if the camera state is unavailable
  }
  void toggleMarkerVisibility(bool toggle) {
    _isMarkerVisible = toggle;
    notifyListeners();
  }

  // Check if the marker is visible
  bool isMarkerVisible() {
    return _isMarkerVisible;
  }

  Future<void> getLocation() async {
    var status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      print("dsadasdsa");
      await enableLocationComponent();
    } else {
      // Handle permission denied case
    }
  }

  Future<void> enableLocationComponent() async {
    if (mapboxMap != null) {
      await mapboxMap!.location.updateSettings(LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        showAccuracyRing: true,
      ));
      print("ne null");
      await moveCameraToPosition();
    }
  }

  Future<void> moveCameraToPosition() async {
    geolocator.Position position =
    await geolocator.Geolocator.getCurrentPosition(
      desiredAccuracy: geolocator.LocationAccuracy.high,
    );
    currentUserLocation = position;

    print(position);

    mapboxMap?.easeTo(
      CameraOptions(
        center: Point(
          coordinates: Position(
            position.longitude,
            position.latitude,
          ),
        ),
        zoom: 14,
        bearing: 0,
        pitch: 5,
      ),
      MapAnimationOptions(duration: 500, startDelay: 0),
    );
    // Save location or do other things...
  }



}