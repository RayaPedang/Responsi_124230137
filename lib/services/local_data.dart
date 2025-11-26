import '../models/news_model.dart';

class LocalData {
  static List<NewsModel> favorites = [];

  static void addFavorite(NewsModel data) {
    if (!favorites.contains(data)) {
      favorites.add(data);
    }
  }

  static void removeFavorite(NewsModel data) {
    favorites.remove(data);
  }

  static bool isFavorite(NewsModel data) {
    return favorites.contains(data);
  }
}
