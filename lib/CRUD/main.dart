import 'package:flutter/material.dart';
import 'home_page.dart'; // Pastikan import file home_page nanti
import 'note_model.dart'; // Pastikan import model di atas

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Helper statis agar bisa akses toggle theme dari mana saja
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  // Load theme saat aplikasi dibuka
  void _loadTheme() async {
    bool isDark = await LocalStorageService.loadTheme();
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Fungsi ganti tema
  void toggleTheme() {
    setState(() {
      final isDark = _themeMode == ThemeMode.dark;
      _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
      LocalStorageService.saveTheme(!isDark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas CRUD Catatan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true), // Tema Gelap
      themeMode: _themeMode,
      home: const HomePage(),
    );
  }
}