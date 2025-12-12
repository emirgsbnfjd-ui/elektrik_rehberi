import 'dart:math';
import 'package:flutter/material.dart';

class EvSarjSayfasi extends StatefulWidget {
  const EvSarjSayfasi({super.key});

  @override
  State<EvSarjSayfasi> createState() => _EvSarjSayfasiState();
}

class _EvSarjSayfasiState extends State<EvSarjSayfasi> {
  // Faz
  bool ucFaz = true; // default 3 faz
  final _v = TextEditingController(text: '400'); // 3 faz 400 / 1 faz 230

  // Güç (kullanıcı yazacak)
  final _kw = TextEditingController(text: '11');

  // Gelişmiş: cosφ + verim
  bool advanced = false;
  final _cos = TextEditingController(text: '0.99');   // 0-1
  final _verim = TextEditingController(text: '0.90'); // 0-1

  // Süre
  final _bataryaKwh = TextEditingController(text: '60');
  final _socBas = TextEditingController(text: '20');
  final _socBit = TextEditingController(text: '80');

  // Kablo + Gerilim düşümü
  bool showCable = false;
  bool bakir = true;
  final _uzunluk = TextEditingController(text: '20');  // m
  final _izinliVd = TextEditingController(text: '3');  // %

  String sonuc = '';

