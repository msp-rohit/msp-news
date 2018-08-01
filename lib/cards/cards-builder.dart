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

  double prevCardY;
  double tempPrevCardY;
  double stackCardY;
  double tempStackCardY;
  double yStartOffset;
  double yEndOffset;

  AnimationController yAnimationUp;
  AnimationController yAnimationDown;
  AnimationController yFlyOutUp;
  AnimationController yFlyInDown;

  @override
  void initState() {
    super.initState();
    index = -1;
    showPrevCard = index >= 0;
    showCurCard = index + 1 < widget.cards.length;
    showNextCard = index + 2 < widget.cards.length;

    prevCardY = -750.0;
    tempPrevCardY = -750.0;
    stackCardY = 0.0;
    tempStackCardY = 0.0;

    /* Local variables */
    double slideUp = 250.0;
    double slideDown = 150.0;
    double flyInMovement = 600.0;
    double flyOutMovement = 750.0;

    /* Animation Controllers */
    yAnimationUp = new AnimationController(duration: const Duration(milliseconds: 240), vsync: this);
    yAnimationUp.addListener(() {
      if(index != widget.cards.length - 1) {
        setState(() {
          stackCardY = yAnimationUp.value * -slideUp;
        });
      }
    });
    yAnimationDown = new AnimationController(duration: const Duration(milliseconds: 50), vsync: this);
    yAnimationDown.addListener(() {
      if(index != -1) {
        setState(() {
          prevCardY = tempPrevCardY + (yAnimationDown.value * flyInMovement);
        });
      }
    });
    yFlyOutUp = new AnimationController(duration: const Duration(milliseconds: 240), vsync: this);
    yFlyOutUp.addListener(() {
      /* Next card */
      if(index != widget.cards.length - 1) {
        setState(() {
          stackCardY = tempStackCardY - (yFlyOutUp.value * flyOutMovement);
          if(yFlyOutUp.value == 1) {
            index++;
            resetParams();
          }
        });
      }
    });
    yFlyInDown = new AnimationController(duration: const Duration(milliseconds: 240), vsync: this);
    yFlyInDown.addListener(() {
      /* Prev card */
      if(index > -1) {
        setState(() {
          prevCardY = tempPrevCardY + (yFlyInDown.value * slideDown);
          if(yFlyInDown.value == 1) {
            index--;
            resetParams();
          }
        });
      }
    });
  }

  /* Custom Functions: */
  void resetParams() {
    showPrevCard = index >= 0;
    showCurCard = index + 1 < widget.cards.length;
    showNextCard = index + 2 < widget.cards.length;

    prevCardY = -750.0;
    tempPrevCardY = -750.0;
    stackCardY = 0.0;
    tempStackCardY = 0.0;
  }

  void toNextCardY() {
    if(index < widget.cards.length - 1) {
      tempStackCardY = stackCardY;
      yFlyOutUp.forward(from: 0.0);
    } else {
      yAnimationUp.reverse(from: 1.0);
    }
  }

  void toPrevCardY() {
    if(index > -1) {
      tempPrevCardY = prevCardY;
      yFlyInDown.forward(from: 0.0);
    } else {
      yAnimationDown.reverse(from: 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { /* Do nothing */ },
      onVerticalDragStart: (details) {
        print("x:${details.globalPosition.dx} y:${details.globalPosition.dy} direction:${details.globalPosition.distance}");
        yStartOffset = details.globalPosition.dy;
        yEndOffset = yStartOffset;
        if(details.globalPosition.direction >= 1) { // Upwards
          yAnimationUp.forward(from: 0.0);
        } else { // Downwards
          yAnimationDown.forward(from: 0.0);
        }
      },
      onVerticalDragUpdate: (details) {
        yEndOffset = details.globalPosition.dy;
      },
      onVerticalDragEnd: (details) {
        double distance = yEndOffset - yStartOffset;
        double thresholdValue = 70.0;
        // 1. If card was swiped quickly then remove it!
        if(details.primaryVelocity != 0) {
          if(distance < 0) { // upwards / next card
            toNextCardY();
          } else { // Downwards / prev card
            toPrevCardY();
          }
        } 
        // 2. If card was swiped slowly then check for distance threshold
        else {
          // 2a. If threshold was crossed: complete the action
          if(distance.abs() > thresholdValue) {
            if(distance < 0) { // upwards / next card
              toNextCardY();
            } else { // Downwards / prev card
              toPrevCardY();
            }
          } else {
            // 2b. If threshold was not crossed: reverse the animation
            if(distance < 0) { // upwards
              yAnimationUp.reverse(from: 1.0);
            } else { // Downwards
              yAnimationDown.reverse(from: 1.0);
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