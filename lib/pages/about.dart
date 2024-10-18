import 'package:flutter/material.dart';
import 'package:testmap/pages/appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class NameRoleText extends StatelessWidget {
  final String name;
  final String role;

  const NameRoleText({
    Key? key,
    required this.name,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$name - ',
            style: const TextStyle(
              fontFamily: 'Montserrat',
              color: Color(0xFFF5F7FA),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: role,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              color: Color(0xFFF5F7FA),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class HyperlinkWithIcon extends StatelessWidget {
  final String url;
  final String text;

  const HyperlinkWithIcon({
    required this.url,
    required this.text,
  });

  void _launchURL() async {
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchURL,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
              'assets/telegram.png',height: 25,),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1D2024),
        appBar: MainAppBar(),
        body: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'О приложении',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Color(0xFFF5F7FA),
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Контейнер что это вообще
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Card(
                color: const Color(0xFF2F3135),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Приложение создано командой студентов ИКТИБ ЮФУ по кейсу от компании AiweApps.',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xFFF5F7FA),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            // Контейнер с инфо о нас
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Card(
                color: const Color(0xFF2F3135),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Состав Команды',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xFFF5F7FA),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      NameRoleText(
                        name: 'Кравченко Александр',
                        role: 'капитан, Fullstack разработчик',
                      ),
                      SizedBox(height: 8),
                      NameRoleText(
                          name: 'Алферьев Даниил',
                          role: 'дизайнер, Frontend разработчик.'),
                      SizedBox(height: 8),
                      NameRoleText(
                          name: 'Кузамишев Залим', role: 'Backend разработчик'),
                      SizedBox(height: 8),
                      NameRoleText(
                          name: 'Домбрина Алёна',
                          role: 'дизайнер, SMM - специалист'),
                      SizedBox(height: 8),
                      NameRoleText(name: 'Бачурина Анна', role: 'тестировщик'),
                      SizedBox(height: 8),
                      NameRoleText(
                          name: 'Косенко Станислав',
                          role: 'системный аналитик'),
                      SizedBox(height: 8),
                      NameRoleText(
                          name: 'Ванин Матвей', role: 'SMM - специалист'),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Card(
                color: const Color(0xFF2F3135),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Стек приложения',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Color(0xFFF5F7FA),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'Flutter + Spring + PostgreSQL',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Color(0xFFF5F7FA),
                              fontSize: 14
                          ),
                        )
                      ],
                    )),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Card(
                color: const Color(0xFF2F3135),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Связь с разработчиком',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Color(0xFFF5F7FA),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        HyperlinkWithIcon(url: 'https://t.me/w6rs7', text: '@w6rs7')
                      ],
                    )),
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Версия приложения: 0.0.7(7)',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Color(0xFFF5F7FA),
                  fontSize: 14
              ),
            )
          ],
        ));
  }
}
