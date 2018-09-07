import 'package:flutter/material.dart';
import 'individual-card.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CardsBuilder extends StatefulWidget {
  final List cards;
  CardsBuilder({Key key, this.cards}) : super(key: key);

  @override
  _CardsBuilderState createState() => _CardsBuilderState();
}

class _CardsBuilderState extends State<CardsBuilder> with TickerProviderStateMixin {
  int index;
  bool showCurCard;
  bool showPrevCard;
  bool showNextCard;
  /* Card positions */
  double stackCardY;
  double prevCardY;
  double stackCardX;
  double prevCardX;
  /* Positioning variables */
  double yStartOffset;
  double yEndOffset;
  double xStartOffset;
  double xEndOffset;
  /* Temporary Variables/Constants */
  double tempPrevCardY;
  double tempStackCardY;
  double tempPrevCardX;
  double tempStackCardX;
  // double tempDeltaY;
  /* Constants */
  final double initialPrevPosY = -600.0;
  final double initialPrevPosX = 0.0;
  /* Screen dimensions */
  double screenHeight;
  double screenWidth;
  /* WebView flags */
  bool webViewClose;
  bool disableSwipes;

  /* Animation Controllers */
  AnimationController flyOutY; Animation<double> _flyOutY;
  AnimationController flyInY; Animation<double> _flyInY;
  AnimationController flyOutX; Animation<double> _flyOutX;
  AnimationController flyInX; Animation<double> _flyInX;

  @override
  void initState() {
    super.initState();
    /* If description is cut, add "..(more)" */
    for(var i = 0; i < widget.cards.length - 1; i++) {
      if(!widget.cards[i].description.endsWith('.')) {
        widget.cards[i].description += "..";
      }
    }
    /* Display related card variables */
    index = -1;
    showPrevCard = index >= 0;
    showCurCard = index + 1 < widget.cards.length;
    showNextCard = index + 2 < widget.cards.length;
    /* Card positions */
    stackCardY = 0.0;
    prevCardY = initialPrevPosY; // Only initially (changed with gesture or widget creation)
    stackCardX = 0.0;
    prevCardX = 0.0;
    /* Positioning variables */
    yStartOffset = 0.0;
    yEndOffset = 0.0;
    xStartOffset = 0.0;
    xEndOffset = 0.0;
    /* Temporary Variables/Constants */
    tempPrevCardY = prevCardY;
    tempStackCardY = stackCardY;
    tempPrevCardX = prevCardX;
    tempStackCardX = stackCardX;
    /* WebView */
    webViewClose = false;
    disableSwipes = false;

    /* Animation logic */
    /* Vertical: */
    flyOutY = new AnimationController(duration: const Duration(milliseconds: 280), vsync: this);
    _flyOutY = new CurvedAnimation(parent: flyOutY, curve: Curves.easeInOut);
    _flyOutY.addListener(() {
      /* Next card */
      if(index != widget.cards.length - 1) {
        setState(() {
          stackCardY = _flyOutY.value * tempPrevCardY;
          if(flyOutY.value == 1) resetParams(true, false);
        });
      }
    });
    flyInY = new AnimationController(duration: const Duration(milliseconds: 280), vsync: this);
    _flyInY = new CurvedAnimation(parent: flyInY, curve: Curves.easeInOut);
    _flyInY.addListener(() {
      /* Prev card */
      if(index > -1) {
        setState(() {
          prevCardY = tempPrevCardY - (_flyInY.value * tempPrevCardY);
          if(flyInY.value == 1) resetParams(false, false);
        });
      }
    });
    /* Horizontal: */
    flyOutX = new AnimationController(duration: const Duration(milliseconds: 280), vsync: this);
    _flyOutX = new CurvedAnimation(parent: flyOutX, curve: Curves.easeInOut);
    _flyOutX.addListener(() {
      /* Next card */
      if(index != widget.cards.length - 1) {
        setState(() {
          stackCardX = -(_flyOutX.value * screenWidth);
          if(flyOutX.value == 1) resetParams(true, false);
        });
      }
    });
    flyInX = new AnimationController(duration: const Duration(milliseconds: 280), vsync: this);
    _flyInX = new CurvedAnimation(parent: flyInX, curve: Curves.easeInOut);
    _flyInX.addListener(() {
      /* Prev card */
      if(index > -1) {
        setState(() {
          if(flyInX.value == 0) {
            prevCardX = -screenWidth;
            tempPrevCardX = prevCardX;
            prevCardY = 0.0;
          }
          prevCardX = tempPrevCardX + (_flyInX.value * screenWidth);
          if(flyInX.value == 1) resetParams(false, false);
        });
      }
    });
  }

  /* Custom Functions: */
  void resetParams(forward, noChange) {
    if(!noChange) {
      if(forward) index++;
      else index--;
    }
    showPrevCard = index >= 0;
    showCurCard = index + 1 < widget.cards.length;
    showNextCard = index + 2 < widget.cards.length;
    /* Card Pos */
    stackCardY = 0.0;
    prevCardY = initialPrevPosY;
    stackCardX = 0.0;
    prevCardX = 0.0;
    /* Pos vars */
    yStartOffset = 0.0;
    yEndOffset = 0.0;
    xStartOffset = 0.0;
    xEndOffset = 0.0;
    /* Temp vars */
    tempPrevCardY = prevCardY;
    tempStackCardY = stackCardY;
    tempPrevCardX = prevCardX;
    tempStackCardX = stackCardX;
    /* WebView */
    webViewClose = false;
    disableSwipes = false;
  }
  double prevInitialPositionY(context) {
    tempPrevCardY = -(screenHeight);
    return tempPrevCardY;
  }
  double prevInitialPositionX(context) {
    tempPrevCardX = 0.0;
    return tempPrevCardX;
  }

