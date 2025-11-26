import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/news_item.dart';
import 'detail_screen.dart';
import 'favorite_screen.dart';
import 'login_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Welcome, $username"), // [cite: 42, 43]
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteScreen()),
              ),
            ),
            IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Articles'), // [cite: 44]
              Tab(text: 'Blogs'), // [cite: 45]
              Tab(text: 'Reports'), // [cite: 52]
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            NewsList(endpoint: 'articles'),
            NewsList(endpoint: 'blogs'),
            NewsList(endpoint: 'reports'),
          ],
        ),
      ),
    );
  }
}

// Widget Reusable untuk List Berita
class NewsList extends StatelessWidget {
  final String endpoint;
  const NewsList({super.key, required this.endpoint});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return FutureBuilder<List<NewsItem>>(
      future: apiService.fetchNews(endpoint),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No data found"));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final item = snapshot.data![index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: Image.network(
                  item.imageUrl,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                ),
                title: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ), // [cite: 46]
                subtitle: Text(
                  DateFormat(
                    'MMMM dd, yyyy',
                  ).format(DateTime.parse(item.publishedAt)),
                ), // [cite: 47]
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(newsItem: item),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
