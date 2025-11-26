import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_model.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<News> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Memuat data saat halaman dibuka
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> savedFavorites = prefs.getStringList('favorites') ?? [];
      setState(() {
        _favorites = savedFavorites
            .map((item) {
              try {
                return News.fromJson(json.decode(item));
              } catch (e) {
                debugPrint('Error parsing favorite item: $e');
                return null;
              }
            })
            .whereType<News>()
            .toList();
      });
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  // Fungsi hapus data
  Future<void> _removeFavorite(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedFavorites = prefs.getStringList('favorites') ?? [];

    News removedItem = _favorites[index];
    savedFavorites.removeAt(index);

    await prefs.setStringList('favorites', savedFavorites);

    setState(() {
      _favorites.removeAt(index);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${removedItem.title} removed from favorites')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites'), centerTitle: true),
      body: _favorites.isEmpty
          ? const Center(child: Text("No Favorites yet"))
          : ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final news = _favorites[index];
                // Fitur Swipe to Delete
                return Dismissible(
                  key: Key(news.title + news.newsSite),
                  direction:
                      DismissDirection.horizontal, // Swipe kiri atau kanan
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _removeFavorite(index);
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: ListTile(
                      leading: Image.network(
                        news.imageUrl,
                        width: 50,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                      ),
                      title: Text(news.title),
                      subtitle: Text(news.publishedAt),
                      onTap: () {
                        // Navigasi ke Detail
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(news: news),
                          ),
                        ).then((_) => _loadFavorites());
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
