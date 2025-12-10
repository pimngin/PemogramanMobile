import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Model Data Catatan [cite: 52, 381, 382]
class Note {
  String title;
  String content;
  String category; // Kategori: Kuliah, Organisasi, Pribadi, Lain-lain
  DateTime date;   // Tanggal pembuatan

  Note({
    required this.title,
    required this.content,
    required this.category,
    required this.date,
  });

  // Convert ke Map untuk disimpan sebagai JSON
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  // Convert dari Map (JSON) ke Object Note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      category: map['category'] ?? 'Lain-lain',
      date: DateTime.parse(map['date']),
    );
  }
}

// Service untuk SharedPreferences (Bonus) [cite: 393, 395]
class LocalStorageService {
  static const String _keyNotes = 'notes_data';
  static const String _keyTheme = 'is_dark_mode';

  // Simpan List Catatan
  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(notes.map((e) => e.toMap()).toList());
    await prefs.setString(_keyNotes, encoded);
  }

  // Load List Catatan
  static Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString(_keyNotes);
    if (notesString == null) return [];

    final List<dynamic> decoded = json.decode(notesString);
    return decoded.map((e) => Note.fromMap(e)).toList();
  }

  // Simpan Preferensi Dark Mode
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTheme, isDark);
  }

  // Load Preferensi Dark Mode
  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTheme) ?? false;
  }
}