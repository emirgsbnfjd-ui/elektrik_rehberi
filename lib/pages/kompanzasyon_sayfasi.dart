import 'package:flutter/material.dart';
import 'dart:math';

class KompanzasyonSayfasi extends StatefulWidget {
  const KompanzasyonSayfasi({super.key});

  @override
  State<KompanzasyonSayfasi> createState() => _KompanzasyonSayfasiState();
}

class _KompanzasyonSayfasiState extends State<KompanzasyonSayfasi> {
  final _kw = TextEditingController();
  final _cos1 = TextEditingController(text: '0.7');
  final _cos2 = TextEditingController(text: '0.95');

  double kvar = 0;

  void hesapla() {
    final p = double.tryParse(_kw.text) ?? 0;
    final c1 = double.tryParse(_cos1.text) ?? 0;
    final c2 = double.tryParse(_cos2.text) ?? 0;

    final q1 = p * tan(acos(c1));
    final q2 = p * tan(acos(c2));

    setState(() => kvar = q1 - q2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kompanzasyon Hesabı')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _kw, decoration: const InputDecoration(labelText: 'Aktif Güç (kW)')),
            TextField(controller: _cos1, decoration: const InputDecoration(labelText: 'Mevcut cosφ')),
            TextField(controller: _cos2, decoration: const InputDecoration(labelText: 'Hedef cosφ')),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: hesapla, child: const Text('Hesapla')),
            const SizedBox(height: 16),
            Text('Gerekli Kondansatör: ${kvar.toStringAsFixed(2)} kVAr'),
          ],
        ),
      ),
    );
  }
}
