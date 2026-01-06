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

  // ✅ yeni: sonuç state
  bool _hasResult = false;
  String? _err;

  // ✅ yeni: hesaplanan değerler
  String _fazNotu = '';
  double _kwVal = 0;
  double _VVal = 0;
  double _I = 0;
  double _designI = 0;
  int _sigortaStd = 0;

  // ✅ kablo sonuçları
  double? _Lm;
  double? _vdLimit;
  double? _sRec;
  double? _dvV;
  double? _dvPct;
  String? _cableErr;

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

  // ✅ yeni: abartı değer/format kontrol (tek yer)
  String? _validateInputs({
    required double kw,
    required double V,
    double? Lm,
    double? vdLimit,
  }) {
    // pratik sınırlar (LV pano için)
    if (kw < 0.1 || kw > 500) {
      return 'Güç değeri mantıksız (${kw.toStringAsFixed(2)} kW).\n'
          '0.1 – 500 kW aralığında olmalı.';
    }
    if (V < 110 || V > 1000) {
      return 'Gerilim değeri mantıksız (${V.toStringAsFixed(0)} V).\n'
          '110 – 1000 V aralığında olmalı.';
    }
    if (Lm != null) {
      if (Lm < 1 || Lm > 500) {
        return 'Hat uzunluğu mantıksız (${Lm.toStringAsFixed(0)} m).\n'
            '1 – 500 m aralığında olmalı.';
      }
    }
    if (vdLimit != null) {
      if (vdLimit < 0.5 || vdLimit > 10) {
        return 'İzinli düşüm değeri mantıksız (%${vdLimit.toStringAsFixed(1)}).\n'
            '0.5 – 10% aralığında olmalı.';
      }
    }
    return null;
  }

  void hesapla() {
    setState(() {
      _err = null;
      _hasResult = false;
      _cableErr = null;

      _sRec = null;
      _dvV = null;
      _dvPct = null;
      _Lm = null;
      _vdLimit = null;
    });

    final kw = _d(_kw);
    final V = _d(_v);

    if (kw == null || kw <= 0) {
      setState(() => _err = 'kW değerini kontrol et.');
      return;
    }
    if (V == null || V <= 0) {
      setState(() => _err = 'Gerilim (V) değerini kontrol et.');
      return;
    }

    // Eğer cable açıksa onun inputlarını da burada okuyup validate edelim
    double? Lm;
    double? vdLimit;
    if (showCable) {
      Lm = _d(_uzunluk);
      vdLimit = _d(_izinliVd);
      if (Lm == null || vdLimit == null) {
        setState(() => _err = 'Kablo alanlarında sayı formatını kontrol et.');
        return;
      }
    }

    final valErr = _validateInputs(kw: kw, V: V, Lm: Lm, vdLimit: vdLimit);
    if (valErr != null) {
      setState(() => _err = valErr);
      return;
    }

    final pW = kw * 1000.0;
    final I = _currentFromPowerW(pW: pW, v: V);

    // aşırı uç akım kontrolü (LV pano için pratik)
    if (I.isNaN || I.isInfinite || I > 4000) {
      setState(() => _err = 'Hesap akımı çok uç çıktı (${I.toStringAsFixed(0)} A). Değerleri kontrol et.');
      return;
    }

    final designI = surekliYuk ? I * 1.25 : I;

    if (designI > 4000) {
      setState(() => _err = 'Tasarım akımı çok yüksek (${designI.toStringAsFixed(0)} A). Değerleri kontrol et.');
      return;
    }

    final sigortaStd = _roundToStdBreaker(designI);

    final fazNotu = ucFaz
        ? '3 Faz seçildi: V = faz-faz (genelde 400V)'
        : '1 Faz seçildi: V = faz-nötr (genelde 230V)';

    // kablo hesabı
    if (showCable) {
      _Lm = Lm;
      _vdLimit = vdLimit;

      final sRec = _pickCableSize(
        Lm: Lm!,
        V: V,
        I: I,
        vdLimitPercent: vdLimit!,
        designCurrent: designI,
      );

      if (sRec == null) {
        _cableErr =
        'Uygun kesit bulunamadı.\n'
            'Uzunluk/akım/izinli % çok sıkı olabilir.';
      } else {
        final dvV = _voltDropV(Lm: Lm, I: I, Smm2: sRec);
        final dvPct = (dvV / V) * 100.0;

        _sRec = sRec;
        _dvV = dvV;
        _dvPct = dvPct;
      }
    }

    setState(() {
      _fazNotu = fazNotu;
      _kwVal = kw;
      _VVal = V;
      _I = I;
      _designI = designI;
      _sigortaStd = sigortaStd;

      _hasResult = true;
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

  // ---------- UI küçük yardımcılar ----------

  Widget _pill({required String text, required bool ok}) {
    final c = ok ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ok ? Icons.check_circle : Icons.error, size: 16, color: c),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontWeight: FontWeight.w700, color: c)),
        ],
      ),
    );
  }

  Widget _kv(String k, String v, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
          Text(
            v,
            style: TextStyle(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // basit şema: Kaynak — Kablo — Yük
  Widget _schema({required String midTop, required String midBottom}) {
    Widget box(String text, IconData icon) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      );
    }

    return Row(
      children: [
        box('Kaynak', Icons.power),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              Text(midTop, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(child: Divider(thickness: 2, color: Theme.of(context).dividerColor)),
                  const SizedBox(width: 8),
                  Icon(Icons.bolt, size: 16, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Divider(thickness: 2, color: Theme.of(context).dividerColor)),
                ],
              ),
              const SizedBox(height: 6),
              Text(midBottom, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color)),
            ],
          ),
        ),
        const SizedBox(width: 10),
        box('Yük', Icons.electrical_services),
      ],
    );
  }

  // ---------- BUILD ----------

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
          FilledButton.icon(
            onPressed: hesapla,
            icon: const Icon(Icons.calculate),
            label: const Text('Hesapla'),
          ),

          const SizedBox(height: 12),

          // ✅ Hata kartı
          if (_err != null)
            Card(
              color: Colors.red.withOpacity(0.08),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _err!,
                        style: const TextStyle(color: Colors.red, height: 1.35),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ✅ Sonuç kartları
          if (_hasResult) ...[
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.55),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('--- PANO / SİGORTA HESABI ---',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                        const Spacer(),
                        _pill(text: 'Hesaplandı', ok: true),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(_fazNotu, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                    const SizedBox(height: 10),

                    _schema(
                      midTop: 'Hesap akımı: ${_I.toStringAsFixed(2)} A',
                      midBottom: 'Önerilen sigorta: $_sigortaStd A',
                    ),

                    const SizedBox(height: 10),
                    _kv('Güç', '${_kwVal.toStringAsFixed(2)} kW', bold: true),
                    _kv('Gerilim', '${_VVal.toStringAsFixed(0)} V'),
                    _kv('Hesap akımı', '${_I.toStringAsFixed(2)} A', bold: true),
                    _kv('Sürekli yük', surekliYuk ? 'Evet (×1.25)' : 'Hayır'),
                    _kv('Tasarım akımı', '${_designI.toStringAsFixed(2)} A', bold: true),
                    _kv('Önerilen sigorta (standart)', '$_sigortaStd A', bold: true),

                    const SizedBox(height: 10),
                    const Divider(),
                    const Text('Pratik not', style: TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    Text(
                      '- Motor/kompresör gibi ilk kalkışlı yüklerde sigorta eğrisi (C/D) önemli.\n'
                          '- Ana girişte seçicilik için üst-alt sigorta koordinasyonuna bak.\n'
                          '- Kaçak akım: ev/ıslak hacim için 30mA yaygın, ana koruma için 300mA seçilebiliyor.\n'
                          '- Parafudr (SPD): yıldırıma açık bölgede ve hassas cihazlarda önerilir.',
                      style: const TextStyle(fontSize: 13, height: 1.35),
                    ),
                  ],
                ),
              ),
            ),

            if (showCable)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('--- KABLO / DÜŞÜM (yaklaşık) ---',
                              style: TextStyle(fontWeight: FontWeight.w900)),
                          const Spacer(),
                          if (_cableErr == null && _sRec != null && _dvPct != null)
                            _pill(text: _dvPct! <= (_vdLimit ?? 3) ? 'Uygun' : 'Uygun değil', ok: (_dvPct! <= (_vdLimit ?? 3))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _kv('İletken', bakir ? 'Bakır' : 'Alüminyum'),
                      _kv('Hat', '${(_Lm ?? 0).toStringAsFixed(0)} m'),
                      _kv('İzinli düşüm', '%${(_vdLimit ?? 0).toStringAsFixed(1)}'),

                      if (_cableErr != null) ...[
                        const SizedBox(height: 8),
                        Text(_cableErr!, style: const TextStyle(color: Colors.red, height: 1.35)),
                      ] else ...[
                        _kv('Önerilen kesit', '${(_sRec ?? 0).toStringAsFixed(0)} mm²', bold: true),
                        _kv('Tahmini düşüm', '${(_dvV ?? 0).toStringAsFixed(2)} V', bold: true),
                        _kv('Düşüm yüzdesi', '%${(_dvPct ?? 0).toStringAsFixed(2)}', bold: true),
                        const SizedBox(height: 8),
                        Text(
                          'Not: Döşeme şekli/ısı/grup sayısı gerçek seçimi değiştirir.',
                          style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],

          if (!_hasResult && _err == null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Değerleri girip “Hesapla”ya bas. Sonuç burada şablonlu şekilde görünecek.',
                  style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
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
