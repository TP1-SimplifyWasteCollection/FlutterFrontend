import 'package:flutter/material.dart';

class AboutWindow extends StatelessWidget {
  const AboutWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline),
      tooltip: 'Показать разработчиков',
      onPressed: () {
        Navigator.push(context, MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('О приложении'),
                flexibleSpace: FlexibleSpaceBar(
                  background:
                      Image.asset('assets/Header.png', fit: BoxFit.cover),
                ),
              ),
              body: const Center(
                child: Text(
                  'Z V ликвидация💩💩💩.\nНаписал Санёк',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            );
          },
        ));
      },
    );
  }
}
