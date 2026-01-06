import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GucHesabiSayfasi extends StatefulWidget {
  const GucHesabiSayfasi({super.key});

  @override
  State<GucHesabiSayfasi> createState() => _GucHesabiSayfasiState();
}

enum GirisTuru { pKw, iA, sKva }

class _GucHesabiSayfasiState extends State<GucHesabiSayfasi> {
  // Girişler
  final _valCtrl = TextEditingController();
  final _vCtrl = TextEditingController(text: '230'); // mono 230, tri 400
  final _cosCtrl = TextEditingController(text: '0,90');
  final _etaCtrl = TextEditingController(text: '0,90');

  bool trifaze = false;
  GirisTuru giris = GirisTuru.pKw;

  // Sonuçlar
  String? _sekil;
  String? _sonucSatiri;
  String? _kisaNot;

  double? _toDouble(TextEditingController c) {
    final t = c.text.trim().replaceAll(' ', '').replaceAll(',', '.');
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  final _numFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]')),
  ];

  void _setVarsayilanGerilim() {
    _vCtrl.text = trifaze ? '400' : '230';
  }

  void _clearResult() {
    setState(() {
      _sekil = null;
      _sonucSatiri = null;
      _kisaNot = null;
    });
  }

  void _error(String msg) {
    setState(() {
      _sekil = null;
      _sonucSatiri = null;
      _kisaNot = msg;
    });
  }

  bool _isReasonableVoltage(double v) {
    if (!trifaze) return v >= 80 && v <= 300;
    return v >= 200 && v <= 800;
  }

  String _girisAdi(GirisTuru g) {
    switch (g) {
      case GirisTuru.pKw:
        return 'P (kW)';
      case GirisTuru.sKva:
        return 'S (kVA)';
      case GirisTuru.iA:
        return 'I (A)';
    }
  }

  void hesapla() {
    final val = _toDouble(_valCtrl);
    final v = _toDouble(_vCtrl);
    final cos = _toDouble(_cosCtrl);
    final eta = _toDouble(_etaCtrl);

    if (v == null || v <= 0) return _error('Gerilim (V) geçersiz.');
    if (!_isReasonableVoltage(v)) {
      return _error(trifaze
          ? 'Trifaze için gerilim çok uç. 200–800V arası gir.'
          : 'Monofaze için gerilim çok uç. 80–300V arası gir.');
    }
    if (cos == null || cos <= 0 || cos > 1) return _error('cosφ 0–1 arası olmalı.');
    if (eta == null || eta <= 0 || eta > 1) return _error('Verim (η) 0–1 arası olmalı.');
    if (val == null || val <= 0) return _error('Giriş değerini gir (0’dan büyük).');

    final k = trifaze ? (math.sqrt(3) * v) : v;

    double pKw, sKva, qKvar, iA;

    final phi = math.acos(cos);
    final sinPhi = math.sin(phi);

    if (giris == GirisTuru.pKw) {
      pKw = val;
      if (pKw > 2000) return _error('P çok büyük görünüyor. Daha gerçekçi bir değer gir.');
      sKva = pKw / (cos * eta);
      iA = (sKva * 1000) / k;
    } else if (giris == GirisTuru.sKva) {
      sKva = val;
      if (sKva > 3000) return _error('S çok büyük görünüyor. Daha gerçekçi bir değer gir.');
      pKw = sKva * cos * eta;
      iA = (sKva * 1000) / k;
    } else {
      iA = val;
      if (iA > 4000) return _error('Akım çok büyük görünüyor. Daha gerçekçi bir değer gir.');
      sKva = (iA * k) / 1000;
      pKw = sKva * cos * eta;
    }

    qKvar = sKva * sinPhi;

    if (iA.isNaN || iA.isInfinite || iA <= 0) return _error('Hesap sonucu geçersiz (I).');
    if (sKva.isNaN || sKva.isInfinite || sKva <= 0) return _error('Hesap sonucu geçersiz (S).');
    if (pKw.isNaN || pKw.isInfinite || pKw <= 0) return _error('Hesap sonucu geçersiz (P).');
    if (iA > 6000) return _error('Akım çok uç çıktı. Girdileri kontrol et.');

    // ✅ PRO ŞEMA: tek hat + koruma elemanları
    final sekil = trifaze
        ? '''
   3~ TEK HAT DİYAGRAMI (TRİFAZE)

 L1 ───────────┐
 L2 ───────────┼──[ 3P MCB ]──[ RCD ]──[   YÜK   ]
 L3 ───────────┘

 N  ───────────────────────────[ RCD ]───────────┘   (ops.)

 V = ${v.toStringAsFixed(0)} V  (faz-faz)
'''
        : '''
   1~ TEK HAT DİYAGRAMI (MONOFAZE)

 L  ───[ 1P MCB ]──[ RCD ]──[   YÜK   ]────────────┐
 N  ─────────────────────────[ RCD ]───────────────┘

 V = ${v.toStringAsFixed(0)} V  (faz-nötr)
''';

    final sonucSatiri = '''
GİRİŞ BİLGİLERİ
• Tür        : ${_girisAdi(giris)}
• Değer     : ${val.toStringAsFixed(3)}
• Sistem    : ${trifaze ? "Trifaze (3~)" : "Monofaze (1~)"}
• Gerilim   : ${v.toStringAsFixed(0)} V
• cosφ      : ${cos.toStringAsFixed(2)}
• η (Verim) : ${eta.toStringAsFixed(2)}

HESAP SONUÇLARI
• P (Aktif Güç)    : ${pKw.toStringAsFixed(3)} kW
• S (Görünür Güç)  : ${sKva.toStringAsFixed(3)} kVA
• Q (Reaktif Güç)  : ${qKvar.toStringAsFixed(3)} kVAr
• I (Hat Akımı)    : ${iA.toStringAsFixed(2)} A
'''.trim();

    final kStr = trifaze ? '√3·V' : 'V';

    final not = '''
Formüller:
• S = P / (cosφ · η)
• I = (S · 1000) / ($kStr)
• Q = S · sinφ

φ = arccos(cosφ)  →  sinφ = ${sinPhi.toStringAsFixed(3)}
'''.trim();

    setState(() {
      _sekil = sekil.trimRight();
      _sonucSatiri = sonucSatiri;
      _kisaNot = not;
    });
  }

  @override
  void dispose() {
    _valCtrl.dispose();
    _vCtrl.dispose();
    _cosCtrl.dispose();
    _etaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    String girisLabel() {
      switch (giris) {
        case GirisTuru.pKw:
          return 'Giriş: Güç P (kW)';
        case GirisTuru.iA:
          return 'Giriş: Akım I (A)';
        case GirisTuru.sKva:
          return 'Giriş: Görünür Güç S (kVA)';
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Güç Hesabı (Şemalı)')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 0,
                color: cs.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: trifaze,
                        onChanged: (v) {
                          setState(() {
                            trifaze = v;
                            _setVarsayilanGerilim();
                          });
                          _clearResult();
                        },
                        title: const Text('Trifaze'),
                        subtitle: Text(trifaze
                            ? 'Varsayılan: 400V (faz-faz)'
                            : 'Varsayılan: 230V (faz-nötr)'),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<GirisTuru>(
                        value: giris,
                        items: const [
                          DropdownMenuItem(
                            value: GirisTuru.pKw,
                            child: Text('P (kW) → Akım / Güçler'),
                          ),
                          DropdownMenuItem(
                            value: GirisTuru.iA,
                            child: Text('I (A) → Güçler'),
                          ),
                          DropdownMenuItem(
                            value: GirisTuru.sKva,
                            child: Text('S (kVA) → Akım / Güçler'),
                          ),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() {
                            giris = v;
                            _valCtrl.clear();
                          });
                          _clearResult();
                        },
                        decoration: const InputDecoration(
                          labelText: 'Hangi değer biliniyor?',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _input(
                        label: girisLabel(),
                        controller: _valCtrl,
                        hint: 'Örnek: 5,5',
                        formatters: _numFormatter,
                        onChanged: (_) => _clearResult(),
                      ),
                      _input(
                        label: 'Gerilim (V)',
                        controller: _vCtrl,
                        hint: trifaze ? '400' : '230',
                        formatters: _numFormatter,
                        onChanged: (_) => _clearResult(),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _input(
                              label: 'cosφ',
                              controller: _cosCtrl,
                              hint: '0,90',
                              formatters: _numFormatter,
                              onChanged: (_) => _clearResult(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _input(
                              label: 'Verim (η)',
                              controller: _etaCtrl,
                              hint: '0,90',
                              formatters: _numFormatter,
                              onChanged: (_) => _clearResult(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: hesapla,
                          icon: const Icon(Icons.calculate),
                          label: const Text('Hesapla'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                color: cs.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: _kisaNot == null && _sonucSatiri == null && _sekil == null
                      ? Text(
                    'Sonuç burada. Değerleri girip “Hesapla”ya bas.',
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(0.75),
                      fontWeight: FontWeight.w500,
                    ),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.schema, color: cs.primary),
                          const SizedBox(width: 8),
                          const Text(
                            'Sonuç (Şemalı)',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          const Spacer(),
                          if (_sonucSatiri != null)
                            IconButton(
                              tooltip: 'Kopyala',
                              onPressed: () {
                                final txt = [
                                  if (_sekil != null) _sekil!,
                                  if (_sonucSatiri != null) _sonucSatiri!,
                                  if (_kisaNot != null) _kisaNot!,
                                ].join('\n');
                                Clipboard.setData(ClipboardData(text: txt));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Kopyalandı')),
                                );
                              },
                              icon: const Icon(Icons.copy),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_sekil != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: cs.outlineVariant.withOpacity(0.7)),
                          ),
                          child: SelectableText(
                            _sekil!,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              height: 1.15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (_sonucSatiri != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cs.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: cs.outlineVariant.withOpacity(0.7)),
                          ),
                          child: SelectableText(
                            _sonucSatiri!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (_kisaNot != null) ...[
                        Text(
                          _kisaNot!,
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input({
    required String label,
    required TextEditingController controller,
    required String hint,
    required List<TextInputFormatter> formatters,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        inputFormatters: formatters,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
