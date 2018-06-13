import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:io' show File, Platform;
import 'package:share/share.dart';
import 'models.dart';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {

  final FirebaseApp app = await FirebaseApp.configure(
    name: 'msp-news',
    options: Platform.isIOS
        ? const FirebaseOptions(
      googleAppID: '1:913242906809:ios:51b07fa25fd6c39e',
      gcmSenderID: '913242906809',
      databaseURL: 'https://msp-news.firebaseio.com/',
    )
        : const FirebaseOptions(
      googleAppID: '1:913242906809:android:51b07fa25fd6c39e',
      apiKey: 'AIzaSyC284_9DvLbA24Gv42UiXacn2dQC0Bwxts',
      databaseURL: 'https://msp-news.firebaseio.com/',
    ),
  );

  runApp(new MyAppWrapper(app: app));
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return new File('$path/news.json');
}

class MyAppWrapper extends StatefulWidget {

  MyAppWrapper({this.app});
  final FirebaseApp app;

  @override
  _MyAppWrapperState createState() => new _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper> {

  int offset = 0;
  int perPage = 30;

  List<NewsItem> newsData = [];
  int activeNewsIndex = 0;

  @override
  void initState() {

    final FirebaseDatabase dbRef = FirebaseDatabase(app: widget.app);
    DatabaseReference itemRef = dbRef.reference();

    itemRef.once().then((DataSnapshot value) {
      print(value.value);

//      writeIntoLocal(value.value);
//      readFromLocal();
    });

    super.initState();
  }

  Future readFromLocal() async {

    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      print(contents);

    } catch (e) {
      // If we encounter an error, return 0
      print("error1");
    }

  }

  Future writeIntoLocal(value) async {

    final file = await _localFile;
    file.writeAsString(value.value);

  }

  @override
  Widget build(BuildContext context) {
    return new MyApp();
  }
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'News App',
      home: new Scaffold(
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.share),
          onPressed: () {
            final shareUrl = "hellow rol here";
            final RenderBox box = context.findRenderObject();
            Share.share(
                shareUrl,
                sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
            );
          },
        ),
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
                child: new CardFlipper()
            ),
          ],
        ),
      ),
    );
  }
}



class CardFlipper extends StatefulWidget {
  @override
  _CardFlipperState createState() => new _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper> with TickerProviderStateMixin {

  double scrollPercent = 0.0;
  int numberCards = 10;
  int cardsVisible = 3;
  bool pageUpdated = false;
  int activeCardIndex = 0;
  Offset startDrag; //where on the screen dragging starts
  double startDragPercentScroll; //scroll percent when dragging starts

  // these two are needed because of the animation if the user leaves the card drag before reaching the proper position
  double finishScrollStart;
  double finishScrollEnd;
  AnimationController finishScrollController;

  int scrollDirection;
  // 1 is up
  // -1 is down

  @override
  void initState() {

    super.initState();

    finishScrollController = new AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    )
      ..addListener(() {
        // it runs every time animation changes
        setState(() {
          // lerpDouble is a linear interpolation
          // given start and end value for every instance
          scrollPercent = lerpDouble(finishScrollStart, finishScrollEnd, finishScrollController.value);//

          if(scrollPercent == finishScrollEnd) {
            // clamping activeCardIndex between 0 and cardsVisible
            activeCardIndex = (scrollDirection == 1 ? activeCardIndex - 1 : activeCardIndex + 1).clamp(0, cardsVisible-1);
          }
        });
      });
  }

  @override
  void dispose() {

    finishScrollController.dispose();
    super.dispose();

  }

