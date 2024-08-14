import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'api_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Networking and API Integration',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/api': (context) => ApiScreen(),
      },
    );
  }
}
