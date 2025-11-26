import 'package:flutter/material.dart';
import '../models/news_item.dart';

class FavoriteProvider with ChangeNotifier {
  final List<NewsItem> _favorites = [];

  List<NewsItem> get favorites => _favorites;

  void toggleFavorite(NewsItem item) {
    final isExist = _favorites.contains(item);
    if (isExist) {
      _favorites.remove(item);
    } else {
      _favorites.add(item);
    }
    notifyListeners();
  }

  bool isFavorite(NewsItem item) {
    return _favorites.contains(item);
  }

  // Fungsi khusus untuk swipe delete
  void removeFavorite(NewsItem item) {
    _favorites.remove(item);
    notifyListeners();
  }
}
