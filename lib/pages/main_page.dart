// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:testmap/pages/appbar.dart';
import 'package:testmap/pages/slidingpanel.dart';

import 'map_screen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RecycleMeMain extends StatefulWidget {
  const RecycleMeMain({super.key});

  @override
  State<RecycleMeMain> createState() => _RecycleMeMainState();
}

class _RecycleMeMainState extends State<RecycleMeMain> {
  final ValueNotifier<String> _currentScreenNotifier =
      ValueNotifier('RecycleMeMain');
  final PanelController _panelController = PanelController();

  List<RecyclingCardData> _cardsData = [
    RecyclingCardData(
      name: 'МирВторСырья',
      address: 'ул. Извилистая, 13',
      phone: '89889431886',
      openingHour: DateTime(0, 1, 1, 9, 0),
      closingHour: DateTime(0, 1, 1, 21, 0),
      recyclingItems: ['Бумага', 'Пластик', 'Метал', 'Метал'],
      position: LatLng(37.425496, -122.088060),
      id: '1',
    ),
    RecyclingCardData(
      name: 'ЭкоПункт',
      address: 'ул. Прямая, 24',
      phone: '1234567890',
      openingHour: DateTime(0, 1, 1, 9, 0),
      closingHour: DateTime(0, 1, 1, 23, 0),
      recyclingItems: ['Шины'],
      position: LatLng(37.421015, -122.087567),
      id: '2',
    ),
  ];
 

  @override
  void dispose() {
    _currentScreenNotifier.dispose();
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
            maxHeight: MediaQuery.of(context).size.height-100,
            minHeight: 230,
            panelBuilder: (ScrollController sc) =>
                _buildSlidingPanel(sc, context),
            body: FullMap(cardsData: _cardsData,),
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
        SlidingPanelContent(cardsData: _cardsData,), 
      ],
    ),
    );
  }

}
