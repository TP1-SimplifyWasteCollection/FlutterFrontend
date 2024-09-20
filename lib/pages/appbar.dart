import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testmap/pages/login.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  MainAppBar({super.key})
      : preferredSize = Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF8E8E8E),
      leading: Padding(
        padding: EdgeInsets.only(left: 8.0), 
        child: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset('assets/menu.svg'),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
      ),
      flexibleSpace: Container(
        alignment: Alignment.bottomLeft, 
        padding: EdgeInsets.only(left: 56.0, bottom: 19.0), 
        child: SvgPicture.asset(
          'assets/logo.svg', 
          height: 25,
        ),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset('assets/add_point.svg'),
          padding:  EdgeInsets.only(bottom: 5.0),
          constraints: BoxConstraints(),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16.0), 
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return LoginPage(); 
                },
              );
            },
            icon: SvgPicture.asset('assets/login.svg'),
            padding: EdgeInsets.only(bottom: 5.0),
            constraints: BoxConstraints(),
          ),
        ),
      ],
    );
  }
}