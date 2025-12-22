import 'package:flutter/material.dart';

class EvTuketimiSayfasi extends StatefulWidget {
  const EvTuketimiSayfasi({super.key});

  @override
  State<EvTuketimiSayfasi> createState() => _EvTuketimiSayfasiState();
}

class _EvTuketimiSayfasiState extends State<EvTuketimiSayfasi> {
  // Güç kW
  final _gucKw = TextEditingController(text: '0.30'); // örn buzdolabı etiketi 300W -> 0.30 kW
  final _saat = TextEditingController(text: '24');    // buzdolabı için genelde 24 yazılır
  final _gun = TextEditingController(text: '30');     // gün/ay
  final _birimFiyat = TextEditingController(text: '2.5'); // TL/kWh

  // ✅ yeni: çalışma oranı (%)
  final _calismaOrani = TextEditingController(text: '30'); // %30 tipik olabilir

  String sonuc = '';

  double? _d(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '.').trim());

  void hesapla() {
    final gucKw = _d(_gucKw);
    final saatGun = _d(_saat);
    final gunAy = _d(_gun);
    final fiyat = _d(_birimFiyat);
    final oran = _d(_calismaOrani);

    if ([gucKw, saatGun, gunAy, fiyat, oran].any((e) => e == null)) {
      setState(() => sonuc = 'Lütfen tüm alanları doldur.');
      return;
    }

    if (gucKw! <= 0 || saatGun! <= 0 || gunAy! <= 0 || fiyat! <= 0) {
      setState(() => sonuc = 'Değerler 0’dan büyük olmalı.');
      return;
    }

    if (oran! <= 0 || oran > 100) {
      setState(() => sonuc = 'Çalışma oranı 1 ile 100 arasında olmalı.');
      return;
    }

    // ✅ çalışma oranı dahil
    final duty = oran / 100.0;

    final gunlukKwh = gucKw * saatGun * duty;
    final aylikKwh = gunlukKwh * gunAy;
    final aylikTl = aylikKwh * fiyat;

    // ekstra: gerçek çalışma saati gibi gösterelim
    final efektifSaat = saatGun * duty;

    setState(() {
      sonuc =
          '- EV TÜKETİM HESABI -\n'
          'Cihaz Gücü        : ${gucKw.toStringAsFixed(2)} kW\n'
          'Günlük Süre       : ${saatGun.toStringAsFixed(1)} saat\n'
          'Çalışma Oranı     : %${oran.toStringAsFixed(0)}\n'
          'Efektif Çalışma   : ${efektifSaat.toStringAsFixed(1)} saat/gün\n\n'
          'Günlük Tüketim    : ${gunlukKwh.toStringAsFixed(2)} kWh\n'
          'Aylık Tüketim     : ${aylikKwh.toStringAsFixed(2)} kWh\n\n'
          'Birim Fiyat       : ${fiyat.toStringAsFixed(2)} TL / kWh\n'
          'Aylık Maliyet     : ${aylikTl.toStringAsFixed(2)} TL\n\n'
          'Not:\n'
          '- Buzdolabı/klima gibi termostatlı cihazlarda “çalışma oranı” çok önemlidir.\n'
          '- Ortam sıcaklığı arttıkça çalışma oranı yükselir.\n'
          '- Kademeli tarife varsa sonuç değişebilir.';
    });
  }

  @override
  void dispose() {
    _gucKw.dispose();
    _saat.dispose();
    _gun.dispose();
    _birimFiyat.dispose();
    _calismaOrani.dispose();
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
          _input('Günlük Kullanım (saat)', _saat, 'Buzdolabı için genelde 24'),
          _input('Çalışma Oranı (%)', _calismaOrani, 'Örn: 30 (buzdolabı), 50 (klima)'),
          _input('Ayda Kaç Gün', _gun, 'Örn: 30'),
          _input('Elektrik Birim Fiyatı (TL/kWh)', _birimFiyat, 'Örn: 2.5'),
          const SizedBox(height: 12),

          FilledButton(
            onPressed: hesapla,
            child: const Text('Hesapla'),
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(sonuc.isEmpty ? 'Sonuç burada görünecek.' : sonuc),
            ),
          ),

          const SizedBox(height: 10),

          Card(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Bilgi:\n'
'- Termostatlı cihazlarda (buzdolabı, klima, derin dondurucu, kombi vb.) cihaz fişte olsa bile '
'motor veya ısıtıcı **sürekli çalışmaz**.\n'
'- Bu cihazlar ortam sıcaklığına göre **aç-kapa (devreye girip çıkma)** yapar.\n'
'- Bu nedenle etiket üzerinde yazan güç, cihazın **her an çektiği güç** anlamına gelmez.\n\n'

'Çalışma Oranı (%):\n'
'- Bir cihazın gün içindeki **gerçek çalışma süresinin yüzdesini** ifade eder.\n'
'- Örneğin %30 çalışma oranı, cihazın günün yaklaşık **%30’unda aktif** çalıştığı anlamına gelir.\n'
'- Bu değer; mevsime, ortam sıcaklığına, kullanım alışkanlığına ve cihaz verimliliğine göre değişir.\n\n'

'Ev Aletleri Ortalama Güç Tüketimleri (yaklaşık – kW):\n'
'- Buzdolabı: 0.10 – 0.30 kW (termostatlı; çalışma oranı genelde %25 – %40)\n'
'- Derin dondurucu: 0.15 – 0.40 kW (ortam sıcaklığı arttıkça çalışma oranı yükselir)\n\n'

'Klima (inverter):\n'
'• 9.000 BTU  : 0.60 – 0.90 kW\n'
'• 12.000 BTU : 0.80 – 1.20 kW\n'
'• 18.000 BTU : 1.20 – 1.80 kW\n'
'(Çalışma oranı genelde %30 – %60)\n\n'

'Televizyon (LED/LCD):\n'
'• 32 inç : 0.04 – 0.07 kW\n'
'• 43 inç : 0.07 – 0.12 kW\n'
'• 55 inç : 0.10 – 0.18 kW\n'
'(Çalışma oranı %80 – %100 kabul edilebilir)\n\n'

'- Çamaşır makinesi: 0.50 – 2.00 kW (rezistans devredeyken tüketim artar)\n'
'- Bulaşık makinesi: 1.20 – 2.20 kW (su ısıtma aşamasında yüksek güç çeker)\n'
'- Elektrikli fırın: 1.80 – 2.50 kW\n'
'- Su ısıtıcı (kettle): 1.80 – 2.20 kW\n'
'- Mikrodalga fırın: 0.80 – 1.50 kW\n'
'- Ütü: 1.80 – 2.40 kW\n'
'- Elektrikli süpürge: 0.60 – 1.20 kW\n\n'

'Aydınlatma:\n'
'• LED ampul: 0.005 – 0.015 kW\n'
'• Floresan: 0.018 – 0.036 kW\n'
'• Halojen: 0.035 – 0.070 kW\n\n'

'Tipik Çalışma Oranları:\n'
'- Buzdolabı: %25 – %40\n'
'- Derin dondurucu: %30 – %45\n'
'- Klima (inverter): %30 – %60\n'
'- Kombi: %10 – %40\n'
'- Televizyon / Aydınlatma: %80 – %100\n\n'

'Notlar:\n'
'- Değerler ortalama ve yaklaşık değerlerdir.\n'
'- Etiket gücü genelde cihazın **maksimum** çekebileceği gücü ifade eder.\n'
'- Termostatlı ve inverterli cihazlarda “çalışma oranı” mutlaka hesaba katılmalıdır.\n'
'- Aynı anda çalışan cihaz sayısı toplam tüketimi artırır.\n'
'- Kademeli elektrik tarifelerinde toplam maliyet farklı çıkabilir.',
style: TextStyle(fontSize: 13, height: 1.4),
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
