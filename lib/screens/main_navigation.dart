import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan import ini
import 'home_screen.dart';
import 'favorite_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  String _title = 'Space News'; // Default title

  final List<Widget> _screens = [const HomePage(), const FavoritePage()];

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  // Fungsi untuk mengambil username dari Shared Preferences
  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? 'User';
    setState(() {
      // Set title AppBar sesuai format yang diminta
      // Anda bisa menyesuaikan teksnya, misal: "Hi, $username" atau hanya "$username"
      _title = "Hi, $username";
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Opsional: Mengubah judul AppBar saat pindah tab
      if (index == 1) {
        _title = "Favorite Page";
      } else {
        _loadUsername(); // Kembalikan ke nama user saat di tab Home
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      appBar: AppBar(
        title: Text(_title), // Menggunakan variabel _title
        centerTitle: true,
        elevation: _selectedIndex == 0 ? 2 : 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
                        onPressed: () async {
                          // Hapus sesi login (opsional, tergantung kebutuhan logout Anda)
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isLogin', false);

                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false,
                            );
                          }
                        },
                        child: const Text('Ya'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
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
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
