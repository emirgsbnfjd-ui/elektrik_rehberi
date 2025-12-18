import 'dart:math';
import 'package:flutter/material.dart';

class GucHesabiSayfasi extends StatefulWidget {
  const GucHesabiSayfasi({super.key});

  @override
  State<GucHesabiSayfasi> createState() => _GucHesabiSayfasiState();
}

class _GucHesabiSayfasiState extends State<GucHesabiSayfasi> {
  final _pKw = TextEditingController();
  final _v = TextEditingController(text: '230');
  final _cos = TextEditingController(text: '0.90');

  bool trifaze = false;
  String sonuc = '';

  double? _d(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '.'));

  void hesapla() {
    final pKw = _d(_pKw);
    final v = _d(_v);
    final cos = _d(_cos);

    if (pKw == null || v == null || cos == null || cos <= 0 || cos > 1) {
      setState(() => sonuc = 'Değerleri kontrol et (cosφ 0-1 arası)');
      return;
    }

    final pW = pKw * 1000;
    final i = trifaze
        ? pW / (sqrt(3) * v * cos)
        : pW / (v * cos);

    setState(() {
      sonuc =
          '${trifaze ? "Trifaze" : "Monofaze"}\n'
          'Güç: ${pKw.toStringAsFixed(2)} kW\n'
          'Gerilim: ${v.toStringAsFixed(0)} V\n'
          'cosφ: ${cos.toStringAsFixed(2)}\n'
          'Akım: ${i.toStringAsFixed(2)} A';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Güç Hesabı')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: trifaze,
            onChanged: (v) {
              setState(() {
                trifaze = v;
                _v.text = trifaze ? '400' : '230';
              });
            },
            title: const Text('Trifaze'),
          ),
          _input('Güç (kW)', _pKw),
          _input('Gerilim (V)', _v),
          _input('cosφ', _cos),
          const SizedBox(height: 12),
          FilledButton(onPressed: hesapla, child: const Text('Hesapla')),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(sonuc.isEmpty ? 'Sonuç burada' : sonuc),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
