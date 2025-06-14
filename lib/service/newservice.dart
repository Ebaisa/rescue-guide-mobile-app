import 'dart:convert';
import 'package:health/models/newsmodel.dart';
import 'package:http/http.dart' as http;


class NewsService {
  final String _apiKey =
      'd7a46317181c47799bf84d5e973f0ce1'; // Replace with your API key
  final String _endpoint =
      'https://newsapi.org/v2/top-headlines?country=us&category=health&pageSize=4';

  Future<List<NewsArticle>> fetchHealthNews() async {
    final response = await http.get(
      Uri.parse(_endpoint),
      headers: {'Authorization': _apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articles = data['articles'];
      return articles.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
