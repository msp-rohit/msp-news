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
  final PageController controller = new PageController();

  @override
  void initState() {
    super.initState();
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      controller: controller,
      itemCount: widget.cards.length, 
      itemBuilder: (context, index) {
        return IndividualCard(newsItem: widget.cards[index]);
      },
      onPageChanged: (index) {
        print("Current Page: $index");
        // controller.jumpToPage(0);
      }
    );
  }
}