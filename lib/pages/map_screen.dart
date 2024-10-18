import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testmap/pages/slidingpanel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:testmap/mapbox_map_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

List<PointAnnotation> pointAnnotations = [];

class AnnotationClickListener extends OnPointAnnotationClickListener {
  final BuildContext context;
  final List<RecyclingCardData> cardsData;
  final MapboxMap mapboxMap;

  AnnotationClickListener(this.context, this.cardsData, this.mapboxMap);
  @override



  void onPointAnnotationClick(PointAnnotation annotation) {
    print("onAnnotationClick, id: ${annotation.id}");


    String cardId = annotation.id;


    RecyclingCardData? cardData =
        cardsData.firstWhere((card) => card.id2 == cardId);

    print(cardData.name);

    if (cardData != null) {
      mapboxMap.easeTo(
        CameraOptions(
          center: Point(
            coordinates: Position(
                cardData.position.longitude, cardData.position.latitude),
          ),
          zoom: 14,
          bearing: 0,
          pitch: 5,
        ),
        MapAnimationOptions(duration: 200, startDelay: 0),
      );
      Timer(Duration(milliseconds: 200), () {
        showCustomDialog(context, cardData);
      });
    }
  }

  void _openMaps(double latitude, double longitude) async {
    MapsLauncher.launchCoordinates(latitude, longitude);
  }

