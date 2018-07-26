import 'package:flutter/material.dart';
import '../network/fetch.dart';
import '../model/news-model.dart';
import 'cards-builder.dart';

class Cards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<News>>(
            future: fetchNews(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CardsBuilder(cards: snapshot.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return Center(
                child: CircularProgressIndicator() // By default, show a loading spinner
              );
            },
          ),
    );
  }
}
