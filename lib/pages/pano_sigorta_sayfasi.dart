import 'dart:math';
import 'package:flutter/material.dart';

class PanoSigortaSayfasi extends StatefulWidget {
  const PanoSigortaSayfasi({super.key});

  @override
  State<PanoSigortaSayfasi> createState() => _PanoSigortaSayfasiState();
}

class _PanoSigortaSayfasiState extends State<PanoSigortaSayfasi> {
  bool ucFaz = true;

  // Kullanıcı girdileri
  final _kw = TextEditingController(text: '11');   // kW
  final _v = TextEditingController(text: '400');   // 3 faz 400 / 1 faz 230

  bool surekliYuk = true; // evet ise 1.25 pay

  // Kablo + düşüm
  bool showCable = true;
  bool bakir = true;
  final _uzunluk = TextEditingController(text: '20'); // m
  final _izinliVd = TextEditingController(text: '3'); // %

  String sonuc = '';

  double? _d(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '.').trim());

  void _setPhase(bool three) {
    setState(() {
      ucFaz = three;
      _v.text = ucFaz ? '400' : '230';
    });
  }

  // Ω·mm²/m yaklaşık
  static const double _rhoCu = 0.018;
  static const double _rhoAl = 0.028;
  double _rho() => bakir ? _rhoCu : _rhoAl;

  // Yaklaşık ampacity (Cu)
  static final List<MapEntry<double, double>> _ampacityCu = [
    const MapEntry(1.5, 16),
    const MapEntry(2.5, 25),
    const MapEntry(4, 32),
    const MapEntry(6, 40),
    const MapEntry(10, 63),
    const MapEntry(16, 80),
    const MapEntry(25, 100),
    const MapEntry(35, 125),
    const MapEntry(50, 150),
    const MapEntry(70, 195),
    const MapEntry(95, 230),
    const MapEntry(120, 265),
    const MapEntry(150, 300),
    const MapEntry(185, 340),
  ];

  // Standart sigorta akımları
  int _roundToStdBreaker(double a) {
    const std = [6, 10, 16, 20, 25, 32, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315];
    for (final x in std) {
      if (a <= x) return x;
    }
    return std.last;
  }

  // Basit akım hesabı (cosφ yok → pratik yaklaşım)
  // 1 faz: I = P / V
  // 3 faz: I = P / (√3 * V)
  double _currentFromPowerW({required double pW, required double v}) {
    return ucFaz ? (pW / (sqrt(3) * v)) : (pW / v);
  }

  // Gerilim düşümü (yaklaşık, sadece R)
  // 1 faz: ΔV = 2*L*I*ρ/S
  // 3 faz: ΔV = √3*L*I*ρ/S
  double _voltDropV({required double Lm, required double I, required double Smm2}) {
    final k = ucFaz ? sqrt(3) : 2.0;
    return (k * Lm * I * _rho()) / Smm2;
  }

  double? _pickCableSize({
    required double Lm,
    required double V,
    required double I,
    required double vdLimitPercent,
    required double designCurrent,
  }) {
    for (final e in _ampacityCu) {
      final s = e.key;
      final amp = e.value;

      // Alüminyumda kaba derating
      final ampEffective = bakir ? amp : amp * 0.80;
      if (ampEffective < designCurrent) continue;

      final dv = _voltDropV(Lm: Lm, I: I, Smm2: s);
      final vdPct = (dv / V) * 100.0;
      if (vdPct <= vdLimitPercent) return s;
    }
    return null;
  }

  void hesapla() {
    final kw = _d(_kw);
    final V = _d(_v);

    if (kw == null || kw <= 0) {
      setState(() => sonuc = 'kW değerini kontrol et.');
      return;
    }
    if (V == null || V <= 0) {
      setState(() => sonuc = 'Gerilim (V) değerini kontrol et.');
      return;
    }

    final pW = kw * 1000.0;
    final I = _currentFromPowerW(pW: pW, v: V);

    final designI = surekliYuk ? I * 1.25 : I;
    final sigortaStd = _roundToStdBreaker(designI);

    // Basit notlar
    final fazNotu = ucFaz
        ? '3 Faz seçildi: V = faz-faz (genelde 400V)'
        : '1 Faz seçildi: V = faz-nötr (genelde 230V)';

    String cableText = '';
    if (showCable) {
      final Lm = _d(_uzunluk) ?? 0;
      final vdLimit = _d(_izinliVd) ?? 0;

      if (Lm <= 0 || vdLimit <= 0) {
        cableText = '\n--- KABLO / DÜŞÜM ---\nHat uzunluğu ve izinli % değerini kontrol et.';
      } else {
        final sRec = _pickCableSize(
          Lm: Lm,
          V: V,
          I: I,
          vdLimitPercent: vdLimit,
          designCurrent: designI,
        );

        if (sRec == null) {
          cableText =
              '\n--- KABLO / DÜŞÜM ---\nUygun kesit bulunamadı (uzunluk/akım/izinli % çok sıkı olabilir).';
        } else {
          final dvV = _voltDropV(Lm: Lm, I: I, Smm2: sRec);
          final dvPct = (dvV / V) * 100.0;

          cableText =
              '\n--- KABLO / DÜŞÜM (yaklaşık) ---\n'
              'İletken: ${bakir ? "Bakır" : "Alüminyum"}\n'
              'Hat: ${Lm.toStringAsFixed(0)} m | İzinli: %${vdLimit.toStringAsFixed(1)}\n'
              'Önerilen kesit: ${sRec.toStringAsFixed(0)} mm²\n'
              'Tahmini düşüm: ${dvV.toStringAsFixed(2)} V  (%${dvPct.toStringAsFixed(2)})\n'
              'Not: Döşeme şekli/ısı/grup sayısı gerçek seçimi değiştirir.';
        }
      }
    }

    setState(() {
      sonuc =
          '--- PANO / SİGORTA HESABI ---\n'
          '$fazNotu\n\n'
          'Güç: ${kw.toStringAsFixed(2)} kW\n'
          'Gerilim: ${V.toStringAsFixed(0)} V\n'
          'Hesap akımı: ${I.toStringAsFixed(2)} A\n\n'
          'Sürekli yük: ${surekliYuk ? "Evet (×1.25)" : "Hayır"}\n'
          'Tasarım akımı: ${designI.toStringAsFixed(2)} A\n'
          'Önerilen sigorta (standart): $sigortaStd A\n\n'
          'Pratik not:\n'
          '- Motor/kompresör gibi ilk kalkışlı yüklerde sigorta eğrisi (C/D) önemli.\n'
          '- Ana girişte seçicilik için üst-alt sigorta koordinasyonuna bak.\n'
          '- Kaçak akım: ev/ıslak hacim için 30mA yaygın, ana koruma için 300mA seçilebiliyor.\n'
          '- Parafudr (SPD): yıldırıma açık bölgede ve hassas cihazlarda önerilir.'
          + cableText;
    });
  }

  @override
  void dispose() {
    _kw.dispose();
    _v.dispose();
    _uzunluk.dispose();
    _izinliVd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pano / Sigorta Seçimi')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: ucFaz,
            title: const Text('3 Faz'),
            subtitle: Text(ucFaz ? 'Genelde 400V (faz-faz)' : 'Genelde 230V (faz-nötr)'),
            onChanged: _setPhase,
          ),

          _input('Güç (kW)', _kw, 'Örn: 5.5 / 11 / 22'),
          _input('Gerilim (V)', _v, 'Örn: 230 / 400'),

          SwitchListTile(
            value: surekliYuk,
            title: const Text('Sürekli yük payı (×1.25)'),
            subtitle: const Text('Isınma payı için (EV, ısıtıcı, sürekli çalışan yükler)'),
            onChanged: (x) => setState(() => surekliYuk = x),
          ),

          SwitchListTile(
            value: showCable,
            title: const Text('Kablo + Gerilim Düşümü (yaklaşık)'),
            onChanged: (x) => setState(() => showCable = x),
          ),

          if (showCable) ...[
            SwitchListTile(
              value: bakir,
              title: const Text('İletken: Bakır'),
              subtitle: const Text('Kapalıysa Alüminyum varsayılır'),
              onChanged: (x) => setState(() => bakir = x),
            ),
            Row(
              children: [
                Expanded(child: _input('Hat uzunluğu (m)', _uzunluk, 'Örn: 20')),
                const SizedBox(width: 10),
                Expanded(child: _input('İzinli düşüm (%)', _izinliVd, 'Örn: 3')),
              ],
            ),
          ],

          const SizedBox(height: 12),
          FilledButton(onPressed: hesapla, child: const Text('Hesapla')),

          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(sonuc.isEmpty ? 'Sonuç burada görünecek.' : sonuc),
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
