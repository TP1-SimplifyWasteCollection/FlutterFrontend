import 'package:flutter/material.dart';
import 'package:testmap/pages/appbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            body: FullMap(),
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
        SlidingPanelContent(), 
      ],
    ),
    );
  }

}
