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
  /* Positioning variables */
  double yStartOffset;
  double yEndOffset;
  /* Temporary Variables/Constants */
  double tempPrevCardY;
  double tempStackCardY;
  /* Constants */
  final double initialPrevPos = -600.0;

  /* Animation Controllers */
  AnimationController flyOutY; Animation<double> _flyOutY;
  AnimationController flyInY; Animation<double> _flyInY;

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
    prevCardY = initialPrevPos; // Only initially (changed with gesture or widget creation)
    /* Positioning variables */
    yStartOffset = 0.0;
    yEndOffset = 0.0;
    /* Temporary Variables/Constants */
    tempPrevCardY = prevCardY;
    tempStackCardY = stackCardY;

    /* Animation logic */
    flyOutY = new AnimationController(duration: const Duration(milliseconds: 280), vsync: this);
    _flyOutY = new CurvedAnimation(parent: flyOutY, curve: Curves.easeInOut);
    _flyOutY.addListener(() {
      /* Next card */
      if(index != widget.cards.length - 1) {
        setState(() {
          stackCardY = tempStackCardY + (flyOutY.value * tempPrevCardY);
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
          prevCardY = tempPrevCardY - (flyInY.value * tempPrevCardY);
          if(flyInY.value == 1) resetParams(false, false);
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
    prevCardY = initialPrevPos;
    /* Pos vars */
    yStartOffset = 0.0;
    yEndOffset = 0.0;
    /* Temp vars */
    tempPrevCardY = prevCardY;
    tempStackCardY = stackCardY;
  }
  double prevInitialPosition(context) {
    tempPrevCardY = -(MediaQuery.of(context).size.height);
    return tempPrevCardY;
  }

  /* Widget: */
  @override
  Widget build(BuildContext context) {
    prevCardY = (prevCardY == initialPrevPos) ? prevInitialPosition(context) : prevCardY; // Changed on widget creation
    return GestureDetector(
      onTap: () { /* Do nothing */ },
      onVerticalDragStart: (details) {
        yStartOffset = details.globalPosition.dy;
        yEndOffset = yStartOffset;
      },
      onVerticalDragUpdate: (details) {
        yEndOffset = details.globalPosition.dy;
      },
      onVerticalDragEnd: (details) {
        double distance = yEndOffset - yStartOffset;
        double thresholdValue = 160.0;
        /* Velocity Crossed? */
        if(details.primaryVelocity != 0) {
          if(distance < 0) { // next 
            tempStackCardY = stackCardY;
            flyOutY.forward(from: 0.0);
          } else { // prev 
            tempPrevCardY = prevCardY;
            flyInY.forward(from: 0.0);
          }
        } else {
          /* Threshold crossed? */
          if(distance.abs() > thresholdValue) {
            if(distance < 0) { // next
              tempStackCardY = stackCardY;
              flyOutY.forward(from: 0.0);
            } else { // prev
              tempPrevCardY = prevCardY;
              flyInY.forward(from: 0.0);
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
            positionY: 0.0 // Remains fixed (No animations affect this card => static)
          ) : Container(width: 0.0, height: 0.0),
          /* Current Card: */
          showCurCard ? IndividualCard(
            newsItem: widget.cards[index + 1] ,
            positionY: stackCardY
          ) : Container(width: 0.0, height: 0.0),
          /* Previous Card: */
          showPrevCard ? IndividualCard(
            newsItem: widget.cards[index],
            positionY: prevCardY
          ) : Container(width: 0.0, height: 0.0),
        ]
      )
    );
  }
}