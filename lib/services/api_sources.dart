import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class ApiSource {
  static const String _baseUrl = 'https://api.spaceflightnewsapi.net/v4';

  // PERBAIKAN: Menggunakan 'News' agar sesuai dengan nama class di news_model.dart
  static Future<List<News>> getData(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$endpoint/'));

      if (response.statusCode != 200) return [];

      final decoded = json.decode(response.body);

      // API may return a plain List or an object with 'results'
      List<dynamic> items = [];
      if (decoded is List) {
        items = decoded;
      } else if (decoded is Map && decoded.containsKey('results')) {
        final res = decoded['results'];
        if (res is List) items = res;
      } else {
        // Unexpected shape
        debugPrint('Unexpected API response shape for $endpoint');
        return [];
      }

      return items
          .map((e) {
            try {
              return News.fromJson(Map<String, dynamic>.from(e));
            } catch (e) {
              debugPrint('Error parsing news item: $e');
              return null;
            }
          })
          .whereType<News>()
          .toList();
    } catch (e) {
      debugPrint(
        "Error fetching data: $e",
      ); // Menggunakan debugPrint untuk log yang lebih baik
      return [];
    }
  }
}
