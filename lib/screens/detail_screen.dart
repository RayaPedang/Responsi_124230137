import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_item.dart';
import '../providers/favorite_provider.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  final NewsItem newsItem;

  const DetailScreen({super.key, required this.newsItem});

  // Fungsi untuk launch URL
  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(newsItem.url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Page"), // [cite: 57]
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(
                  provider.isFavorite(newsItem)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: provider.isFavorite(newsItem) ? Colors.red : null,
                ),
                onPressed: () => provider.toggleFavorite(newsItem),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              newsItem.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsItem.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // [cite: 58]
                  const SizedBox(height: 8),
                  Text(
                    DateFormat(
                      'MMMM dd, yyyy',
                    ).format(DateTime.parse(newsItem.publishedAt)),
                    style: const TextStyle(color: Colors.grey),
                  ), // [cite: 59]
                  const SizedBox(height: 8),
                  Text(
                    newsItem.newsSite,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    newsItem.summary,
                    style: const TextStyle(fontSize: 16),
                  ), // [cite: 60]
                ],
              ),
            ),
          ],
        ),
      ),
      // Tombol Floating Button untuk "Read more..." [cite: 55, 63]
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchUrl,
        label: const Text("Read more..."),
        icon: const Icon(Icons.open_in_browser),
      ),
    );
  }
}
