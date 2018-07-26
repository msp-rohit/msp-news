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
        // appBar: new AppBar(
        //   title: Text('News App'),
        //   backgroundColor: Colors.blue.withOpacity(0.5),
        // ),
        body: Cards(), // Invoke the Cards Widget
        backgroundColor: const Color(0xFFfefefe)
      ),
    );
  }
}