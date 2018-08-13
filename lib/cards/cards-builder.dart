import 'package:flutter/material.dart';
import '../model/news-model.dart';
import 'individual-card.dart';

class CardsBuilder extends StatefulWidget {
  final List<News> cards;
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

  /* Animation Controllers */
  AnimationController flyOutY; Animation<double> _flyOutY;
  AnimationController flyInY; Animation<double> _flyInY;
  AnimationController flyOutX; Animation<double> _flyOutX;
  AnimationController flyInX; Animation<double> _flyInX;

  @override
  void initState() {
    super.initState();
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
    // tempDeltaY = 0.0;

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
    // tempDeltaY = 0.0;
  }
  double prevInitialPositionY(context) {
    tempPrevCardY = -(screenHeight);
    return tempPrevCardY;
  }
  double prevInitialPositionX(context) {
    tempPrevCardX = 0.0;
    return tempPrevCardX;
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
        yStartOffset = details.globalPosition.dy;
        yEndOffset = yStartOffset;
      },
      onVerticalDragUpdate: (details) {
        yEndOffset = details.globalPosition.dy;
        // double distance = yEndOffset - yStartOffset;
        // if(distance < 0) { // Next (Up)
        //   tempDeltaY = details.delta.dy;
        //   setState(() {
        //     stackCardY += tempDeltaY;
        //   });
        // } else {

        // }
      },
      onVerticalDragEnd: (details) {
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
        yStartOffset = details.globalPosition.dx;
        yEndOffset = yStartOffset;
      },
      onHorizontalDragUpdate: (details) {
        yEndOffset = details.globalPosition.dx;
      },
      onHorizontalDragEnd: (details) {
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
              bottom: 10.0,
              left: 10.0,
              right: 10.0
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                const Radius.circular(10.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xcc000000),
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
            curCard: false
          ) : Container(width: 0.0, height: 0.0),
          /* Current Card: */
          showCurCard ? IndividualCard(
            newsItem: widget.cards[index + 1] ,
            positionY: stackCardY,
            positionX: stackCardX,
            curCard: true
          ) : Container(width: 0.0, height: 0.0),
          /* Previous Card: */
          showPrevCard ? IndividualCard(
            newsItem: widget.cards[index],
            positionY: prevCardY,
            positionX: prevCardX,
            curCard: false
          ) : Container(width: 0.0, height: 0.0),
        ]
      )
    );
  }
}