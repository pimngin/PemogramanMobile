import 'package:flutter/material.dart';
import 'note_form_page.dart';
import 'note_model.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  String _selectedCategory = 'Semua'; // Filter default

  final List<String> _categories = ['Semua', 'Kuliah', 'Organisasi', 'Pribadi', 'Lain-lain'];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Load data dari SharedPreferences [cite: 394]
  Future<void> _loadNotes() async {
    final loaded = await LocalStorageService.loadNotes();
    setState(() {
      _notes = loaded;
      _filterNotes();
    });
  }

  // Filter list berdasarkan kategori dropdown
  void _filterNotes() {
    if (_selectedCategory == 'Semua') {
      _filteredNotes = List.from(_notes);
    } else {
      _filteredNotes = _notes.where((note) => note.category == _selectedCategory).toList();
    }
  }

  // Mendapatkan Icon berdasarkan kategori
  Icon _getCategoryIcon(String category) {
    switch (category) {
      case 'Kuliah': return const Icon(Icons.school, color: Colors.blue);
      case 'Organisasi': return const Icon(Icons.groups, color: Colors.orange);
      case 'Pribadi': return const Icon(Icons.person, color: Colors.green);
      default: return const Icon(Icons.note, color: Colors.grey);
    }
  }

  // Navigasi ke Form Tambah/Edit [cite: 389]
  Future<void> _openForm({Note? existingNote, int? index}) async {
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (context) => NoteFormPage(existingNote: existingNote),
      ),
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          _notes[index] = result; // Update
        } else {
          _notes.add(result); // Create
        }
        _filterNotes(); // Refresh filter
        LocalStorageService.saveNotes(_notes); // Auto-save ke HP
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(index != null ? 'Catatan diperbarui' : 'Catatan ditambahkan')),
      );
    }
  }

  void _deleteNote(int index) {
    // Cari index asli di list utama (karena index di filtered list bisa beda)
    Note noteToDelete = _filteredNotes[index];
    int realIndex = _notes.indexOf(noteToDelete);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Catatan?'),
        content: Text('Hapus "${noteToDelete.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              setState(() {
                _notes.removeAt(realIndex);
                _filterNotes();
                LocalStorageService.saveNotes(_notes);
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          // Tombol Ganti Tema (Dark Mode Toggle)
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              MyApp.of(context)?.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Area Filter Kategori
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Filter Kategori',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.filter_list),
              ),
              value: _selectedCategory,
              items: _categories.map((String cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedCategory = val!;
                  _filterNotes();
                });
              },
            ),
          ),
          // List Catatan [cite: 388]
          Expanded(
            child: _filteredNotes.isEmpty
                ? const Center(child: Text('Belum ada catatan di kategori ini.'))
                : ListView.builder(
              itemCount: _filteredNotes.length,
              itemBuilder: (context, index) {
                final note = _filteredNotes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: _getCategoryIcon(note.category), // Icon Kategori
                    title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(note.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(
                          '${note.date.day}/${note.date.month}/${note.date.year}', // Tampilkan Tanggal
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    onTap: () => _openForm(existingNote: note, index: _notes.indexOf(note)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteNote(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}