  /* Web view state functions */
  void showWebView() {
    return setState(() {
      disableSwipes = true;
      webViewClose = true;
    });
  }
  void hideWebView() {
    return setState(() {
      disableSwipes = false;
      webViewClose = false;
    });
  }
  Widget webViewManager() {
    return webViewClose ? Positioned(
      top: 0.0,
      left: 0.0,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GestureDetector(
        onTap: () {
          final flutterWebviewPlugin = new FlutterWebviewPlugin();
          flutterWebviewPlugin.close();
          hideWebView();
        },
        child: Container(
          color: const Color(0xFFFFFFFF),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 72.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5A623),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: const Color(0xffDFE1E8),
                      offset: Offset(0.0, 1.0),
                      blurRadius: 2.0,
                    )
                  ]
                ),
                padding: EdgeInsets.only(top: 35.0, bottom: 10.0, left: 10.0, right: 10.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_back, 
                      color: Color(0xFFFFFFFF)
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: Text(
                        'newskard', 
                        style: TextStyle(
                          fontSize: 18.0,
                          color: const Color(0xFFFFFFFF)
                        )
                      )
                    ),
                    Expanded(child: Container())
                  ]
                )
              ),
              Expanded(
                child: Center(
                  child: CircularProgressIndicator()
                )
              )
            ]
          )
        )
      )
    ) : Text(''); 
  }

  /* Widget: */
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    prevCardY = (prevCardY == initialPrevPosY) ? prevInitialPositionY(context) : prevCardY; // Changed on widget creation
    prevCardX = (prevCardX == initialPrevPosX) ? prevInitialPositionX(context) : prevCardX; // Changed on widget creation
    return GestureDetector(
      onTap: () { /* Do nothing */ },
      onVerticalDragStart: (details) {
        if(disableSwipes) return;
        yStartOffset = details.globalPosition.dy;
        yEndOffset = yStartOffset;
      },
      onVerticalDragUpdate: (details) {
        if(disableSwipes) return;
        yEndOffset = details.globalPosition.dy;
      },
      onVerticalDragEnd: (details) {
        if(disableSwipes) return;
        double distance = yEndOffset - yStartOffset;
        double thresholdValue = 160.0;
        /* Velocity Crossed? */
        if(details.primaryVelocity != 0) {
          if(distance < 0) { // next 
            tempStackCardY = distance;
            flyOutY.forward(from: 0.0);
          } else { // prev 
            tempPrevCardY = prevCardY - distance;
            flyInY.forward(from: 0.0);
          }
        } else {
          /* Threshold crossed? */
          if(distance.abs() > thresholdValue) {
            if(distance < 0) { // next
              tempStackCardY = distance;
              flyOutY.forward(from: 0.0);
            } else { // prev
              tempPrevCardY = prevCardY - distance;
              flyInY.forward(from: 0.0);
            }
          }
        }
      },
      onHorizontalDragStart: (details) {
        if(disableSwipes) return;
        yStartOffset = details.globalPosition.dx;
        yEndOffset = yStartOffset;
      },
      onHorizontalDragUpdate: (details) {
        if(disableSwipes) return;
        yEndOffset = details.globalPosition.dx;
      },
      onHorizontalDragEnd: (details) {
        if(disableSwipes) return;
        double distance = yEndOffset - yStartOffset;
        double thresholdValue = 80.0;
        /* Velocity Crossed? */
        if(details.primaryVelocity != 0) {
          if(distance < 0) { // next 
            flyOutX.forward(from: 0.0);
          } else { // prev
            flyInX.forward(from: 0.0);
          } 
        } else {
          /* Threshold crossed? */
          if(distance.abs() > thresholdValue) {
            if(distance < 0) { // next
            } else { // prev
            }
          }
        }
      },
      child: Stack(
        children: <Widget>[
          /* Last card (Static): For border/shadow effects */
          Container(
            margin: new EdgeInsets.only(
              top: 30.0,
              bottom: 5.0,
              left: 5.0,
              right: 5.0
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                const Radius.circular(10.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xffaaaaaa),
                  offset: Offset(0.0, 1.0),
                  blurRadius: 1.0,
                )
              ]
            ),
            child: Center(
              child: Text(
                'End of articles'
              )
            )
          ),
          /* Next Card: */
          showNextCard ? IndividualCard(
            newsItem: widget.cards[index + 2] ,
            positionY: 0.0, // Remains fixed (No animations affect this card => static)
            positionX: 0.0,
            curCard: false,
            webViewShow: showWebView,
            webViewHide: hideWebView 
          ) : Container(width: 0.0, height: 0.0),
          /* Current Card: */
          showCurCard ? IndividualCard(
            newsItem: widget.cards[index + 1] ,
            positionY: stackCardY,
            positionX: stackCardX,
            curCard: true,
            webViewShow: showWebView,
            webViewHide: hideWebView 
          ) : Container(width: 0.0, height: 0.0),
          /* Previous Card: */
          showPrevCard ? IndividualCard(
            newsItem: widget.cards[index],
            positionY: prevCardY,
            positionX: prevCardX,
            curCard: false,
            webViewShow: showWebView,
            webViewHide: hideWebView 
          ) : Container(width: 0.0, height: 0.0),
          webViewManager()
        ]
      )
    );
  }
}