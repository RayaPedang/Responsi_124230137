import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Tambahkan import ini
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
  String _selectedCategory = "articles"; // Default category
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

  // Fungsi baru untuk memformat tanggal sesuai PDF (Contoh: November 18 2024)
  String _formatDate(String dateString) {
    try {
      final DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('MMMM d yyyy').format(parsedDate);
    } catch (e) {
      return dateString; // Fallback jika parsing gagal
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              "Selamat datang, $_username",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Menu Pilihan (Articles, Blogs, Reports)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMenuButton("Articles", "articles"),
                _buildMenuButton("Blogs", "blogs"),
                _buildMenuButton("Reports", "reports"),
              ],
            ),
          ),
          const SizedBox(height: 10),
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
                    final isFav = LocalData.isFavorite(item);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) =>
                                const Icon(Icons.broken_image, size: 80),
                          ),
                        ),
                        title: Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Menggunakan helper _formatDate di sini
                        subtitle: Text(
                          _formatDate(item.publishedAt),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isFav) {
                                LocalData.removeFavorite(item);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${item.title} dihapus dari favorit',
                                    ),
                                  ),
                                );
                              } else {
                                LocalData.addFavorite(item);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${item.title} ditambahkan ke favorit',
                                    ),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                        onTap: () async {
                          // Navigasi ke Detail Page
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(news: item),
                            ),
                          );
                          // Refresh state ketika kembali dari detail page
                          setState(() {});
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
        backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      onPressed: () => _changeCategory(value),
      child: Text(label),
    );
  }
}
