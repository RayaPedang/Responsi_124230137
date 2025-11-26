// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsi',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // Aplikasi dimulai dari Halaman Login (Soal 1)
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const MainNavigation(),
      },
      home: const LoginPage(),
    );
  }
}
