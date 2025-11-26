import '../models/news_model.dart';

class LocalData {
  // Menyimpan data favorit dalam memory (List statis)
  static List<News> favorites = [];

  // Cek apakah item sudah ada di favorit
  static bool isFavorite(News news) {
    return favorites.any((element) => element.id == news.id);
  }

  // Tambah ke favorit
  static void addFavorite(News news) {
    if (!isFavorite(news)) {
      favorites.add(news);
    }
  }

  // Hapus dari favorit
  static void removeFavorite(News news) {
    favorites.removeWhere((element) => element.id == news.id);
  }
}