  double? _d(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '.').trim());

  // Ω·mm²/m yaklaşık
  static const double _rhoCu = 0.018;
  static const double _rhoAl = 0.028;

  // Yaklaşık ampacity listesi (Cu, PVC, genel)
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

  double _rho() => bakir ? _rhoCu : _rhoAl;

  void _setPhase(bool three) {
    setState(() {
      ucFaz = three;
      _v.text = ucFaz ? '400' : '230';
    });
  }

  // P = V*I*cos (1 faz)
  // P = √3*V*I*cos (3 faz, V faz-faz)
  double _currentFromPowerW({required double pW, required double v, required double cos}) {
    return ucFaz ? (pW / (sqrt(3) * v * cos)) : (pW / (v * cos));
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

  int _roundToStdBreaker(double a) {
    const std = [6, 10, 16, 20, 25, 32, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315];
    for (final x in std) {
      if (a <= x) return x;
    }
    return std.last;
  }

  void hesapla() {
    final V = _d(_v);
    final kw = _d(_kw);

    if (V == null || V <= 0) {
      setState(() => sonuc = 'Gerilim (V) değerini kontrol et.');
      return;
    }
    if (kw == null || kw <= 0) {
      setState(() => sonuc = 'Şarj gücü (kW) değerini kontrol et.');
      return;
    }

    // Tek fazda yüksek güç uyarısı (çok katı olmasın diye sadece uyarı yazacağız)
    final tekFazUyari = (!ucFaz && kw > 7.4)
        ? 'Uyarı: 1 fazda 7.4 kW üstü genelde ev tesisatında zorlanır.\n\n'
        : '';

    final pf = advanced ? (_d(_cos) ?? 0) : 1.0;
    final eff = advanced ? (_d(_verim) ?? 0) : 1.0;

    if (advanced) {
      if (pf <= 0 || pf > 1 || eff <= 0 || eff > 1) {
        setState(() => sonuc = 'cosφ/verim değerlerini kontrol et (0-1 arası).');
        return;
      }
    }

    final batKwh = _d(_bataryaKwh);
    final soc1 = _d(_socBas);
    final soc2 = _d(_socBit);

    if ([batKwh, soc1, soc2].any((x) => x == null)) {
      setState(() => sonuc = 'Batarya / SOC alanlarını doldur.');
      return;
    }

    final B = batKwh!;
    final s1 = soc1!;
    final s2 = soc2!;
    if (B <= 0 || s1 < 0 || s2 < 0 || s1 >= s2 || s2 > 100) {
      setState(() => sonuc = 'SOC değerlerini kontrol et (örn 20 → 80).');
      return;
    }

    final pW = kw * 1000.0;
    final I = _currentFromPowerW(pW: pW, v: V, cos: pf);

    // kVA
    final sKva = (pW / pf) / 1000.0;

    // Süre
    final enerjiBatKwh = B * ((s2 - s1) / 100.0);
    final duvardanKwh = enerjiBatKwh / eff;
    final hours = duvardanKwh / kw;

    final totalMin = (hours * 60).round();
    final h = totalMin ~/ 60;
    final m = totalMin % 60;

    // Sigorta fikri
    final breakerApprox = I * 1.25;
    final breakerStd = _roundToStdBreaker(breakerApprox);

    // Kablo/VD opsiyonel
    String cableText = '';
    if (showCable) {
      final Lm = _d(_uzunluk) ?? 0;
      final vdLimit = _d(_izinliVd) ?? 0;

      if (Lm <= 0 || vdLimit <= 0) {
        cableText = '\n--- KABLO / GERİLİM DÜŞÜMÜ ---\nHat uzunluğu ve izinli % değerlerini kontrol et.';
      } else {
        final designCurrent = I * 1.25;
        final sRec = _pickCableSize(
          Lm: Lm,
          V: V,
          I: I,
          vdLimitPercent: vdLimit,
          designCurrent: designCurrent,
        );

        if (sRec == null) {
          cableText =
              '\n--- KABLO / GERİLİM DÜŞÜMÜ ---\n'
              'Uygun kesit bulunamadı (çok uzun / çok akım / çok düşük izinli %).';
        } else {
          final dvV = _voltDropV(Lm: Lm, I: I, Smm2: sRec);
          final dvPct = (dvV / V) * 100.0;

          cableText =
              '\n--- KABLO / GERİLİM DÜŞÜMÜ (yaklaşık) ---\n'
              'İletken: ${bakir ? "Bakır" : "Alüminyum"}\n'
              'Hat: ${Lm.toStringAsFixed(0)} m   İzinli: %${vdLimit.toStringAsFixed(1)}\n'
              'Önerilen kesit: ${sRec.toStringAsFixed(0)} mm²\n'
              'Tahmini düşüm: ${dvV.toStringAsFixed(2)} V  (%${dvPct.toStringAsFixed(2)})\n'
              'Not: Döşeme şekli/ısı/gruplama gerçek seçimi değiştirir.';
        }
      }
    }

    // RCD bilgilendirme (kısa ama net)
    final rcdInfo =
        '\n--- RCD (bilgi) ---\n'
        '- Birçok AC wallbox için en az Type A kullanılır.\n'
        '- Cihazda DC kaçak algılama yoksa Type B / Type EV gerekebilir.\n'
        'Kesin bilgi için wallbox dokümanına bak.';

    setState(() {
      sonuc =
          tekFazUyari +
          '--- EV ŞARJ ---\n'
          'Faz: ${ucFaz ? "3 Faz" : "1 Faz"}   Gerilim: ${V.toStringAsFixed(0)} V\n'
          'Güç: ${kw.toStringAsFixed(2)} kW\n'
          + (advanced
              ? 'cosφ: ${pf.toStringAsFixed(2)}   Verim: ${eff.toStringAsFixed(2)}\n'
              : 'cosφ/verim: Kapalı (1.00 varsayıldı)\n') +
          '\nÇekilecek Akım: ${I.toStringAsFixed(2)} A\n'
          'Görünür güç: ${sKva.toStringAsFixed(2)} kVA\n'
          'Sigorta fikri (~1.25×): ${breakerApprox.toStringAsFixed(0)} A  → Standart: ${breakerStd} A\n'
          'Not: Sürekli yükte ısınma payı önemlidir.\n\n'
          '--- ŞARJ SÜRESİ ---\n'
          'Batarya: ${B.toStringAsFixed(0)} kWh | SOC: ${s1.toStringAsFixed(0)}% → ${s2.toStringAsFixed(0)}%\n'
          'Bataryaya girecek: ${enerjiBatKwh.toStringAsFixed(2)} kWh\n'
          'Duvardan çekilecek: ${duvardanKwh.toStringAsFixed(2)} kWh\n'
          'Tahmini süre: ${h} saat ${m} dk\n'
          'Not: %80 sonrası güç düşebilir (gerçek süre uzayabilir).'
          + cableText +
          rcdInfo;
    });
  }

  @override
  void dispose() {
    _v.dispose();
    _kw.dispose();
    _cos.dispose();
    _verim.dispose();
    _bataryaKwh.dispose();
    _socBas.dispose();
    _socBit.dispose();
    _uzunluk.dispose();
    _izinliVd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EV Şarj (Basit + Gelişmiş)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: ucFaz,
            title: const Text('3 Faz'),
            subtitle: Text(ucFaz ? 'V: Faz-Faz (genelde 400V)' : 'V: Faz-Nötr (genelde 230V)'),
            onChanged: _setPhase,
          ),

          _input('Şarj Gücü (kW)', _kw, 'Örn: 3.7 / 7.4 / 11 / 22'),
          _input('Gerilim (V)', _v, 'Örn: 230 / 400'),

          SwitchListTile(
            value: advanced,
            title: const Text('Gelişmiş: cosφ + verim'),
            subtitle: const Text('Kapalıysa cosφ=1.00 ve verim=1.00 alınır'),
            onChanged: (x) => setState(() => advanced = x),
          ),
          if (advanced) ...[
            Row(
              children: [
                Expanded(child: _input('cosφ', _cos, 'Örn: 0.99')),
                const SizedBox(width: 10),
                Expanded(child: _input('Verim (0-1)', _verim, 'Örn: 0.90')),
              ],
            ),
          ],

          const SizedBox(height: 10),
          const Text('Şarj Süresi', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          _input('Batarya Kapasitesi (kWh)', _bataryaKwh, 'Örn: 60'),
          Row(
            children: [
              Expanded(child: _input('Başlangıç SOC (%)', _socBas, 'Örn: 20')),
              const SizedBox(width: 10),
              Expanded(child: _input('Bitiş SOC (%)', _socBit, 'Örn: 80')),
            ],
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
              subtitle: const Text('Kapalıysa Alüminyum varsayılır (kaba derating uygulanır)'),
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
