import 'package:flutter/material.dart';
import 'note_model.dart';

class NoteFormPage extends StatefulWidget {
  final Note? existingNote;
  const NoteFormPage({super.key, this.existingNote});

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String _selectedCategory = 'Kuliah'; // Default kategori

  final List<String> _categories = ['Kuliah', 'Organisasi', 'Pribadi', 'Lain-lain'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingNote?.title ?? '');
    _contentController = TextEditingController(text: widget.existingNote?.content ?? '');
    if (widget.existingNote != null) {
      _selectedCategory = widget.existingNote!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) return; // Validasi wajib [cite: 392]

    final newNote = Note(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      category: _selectedCategory,
      // Jika edit, pakai tanggal lama, jika baru pakai waktu sekarang [cite: 381]
      date: widget.existingNote?.date ?? DateTime.now(),
    );

    Navigator.pop(context, newNote); // Kembali membawa data [cite: 389]
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingNote != null ? 'Edit Catatan' : 'Catatan Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Input Judul
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Input Kategori (Dropdown) [cite: 382]
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
                items: _categories.map((String cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 16),

              // Input Isi
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Isi Catatan',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (val) => val == null || val.isEmpty ? 'Isi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saveNote,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}