import 'package:flutter/material.dart';

class EvTuketimiSayfasi extends StatefulWidget {
  const EvTuketimiSayfasi({super.key});

  @override
  State<EvTuketimiSayfasi> createState() => _EvTuketimiSayfasiState();
}

class _EvTuketimiSayfasiState extends State<EvTuketimiSayfasi> {
  // Güç artık kW
  final _gucKw = TextEditingController(text: '1'); // kW
  final _saat = TextEditingController(text: '5'); // saat/gün
  final _gun = TextEditingController(text: '30'); // gün/ay
  final _birimFiyat = TextEditingController(text: '2.5'); // TL/kWh

  String sonuc = '';

  double? _d(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '.').trim());

  void hesapla() {
    final gucKw = _d(_gucKw);
    final saatGun = _d(_saat);
    final gunAy = _d(_gun);
    final fiyat = _d(_birimFiyat);

    if ([gucKw, saatGun, gunAy, fiyat].any((e) => e == null)) {
      setState(() => sonuc = 'Lütfen tüm alanları doldur.');
      return;
    }

    if (gucKw! <= 0 || saatGun! <= 0 || gunAy! <= 0 || fiyat! <= 0) {
      setState(() => sonuc = 'Değerler 0’dan büyük olmalı.');
      return;
    }

    // Hesaplar (kW direkt giriliyor)
    final gunlukKwh = gucKw * saatGun;
    final aylikKwh = gunlukKwh * gunAy;
    final aylikTl = aylikKwh * fiyat;

    setState(() {
      sonuc =
          '✅ EV TÜKETİM HESABI ✅\n'
          'Cihaz Gücü      : ${gucKw.toStringAsFixed(2)} kW\n'
          'Günlük Kullanım : ${saatGun.toStringAsFixed(1)} saat\n'
          'Aylık Gün       : ${gunAy.toStringAsFixed(0)} gün\n\n'
          'Günlük Tüketim  : ${gunlukKwh.toStringAsFixed(2)} kWh\n'
          'Aylık Tüketim   : ${aylikKwh.toStringAsFixed(2)} kWh\n\n'
          'Birim Fiyat     : ${fiyat.toStringAsFixed(2)} TL / kWh\n'
          'Aylık Maliyet   : ${aylikTl.toStringAsFixed(2)} TL\n\n'
          'Not:\n'
          '- Bu değerler ortalama kullanım içindir.\n'
          '- Aynı anda çalışan cihazlar toplamı faturayı büyütür.\n'
          '- Kademeli tarife varsa sonuç değişebilir.';
    });
  }

  @override
  void dispose() {
    _gucKw.dispose();
    _saat.dispose();
    _gun.dispose();
    _birimFiyat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ev Tüketimi (kWh + TL)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _input('Cihaz Gücü (kW)', _gucKw, 'Örn: 0.1 = 100W'),
          _input('Günlük Kullanım (saat)', _saat, 'Örn: 5'),
          _input('Ayda Kaç Gün', _gun, 'Örn: 30'),
          _input('Elektrik Birim Fiyatı (TL/kWh)', _birimFiyat, 'Örn: 2.5'),
          const SizedBox(height: 12),

          FilledButton(
            onPressed: hesapla,
            child: const Text('Hesapla'),
          ),

          const SizedBox(height: 12),

          // 🔹 SONUÇ KARTI
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                sonuc.isEmpty ? 'Sonuç burada görünecek.' : sonuc,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 BİLGİLENDİRME NOTU (HER ZAMAN GÖRÜNÜR)
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Bilgilendirme:\n'
                '- Cihaz gücü kiloWatt (kW) cinsinden girilmelidir.\n'
                '- Watt (W) değeri varsa 1000’e bölerek kW’a çevirin.\n\n'
                'Örnek:\n'
                '• 100 W → 0.10 kW\n'
                '• 300 W (Buzdolabı) → 0.30 kW\n'
                '• 1000 W → 1.00 kW',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(String label, TextEditingController c, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
