import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kalkulator Nilai Mahasiswa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const KalkulatorNilaiScreen(),
    );
  }
}

class KalkulatorNilaiScreen extends StatefulWidget {
  const KalkulatorNilaiScreen({super.key});

  @override
  State<KalkulatorNilaiScreen> createState() => _KalkulatorNilaiScreenState();
}

class _KalkulatorNilaiScreenState extends State<KalkulatorNilaiScreen> {
  final _namaController = TextEditingController();
  final _tugasController = TextEditingController();
  final _utsController = TextEditingController();
  final _uasController = TextEditingController();

  String? _matkulTerpilih;
  double? _nilaiAkhir;
  String _grade = '';
  String _status = '';
  String _namaMahasiswa = '';
  String _mataKuliah = '';

  // Daftar Mata Kuliah
  final List<String> _daftarMatkul = [
    'Pemrograman Aplikasi Bergerak',
    'Pemrograman Web',
    'Basis Data',
    'Analisis dan Perancangan Sistem Informasi',
    'Jaringan Komputer',
    'Algoritma dan Pemrograman',
  ];

  void _hitungNilai() {
    final double? tugas = double.tryParse(_tugasController.text);
    final double? uts = double.tryParse(_utsController.text);
    final double? uas = double.tryParse(_uasController.text);

    if (_namaController.text.isEmpty ||
        _matkulTerpilih == null ||
        tugas == null ||
        uts == null ||
        uas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua inputan dengan benar!')),
      );
      return;
    }

    // Perhitungan Nilai Akhir: 30% Tugas + 30% UTS + 40% UAS
    final double akhir = (0.30 * tugas) + (0.30 * uts) + (0.40 * uas);

    // Menentukan Grade
    String grade;
    if (akhir >= 85) {
      grade = 'A';
    } else if (akhir >= 75) {
      grade = 'B';
    } else if (akhir >= 65) {
      grade = 'C';
    } else if (akhir >= 50) {
      grade = 'D';
    } else {
      grade = 'E';
    }

    // Menentukan Status Kelulusan
    String status = akhir >= 60 ? 'Lulus' : 'Tidak Lulus';

    setState(() {
      _namaMahasiswa = _namaController.text;
      _mataKuliah = _matkulTerpilih!;
      _nilaiAkhir = akhir;
      _grade = grade;
      _status = status;
    });
  }

  void _resetForm() {
    setState(() {
      _namaController.clear();
      _tugasController.clear();
      _utsController.clear();
      _uasController.clear();
      _matkulTerpilih = null;
      _nilaiAkhir = null;
      _grade = '';
      _status = '';
      _namaMahasiswa = '';
      _mataKuliah = '';
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _tugasController.dispose();
    _utsController.dispose();
    _uasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Nilai Mahasiswa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Mahasiswa',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _matkulTerpilih,
              decoration: const InputDecoration(
                labelText: 'Pilih Mata Kuliah',
                border: OutlineInputBorder(),
              ),
              items: _daftarMatkul.map((String matkul) {
                return DropdownMenuItem<String>(
                  value: matkul,
                  child: Text(matkul),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _matkulTerpilih = newValue;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tugasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nilai Tugas (30%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _utsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nilai UTS (30%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _uasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nilai UAS (40%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _hitungNilai,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Hitung Nilai'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _resetForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_nilaiAkhir != null)
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hasil Perhitungan:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Divider(),
                      Text('Nama: $_namaMahasiswa'),
                      Text('Mata Kuliah: $_mataKuliah'),
                      Text('Nilai Akhir: ${_nilaiAkhir!.toStringAsFixed(2)}'),
                      Text('Grade: $_grade'),
                      Text(
                        'Status: $_status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _status == 'Lulus' ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
