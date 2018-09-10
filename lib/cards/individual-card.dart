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
  int imageFlex = 17, contentFlex = 14, shareAndViewFlex = 3;
  double cardTopMargin = 30.0, cardBottomMargin = 5.0, cardHorizontalMargin = 5.0;
  double sourceTopPad = 10.0, sourceBottomPad = 2.0, sourceLH = 1.1, sourceFS = 11.0, sourceRightPad = 10.0, sourceLeftPad = 10.0;
  double titleTopPad = 0.0, titleBottomPad = 5.0, titleLH = 0.9, titleFS = 16.0, titleRightPad = 10.0, titleLeftPad = 10.0;
  int maxTitleLines = 3;
  double dateTopPad = 0.0, dateBottomPad = 5.0, dateLH = 1.0, dateFS = 11.0, dateRightPad = 10.0, dateLeftPad = 10.0;
  double descTopPad = 0.0, descBottomPad = 0.0, descLH = 1.2, descFS = 13.0, descRightPad = 10.0, descLeftPad = 10.0;

  double idealAspectRatio = num.parse((411.42 / 683.43).toStringAsFixed(2)); // up to 1 decimal point precision

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

    /* Determine size of card based on aspect ratio */
    double presentAspectRatio = num.parse((MediaQuery.of(context).size.width / MediaQuery.of(context).size.height).toStringAsFixed(2));
    // print("$idealAspectRatio $presentAspectRatio");
    // TODO: Fix card height/width based on screen aspect ratio.

    int descMaxLines() {
      int totalFlex = imageFlex + contentFlex + shareAndViewFlex;
      double screenHeight = MediaQuery.of(context).size.height;
      double cardHeight = screenHeight - (cardTopMargin + cardBottomMargin);
      double contentHeight = cardHeight * (contentFlex / totalFlex);
      double sourceHeight = sourceTopPad + sourceBottomPad + (sourceFS * sourceLH);
      double titleHeight = titleTopPad + titleBottomPad + (titleFS * titleLH * maxTitleLines);
      double dateHeight = dateTopPad + dateBottomPad + (dateFS * dateLH);
      double descriptionHeight = contentHeight - (sourceHeight + titleHeight + dateHeight);
      int descriptionLines = (descriptionHeight / (descFS * descLH)).floor();

      int correctionFactor = 3;
      return descriptionLines - correctionFactor;
    }

    Widget share() {
      return Container(
        margin: new EdgeInsets.only(right: 10.0, bottom: 2.0),
        child: RaisedButton(
          onPressed: () {
            Share.share('${widget.newsItem.title} ${widget.newsItem.fullArticleLink}\n\n\nDownload Newskard news app from playstore https://play.google.com/store/apps/details?id=in.newskard.android');
          },
          padding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
          textColor: Colors.black,
          color: Colors.white.withOpacity(1.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: new EdgeInsets.only(top: 1.5),
                margin: new EdgeInsets.only(right: 5.0),
                child: Icon(Icons.share, color: const Color(0xFF603C00), size: 14.0)
              ),
              Text(
              'Share',
                style: TextStyle(
                  color: const Color(0xFF603C00),
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500
                )
              )
            ]
          )
        ) 
      );
    }

    Widget readMore() {
      return Container(
        margin: new EdgeInsets.only(left: 5.0),
        child: RaisedButton(
          elevation: 0.0,
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
          padding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          textColor: Colors.black,
          color: Colors.white.withOpacity(1.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
              'Read Full Story',
                style: TextStyle(
                  color: const Color(0xFF603C00),
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500
                )
              ),
            ]
          )
        ) 
      );
    }

    Widget cardWidget = Card(
      shape: new RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      elevation: 0.0,
      margin: new EdgeInsets.only(
        top: cardTopMargin,
        bottom: cardBottomMargin,
        left: cardHorizontalMargin,
        right: cardHorizontalMargin
      ),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          /* Image: */
          Flexible(
            flex: imageFlex,
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
                  child: new ClipRRect(
                    borderRadius: new BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                    child: Image.network(widget.newsItem.imageUrl, fit: BoxFit.cover)
                  ),
                )
              ],
            )
          ),
          /* News Source: */
          Flexible(
            flex: contentFlex,
            child: Column(
              children: <Widget>[
                Container(
                  padding: new EdgeInsets.only(top: sourceTopPad, bottom: sourceBottomPad, right: sourceRightPad, left: sourceLeftPad),
                  width: double.infinity,
                  child: Text(widget.newsItem.sourceName, style: TextStyle(
                      fontSize: sourceFS,
                      height: sourceLH,
                      fontFamily: 'Roboto'
                    ),
                    overflow: TextOverflow.fade
                  )
                ),
                /* News Title: */
                Container(
                  padding: new EdgeInsets.only(top: titleTopPad, bottom: titleBottomPad, left: titleLeftPad, right: titleRightPad),
                  width: double.infinity,
                  child: Text(widget.newsItem.title, style: TextStyle(
                      fontSize: titleFS,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      height: titleLH
                    ),
                    maxLines: maxTitleLines,
                    overflow: TextOverflow.ellipsis
                  )
                ),
                /* Publish Date: */
                Container(
                  padding: new EdgeInsets.only(top: dateTopPad, bottom: dateBottomPad, right: dateRightPad, left: dateLeftPad),
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Icon(const IconData(0xe8b5, fontFamily: 'MaterialIcons'), size: 11.0),
                      Padding(padding: new EdgeInsets.all(1.0)),
                      Text(humanDate, style: TextStyle(
                          fontSize: dateFS,
                          height: dateLH,
                          fontFamily: 'Roboto'
                        ), 
                        overflow: TextOverflow.fade
                      )
                    ],
                  ),
                ),
                /* Description: */
                Container(
                  padding: new EdgeInsets.only(top: descTopPad, bottom: descBottomPad, right: descRightPad, left: descLeftPad),
                  width: double.infinity,
                  child: Text(widget.newsItem.description, style: TextStyle(
                      fontSize: descFS,
                      height: descLH,
                      fontFamily: 'Roboto'
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: descMaxLines(),
                  )
                )
              ],
            )
          ),
          Flexible(
            flex: shareAndViewFlex,
            /* Article Link & Share Button: */
            child: Container(
              padding: new EdgeInsets.only(bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  readMore(),
                  share()
                ]
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