import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'favorite_screen.dart';
import 'login_screen.dart'; // Import LoginScreen untuk navigasi manual
import '../services/local_data.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  String _username = ""; // Variabel untuk menyimpan username

  final List<Widget> _screens = [const HomePage(), const FavoritePage()];

  @override
  void initState() {
    super.initState();
    _loadUsername();
    // Load persisted favorites into memory
    LocalData.loadFavorites().then((_) {
      if (mounted) setState(() {});
    });
  }

  // Mengambil username dari SharedPreference untuk ditampilkan di AppBar
  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "User";
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus data sesi login

    // Clear in-memory favorites cache
    LocalData.favorites.clear();

    if (mounted) {
      // PERBAIKAN: Gunakan MaterialPageRoute karena route '/' tidak didefinisikan di main.dart
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // PERBAIKAN: Menampilkan Username di AppBar (Sesuai Soal No. 2)
        // Jika di Home tampilkan username, jika di Favorite tampilkan judul lain
        title: Text(
          _selectedIndex == 0 ? "Hi, $_username" : "My Favorites",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Apa Anda yakin ingin keluar?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed:
                            _logout, // Panggil fungsi logout yang sudah diperbaiki
                        child: const Text(
                          'Ya',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
      ),
    );
  }
}
