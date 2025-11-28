import 'package:flutter/material.dart';

class FormMahasiswaValidasi extends StatefulWidget {
  const FormMahasiswaValidasi({super.key});

  @override
  State<FormMahasiswaValidasi> createState() => _FormMahasiswaValidasiState();
}

class _FormMahasiswaValidasiState extends State<FormMahasiswaValidasi> {
  int _currentStep = 0;
  bool _submitted = false;

  // Controller untuk input text
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomorHPController = TextEditingController();

  // State variable lainnya
  String? _jurusan;
  double _semester = 1;
  List<String> _hobi = [];
  bool _persetujuan = false;

  // Key untuk validasi form
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  // Data Options
  final List<String> _jurusanOptions = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Komputer',
    'Manajemen Informatika',
    'Desain Komunikasi Visual'
  ];

  final List<String> _hobiOptions = [
    'Olahraga',
    'Musik',
    'Membaca',
    'Gaming',
    'Travelling',
    'Fotografi'
  ];

  // --- LOGIKA NAVIGASI & VALIDASI ---

  void _handleNext() {
    if (_currentStep == 0) {
      if (_formKeyStep1.currentState!.validate()) {
        setState(() => _currentStep++);
      }
    } else if (_currentStep == 1) {
      if (_formKeyStep2.currentState!.validate()) {
        if (_hobi.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pilih minimal satu hobi')),
          );
          return;
        }
        setState(() => _currentStep++);
      }
    } else {
      _handleSubmit();
    }
  }

  void _handleSubmit() {
    if (!_persetujuan) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda harus menyetujui syarat & ketentuan')),
      );
      return;
    }
    setState(() => _submitted = true);
  }

  void _handleBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _resetForm() {
    _namaController.clear();
    _emailController.clear();
    _nomorHPController.clear();
    setState(() {
      _jurusan = null;
      _semester = 1;
      _hobi = [];
      _persetujuan = false;
      _currentStep = 0;
      _submitted = false;
    });
  }

  // --- WIDGETS ---

  @override
  Widget build(BuildContext context) {
    // Jika sudah submit, tampilkan halaman sukses
    if (_submitted) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade50, Colors.indigo.shade100],
            ),
          ),
          child: Center(
            child: Card(
              margin: const EdgeInsets.all(32),
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 80),
                    const SizedBox(height: 16),
                    const Text(
                      'Registrasi Berhasil!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nama: ${_namaController.text}'),
                          Text('Email: ${_emailController.text}'),
                          Text('Nomor HP: ${_nomorHPController.text}'),
                          Text('Jurusan: $_jurusan'),
                          Text('Semester: ${_semester.toInt()}'),
                          Text('Hobi: ${_hobi.join(', ')}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _resetForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: const Text('Isi Form Lagi'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Halaman Form Utama
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.indigo.shade100],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'Form Registrasi Mahasiswa',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Lengkapi data Anda dengan benar',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  // Stepper Indicator (Simplified)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStepIndicator(0, 'Pribadi', Icons.person),
                        _buildLine(0),
                        _buildStepIndicator(1, 'Akademik', Icons.school),
                        _buildLine(1),
                        _buildStepIndicator(2, 'Konfirmasi', Icons.check_circle_outline),
                      ],
                    ),
                  ),

                  // Form Content
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        if (_currentStep == 0) _buildStep1(),
                        if (_currentStep == 1) _buildStep2(),
                        if (_currentStep == 2) _buildStep3(),

                        const SizedBox(height: 32),

                        // Navigation Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: _currentStep == 0 ? null : _handleBack,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade200,
                                foregroundColor: Colors.grey.shade800,
                              ),
                              child: const Text('Kembali'),
                            ),
                            ElevatedButton(
                              onPressed: _handleNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(_currentStep == 2 ? 'Submit' : 'Lanjut'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- BUILDER HELPER ---

  Widget _buildStepIndicator(int index, String title, IconData icon) {
    bool isActive = index == _currentStep;
    bool isCompleted = index < _currentStep;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? Colors.indigo : (isCompleted ? Colors.green : Colors.grey.shade300),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.indigo : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        )
      ],
    );
  }

  Widget _buildLine(int index) {
    return Expanded(
      child: Container(
        height: 2,
        color: index < _currentStep ? Colors.green : Colors.grey.shade300,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 20), // align with circle
      ),
    );
  }

  // --- FORM STEPS ---

  Widget _buildStep1() {
    return Form(
      key: _formKeyStep1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Data Pribadi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextFormField(
            controller: _namaController,
            decoration: const InputDecoration(
              labelText: 'Nama Lengkap',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (value) => value!.trim().isEmpty ? 'Nama wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.trim().isEmpty) return 'Email wajib diisi';
              if (!value.contains('@')) return 'Format email tidak valid';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nomorHPController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Nomor HP',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.trim().isEmpty) return 'Nomor HP wajib diisi';
              if (!RegExp(r'^\d+$').hasMatch(value)) return 'Hanya boleh angka';
              if (value.length < 10) return 'Minimal 10 digit';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _formKeyStep2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Data Akademik', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _jurusan,
            decoration: const InputDecoration(
              labelText: 'Jurusan',
              border: OutlineInputBorder(),
            ),
            items: _jurusanOptions.map((String val) {
              return DropdownMenuItem(value: val, child: Text(val));
            }).toList(),
            onChanged: (value) => setState(() => _jurusan = value),
            validator: (value) => value == null ? 'Jurusan wajib dipilih' : null,
          ),
          const SizedBox(height: 24),
          Text('Semester: ${_semester.toInt()}', style: const TextStyle(fontWeight: FontWeight.w500)),
          Slider(
            value: _semester,
            min: 1,
            max: 8,
            divisions: 7,
            label: _semester.round().toString(),
            onChanged: (value) => setState(() => _semester = value),
          ),
          const SizedBox(height: 16),
          const Text('Hobi (Pilih minimal 1)', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _hobiOptions.map((hobi) {
              return FilterChip(
                label: Text(hobi),
                selected: _hobi.contains(hobi),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _hobi.add(hobi);
                    } else {
                      _hobi.remove(hobi);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Konfirmasi Data', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildSummaryRow('Nama', _namaController.text),
              _buildSummaryRow('Email', _emailController.text),
              _buildSummaryRow('No HP', _nomorHPController.text),
              _buildSummaryRow('Jurusan', _jurusan ?? '-'),
              _buildSummaryRow('Semester', _semester.toInt().toString()),
              _buildSummaryRow('Hobi', _hobi.join(', ')),
            ],
          ),
        ),
        const SizedBox(height: 20),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Saya menyetujui Syarat & Ketentuan yang berlaku dan menyatakan bahwa data yang saya berikan adalah benar.',
            style: TextStyle(fontSize: 13),
          ),
          value: _persetujuan,
          onChanged: (value) => setState(() => _persetujuan = value!),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
// Tambahkan ini di baris paling bawah file
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FormMahasiswaValidasi(),
  ));
}
