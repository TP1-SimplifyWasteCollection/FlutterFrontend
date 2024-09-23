import 'package:flutter/material.dart';
import 'package:testmap/pages/appbar.dart';


import 'map_screen.dart';

import 'package:testmap/screens/collection_points_view.dart';


class RecycleMeMain extends StatefulWidget {
  const RecycleMeMain({super.key});

  @override
  State<RecycleMeMain> createState() => _RecycleMeMainState();
}

class _RecycleMeMainState extends State<RecycleMeMain> {
  final ValueNotifier<String> _currentScreenNotifier =
      ValueNotifier('RecycleMeMain');
  List<String> items = List.generate(10, (index) => 'Item $index');
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
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: FullMap(),
            ),
          ),
          CollectionPointsView(
            items: items,
            isExpanded: isExpanded,
            onToggleExpanded: toggleListView,
            onSort: sortItems,
          ),
        ],
      ),
    );
  }
}
