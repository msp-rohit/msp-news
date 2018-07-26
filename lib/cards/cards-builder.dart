import 'package:flutter/material.dart';
import '../model/news-model.dart';
import 'individual-card.dart';

class CardsBuilder extends StatefulWidget {
  final List<News> cards;
  CardsBuilder({Key key, this.cards}) : super(key: key);

  @override
  _CardsBuilderState createState() => _CardsBuilderState();
}

class _CardsBuilderState extends State<CardsBuilder> {
  int index;

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  void switchPages(details) {
    if(details.primaryVelocity < -1000) {
      setState(() {
        index != (widget.cards.length) ? index++ : index; // Next Card (move window forward)
        // Card @ widget.cards.length is 'end of articles' card: Hence, displaying it.
        // Above is the reason for not using `index != (widget.cards.length - 1)`
      });
    } else if(details.primaryVelocity > 1000) {
      setState(() {
        index != 0 ? index--: index; // Previous Card (move window backward)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( 
      onVerticalDragStart: (details) {
        print("*Start Vertical: Direction = ${details.globalPosition.direction}");
      },
      onVerticalDragEnd: (details) {
        print("*End*");
        print("Primary Velocity: ${details.primaryVelocity}");
        switchPages(details);
      },
      onHorizontalDragStart: (details) {
        print("*Start Horizontal: Direction = ${details.globalPosition.direction}");
      },
      onHorizontalDragEnd: (details) {
        print("*End*");
        print("Primary Velocity: ${details.primaryVelocity}");
        switchPages(details);
      },
      child: Stack(
        children: <Widget>[
          /* Last card: For border/shadow effects */
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
          /* Real Card(s): */
          IndividualCard(
            newsItem: widget.cards[index == widget.cards.length ? index - 1 : index]
          )
        ]
      )
    );
  }
}