import 'package:flutter/material.dart';
import '../model/news-model.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

typedef void Callback();

class IndividualCard extends StatefulWidget {
  final News newsItem;
  final double positionY;
  final double positionX;
  final bool curCard;
  final Callback webViewShow;
  final Callback webViewHide;
  IndividualCard({
    Key key, 
    this.newsItem, this.positionY, this.positionX, 
    this.curCard, this.webViewShow, this.webViewHide
  }) : super(key: key);
  
  @override
  _IndividualCardState createState() => _IndividualCardState();
}

class _IndividualCardState extends State<IndividualCard> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  /* Methods */
  String formatDate(dateString) {
    var curDate = DateTime.now().toLocal();
    var date = (DateTime.parse(dateString)).toLocal();
    var diff = '${curDate.minute - date.minute} minutes ago';
    var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    if( (curDate.hour - date.hour >= 1) || 
        (curDate.day - date.day >= 1) || 
        (curDate.month - date.month >= 1) || 
        (curDate.year - date.year >= 1) ) {
      if( (curDate.day - date.day >= 1) || 
          (curDate.day - date.day >= 1) || 
          (curDate.month - date.month >= 1) || 
          (curDate.year - date.year >= 1) ) {
        if( (curDate.month - date.month >= 1) ||
            (curDate.year - date.year >= 1) ) {
          if(curDate.year - date.year >= 1) {
            diff = '${curDate.year - date.year} year${curDate.year - date.year == 1 ? '' : 's'} ago - ${months[date.month - 1]} ${date.day}';
          } else {
            diff = '${curDate.month - date.month} month${curDate.month - date.month == 1 ? '' : 's'} ago - ${months[date.month - 1]} ${date.day}';
          }
        } else {
          diff = '${curDate.day - date.day} day${curDate.day - date.day == 1 ? '' : 's'} ago - ${months[date.month - 1]} ${date.day}';
        }
      } else {
        diff = '${curDate.hour - date.hour} hour${curDate.hour - date.hour == 1 ? '' : 's'} ago';
      }
    }
    return diff;
  }

  Widget loadImageWithoutErr() {
    try {
      return FadeInImage.assetNetwork(
        placeholder: 'images/image_placeholder.png',
        image: widget.newsItem.imageUrl,
        fit: BoxFit.scaleDown
      );
    } catch (Exception) {
      print(Exception);
      return Image.asset('images/image_placeholder.png');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    var humanDate = formatDate(widget.newsItem.publishedDate); // Adjust the date format.

    Widget cardWidget = Card(
      shape: new RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      elevation: 0.0,
      margin: new EdgeInsets.only(
        top: 30.0,
        bottom: 5.0,
        left: 5.0,
        right: 5.0
      ),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          /* Image: */
          Flexible(
            flex: 3,
            child: Container(
              constraints: BoxConstraints.expand(),
              child:loadImageWithoutErr()
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
                Icon(const IconData(0xe8b5, fontFamily: 'MaterialIcons'), size: 11.0),
                Padding(padding: new EdgeInsets.all(1.0)),
                Text(humanDate, style: TextStyle(
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
                onPressed: () {
                  widget.webViewShow();
                  final flutterWebviewPlugin = new FlutterWebviewPlugin();
                  flutterWebviewPlugin.launch(
                    widget.newsItem.fullArticleLink,
                    rect: new Rect.fromLTWH(
                      0.0, 
                      72.0, 
                      MediaQuery.of(context).size.width, 
                      MediaQuery.of(context).size.height
                    )
                  );
                },
                padding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                textColor: Colors.black,
                color: Colors.white.withOpacity(1.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                    'View Article',
                      style: TextStyle(
                        color: const Color(0xFF603C00),
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500
                      )
                    ),
                    Container(
                      padding: new EdgeInsets.only(top: 1.5),
                      child: Icon(const IconData(0xe409, fontFamily: 'MaterialIcons'), color: const Color(0xFF603C00), size: 14.0)
                    )
                  ]
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