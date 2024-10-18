import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testmap/pages/about.dart';
import 'package:testmap/pages/login.dart';
import 'package:testmap/pages/profile_page.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  MainAppBar({super.key}) : preferredSize = Size.fromHeight(60.0);

  @override
  final Size preferredSize;

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  ValueNotifier<bool> isLoggedIn = ValueNotifier(false); // Track login state

  @override
  void initState() {
    super.initState();
  }

  void updateLoginStatus(bool status) {
    isLoggedIn.value = status; // Update login state
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF1D2024),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      leading: Navigator.canPop(context)
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset('assets/buttonClose.svg'),
            )
          : Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutPage(),
                    ),
                  );
                },
                icon: SvgPicture.asset('assets/button_info.svg'),
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
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: ValueListenableBuilder<bool>(
            valueListenable: isLoggedIn,
            builder: (context, loggedIn, child) {
              return IconButton(
                onPressed: () {
                  if (loggedIn) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );

                  } else {
                    showDialog(
                      context: context,

                      builder: (BuildContext context) {
                        return LoginPage(
                          onLoginSuccess: () {
                            updateLoginStatus(true); // Set login status to true
                          },
                        );
                      },
                    );
                  }
                },
                icon: SvgPicture.asset(
                  loggedIn
                          ? 'assets/profile.svg'
                          : 'assets/login.svg', // Change icon based on login state
                ),
                padding: EdgeInsets.only(bottom: 5.0),
                constraints: BoxConstraints(),
              );
            },
          ),
        ),
      ],
    );
  }
}
