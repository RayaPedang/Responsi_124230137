import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_item.dart';

class ApiService {
  final String _baseUrl = 'https://api.spaceflightnewsapi.net/v4'; // [cite: 31]

  Future<List<NewsItem>> fetchNews(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List results = json['results'];
      return results.map((e) => NewsItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
