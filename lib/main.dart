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
    final int primaryColor = 0xFF0B76EB;
    final int secondaryColor = 0xFF2C95F9;

    return MaterialApp(
      title: 'NewsKard',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Color(primaryColor),
        accentColor: Color(secondaryColor)
      ),
      home: Scaffold(
        /* NOT adding AppBar */
        body: Cards(), // Invoke Cards Widget
        backgroundColor: Colors.white
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return app();
  }
}