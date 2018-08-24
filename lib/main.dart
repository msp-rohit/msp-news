import 'package:flutter/material.dart';
import 'cards/all-cards.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var splash = true;

  @override
  void initState (){
    super.initState();
    splash = true;
    new Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        splash = false;
      });
    });
  }

  Widget app() {
    return MaterialApp(
      title: 'NewsKard',
      theme: ThemeData(fontFamily: 'Google Sans', primarySwatch: Colors.blue),
      home: Scaffold(
        /* NOT adding AppBar */
        body: Cards(), // Invoke Cards Widget
        backgroundColor: const Color(0xFFecf0f1)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return splash ? MaterialApp(
        title: 'NewsKard',
        home: SplashScreen()
    ) : app();
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Widget splashScreen(context) {
    String newsKardImg = 'images/newskard.png';
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(newsKardImg),
          fit: BoxFit.cover,
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return splashScreen(context);
  }
}