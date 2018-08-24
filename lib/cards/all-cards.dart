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
    String splashImage = 'images/splash_bg@2x.png';
    String splashHeader = 'images/splash_hdr@2x.png';
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(splashImage),
          fit: BoxFit.cover,
        )
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 40.0,
            width: 222.0,
            height: 71.0,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(splashHeader),
                  fit: BoxFit.cover,
                )
              )
            )
          ),
          Center(
            child: CircularProgressIndicator() // By default, show a loading spinner
          )
        ],
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
            } else if(snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}")
              );
            } else {
              return CardsBuilder(cards: formatSnapshot(snapshot.data));
            }
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