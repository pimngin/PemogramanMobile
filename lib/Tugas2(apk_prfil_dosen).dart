import 'package:flutter/material.dart';

// --- LANGKAH1: MODEL DATA ---
class Dosen {
  final String nama;
  final String nidn;
  final String email;
  final String NetworkImage;
  final String pendidikan;
  final String keahlian;

  Dosen({
    required this.nama,
    required this.nidn,
    required this.email,
    required this.NetworkImage,
    required this.pendidikan,
    required this.keahlian,
  });
}

// --- LANGKAH 2: DATA DUMMY ---
final List<Dosen> daftarDosen = [
  Dosen(
    nama: "Dr. Desi Pratami, S.T., M.Kom.",
    nidn: "0012345678",
    email: "budi.hartono@email.com",
    NetworkImage:  "data:image/jpeg;base64,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",
    pendidikan: "S3 Ilmu Komputer, Universitas Teknologi",
    keahlian: "Kecerdasan Buatan, Machine Learning",
  ),
  Dosen(
    nama: "Prof. Dr. Siti Aminah, S.Kom., M.Sc.",
    nidn: "0023456789",
    email: "siti.aminah@email.com",
    NetworkImage: "https://cdn.polyspeak.ai/speakmaster/poly-sdispatcher/images/c5bf339c-7740-437e-ae4e-b3fb666379f9.WEBP",
    pendidikan: "S3 Sistem Informasi, Institute of Science",
    keahlian: "Data Mining, Big Data Analytics",
  ),
  Dosen(
    nama: "shizuka hiratsuka, S.T., M.T.",
    nidn: "0034567890",
    email: "shizuka.hiratsuka@email.com",
    NetworkImage: "data:image/jpeg;base64,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",
    pendidikan: "S2 Teknik Informatika, Universitas Nasional",
    keahlian: "Mobile-First Development, Flutter",
  ),
  Dosen(
    nama: "Dr. rossweisse, S.Si., M.Kom.",
    nidn: "0045678901",
    email: "rossweisse@email.com",
    NetworkImage: "https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/deff5382-d7b3-40ae-8a9e-0f79c2a9dbe1/width=450/27606547.jpeg",
    pendidikan: "S3 Ilmu Komputer, Universitas Global",
    keahlian: "Jaringan Komputer, Keamanan Siber",
  ),
];


// --- LANGKAH 3: APLIKASI UTAMA ---
void main() {
  runApp(const ProfilDosenApp());
}

class ProfilDosenApp extends StatelessWidget {
  const ProfilDosenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profil Dosen App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 2,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const DosenListPage(),
    );
  }
}


// --- LANGKAH 4: HALAMAN 1 (DAFTAR DOSEN) ---
class DosenListPage extends StatelessWidget {
  const DosenListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Dosen"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: daftarDosen.length,
        itemBuilder: (BuildContext context, int index) {
          final Dosen dosen = daftarDosen[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DosenDetailPage(dosen: dosen),
                ),
              );
            },
            child: Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(dosen.NetworkImage),
                    backgroundColor: Colors.indigo[100],
                  ),
                  title: Text(
                    dosen.nama,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("NIDN: ${dosen.nidn}"),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.indigo, size: 16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


// --- LANGKAH 5: HALAMAN 2 (DETAIL DOSEN) ---
class DosenDetailPage extends StatelessWidget {
  final Dosen dosen;

  const DosenDetailPage({super.key, required this.dosen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Dosen"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan foto dan nama
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade200, Colors.indigo.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(dosen.NetworkImage),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    dosen.nama,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "NIDN: ${dosen.nidn}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Bagian informasi detail
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard("Email", dosen.email, Icons.email),
                  const SizedBox(height: 12),
                  _buildInfoCard("Pendidikan Terakhir", dosen.pendidikan, Icons.school),
                  const SizedBox(height: 12),
                  _buildInfoCard("Bidang Keahlian", dosen.keahlian, Icons.star),
                  const SizedBox(height: 24),

                  // Tombol Aksi
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Aksi saat tombol ditekan, misalnya menampilkan SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Menghubungi ${dosen.email}..."),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.send),
                      label: const Text("Hubungi via Email"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk membuat kartu informasi agar tidak duplikasi kode
  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
}
