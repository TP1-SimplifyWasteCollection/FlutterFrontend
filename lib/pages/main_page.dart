import 'package:flutter/material.dart';
import 'package:testmap/pages/appbar.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  List<String> items = List.generate(10, (index) => 'Item $index');
  final PanelController _panelController = PanelController();
  bool isAscending = true;
  bool isExpanded = false;
  bool isMenuOpened = false;

  @override
  void dispose() {
    _currentScreenNotifier.dispose();
    super.dispose();
  }

  void sortItems() {
    setState(() {
      items.sort((a, b) => isAscending ? a.compareTo(b) : b.compareTo(a));
      isAscending = !isAscending;
    });
  }

  void toggleListView() {
    setState(() {
      isExpanded = !isExpanded;
    });
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
            maxHeight: 780,
            minHeight: 200, 
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

  // Build the sliding panel content
  Widget _buildSlidingPanel(ScrollController sc, BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        controller: sc,
        children: <Widget>[
          SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset('assets/arrowUp.svg'),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Что вы хотите сдать?",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  color: Color(0xFFF5F7FA),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
