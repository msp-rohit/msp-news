import 'package:flutter/material.dart';
import '../model/news-model.dart';
import 'package:url_launcher/url_launcher.dart';

class IndividualCard extends StatefulWidget {
  final News newsItem;
  final double positionY;
  final double positionX;
  final bool curCard;
  IndividualCard({Key key, this.newsItem, this.positionY, this.positionX, this.curCard}) : super(key: key);
  
  @override
  _IndividualCardState createState() => _IndividualCardState();
}

class _IndividualCardState extends State<IndividualCard> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Widget cardWidget = Card(
      shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(width: 1.0, color: const Color(0x33000000))),
      elevation: 0.0,
      margin: new EdgeInsets.only(
        top: 30.0,
        bottom: 10.0,
        left: 10.0,
        right: 10.0
      ),
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
          /* Image: */
          Flexible(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.newsItem.imageUrl),
                  fit: BoxFit.cover,
                )
              )
            )
          ),
          /* News Source: */
          Container(
            padding: new EdgeInsets.only(top: 10.0, bottom: 5.0, right: 10.0, left: 10.0),
            width: double.infinity,
            child: Text(widget.newsItem.sourceName, style: TextStyle(
                fontSize: 11.0,
                fontFamily: 'Roboto'
              ),
              overflow: TextOverflow.fade
            )
          ),
          /* News Title: */
          Container(
            padding: new EdgeInsets.only(bottom: 5.0, left: 10.0, right: 10.0),
            width: double.infinity,
            child: Text(widget.newsItem.title, style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis
            )
          ),
          /* Publish Date: */
          Container(
            padding: new EdgeInsets.only(bottom: 10.0, right: 10.0, left: 10.0),
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Icon(const IconData(0xe916, fontFamily: 'MaterialIcons'), size: 11.0),
                Padding(padding: new EdgeInsets.all(1.0)),
                Text(widget.newsItem.publishedDate, style: TextStyle(
                    fontSize: 11.0,
                    fontFamily: 'Roboto'
                  ), 
                  overflow: TextOverflow.fade
                )
              ],
            ),
          ),
          /* Description: */
          Expanded(
            child: Container(
              padding: new EdgeInsets.only(bottom: 15.0, right: 10.0, left: 10.0),
              width: double.infinity,
              child: Text(widget.newsItem.description, style: TextStyle(
                  fontSize: 15.0,
                  height: 1.3,
                  fontFamily: 'Roboto'
                ),
                overflow: TextOverflow.fade
              )
            )
          ),
          /* Article Link Button: */
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
            height: 90.0,
            child: Center(
              child: RaisedButton(
                onPressed: () async {
                  if (await canLaunch(widget.newsItem.fullArticleLink)) {
                    await launch(widget.newsItem.fullArticleLink);
                  } else {
                    throw 'Could not launch ${widget.newsItem.fullArticleLink}';
                  }
                },
                padding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                textColor: Colors.black,
                color: Colors.white.withOpacity(1.0),
                child: Text(
                  'View Article',
                  style: TextStyle(
                    color: const Color(0xFF2980b9),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500
                  )
                )
              ) 
            )
          )
        ]
      )
    );

    Widget positionedWidget = Positioned(
      top: widget.positionY,
      left: widget.positionX,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: cardWidget
    );

    return positionedWidget;
  }
}