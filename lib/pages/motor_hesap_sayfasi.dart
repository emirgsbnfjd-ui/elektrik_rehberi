import 'dart:math';
import 'package:flutter/material.dart';

enum BaslatmaTipi { dol, yildizUcgen, softStarter, vfd }

class MotorHesapSayfasi extends StatefulWidget {
  const MotorHesapSayfasi({super.key});

  @override
  State<MotorHesapSayfasi> createState() => _MotorHesapSayfasiState();
}

class _MotorHesapSayfasiState extends State<MotorHesapSayfasi> {
  final _kw = TextEditingController();
  final _v = TextEditingController(text: '400');
  final _cos = TextEditingController(text: '0.85');
  final _eta = TextEditingController(text: '0.90');

  // Kablo / gerilim düşümü için
  final _uzunluk = TextEditingController(text: '30'); // metre
  final _izinliVd = TextEditingController(text: '3'); // %

  bool ucFaz = true;
  BaslatmaTipi baslatma = BaslatmaTipi.dol;

  String sonuc = '';

  double? _d(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '.').trim());

  // Yaklaşık bakır özdirenci (Ω·mm²/m)
  static const double _rhoCu = 0.018;

  // Basit akım taşıma kapasiteleri (yaklaşık) — Cu, PVC, genel kullanım
  // Not: Gerçekte döşeme şekli, ortam sıcaklığı, grup sayısı vb. etkiler.
  static Map<double, double> _ampacityApprox = {
    1.5: 16,
    2.5: 25,
    4: 32,
    6: 40,
    10: 63,
    16: 80,
    25: 100,
    35: 125,
    50: 150,
    70: 195,
    95: 230,
    120: 265,
    150: 300,
    185: 340,
  };

  double _startMultiplier(BaslatmaTipi t) {
    switch (t) {
      case BaslatmaTipi.dol:
        return 6.0; // tipik 5-7x
      case BaslatmaTipi.yildizUcgen:
        return 2.0; // hat akımı ~ 1/3, pratikte ~2x civarı görülür
      case BaslatmaTipi.softStarter:
        return 3.0; // ayara göre 2-4x
      case BaslatmaTipi.vfd:
        return 1.2; // genelde 1.1-1.3x
    }
  }

  // Gerilim düşümü (yaklaşık, sadece R ile). Reaktans/ cos etkisi ihmal.
  // Tek faz: ΔV = 2*L*I*ρ / S
  // Üç faz: ΔV = √3*L*I*ρ / S
  double _voltDropV({
    required bool ucFaz,
    required double Lm,
    required double I,
    required double Smm2,
  }) {
    final k = ucFaz ? sqrt(3) : 2.0;
    return (k * Lm * I * _rhoCu) / Smm2;
  }

  double? _pickCableSize({
    required bool ucFaz,
    required double Lm,
    required double V,
    required double I,
    required double vdLimitPercent,
    required double designCurrent, // kablo için hedef akım (örn. 1.25*In)
  }) {
    for (final s in _ampacityApprox.keys) {
      final amp = _ampacityApprox[s]!;
      if (amp < designCurrent) continue;

      final dv = _voltDropV(ucFaz: ucFaz, Lm: Lm, I: I, Smm2: s);
      final vdPct = (dv / V) * 100.0;
      if (vdPct <= vdLimitPercent) return s;
    }
    return null;
  }

  String _breakerCurveSuggestion(double startMult) {
    // Çok kaba: D (10-20In), C (5-10In), B (3-5In)
    // StartMult 6x ise C/D, 2x ise B/C, VFD 1.2x B/C
    if (startMult >= 6) return 'C veya D (motor kalkışı için D daha rahat)';
    if (startMult >= 3) return 'C (çoğu motor için) / gerekirse D';
    return 'B veya C';
  }

  void hesapla() {
    final kw = _d(_kw);
    final V = _d(_v);
    final cos = _d(_cos);
    final eta = _d(_eta);
    final Lm = _d(_uzunluk);
    final vdLim = _d(_izinliVd);

    if ([kw, V, cos, eta, Lm, vdLim].any((x) => x == null)) {
      setState(() => sonuc = 'Lütfen tüm alanları doldur.');
      return;
    }

    final pKw = kw!;
    final v = V!;
    final c = cos!;
    final e = eta!;
    final L = Lm!;
    final vdLimit = vdLim!;

    if (pKw <= 0 || v <= 0 || c <= 0 || c > 1 || e <= 0 || e > 1 || L < 0 || vdLimit <= 0) {
      setState(() => sonuc = 'Değerleri kontrol et (cosφ/η: 0-1 arası).');
      return;
    }

    final pOutW = pKw * 1000.0;   // motor çıkış gücü (mekanik)
    final pInW = pOutW / e;       // giriş (yaklaşık)
    final sVA = pInW / c;         // görünür güç
    final sKva = sVA / 1000.0;

    final inA = ucFaz
        ? pInW / (sqrt(3) * v * c)
        : pInW / (v * c);

    final hp = pKw * 1.341;

    // Kalkış akımı tahmini
    final startMult = _startMultiplier(baslatma);
    final iStart = inA * startMult;

    // Termik ayarı (çok yaygın pratik: 1.00–1.05 x In; servis faktörü vs. değişir)
    final termikLow = inA * 1.00;
    final termikHigh = inA * 1.05;

    // Şalter/MCB anma akımı (kaba): 1.25 x In
    final breakerNom = inA * 1.25;

    // Kablo tasarım akımı (kaba): 1.25 x In (ısınma/rezerv)
    final designCurrent = inA * 1.25;

    // Kablo kesiti öner (ampacity + Vd%)
    final sRec = _pickCableSize(
      ucFaz: ucFaz,
      Lm: L,
      V: v,
      I: inA,
      vdLimitPercent: vdLimit,
      designCurrent: designCurrent,
    );

    double? dvRecV;
    double? dvRecPct;
    if (sRec != null && sRec > 0) {
      dvRecV = _voltDropV(ucFaz: ucFaz, Lm: L, I: inA, Smm2: sRec);
      dvRecPct = (dvRecV / v) * 100.0;
    }

    final curve = _breakerCurveSuggestion(startMult);

    String baslatmaStr(BaslatmaTipi t) {
      switch (t) {
        case BaslatmaTipi.dol: return 'Direkt (DOL)';
        case BaslatmaTipi.yildizUcgen: return 'Yıldız/Üçgen';
        case BaslatmaTipi.softStarter: return 'Soft Starter';
        case BaslatmaTipi.vfd: return 'Sürücü (VFD)';
      }
    }

    setState(() {
      sonuc =
          '--- Temel ---\n'
          'Faz: ${ucFaz ? "3 Faz" : "1 Faz"}\n'
          'V: ${v.toStringAsFixed(0)} V   cosφ: ${c.toStringAsFixed(2)}   η: ${e.toStringAsFixed(2)}\n'
          'Motor: ${pKw.toStringAsFixed(2)} kW  (~${hp.toStringAsFixed(2)} HP)\n'
          'Giriş Gücü: ${(pInW / 1000).toStringAsFixed(2)} kW\n'
          'Görünür Güç: ${sKva.toStringAsFixed(2)} kVA\n'
          'Anma Akımı (In): ${inA.toStringAsFixed(2)} A\n\n'

          '--- Kalkış ---\n'
          'Başlatma: ${baslatmaStr(baslatma)}\n'
          'Kalkış katsayısı: ~${startMult.toStringAsFixed(1)}x\n'
          'Kalkış akımı (tahmini): ${iStart.toStringAsFixed(1)} A\n\n'

          '--- Termik / Şalter (yaklaşık) ---\n'
          'Termik ayarı: ${termikLow.toStringAsFixed(1)} – ${termikHigh.toStringAsFixed(1)} A\n'
          'Şalter/MCB anma akımı fikri: ~${breakerNom.toStringAsFixed(0)} A\n'
          'Eğri önerisi: $curve\n\n'

          '--- Kablo / Gerilim Düşümü (bakır, yaklaşık) ---\n'
          'Hat uzunluğu: ${L.toStringAsFixed(0)} m   İzinli düşüm: ${vdLimit.toStringAsFixed(1)} %\n'
          + (sRec == null
              ? 'Öneri: Bu şartlarda uygun kesit bulunamadı (çok uzun/çok akım/çok düşük izinli %).'
              : 'Önerilen kesit: ${sRec.toStringAsFixed(0)} mm²\n'
                'Tahmini düşüm: ${dvRecV!.toStringAsFixed(2)} V  (%${dvRecPct!.toStringAsFixed(2)})\n'
                'Not: Döşeme şekli/ısı/grup sayısı gerçek seçimi değiştirir.')
          ;
    });
  }

  @override
  void dispose() {
    _kw.dispose();
    _v.dispose();
    _cos.dispose();
    _eta.dispose();
    _uzunluk.dispose();
    _izinliVd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Motor Hesapları')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: ucFaz,
            title: const Text('3 Faz'),
            subtitle: Text(ucFaz ? 'V: Faz-Faz (genelde 400V)' : 'V: Faz-Nötr (genelde 230V)'),
            onChanged: (x) {
              setState(() {
                ucFaz = x;
                _v.text = ucFaz ? '400' : '230';
              });
            },
          ),

          _input('Motor Gücü (kW)', _kw, 'Örn: 7.5'),
          _input('Gerilim (V)', _v, ucFaz ? 'Örn: 400' : 'Örn: 230'),
          Row(
            children: [
              Expanded(child: _input('cosφ', _cos, 'Örn: 0.85')),
              const SizedBox(width: 10),
              Expanded(child: _input('Verim (η)', _eta, 'Örn: 0.90')),
            ],
          ),

          const SizedBox(height: 10),
          DropdownButtonFormField<BaslatmaTipi>(
            value: baslatma,
            decoration: const InputDecoration(
              labelText: 'Başlatma Tipi',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: BaslatmaTipi.dol, child: Text('Direkt (DOL)')),
              DropdownMenuItem(value: BaslatmaTipi.yildizUcgen, child: Text('Yıldız/Üçgen')),
              DropdownMenuItem(value: BaslatmaTipi.softStarter, child: Text('Soft Starter')),
              DropdownMenuItem(value: BaslatmaTipi.vfd, child: Text('Sürücü (VFD)')),
            ],
            onChanged: (v) => setState(() => baslatma = v ?? BaslatmaTipi.dol),
          ),

          const SizedBox(height: 12),
          const Text('Kablo / Gerilim Düşümü', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _input('Hat uzunluğu (m)', _uzunluk, 'Örn: 30')),
              const SizedBox(width: 10),
              Expanded(child: _input('İzinli düşüm (%)', _izinliVd, 'Örn: 3')),
            ],
          ),

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
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
