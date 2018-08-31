import 'package:flutter/material.dart';
import 'cards/all-cards.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState (){
    super.initState();
  }

  Widget app() {
    return MaterialApp(
      title: 'NewsKard',
      theme: ThemeData(
        fontFamily: 'Poppins', 
        primaryColor: const Color(0xFF8D5800),
        accentColor: const Color(0xFFF5A623)
      ),
      home: Scaffold(
        /* NOT adding AppBar */
        body: Cards(), // Invoke Cards Widget
        backgroundColor: const Color(0xFFecf0f1)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return app();
  }
}