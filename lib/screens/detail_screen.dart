import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_model.dart';

class DetailScreen extends StatefulWidget {
  final News news;
  const DetailScreen({super.key, required this.news});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  // Cek apakah item ini sudah ada di favorit
  Future<void> _checkFavoriteStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> savedFavorites = prefs.getStringList('favorites') ?? [];
      setState(() {
        isFavorite = savedFavorites.any((item) {
          try {
            final existing = News.fromJson(json.decode(item));
            return existing.id == widget.news.id;
          } catch (e) {
            return false;
          }
        });
      });
    } catch (e) {
      debugPrint('Error checking favorite status: $e');
    }
  }

  // Tambah atau Hapus Favorit
  Future<void> _toggleFavorite() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> savedFavorites = prefs.getStringList('favorites') ?? [];

      if (isFavorite) {
        // Hapus
        savedFavorites.removeWhere((item) {
          try {
            final existing = News.fromJson(json.decode(item));
            return existing.id == widget.news.id;
          } catch (e) {
            return false;
          }
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.news.title} removed from favorites'),
            ),
          );
        }
      } else {
        // Tambah
        String currentItemJson = json.encode(widget.news.toJson());
        savedFavorites.add(currentItemJson);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${widget.news.title} added to favorites')),
          );
        }
      }

      await prefs.setStringList('favorites', savedFavorites);
      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating favorites')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Article'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.news.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.image_not_supported, size: 64),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              widget.news.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Source and Date
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Source',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.news.newsSite,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Published',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.news.publishedAt.split('T').first,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Divider
            const Divider(),
            const SizedBox(height: 16),

            // Summary Title
            const Text(
              'Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Summary Content
            Text(
              widget.news.summary.isEmpty
                  ? 'No summary available'
                  : widget.news.summary,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),

            // Read More Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Could open URL using url_launcher package
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening article in browser...'),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('Read Full Article'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
