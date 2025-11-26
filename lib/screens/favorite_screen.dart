import 'package:flutter/material.dart';
import '../services/local_data.dart';
import 'detail_screen.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final favorites = LocalData.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Page")),
      body: favorites.isEmpty
          ? const Center(child: Text("Belum ada data favorit"))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return Dismissible(
                  key: Key(item.id.toString()), // Key unik berdasarkan ID
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      LocalData.removeFavorite(item);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.title} dihapus dari favorit'),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      leading: Image.network(
                        item.imageUrl,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item.title),
                      subtitle: Text(item.publishedAt.substring(0, 10)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(news: item),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
