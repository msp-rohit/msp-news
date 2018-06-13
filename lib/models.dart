import 'package:firebase_database/firebase_database.dart';

class NewsItem {

  String imageUrl;
  String title;
  DateTime publishedDate;
  String sourceName;
  String description;
  String fullArticleLink;
  String numberOfClaps;

  NewsItem(this.imageUrl, this.title, this.publishedDate, this.sourceName, this.description, this.fullArticleLink, this.numberOfClaps);

  NewsItem.fromJSON(DataSnapshot data) {
    imageUrl = data.value['imageUrl'] ? data.value['imageUrl'] : "";
    title = data.value['title'] ? data.value['title'] : "";
    publishedDate = data.value['publishedDate'] ? data.value['publishedDate'] : DateTime.now();
    sourceName = data.value['sourceName'] ? data.value['sourceName'] : "";
    description = data.value['description'] ? data.value['description'] : "";
    fullArticleLink = data.value['fullArticleLink'] ? data.value['fullArticleLink'] : "";
    numberOfClaps = data.value['numberOfClaps'] ? data.value['numberOfClaps'] : 0;
  }
}