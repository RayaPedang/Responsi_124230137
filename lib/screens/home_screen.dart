import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_model.dart';
import '../services/api_sources.dart';
import '../services/local_data.dart';
import 'detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = "";
  String _selectedCategory = "articles"; // Default menu
  late Future<List<News>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _dataFuture = ApiSource.getData(_selectedCategory);
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "User";
    });
  }

  void _changeCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _dataFuture = ApiSource.getData(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Selamat datang, $_username")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMenuButton("Articles", "articles"),
                _buildMenuButton("Blogs", "blogs"),
                _buildMenuButton("Reports", "reports"),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder<List<News>>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Tidak ada data."));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: ListTile(
                        leading: Image.network(
                          item.imageUrl,
                          width: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) =>
                              const Icon(Icons.error),
                        ),
                        title: Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          item.publishedAt.substring(0, 10),
                        ), // Format tanggal simpel
                        trailing: IconButton(
                          icon: Icon(
                            LocalData.isFavorite(item)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              if (LocalData.isFavorite(item)) {
                                LocalData.removeFavorite(item);
                              } else {
                                LocalData.addFavorite(item);
                              }
                            });
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(news: item),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String label, String value) {
    final isSelected = _selectedCategory == value;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.purple[100] : Colors.grey[200],
        foregroundColor: isSelected ? Colors.purple : Colors.black,
      ),
      onPressed: () => _changeCategory(value),
      child: Text(label),
    );
  }
}
