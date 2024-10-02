// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:testmap/pages/appbar.dart';
import 'package:testmap/pages/slidingpanel.dart';

import 'map_screen.dart';
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
  final ValueNotifier<String> _currentScreenNotifier = ValueNotifier('RecycleMeMain');
  final PanelController _panelController = PanelController();
  final ValueNotifier<List<RecyclingCardData>> _cardsDataNotifier = ValueNotifier([]);

  void addCard(RecyclingCardData newCard) {
    setState(() {
      _cardsDataNotifier.value.add(newCard);
    });
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
      List<dynamic> data = jsonDecode(response.body);
      _cardsDataNotifier.value = data.map((json) => RecyclingCardData.fromJson(json)).toList();
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
    return Scaffold(
      appBar: MainAppBar(),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SlidingUpPanel(
            controller: _panelController,
            maxHeight: MediaQuery.of(context).size.height - 100,
            minHeight: 230,
            panelBuilder: (ScrollController sc) => _buildSlidingPanel(sc, context),
            body: FullMap(cardsData: _cardsDataNotifier),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            backdropEnabled: true,
            backdropOpacity: 1.0,
            backdropColor: Color(0xFF1D2024),
            color: Color(0xFF1D2024),
          ),
        ],
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
          SlidingPanelContent(cardsData: _cardsDataNotifier.value, addCard: addCard),
        ],
      ),
    );
  }
}
