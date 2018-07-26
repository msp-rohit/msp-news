import 'package:flutter/material.dart';
import '../model/news-model.dart';
import 'package:url_launcher/url_launcher.dart';

class IndividualCard extends StatefulWidget {
  final News newsItem;
  IndividualCard({Key key, this.newsItem}) : super(key: key);
  
  @override
  _IndividualCardState createState() => _IndividualCardState();
}

class _IndividualCardState extends State<IndividualCard> {
  String finalDescription;
  String finalTitle;
  String finalSourceName;
  @override
  void initState() {
    super.initState();
      finalDescription = widget.newsItem.description;
      finalTitle = widget.newsItem.title;
      finalSourceName = widget.newsItem.sourceName;
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: new EdgeInsets.only(
        top: 30.0,
        bottom: 10.0,
        left: 10.0,
        right: 10.0
      ),
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
          Container(
            height: 250.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.newsItem.imageUrl),
                fit: BoxFit.cover,
              )
            )
          ),
          Container(
            padding: new EdgeInsets.only(top: 10.0, bottom: 7.0, left: 10.0, right: 10.0),
            child: Text(finalTitle, style: TextStyle(
                fontSize: 22.0,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
            Container(
              padding: new EdgeInsets.only(bottom: 8.0, right: 10.0, left: 10.0),
              child: Text(finalSourceName, style: TextStyle(
                  fontSize: 11.0
                ),
                overflow: TextOverflow.fade
              )
            ),
            Container(
              padding: new EdgeInsets.only(bottom: 8.0, right: 10.0, left: 10.0),
              child: Text(widget.newsItem.publishedDate, style: TextStyle(
                  fontSize: 11.0
                ), 
                overflow: TextOverflow.fade
              )
            )
          ]),
          Expanded(
            child: Container(
              padding: new EdgeInsets.only(bottom: 15.0, right: 10.0, left: 10.0),
              child: Text(finalDescription, style: TextStyle(
                  fontSize: 15.0,
                  height: 1.3
                ),
                overflow: TextOverflow.fade
              )
            )
          ),
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0x00FFFFFF), const Color(0xDDFFFFFF), 
                  const Color(0xEEFFFFFF), const Color(0xFFFFFFFF),
                  const Color(0xFFFFFFFF)
                ],
                tileMode: TileMode.repeated, // repeats the gradient over the canvas
                stops: [0.0, 0.25, 0.5, 0.75, 1.0]
              ),
            ),
            width: double.infinity,
            height: 75.0,
            child: Center(
              child: RaisedButton(
                onPressed: () async {
                  if (await canLaunch(widget.newsItem.fullArticleLink)) {
                    await launch(widget.newsItem.fullArticleLink);
                  } else {
                    throw 'Could not launch ${widget.newsItem.fullArticleLink}';
                  }
                },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                textColor: Colors.black,
                color: Colors.white.withOpacity(1.0),
                child: Text(
                  'View Article',
                  style: TextStyle(
                    fontSize: 12.0
                  ),
                )
              ) 
            )
          )
        ]
      )
    );
  }
}