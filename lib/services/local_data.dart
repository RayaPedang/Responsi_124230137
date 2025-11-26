import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_model.dart';

class LocalData {
  // List statis untuk menampung data di memori aplikasi
  static List<News> favorites = [];
  static const String _prefKey = 'favorites_data';

  // Cek apakah item sudah ada di favorit
  static bool isFavorite(News news) {
    return favorites.any((element) => element.id == news.id);
  }

  // Tambah ke favorit dan simpan ke penyimpanan lokal
  static Future<void> addFavorite(News news) async {
    if (!isFavorite(news)) {
      favorites.add(news);
      await _saveToStorage();
    }
  }

  // Hapus dari favorit dan perbarui penyimpanan lokal
  static Future<void> removeFavorite(News news) async {
    favorites.removeWhere((element) => element.id == news.id);
    await _saveToStorage();
  }

  // Simpan list favorit saat ini ke SharedPreferences
  static Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    // Ubah List<News> menjadi JSON String
    final String encodedData = json.encode(
      favorites.map((e) => e.toJson()).toList(),
    );
    await prefs.setString(_prefKey, encodedData);
  }

  // Muat data dari SharedPreferences ke variabel statis
  static Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_prefKey);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      favorites = jsonList.map((e) => News.fromJson(e)).toList();
    }
  }
}
