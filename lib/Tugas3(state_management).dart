import 'package:flutter/material.dart';
void main() {
  runApp(const FeadbackApp());
}

// === WIDGET UTAMA APLIKASI ===
class FeadbackApp extends StatelessWidget {
  const FeadbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Feedback',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        // Tema untuk button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        // Tema untuk input field
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.deepPurple),
        ),
      ),
      // Halaman awal aplikasi adalah HalamanPendaftaran
      home: const HalamanPendaftaran(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// === MODEL UNTUK MENYIMPAN DATA FEEDBACK ===
class FeedbackData {
  final String nama;
  final String komentar;
  final double rating;
  final DateTime waktu;

  FeedbackData({
    required this.nama,
    required this.komentar,
    required this.rating,
    required this.waktu,
  });
}

// List global untuk menyimpan semua feedback yang masuk
final List<FeedbackData> daftarFeedbackGlobal = [];


// === HALAMAN 1: FORM PENDAFTARAN (UPDATED) ===
class HalamanPendaftaran extends StatefulWidget {
  const HalamanPendaftaran({super.key});

  @override
  State<HalamanPendaftaran> createState() => _HalamanPendaftaranState();
}

class _HalamanPendaftaranState extends State<HalamanPendaftaran> {
  // Controller untuk setiap TextField
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _teleponController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();

  // State untuk Dropdown dan Password
  String? _jenisKelamin; // Variabel untuk menyimpan pilihan jenis kelamin
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  void _kirimData() {
    // Validasi form sebelum melanjutkan
    if (_formKey.currentState!.validate()) {
      // Ambil data nickname untuk diteruskan ke halaman feedback
      final nickname = _nicknameController.text;

      // Pindah ke HalamanFeedback dengan membawa data nickname
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HalamanFeedback(namaPengguna: nickname),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Pastikan semua controller di-dispose
    _namaController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pendaftaran'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_add_alt_1, size: 60, color: Colors.deepPurple),
                const SizedBox(height: 16),
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // NAMA LENGKAP
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // NICKNAME
                TextFormField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(
                    labelText: 'Nickname',
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nickname tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // EMAIL
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email tidak boleh kosong!';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Masukkan format email yang valid!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // NOMOR TELEPON
                TextFormField(
                  controller: _teleponController,
                  decoration: const InputDecoration(
                    labelText: 'No. Telepon',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'No. Telepon tidak boleh kosong!';
                    }
                    if (value.length < 9) {
                      return 'No. Telepon terlalu pendek!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // === PILIHAN JENIS KELAMIN ===
                DropdownButtonFormField<String>(
                  value: _jenisKelamin,
                  decoration: const InputDecoration(
                    labelText: 'Jenis Kelamin',
                    prefixIcon: Icon(Icons.wc),
                  ),
                  hint: const Text('Pilih Jenis Kelamin'),
                  items: ['Laki-laki', 'Perempuan'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _jenisKelamin = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Harap pilih jenis kelamin!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // PASSWORD
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible, // Sembunyikan atau tampilkan password
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong!';
                    }
                    if (value.length < 6) {
                      return 'Password minimal harus 6 karakter!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _kirimData,
                  child: const Text('Daftar & Lanjutkan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// === HALAMAN 2: FORM KOMENTAR & RATING (UNCHANGED) ===
class HalamanFeedback extends StatefulWidget {
  final String namaPengguna;

  const HalamanFeedback({super.key, required this.namaPengguna});

  @override
  State<HalamanFeedback> createState() => _HalamanFeedbackState();
}

class _HalamanFeedbackState extends State<HalamanFeedback> {
  final _komentarController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _rating = 0.0; // State untuk menyimpan nilai rating

  void _updateRating(double newRating) {
    // Perbarui state rating saat pengguna menekan bintang
    setState(() {
      _rating = newRating;
    });
  }

  void _kirimFeedback() {
    if (_formKey.currentState!.validate()) {
      if (_rating == 0.0) {
        // Tampilkan peringatan jika rating belum diisi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap berikan rating terlebih dahulu!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Buat objek FeedbackData baru
      final feedbackBaru = FeedbackData(
        nama: widget.namaPengguna,
        komentar: _komentarController.text,
        rating: _rating,
        waktu: DateTime.now(),
      );

      // Gunakan setState untuk menambahkan feedback baru ke list global
      setState(() {
        daftarFeedbackGlobal.add(feedbackBaru);
      });

      // Kembali ke halaman sebelumnya dan langsung ke HalamanHasil
      Navigator.pop(context); // Tutup halaman feedback
      Navigator.push(     // Buka halaman hasil
        context,
        MaterialPageRoute(
          builder: (context) => const HalamanHasil(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _komentarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beri Feedback'),
        actions: [
          // Tombol untuk melihat hasil feedback
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HalamanHasil()),
              );
            },
            tooltip: 'Lihat Hasil Feedback',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, ${widget.namaPengguna}!',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Bagaimana pengalaman Anda Dalam Aplikasi Ini? Tolong Berikan kami masukan.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              const Text('Rating Anda:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              // Widget untuk Rating Bintang
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      _updateRating(index + 1.0);
                    },
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              // Input untuk Komentar
              TextFormField(
                controller: _komentarController,
                decoration: const InputDecoration(
                  labelText: 'Komentar Anda',
                  hintText: 'Tuliskan masukan Anda di sini...',
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Komentar tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _kirimFeedback,
                  child: const Text('Kirim Feedback'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// === HALAMAN 3: MENAMPILKAN HASIL FEEDBACK (UNCHANGED) ===
class HalamanHasil extends StatefulWidget {
  const HalamanHasil({super.key});

  @override
  State<HalamanHasil> createState() => _HalamanHasilState();
}

class _HalamanHasilState extends State<HalamanHasil> {
  @override
  Widget build(BuildContext context) {
    // Urutkan daftar feedback dari yang terbaru
    final sortedList = List.of(daftarFeedbackGlobal)..sort((a, b) => b.waktu.compareTo(a.waktu));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Feedback'),
      ),
      body: sortedList.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Belum ada feedback',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: sortedList.length,
        itemBuilder: (context, index) {
          final feedback = sortedList[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        feedback.nama,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Menampilkan rating bintang
                      Row(
                        children: List.generate(5, (i) => Icon(
                          i < feedback.rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feedback.komentar,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    // Format waktu agar mudah dibaca
                    '${feedback.waktu.day}/${feedback.waktu.month}/${feedback.waktu.year} - ${feedback.waktu.hour}:${feedback.waktu.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

