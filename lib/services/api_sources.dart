import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class ApiSource {
  static const String _baseUrl = 'https://api.spaceflightnewsapi.net/v4';

  static Future<List<NewsModel>> getData(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$endpoint/'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        final List<dynamic> results = jsonBody['results'];

        return results.map((e) => NewsModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}
