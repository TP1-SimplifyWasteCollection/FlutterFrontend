// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:testmap/pages/appbar.dart';
import 'package:testmap/pages/slidingpanel.dart';

import 'map_screen.dart';
import 'package:provider/provider.dart';
import 'package:testmap/mapbox_map_provider.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'dart:convert'; // For jsonDecode
import 'package:http/http.dart' as http;

List<RecyclingCardData> _cardsData = [];
List<RecyclingCardData> get cardsData => _cardsData;
set cardsData(List<RecyclingCardData> newData) {
  _cardsData = newData;
}

class RecycleMeMain extends StatefulWidget {
  const RecycleMeMain({super.key});


  @override
  State<RecycleMeMain> createState() => _RecycleMeMainState();
}

class _RecycleMeMainState extends State<RecycleMeMain> {
  final ValueNotifier<String> _currentScreenNotifier =
      ValueNotifier('RecycleMeMain');
  final PanelController _panelController = PanelController();
  ValueNotifier<List<RecyclingCardData>> _cardsDataNotifier =
      ValueNotifier([]);
  double _fabHeight = 245;
  final GlobalKey<FullMapState> fullMapKey = GlobalKey<FullMapState>();
  final GlobalKey<SlidingPanelContentState> slidingPanelKey = GlobalKey<SlidingPanelContentState>();

  void addCard(RecyclingCardData newCard) async {
    // Convert the RecyclingCardData to JSON
    final Map<String, dynamic> cardData = newCard.toJson();

    // Define your API endpoint URL
    final String url = 'http://points-api.ffokildam.ru:8079/api/points'; // Replace with your API URL

    try {
      // Send a POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=utf-8', // Set the content type with UTF-8
        },
        body: jsonEncode(cardData), // Encode the JSON data
      );

      // Check the response status
      if (response.statusCode == 200 || response.statusCode == 201) {
        // If the server returns a 200 or 201 response, update the state
        setState(() {
          _fetchRecyclingPoints();
        });
      } else {
        // Handle the error if the server response is not 200 or 201
        throw Exception('Failed to add card: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions (e.g., network errors)
      print('Error adding card: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRecyclingPoints();
  }

  Future<void> _fetchRecyclingPoints() async {
    final response = await http.get(
      Uri.parse('http://points-api.ffokildam.ru:8079/api/points'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      List<RecyclingCardData> newData =
          data.map((json) => RecyclingCardData.fromJson(json)).toList();

      // Only update _cardsDataNotifier.value if the number of items has changed
      if (newData.length != _cardsDataNotifier.value.length) {
        _cardsDataNotifier.value = newData;
      }
    } else {
      throw Exception('Failed to load recycling points');
    }
  }

  @override
  void dispose() {
    _currentScreenNotifier.dispose();
    _cardsDataNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapboxMapProvider(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MainAppBar(),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // FullMap should be below the marker
            FullMap(key: fullMapKey, cardsData: _cardsDataNotifier,panelController: _panelController),
            // Center the marker PNG image at the same level as the map
            Consumer<MapboxMapProvider>(
              builder: (context, provider, child) {
                return provider.isMarkerVisible()
                    ? Positioned(
                  top: MediaQuery.of(context).size.height / 2 - 25,
                  left: MediaQuery.of(context).size.width / 2 - 25,
                  child: Image.asset(
                    'assets/icons/location.png', // Your PNG asset path
                    width: 50, // Adjust size
                    height: 50, // Adjust size
                  ),
                )
                    : Container(); // Return an empty container when not visible
              },
            ),
            // SlidingUpPanel should be above the marker
            SlidingUpPanel(
              isDraggable: slidingPanelKey.currentState?.isAddingNewCard ?? false ? false : true,
              controller: _panelController,
              maxHeight: MediaQuery.of(context).size.height - 100,
              minHeight: slidingPanelKey.currentState?.isAddingNewCard ?? false ? 70 : 230,
              panelBuilder: (ScrollController sc) =>
                  _buildSlidingPanel(sc, context),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              backdropEnabled: true,
              backdropOpacity: 1.0,
              backdropColor: Color(0xFF1D2024),
              color: Color(0xFF1D2024),
              onPanelOpened: () {
                _fetchRecyclingPoints();
              },
              onPanelSlide: (double pos) => setState(() {
                double currentMinHeight = slidingPanelKey.currentState?.isAddingNewCard ?? false ? 70 : 230;
                _fabHeight = pos * (MediaQuery.of(context).size.height - 100 - currentMinHeight+15) +
                    currentMinHeight+15;
              }),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 100, // 100 for half the width of the button (200)
              bottom: _fabHeight, // Move with FloatingActionButton
              child: AnimatedOpacity(
                opacity: slidingPanelKey.currentState?.isAddingNewCard ?? false ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300), // Adjust duration as needed
                child: Container(
                  width: 200, // Width of the button
                  height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF005BFF),
                      borderRadius: BorderRadius.circular(8.0),
                    ),// Height of the button
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // Remove default padding
                    ),
                    child: Center(
                      child: Text(
                        'Подтвердить выбор местоположения',
                        textAlign: TextAlign.center, // Center the text
                        maxLines: 2, // Allow text to wrap to 2 lines
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          color: Color(0xFFF5F7FA),
                          fontFamily: 'MontserratBold',
                          fontSize: 14,
                        ),
                      ),
                    ),
                    onPressed: (){
                      _panelController.open();
                    },
                  )
                ),
              ),
            ),
            Positioned(
              right: 20.0,
              bottom: _fabHeight,
              child: AnimatedOpacity(
                opacity: fullMapKey.currentState?.isCameraOnUserLocation ?? false ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300), // Adjust duration as needed
                child: FloatingActionButton(
                  child: Icon(
                    Icons.gps_fixed,
                    color:Color(0xFF005BFF),
                  ),
                  onPressed: () {
                    fullMapKey.currentState?.getLocation();
                  },
                  backgroundColor: Color(0xFF2F3135),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlidingPanel(ScrollController sc, BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        physics: slidingPanelKey.currentState?.isAddingNewCard ?? false ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
        controller: sc,
        children: <Widget>[
          SlidingPanelContent(key: slidingPanelKey, cardsData: _cardsDataNotifier, addCard: addCard, panelController: _panelController,scrollController: sc),
        ],
      ),
    );
  }
}
