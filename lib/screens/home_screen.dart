import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_model.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<News>> _newsList;
  Set<String> _favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _newsList = fetchNews();
    _loadFavorites(); // Load status favorit saat awal
  }

  // Mengambil data favorit dari SharedPreferences untuk pengecekan UI
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedFavorites = prefs.getStringList('favorites') ?? [];

    setState(() {
      _favoriteIds = savedFavorites.map((item) {
        final dynamic json = jsonDecode(item);
        return json['id'].toString();
      }).toSet();
    });
  }

  // Mengambil data dari API
  Future<List<News>> fetchNews() async {
    final response = await http.get(
      Uri.parse('https://api.spaceflightnewsapi.net/v4/articles/'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> newsJson = data['results'] ?? [];
      return newsJson.map((json) => News.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  // Fungsi toggle favorit
  Future<void> _toggleFavorite(News news) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedFavorites = prefs.getStringList('favorites') ?? [];
    String newsId = news.id.toString();
    String newsJson = json.encode(news.toJson());

    bool isAlreadyFavorite = _favoriteIds.contains(newsId);

    if (isAlreadyFavorite) {
      savedFavorites.removeWhere((item) {
        final dynamic json = jsonDecode(item);
        return json['id'].toString() == newsId;
      });
      _favoriteIds.remove(newsId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${news.title} removed from favorites')),
        );
      }
    } else {
      savedFavorites.add(newsJson);
      _favoriteIds.add(newsId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${news.title} added to favorites')),
        );
      }
    }

    await prefs.setStringList('favorites', savedFavorites);
    setState(() {}); // Trigger rebuild untuk update warna icon
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selamat Datang di Space News'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<News>>(
        future: _newsList,
        builder: (context, snapshot) {
          // Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Data Available'));
          }

          // Menampilkan List Data
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final news = snapshot.data![index];
              final String uniqueId = news.id.toString();
              final bool isFavorite = _favoriteIds.contains(uniqueId);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Image.network(
                    news.imageUrl,
                    width: 50,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                  title: Text(
                    news.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(news.newsSite),
                  trailing: IconButton(
                    // Logika perubahan Icon dan Warna
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () => _toggleFavorite(news),
                  ),
                  onTap: () {
                    // Navigasi ke DetailScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(news: news),
                      ),
                    ).then((_) {
                      _loadFavorites();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
