import 'package:flutter/material.dart';
import './home/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro',
      theme: ThemeData.dark(),
      home: HomePage(title: 'Pomodoro'),
    );
  }
}
