import 'package:http/http.dart' as http; // Import the `http` package to make requests
import 'dart:convert'; // Import `convert` package to parse JSON
import 'dart:async'; // For async operations
import '../model/news-model.dart';

/* Fetching JSON Data and converting it into an object */
Future<List<News>> fetchNews() async {
  final api = 'http://pushkardk.com/json/msp-news.json';
  final response = await http.get(api);
  List responseJson = json.decode(response.body.toString());

  if (response.statusCode == 200) {
    List<News> userList = createUserList(responseJson); // If server returns OK, parse JSON
    return userList;
  } else {
    throw Exception('Failed to load post'); // If not OK, throw error.
  }
}

List<News> createUserList(List data){
  List<News> list = new List();
  
  for (int i = 0; i < data.length; i++) {
    String description = data[i]["description"];
    String fullArticleLink = data[i]["fullArticleLink"];
    String imageUrl = data[i]["imageUrl"];
    int numberOfClaps = data[i]["numberOfClaps"];
    String publishedDate = data[i]["publishedDate"];
    String sourceName = data[i]["sourceName"];
    String title = data[i]["title"];

    News newsItem = new News(
      description: description,
      fullArticleLink: fullArticleLink,
      imageUrl: imageUrl,
      numberOfClaps: numberOfClaps,
      publishedDate: publishedDate,
      sourceName: sourceName,
      title: title
    );
    list.add(newsItem);
  }

  return list;
}
/* End JSON Fetch */
