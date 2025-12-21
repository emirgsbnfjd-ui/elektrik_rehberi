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
  final _valCtrl = TextEditingController(); // seçilen giriş türü değeri
  final _vCtrl = TextEditingController(text: '230'); // Mono: 230, Tri: 400
  final _cosCtrl = TextEditingController(text: '0,90');
  final _etaCtrl = TextEditingController(text: '0,90'); // verim

  bool trifaze = false;
  GirisTuru giris = GirisTuru.pKw;

  String sonucMetin = '';

  // . ve , desteği
  double? _toDouble(TextEditingController c) {
    final t = c.text.trim().replaceAll(' ', '').replaceAll(',', '.');
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  // Sadece sayı + , .
  final _numFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]')),
  ];

  void _setVarsayilanGerilim() {
    _vCtrl.text = trifaze ? '400' : '230';
  }

  void hesapla() {
    final val = _toDouble(_valCtrl);
    final v = _toDouble(_vCtrl);
    final cos = _toDouble(_cosCtrl);
    final eta = _toDouble(_etaCtrl);

    // Kontroller
    if (v == null || v <= 0) {
      setState(() => sonucMetin = 'Gerilim (V) geçersiz.');
      return;
    }
    if (cos == null || cos <= 0 || cos > 1) {
      setState(() => sonucMetin = 'cosφ 0-1 arası olmalı.');
      return;
    }
    if (eta == null || eta <= 0 || eta > 1) {
      setState(() => sonucMetin = 'Verim (η) 0-1 arası olmalı.');
      return;
    }
    if (val == null || val <= 0) {
      setState(() => sonucMetin = 'Giriş değerini gir (0’dan büyük).');
      return;
    }

    // Temel çarpan
    final k = trifaze ? (math.sqrt(3) * v) : v;

    // Çözülecek büyüklükler:
    // P (kW), S (kVA), Q (kVAr), I (A)
    double pKw, sKva, qKvar, iA;

    // İlişkiler:
    // S = P / (cos * eta)
    // P = S * cos * eta
    // I = (S*1000) / (k)
    // Q = S * sin(phi)  (phi = arccos(cos))
    final phi = math.acos(cos);
    final sinPhi = math.sin(phi);

    if (giris == GirisTuru.pKw) {
      pKw = val;
      sKva = pKw / (cos * eta);
      iA = (sKva * 1000) / k;
    } else if (giris == GirisTuru.sKva) {
      sKva = val;
      pKw = sKva * cos * eta;
      iA = (sKva * 1000) / k;
    } else {
      // GirisTuru.iA
      iA = val;
      sKva = (iA * k) / 1000;
      pKw = sKva * cos * eta;
    }

    qKvar = sKva * sinPhi;

    // Şema (ASCII)
    final sekil = trifaze
        ? '''
   L1   L2   L3
    |    |    |
   [   YÜK   ]   (3~)
    |    |    |
        N (ops.)
V = ${v.toStringAsFixed(0)} V (faz-faz)
'''
        : '''
   L
   |
 [ YÜK ]   (1~)
   |
   N
V = ${v.toStringAsFixed(0)} V (faz-nötr)
''';

    // Adım adım formül metni
    String girisAciklama() {
      switch (giris) {
        case GirisTuru.pKw:
          return 'Giriş: P = ${pKw.toStringAsFixed(3)} kW';
        case GirisTuru.sKva:
          return 'Giriş: S = ${sKva.toStringAsFixed(3)} kVA';
        case GirisTuru.iA:
          return 'Giriş: I = ${iA.toStringAsFixed(3)} A';
      }
    }

    final kStr = trifaze ? '√3·V' : 'V';
    final vTip = trifaze ? 'faz-faz' : 'faz-nötr';

    setState(() {
      sonucMetin = '''
$sekil
${trifaze ? "TRİFAZE (3~)" : "MONOFAZE (1~)"}  •  V($vTip) = ${v.toStringAsFixed(0)} V
cosφ = ${cos.toStringAsFixed(3)}   •   η = ${eta.toStringAsFixed(3)}

=== SONUÇLAR ===
P (aktif)   : ${pKw.toStringAsFixed(3)} kW
S (görünür) : ${sKva.toStringAsFixed(3)} kVA
Q (reaktif) : ${qKvar.toStringAsFixed(3)} kVAr
I (akım)    : ${iA.toStringAsFixed(2)} A

=== FORMÜL / ADIMLAR ===
${girisAciklama()}

1) İlişki:  S = P / (cosφ·η)   veya   P = S·cosφ·η
2) Akım:    I = (S·1000) / ($kStr)    (burada $kStr = ${k.toStringAsFixed(2)})
3) Reaktif: Q = S·sinφ   (φ = arccos(cosφ) → sinφ = ${sinPhi.toStringAsFixed(4)})

Not: η (verim) motor/trafo gibi yüklerde gerçekçi sonuç verir. Rezistif yükte η≈1 alınabilir.
'''.trim();
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
                color: theme.colorScheme.surface,
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
                        },
                        title: const Text('Trifaze'),
                        subtitle: Text(trifaze
                            ? 'V = 400V (faz-faz) varsayılan'
                            : 'V = 230V (faz-nötr) varsayılan'),
                      ),
                      const SizedBox(height: 8),

                      // Giriş seçimi
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<GirisTuru>(
                              value: giris,
                              items: const [
                                DropdownMenuItem(
                                  value: GirisTuru.pKw,
                                  child: Text('P (kW) → Akım'),
                                ),
                                DropdownMenuItem(
                                  value: GirisTuru.iA,
                                  child: Text('I (A) → Güçler'),
                                ),
                                DropdownMenuItem(
                                  value: GirisTuru.sKva,
                                  child: Text('S (kVA) → Akım'),
                                ),
                              ],
                              onChanged: (v) {
                                if (v == null) return;
                                setState(() {
                                  giris = v;
                                  _valCtrl.clear();
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Hangi değer biliniyor?',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Seçilen giriş
                      _input(
                        label: girisLabel(),
                        controller: _valCtrl,
                        hint: 'Örnek: 5,5',
                        formatters: _numFormatter,
                      ),
                      _input(
                        label: 'Gerilim (V)',
                        controller: _vCtrl,
                        hint: trifaze ? '400' : '230',
                        formatters: _numFormatter,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _input(
                              label: 'cosφ',
                              controller: _cosCtrl,
                              hint: '0,90',
                              formatters: _numFormatter,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _input(
                              label: 'Verim (η)',
                              controller: _etaCtrl,
                              hint: '0,90',
                              formatters: _numFormatter,
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

              // Sonuç
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: sonucMetin.isEmpty
                      ? const Text('Sonuç burada (Hesapla\'ya bas)')
                      : SelectableText(
                          sonucMetin,
                          style: const TextStyle(height: 1.25),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        inputFormatters: formatters,
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
