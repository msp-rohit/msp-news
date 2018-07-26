/* The News Class that models the data that is fetched from the DB/Source */
class News {
  String description;
  String fullArticleLink;
  String imageUrl;
  int numberOfClaps;
  String publishedDate;
  String sourceName;
  String title;

  News({this.description, this.fullArticleLink, this.imageUrl, 
        this.numberOfClaps, this.publishedDate, this.sourceName, this.title });
}