import 'package:flutter/material.dart';
import 'package:testmap/pages/login.dart';

import 'map_screen.dart';

import 'package:testmap/screens/collection_points_view.dart'; // Updated import

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
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(child: Icon(Icons.recycling, size: 48)),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                "Настройки",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settingspage');
              },
            ),
            ListTile(
              leading: Icon(Icons.info_rounded),
              title: Text(
                "О приложении",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/aboutpage');
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('RecycleME'),
        flexibleSpace: FlexibleSpaceBar(
          background: Image.asset('assets/Header.png', fit: BoxFit.cover),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showDialog(context: context, builder: (BuildContext context){
                return LoginPage();
              });
            },
            icon: Icon(Icons.login_rounded),
          )
        ],
      ),
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
