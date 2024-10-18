import 'package:flutter/material.dart';

import 'appbar.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Center(
        child: Text(
          'Z V likvidacia',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Color(0xFF1D2024),
    );
  }
}
