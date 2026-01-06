import 'package:flutter/material.dart';

class EvTuketimiSayfasi extends StatefulWidget {
  const EvTuketimiSayfasi({super.key});

  @override
  State<EvTuketimiSayfasi> createState() => _EvTuketimiSayfasiState();
}

enum PowerUnit { w, kw }

class _EvTuketimiSayfasiState extends State<EvTuketimiSayfasi> {
  // Güç (input: W veya kW)
  final _guc = TextEditingController(text: '0.30'); // varsayılan: 0.30 kW = 300W
  final _saat = TextEditingController(text: '24');
  final _gun = TextEditingController(text: '30');
  final _birimFiyat = TextEditingController(text: '2.5');
  final _calismaOrani = TextEditingController(text: '30');

  PowerUnit _unit = PowerUnit.kw;

  // hesap sonuçları
  bool _hasResult = false;
  String? _err;

  double _gucKw = 0;
  double _saatGun = 0;
  double _gunAy = 0;
  double _fiyat = 0;
  double _oran = 0;

  double _duty = 0;
  double _gunlukKwh = 0;
  double _aylikKwh = 0;
  double _aylikTl = 0;
  double _efektifSaat = 0;

  double? _d(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '.').trim());

  double _powerToKw(double value) => _unit == PowerUnit.kw ? value : (value / 1000.0);

  void hesapla() {
    setState(() {
      _err = null;
      _hasResult = false;
    });

    final gucInput = _d(_guc);
    final saatGun = _d(_saat);
    final gunAy = _d(_gun);
    final fiyat = _d(_birimFiyat);
    final oran = _d(_calismaOrani);

    if ([gucInput, saatGun, gunAy, fiyat, oran].any((e) => e == null)) {
      setState(() => _err = 'Lütfen tüm alanları doğru formatta doldur.');
      return;
    }

    if (gucInput! <= 0 || saatGun! <= 0 || gunAy! <= 0 || fiyat! <= 0) {
      setState(() => _err = 'Değerler 0’dan büyük olmalı.');
      return;
    }

    if (oran! <= 0 || oran > 100) {
      setState(() => _err = 'Çalışma oranı 1 ile 100 arasında olmalı.');
      return;
    }

    final gucKw = _powerToKw(gucInput);
    final duty = oran / 100.0;

    final gunlukKwh = gucKw * saatGun * duty;
    final aylikKwh = gunlukKwh * gunAy;
    final aylikTl = aylikKwh * fiyat;
    final efektifSaat = saatGun * duty;

    setState(() {
      _gucKw = gucKw;
      _saatGun = saatGun;
      _gunAy = gunAy;
      _fiyat = fiyat;
      _oran = oran;

      _duty = duty;
      _gunlukKwh = gunlukKwh;
      _aylikKwh = aylikKwh;
      _aylikTl = aylikTl;
      _efektifSaat = efektifSaat;

      _hasResult = true;
    });
  }

  @override
  void dispose() {
    _guc.dispose();
    _saat.dispose();
    _gun.dispose();
    _birimFiyat.dispose();
    _calismaOrani.dispose();
    super.dispose();
  }

  // ---------------- UI HELPERS ----------------

  Widget _sectionTitle(String title, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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

  Widget _kv(String k, String v, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _money(double v) => v.toStringAsFixed(2);
  String _kwh(double v) => v.toStringAsFixed(2);
  String _num1(double v) => v.toStringAsFixed(1);

  // basit “şema”: Kaynak — Kablo — Yük
  Widget _schema({required String left, required String midTop, required String midBottom, required String right}) {
    final border = Border.all(color: Theme.of(context).dividerColor);
    final radius = BorderRadius.circular(12);

    Widget box(String text, {IconData? icon}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(border: border, borderRadius: radius),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 8),
            ],
            Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      );
    }

    Widget wire() {
      return Expanded(
        child: Column(
          children: [
            Text(midTop, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
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
      );
    }

    return Row(
      children: [
        box(left, icon: Icons.power),
        const SizedBox(width: 10),
        wire(),
        const SizedBox(width: 10),
        box(right, icon: Icons.home_work_outlined),
      ],
    );
  }

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

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    final unitLabel = _unit == PowerUnit.kw ? 'kW' : 'W';

    return Scaffold(
      appBar: AppBar(title: const Text('Ev Tüketimi (kWh + TL)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Girişler', icon: Icons.tune),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // W/kW seçimi
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SegmentedButton<PowerUnit>(
                      segments: const [
                        ButtonSegment(value: PowerUnit.w, label: Text('W')),
                        ButtonSegment(value: PowerUnit.kw, label: Text('kW')),
                      ],
                      selected: {_unit},
                      onSelectionChanged: (s) {
                        final newUnit = s.first;

                        // değeri otomatik çevir
                        final v = _d(_guc);
                        if (v != null && v > 0) {
                          final converted = (newUnit == PowerUnit.kw) ? (v / 1000.0) : (v * 1000.0);
                          _guc.text = (newUnit == PowerUnit.kw)
                              ? converted.toStringAsFixed(2)
                              : converted.toStringAsFixed(0);
                        }

                        setState(() => _unit = newUnit);
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  _input('Cihaz Gücü ($unitLabel)', _guc,
                      _unit == PowerUnit.kw ? 'Örn: 0.30 = 300W' : 'Örn: 300'),

                  _input('Günlük Kullanım (saat)', _saat, 'Örn: 6 / Buzdolabı genelde 24'),
                  _input('Çalışma Oranı (%)', _calismaOrani, 'Örn: 30 (buzdolabı), 50 (klima)'),
                  _input('Ayda Kaç Gün', _gun, 'Örn: 30'),
                  _input('Elektrik Birim Fiyatı (TL/kWh)', _birimFiyat, 'Örn: 2.5'),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: hesapla,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Hesapla'),
                    ),
                  ),

                  if (_err != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_err!, style: const TextStyle(color: Colors.red))),
                      ],
                    )
                  ],
                ],
              ),
            ),
          ),

          _sectionTitle('Sonuç', icon: Icons.assessment),

          if (!_hasResult)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Değerleri girip “Hesapla”ya bas. Sonuçlar burada kartlı şekilde çıkacak.',
                  style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
                ),
              ),
            ),

          if (_hasResult) ...[
            // Üst özet kartı
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _pill(text: 'Hesaplandı', ok: true),
                        const Spacer(),
                        Text('%${_oran.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _schema(
                      left: 'Şebeke',
                      midTop: 'Aylık: ${_kwh(_aylikKwh)} kWh',
                      midBottom: 'Günlük: ${_kwh(_gunlukKwh)} kWh  •  Efektif: ${_num1(_efektifSaat)} s/gün',
                      right: 'Ev / Cihaz',
                    ),
                  ],
                ),
              ),
            ),

            // Detay kartları (grid gibi)
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tüketim', style: TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          _kv('Günlük', '${_kwh(_gunlukKwh)} kWh', bold: true),
                          _kv('Aylık', '${_kwh(_aylikKwh)} kWh', bold: true),
                          _kv('Gün', _gunAy.toStringAsFixed(0)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Maliyet', style: TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          _kv('Birim', '${_money(_fiyat)} TL/kWh'),
                          _kv('Aylık', '${_money(_aylikTl)} TL', bold: true),
                          _kv('Oran', '%${_oran.toStringAsFixed(0)}'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Girdi özeti
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Girdi Özeti', style: TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    _kv('Cihaz gücü', '${_gucKw.toStringAsFixed(2)} kW'),
                    _kv('Günlük süre', '${_saatGun.toStringAsFixed(1)} saat'),
                    _kv('Efektif çalışma', '${_efektifSaat.toStringAsFixed(1)} saat/gün'),
                    _kv('Çalışma oranı', '%${_oran.toStringAsFixed(0)}'),
                  ],
                ),
              ),
            ),
          ],

          _sectionTitle('Bilgi Kartları', icon: Icons.info_outline),

          _infoCard(
            title: 'Çalışma Oranı (%) Ne demek?',
            body:
            'Termostatlı cihazlar (buzdolabı, klima, derin dondurucu, kombi) fişte olsa bile sürekli çalışmaz.\n'
                '“Çalışma oranı”, gün içindeki gerçek çalışma süresinin yüzdesidir.\n\n'
                'Örn: %30 → 24 saatin yaklaşık 7.2 saati aktif çalışma.',
          ),

          _deviceGrid(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ---------------- INFO UI ----------------

  Widget _infoCard({required String title, required String body}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(body, style: const TextStyle(fontSize: 13, height: 1.35)),
          ],
        ),
      ),
    );
  }

  Widget _chipLine(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }

  Widget _deviceGrid() {
    // kısa ve okunur aralıklar
    final items = <String>[
      'Buzdolabı: 0.10–0.30 kW • %25–%40',
      'Derin dondurucu: 0.15–0.40 kW • %30–%45',
      'Klima (inverter) 9K: 0.60–0.90 kW • %30–%60',
      'Klima (inverter) 12K: 0.80–1.20 kW • %30–%60',
      'TV 32": 0.04–0.07 kW • %80–%100',
      'TV 55": 0.10–0.18 kW • %80–%100',
      'Kettle: 1.80–2.20 kW • (kısa süre)',
      'Ütü: 1.80–2.40 kW • (termostatlı)',
      'Fırın: 1.80–2.50 kW',
      'Süpürge: 0.60–1.20 kW',
      'LED ampul: 0.005–0.015 kW',
      'Mikrodalga: 0.80–1.50 kW',
    ];

    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ortalama Cihaz Güçleri (yaklaşık)',
                style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items.map(_chipLine).toList(),
            ),
            const SizedBox(height: 10),
            Text(
              'Not: Değerler yaklaşık ortalamadır. Ortam sıcaklığı ve kullanım alışkanlığına göre değişir.',
              style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
            ),
          ],
        ),
      ),
    );
  }
}
