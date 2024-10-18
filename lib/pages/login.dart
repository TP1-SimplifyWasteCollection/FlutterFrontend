import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors
            .transparent, // Transparent background to avoid default dialog padding
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // Custom width
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: Color(0xFF1D2024),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Войти в аккаунт',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xFFF5F7FA),
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Login TextField
                  Container(
                    width: 300,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xFF2F3135),
                    ),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Логин',
                        hintStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFFF5F7FA),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Password TextField
                  Container(
                    width: 300,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xFF2F3135),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        hintText: 'Пароль',
                        hintStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFFF5F7FA),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                      width: 275,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Color(0xFF005BFF),
                        borderRadius: BorderRadius.circular(20.0),
                      ), // Height of the button
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Center(
                          child: Text(
                            'Войти',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              color: Color(0xFFF5F7FA),
                              fontFamily: 'MontserratBold',
                              fontSize: 18,
                            ),
                          ),
                        ),
                        onPressed: () {
                          widget.onLoginSuccess();
                          Navigator.of(context).pop();
                        },
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'или',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 275,
                    height: 40,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Image.asset(
                        'assets/loginyandex.png',
                        fit: BoxFit.contain,
                        width: 275,
                        height: 40,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Нет аккаунта?',
                            style: TextStyle(
                              fontFamily: 'MontserratBold',
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          TextSpan(
                            text: ' Зарегистриуйтесь',
                            style: TextStyle(
                              fontFamily: 'MontserratBold',
                              color: Color(0xFF005BFF),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
