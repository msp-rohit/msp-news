import 'package:flutter/material.dart';
import '../model/news-model.dart';
import 'cards-builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cards extends StatefulWidget {
  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  void initState() {
    super.initState();
  }

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

  Widget loadingSplashScreen(context) {
    String newsKardImg = 'images/newskard_logo.png';
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          children: <Widget>[
            Expanded(child: Container()),
            Container(
              width: 72.0,
              height: 72.0,
              decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(newsKardImg),
                  fit: BoxFit.scaleDown,
                )
              )
            ),
            Container(
              margin: EdgeInsets.all(20.0),
              width: 116.0,
              height: 2.0,
              child: LinearProgressIndicator(backgroundColor: const Color(0xFFDFE1E8))
            ),
            Expanded(child: Container())
          ]
        )
      )
    ); 
  }
  
  Widget allCards(context) {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection('news')
                .orderBy('publishedDate', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.none || 
             snapshot.connectionState == ConnectionState.waiting) {
            return loadingSplashScreen(context);
          }
          if(snapshot.connectionState == ConnectionState.active ||
             snapshot.connectionState == ConnectionState.done) {
            if(!snapshot.hasData) {
              return loadingSplashScreen(context);
            }
            // if(snapshot.hasError) {
            //   return loadingSplashScreen(context);
            // } else {
              return CardsBuilder(cards: formatSnapshot(snapshot.data));
            // }
          }
        }
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return allCards(context);
  }
}