  void showCustomDialog(BuildContext context, RecyclingCardData data) {
    int extraItemsCount =
        data.recyclingItems.length > 3 ? data.recyclingItems.length - 2 : 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SizedBox(
            width: 600,
            height: 170, 
            child: Card(
              color: Color(0xFF2F3135),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          data.name,
                          style: TextStyle(
                            fontFamily: 'MontserratBold',
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          '${data.address}',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          '${data.phone}',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Row(
                          children: [
                            SvgPicture.asset(
                              isPointOpen(data.openingHour, data.closingHour)
                                  ? 'assets/open.svg'
                                  : 'assets/close.svg',
                              height: 25,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              (data.openingHour.hour == 0 && data.closingHour.hour == 0)
                                  ? '24/7'
                                  : '${data.openingHour.hour} - ${data.closingHour.hour}',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 30,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              backgroundColor: Color(
                                  0xFF005BFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), 
                              ),
                            ),
                            onPressed: () {
                              double latitude = data.position.latitude;
                              double longitude = data.position.longitude;
                              _openMaps(latitude, longitude);
                            },
                            child: Center(
                              child: Text(
                                'Открыть в "Картах?"',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Column(
                      children: _buildRecyclingIcons(
                          data.recyclingItems, extraItemsCount),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool isPointOpen(DateTime openingTime, DateTime closingTime) {
    final now = DateTime.now();
    final currentTime = DateTime(0, 1, 1, now.hour, now.minute);
    return currentTime.isAfter(openingTime) &&
        currentTime.isBefore(closingTime);
  }

  //билдит иконки сырья до 3 штук
  List<Widget> _buildRecyclingIcons(List<String> items, int extraItemsCount) {
    List<Widget> recyclingWidgets = [];
    recyclingWidgets.add(SizedBox(height: 8.0));
    for (int i = 0; i < (items.length > 3 ? 2 : items.length); i++) {
      recyclingWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Container(
            width: 94,
            height: 25,
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            decoration: BoxDecoration(
              color: Color(0xFF20402B),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              items[i],
              style: TextStyle(
                color: Color(0xFF11C44C),
                fontFamily: 'Montserrat',
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    }

    //Проверяет на колво принимаемого сырья, если больше 3 - 3 иконка становится счетчиком оставшихся
    if (items.length > 3) {
      recyclingWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: SizedBox(
            width: 94,
            height: 25,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF20402B),
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: items.map((item) {
                            return Container(
                              width: 94,
                              height: 25,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              margin: EdgeInsets.symmetric(vertical: 2.0),
                              decoration: BoxDecoration(
                                color: Color(0xFF20402B),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                item,
                                style: TextStyle(
                                  color: Color(0xFF11C44C),
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                );
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.of(context).pop();
                });
              },
              child: Text(
                '+ ещё $extraItemsCount',
                style: TextStyle(
                  color: Color(0xFF11C44C),
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );
    }

    return recyclingWidgets;
  }
}

class FullMap extends StatefulWidget {
  final ValueNotifier<List<RecyclingCardData>> cardsData;
  final PanelController panelController;

  FullMap({super.key, required this.cardsData, required this.panelController});

  @override
  State<FullMap> createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MapboxMap? mapboxMap;
  PointAnnotation? pointAnnotation;
  PointAnnotationManager? pointAnnotationManager;
  CameraOptions? initialCameraOptions;
  bool isLocationLoaded = false;
  bool isCameraOnUserLocation = false;
  geolocator.Position? currentUserLocation;
  Timer? cameraCheckTimer;


  Future<void> getLocation() async {
    var status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      _enableLocationComponent();
    } else {
      _showPermissionDeniedDialog();
    }
  }


  @override
  void initState() {
    super.initState();
    _loadPreviousLocation();
    widget.cardsData.addListener(_onCardsDataChanged); // Listen for changes
  }

  @override
  void dispose() {
    widget.cardsData.removeListener(_onCardsDataChanged); // Clean up listener
    cameraCheckTimer?.cancel();
    super.dispose();
  }

    // When cardsData updates, rebuild the map and add markers
  void _onCardsDataChanged() {
    setState(() {
      _deleteAllMarkers();
      _addMarkers();
    });
  }

  Future<void> _loadPreviousLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final double? longitude = prefs.getDouble('longitude');
    final double? latitude = prefs.getDouble('latitude');

    if (longitude != null && latitude != null) {
      setState(() {
        initialCameraOptions = CameraOptions(
          center: Point(coordinates: Position(longitude, latitude)),
          zoom: 14,
          bearing: 0,
          pitch: 5,
        );
      });
    }
    setState(() {
      isLocationLoaded = true;
    });
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    Provider.of<MapboxMapProvider>(context, listen: false).setMapboxMap(mapboxMap);
    getLocation();
    _addMarkers();
  }

  Future<void> _onCameraChangeListener(
      CameraChangedEventData cameraChangedEventData) async {
    if (isCameraOnUserLocation == true) {
      setState(() {
        isCameraOnUserLocation = false;
        print('Dzher Dzher');
        widget.panelController.close();
      });
    }
  }


  Future<void> _enableLocationComponent() async {
    if (mapboxMap != null) {
      await mapboxMap!.location.updateSettings(LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        showAccuracyRing: true,
      ));
      _moveCameraToPosition();
    }
  }

  Future<void> _moveCameraToPosition() async {
    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition(
      desiredAccuracy: geolocator.LocationAccuracy.high,
    );
    currentUserLocation = position;

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

    Timer(Duration(milliseconds: 550), () {
        setState(() {
          isCameraOnUserLocation = true;
          widget.panelController.close();
        });
    });

    _saveLocation(position.longitude, position.latitude);
    
  }

  Future<void> _saveLocation(double longitude, double latitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('longitude', longitude);
    await prefs.setDouble('latitude', latitude);
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Доступ к местоположению запрещен'),
          backgroundColor: Color(0xFF1D2024),
          content: Text(
            'Для корректной работы приложению требуется доступ к Вашему местоположению.\nПожалуйста откройте приложение настройки и дайте доступ.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Перейти в настройки'),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Не давать доступ'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addMarkers() async {
    for (var card in widget.cardsData.value) {
      _addMarker(card);
    }
  }


  Future<void> _addMarker(RecyclingCardData card) async{

    if (mapboxMap == null) return;

    pointAnnotationManager =
        await mapboxMap!.annotations.createPointAnnotationManager();

    final ByteData bytes = await rootBundle.load('assets/icons/marker.png');
    final Uint8List list = bytes.buffer.asUint8List();
    PointAnnotation annotation = (await pointAnnotationManager!.create(
        PointAnnotationOptions(
          geometry: Point(
              coordinates:
                  Position(card.position.longitude, card.position.latitude)),
          image: list,
        ),
      ));

      pointAnnotations.add(annotation);
      card.id2 = annotation.id;
      print("Annotation id: ${card.id2}");
      pointAnnotationManager?.addOnPointAnnotationClickListener(
          AnnotationClickListener(context, widget.cardsData.value, mapboxMap!));
  }

  Future<void> _deleteAllMarkers() async {
    if (mapboxMap == null) return;

    await pointAnnotationManager!.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    MapboxOptions.setAccessToken(
      'pk.eyJ1IjoicHJvamVjdGZmb2tpbGRhbSIsImEiOiJjbHVnc2dueGQxMGZqMmpyb3M4M3Zta3diIn0.Wt5JARj1tQmWb4rInzhKBg',
    );

    return Scaffold(
      body: MapWidget(
              key: ValueKey("mapWidget"),
              onMapCreated: _onMapCreated,
              onCameraChangeListener: _onCameraChangeListener,
              cameraOptions: initialCameraOptions ??
                  CameraOptions(anchor: ScreenCoordinate(x: 0, y: 0)),
              styleUri:
                  'mapbox://styles/projectffokildam/cm1aw1wcn02h801pmeiqf9wbd',
            ),

    );
  }
}
