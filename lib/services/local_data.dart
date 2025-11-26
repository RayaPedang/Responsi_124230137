import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_model.dart';

class LocalData {
  static const String _kFavoritesKey = 'favorites';

  // In-memory cache
  static List<News> favorites = [];

  // Initial load from SharedPreferences
  static Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_kFavoritesKey) ?? [];
      favorites = raw
          .map((s) {
            try {
              return News.fromJson(json.decode(s));
            } catch (_) {
              return null;
            }
          })
          .whereType<News>()
          .toList();
    } catch (e) {
      favorites = [];
    }
  }

  static Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = favorites.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_kFavoritesKey, raw);
  }

  // Cek apakah item sudah ada di favorit
  static bool isFavorite(News news) {
    return favorites.any((element) => element.id == news.id);
  }

  // Tambah ke favorit (persisted)
  static Future<void> addFavorite(News news) async {
    if (!isFavorite(news)) {
      favorites.add(news);
      await _saveFavorites();
    }
  }

  // Hapus dari favorit (persisted)
  static Future<void> removeFavorite(News news) async {
    favorites.removeWhere((element) => element.id == news.id);
    await _saveFavorites();
  }
}
