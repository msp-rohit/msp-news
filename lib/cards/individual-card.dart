import 'package:flutter/material.dart';
import '../model/news-model.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';

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

    int second = 1;
    int minute = 60 * second;
    int hour = 60 * minute;
    int day = 24 * hour;
    int month = 30 * day;
    int year = 12 * month;
    var monthsArr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    var dateStr = "(${monthsArr[date.month - 1]} ${date.day})";
    int deltaSeconds = ((curDate.millisecondsSinceEpoch - date.millisecondsSinceEpoch) / 1000).round();
    var diff;

    /* "Ago" Logic Source : https://stackoverflow.com/questions/11/calculate-relative-time-in-c-sharp */
    if(deltaSeconds < minute) {
      diff = (deltaSeconds == 1) ? "One second ago" : "$deltaSeconds seconds ago";
    } else if(deltaSeconds < 2 * minute) {
      diff = "A minute ago";
    } else if(deltaSeconds < 45 * minute) {
      diff = "${(deltaSeconds / minute).round()} minutes ago";
    } else if(deltaSeconds < 90 * minute) {
      diff = "An hour ago";
    } else if(deltaSeconds < 24 * hour) {
      diff = "${(deltaSeconds / hour).round()} hours ago";
    } else if(deltaSeconds < 48 * hour) {
      diff = "Yesterday $dateStr";
    } else if(deltaSeconds < 30 * day) {
      diff = "${(deltaSeconds / day).round()} days ago $dateStr";
    } else if(deltaSeconds < 12 * month) {
      var monthsDiff = (deltaSeconds / month).round();
      diff = monthsDiff <= 1 ? "One month ago" :  "$monthsDiff months ago $dateStr";
    } else {
      var yearDiff = (deltaSeconds / year).round();
      diff = yearDiff <= 1 ? "One year ago" :  "$yearDiff years ago $dateStr";
    }

    // Overrides:
    var dayDiff;
    if(curDate.month - date.month < 1) { // Same month
      if(curDate.day - date.day >= 25) { // > 25 days
        diff = "About a month ago $dateStr";
      } else if(curDate.day - date.day >= 1) { // > 1 day
        dayDiff = curDate.day - date.day;
        diff = dayDiff <= 1 ? "Yesterday $dateStr" :  "$dayDiff days ago $dateStr";
      }
    }
    
    return diff;
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
            flex: 4,
            child: Stack(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Image.asset('images/image_placeholder.png', fit: BoxFit.cover)
                ),
                Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Image.network(widget.newsItem.imageUrl, fit: BoxFit.cover)                  
                )
              ],
            )
          ),
          /* News Source: */
          Flexible(
            flex: 4,
            child: Column(
              children: <Widget>[
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
                      fontSize: 19.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      height: 0.9
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
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Share.share('${widget.newsItem.title} ${widget.newsItem.fullArticleLink}\n\n\nDownload Newskard news app from playstore https://play.google.com/store/apps/details?id=in.newskard.android');
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5.0, left: 10.0),
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1.0, color: const Color(0xFF603C00)),
                            borderRadius: BorderRadius.all(
                              const Radius.circular(15.0),
                            ), 
                          ),
                          child: Icon(Icons.share, size: 18.0, color: const Color(0xFF603C00))
                        )
                      ),
                      Expanded(child: Container()),
                      Container(
                        margin: new EdgeInsets.only(right: 10.0),
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
                    ]
                  )
                )
              ],
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