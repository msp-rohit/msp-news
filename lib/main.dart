import 'package:flutter/material.dart';
import 'cards/all-cards.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(fontFamily: 'Google Sans', primarySwatch: Colors.blue),
      home: Scaffold(
        /* Decision taken to NOT add AppBar */
        body: Cards(), // Invoke the Cards Widget
        backgroundColor: const Color(0xFFecf0f1)
      ),
    );
  }
}