  void _onVerticalDragStart(DragStartDetails details) {

    startDrag = details.globalPosition;
    startDragPercentScroll = scrollPercent;

  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {

    final currentDrag = details.globalPosition;
    final dragDistance = currentDrag.dy - startDrag.dy;
    final singleCardDragPercent = dragDistance / context.size.height;

    if(dragDistance.abs() > 10) {
      setState(() {
        scrollPercent = (startDragPercentScroll + (-singleCardDragPercent / cardsVisible)).clamp(0.0, 1.0);
        scrollDirection = dragDistance > 0 ? 1 : -1;
        if(scrollDirection == 1 && !pageUpdated) {
          // going down
          pageUpdated = true;
          activeCardIndex = (activeCardIndex - 1).clamp(0, cardsVisible-1);
        }
      });
    }

  }

  void _onVerticalDragEnd(DragEndDetails details) {

    // start the animation from where the user left
    finishScrollStart = scrollPercent;
    pageUpdated = false;

    if(scrollDirection == 1 )
      finishScrollEnd = (scrollPercent * cardsVisible).floor() / cardsVisible;
    else
      finishScrollEnd = (scrollPercent * cardsVisible).ceil() / cardsVisible;
    finishScrollController.forward(from: 0.0);
    setState(() {
      startDrag = null;
      startDragPercentScroll = null;
    });

  }


  List<Widget> _buildCards() {

    List<Widget> tempWidgets = [];

    int startOffset = activeCardIndex > 0 ? 0 : 1;

    if(activeCardIndex < numberCards-1)
      tempWidgets.add(_buildCard(2 - startOffset, cardsVisible, scrollPercent, activeCardIndex+1));

    tempWidgets.add(_buildCard(1 - startOffset, cardsVisible, scrollPercent, activeCardIndex));

    if(activeCardIndex > 0)
      tempWidgets.add(_buildCard(1 - startOffset, cardsVisible, scrollPercent, activeCardIndex-1));

    return tempWidgets;
  }

  Widget _buildCard(int cardIndex, int totalCards, double scrollPercent, int globalCardIndex) {

    final cardScrollPercent = scrollPercent / (1 / totalCards);

    double yOffset = 0.0;

    BoxShadow bs = new BoxShadow(blurRadius: 0.0);

    if(cardIndex == activeCardIndex) {
      yOffset = activeCardIndex - cardScrollPercent;
//      bs = new BoxShadow(
//        blurRadius: 20.0,
//        color: Colors.white30,
//        offset: const Offset(0.0, 0.1),
//      );
    }
    else if(cardIndex < activeCardIndex) {
      // the card has already been swiped
      yOffset = -1.0;
    }

    return FractionalTranslation(
      child: new Container(
        decoration: new BoxDecoration(
          boxShadow: [
            bs
          ],
        ),
        child: new Card(globalCardIndex: globalCardIndex),
      ),
      translation: new Offset(0.0, yOffset),
    );

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      behavior: HitTestBehavior.translucent,
      // just to get the event callback even if the user clicks anywhere in the transparent area

      child: Stack(
        children: _buildCards(),
      ),
    );
  }
}

class Card extends StatefulWidget {

  Card({this.globalCardIndex});
  final int globalCardIndex;

  @override
  _CardState createState() => new _CardState();
}

class _CardState extends State<Card> {

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height - 30.0;

    return new Container(
      color: Colors.white,
      child: new ConstrainedBox(
        constraints: new BoxConstraints(
          minWidth: double.infinity,
          minHeight: screenHeight,
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new ConstrainedBox(
              constraints: new BoxConstraints(minWidth: double.infinity, minHeight: screenHeight*0.4),
              child: new Image.network(
                  "https://www.w3schools.com/howto/img_fjords.jpg",
                  fit: BoxFit.cover
              ),
            ),
            new Padding(
              padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
              child: new Text(
                "hello wrold" + widget.globalCardIndex.toString(),
                style: new TextStyle(
                    color: Colors.black,
                    fontSize: 24.0
                ),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    "Shirish Kumar",
                    style: new TextStyle(
                        color: Colors.black38,
                        fontSize: 13.0,
                        letterSpacing: 0.5
                    ),
                  ),
                  new Text(
                    "Some time ago",
                    style: new TextStyle(
                        color: Colors.black38,
                        fontSize: 13.0,
                        letterSpacing: 0.5
                    ),
                  ),
                ],
              ),
            ),
            new Expanded(
                child: new Padding(
                  padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                  child: new ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: screenHeight*0.5,
                      minWidth: double.infinity,
                    ),
                    child: new Text(
                      "complete news article will come here!",
                      style: new TextStyle(
                          color: Colors.black87,
                          fontSize: 16.0,
                          letterSpacing: 0.7
                      ),
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}


class NewsData {

}