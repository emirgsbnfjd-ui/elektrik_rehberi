import 'package:flutter/material.dart';

class GerilimDusumuSayfasi extends StatefulWidget {
  const GerilimDusumuSayfasi({super.key});

  @override
  State<GerilimDusumuSayfasi> createState() => _GerilimDusumuSayfasiState();
}

class _GerilimDusumuSayfasiState extends State<GerilimDusumuSayfasi> {
  final _uzunluk = TextEditingController();
  final _akim = TextEditingController();
  final _kesit = TextEditingController();

  double dusum = 0;

  void hesapla() {
    final l = double.tryParse(_uzunluk.text) ?? 0;
    final i = double.tryParse(_akim.text) ?? 0;
    final s = double.tryParse(_kesit.text) ?? 0;

    if (s == 0) return;

    // Bakır yaklaşık değer
    dusum = (2 * l * i * 0.018) / s;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerilim Düşümü')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _uzunluk, decoration: const InputDecoration(labelText: 'Hat Uzunluğu (m)')),
            TextField(controller: _akim, decoration: const InputDecoration(labelText: 'Akım (A)')),
            TextField(controller: _kesit, decoration: const InputDecoration(labelText: 'Kablo Kesiti (mm²)')),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: hesapla, child: const Text('Hesapla')),
            const SizedBox(height: 16),
            Text('Gerilim Düşümü: ${dusum.toStringAsFixed(2)} V'),
          ],
        ),
      ),
    );
  }
}
