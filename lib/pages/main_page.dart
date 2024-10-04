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
        appBar: MainAppBar(),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            SlidingUpPanel(
              controller: _panelController,
              maxHeight: MediaQuery.of(context).size.height - 100,
              minHeight: 230,
              panelBuilder: (ScrollController sc) =>
                  _buildSlidingPanel(sc, context),
              body: FullMap(cardsData: _cardsDataNotifier),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              backdropEnabled: true,
              backdropOpacity: 1.0,
              backdropColor: Color(0xFF1D2024),
              color: Color(0xFF1D2024),
              onPanelOpened: () {
                _fetchRecyclingPoints();
              },
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
        controller: sc,
        children: <Widget>[
          SlidingPanelContent(cardsData: _cardsDataNotifier, addCard: addCard, panelController: _panelController,),
        ],
      ),
    );
  }
}
