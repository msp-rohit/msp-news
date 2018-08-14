import 'package:flutter/material.dart';
import '../model/news-model.dart';
import 'cards-builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cards extends StatelessWidget {
  List formatSnapshot(ssData) {
    List data = [];
    for(int i = 0; i < ssData.documents.length; i++) {
      News newsItem;
      newsItem = News(
        description: ssData.documents[i]['description'],
        fullArticleLink: ssData.documents[i]['fullArticleLink'],
        imageUrl: ssData.documents[i]['imageUrl'],
        publishedDate: ssData.documents[i]['publishedDate'],
        sourceName: ssData.documents[i]['sourceName'],
        title: ssData.documents[i]['title']
      );
      data.add(newsItem);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection('news').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator() // By default, show a loading spinner
            );
          } else if(snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}")
            );
          } else {
            return CardsBuilder(cards: formatSnapshot(snapshot.data));
          }
        }
      )
    );
  }
}
