import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum BaslatmaTipi { dol, yildizUcgen, softStarter, vfd }
enum KorumaTipi { mpcb, mcbTermik }

class MotorHesapSayfasi extends StatefulWidget {
  const MotorHesapSayfasi({super.key});

  @override
  State<MotorHesapSayfasi> createState() => _MotorHesapSayfasiState();
}

class _MotorHesapSayfasiState extends State<MotorHesapSayfasi> {
  // Zorunlu
  final _kw = TextEditingController();
  final _v = TextEditingController(text: '400');

  // Gelişmiş
  final _cos = TextEditingController(text: '0.85');
  final _eta = TextEditingController(text: '0.90');

  // Özel kalkış katsayısı
  bool ozelKalkis = false;
  final _startMultCustom = TextEditingController(text: '6');

  bool ucFaz = true;
  bool gelismisAcik = false;

  BaslatmaTipi baslatma = BaslatmaTipi.dol;
  KorumaTipi korumaTipi = KorumaTipi.mpcb;

  // kopyalama için string sonuç
  String sonuc = '';
  String? hata;

  // kartlı sonuç state
  bool _hasResult = false;

  // Hesaplanan değerler
  double _kwVal = 0;
  double _VVal = 0;
  double _cosVal = 0.85;
  double _etaVal = 0.90;

  double _pInKW = 0;
  double _sKva = 0;
  double _inA = 0;
  double _hp = 0;

  double _startMult = 0;
  double _iStart = 0;

  double _ayarLow = 0;
  double _ayarHigh = 0;
  String _termikRange = '';
  double _breakerNom = 0;
  String _curve = '';

  double? _d(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '.').trim());

  double _startMultiplier(BaslatmaTipi t) {
    switch (t) {
      case BaslatmaTipi.dol:
        return 6.0;
      case BaslatmaTipi.yildizUcgen:
        return 2.0;
      case BaslatmaTipi.softStarter:
        return 3.0;
      case BaslatmaTipi.vfd:
        return 1.2;
    }
  }

  String _baslatmaStr(BaslatmaTipi t) {
    switch (t) {
      case BaslatmaTipi.dol:
        return 'Direkt (DOL)';
      case BaslatmaTipi.yildizUcgen:
        return 'Yıldız/Üçgen';
      case BaslatmaTipi.softStarter:
        return 'Soft Starter';
      case BaslatmaTipi.vfd:
        return 'Sürücü (VFD)';
    }
  }

  String _korumaStr(KorumaTipi t) {
    switch (t) {
      case KorumaTipi.mpcb:
        return 'MPCB';
      case KorumaTipi.mcbTermik:
        return 'MCB + Termik';
    }
  }

  String _breakerCurveSuggestion(double startMult) {
    if (startMult >= 6) return 'C veya D (kalkış ağırsa D daha rahat)';
    if (startMult >= 3) return 'C (çoğu motor için) / gerekirse D';
    return 'B veya C';
  }

  void _setError(String msg) {
    setState(() {
      hata = msg;
      sonuc = '';
      _hasResult = false;
    });
  }

  String _termikAralikOner(double inA) {
    final step = inA < 20 ? 2.0 : (inA < 80 ? 5.0 : 10.0);
    final low = (inA / step).floor() * step;
    final high = (inA / step).ceil() * step;
    final l = max(0.1, low);
    final h = max(l + step, high);
    return '${l.toStringAsFixed(l < 10 ? 1 : 0)} – ${h.toStringAsFixed(h < 10 ? 1 : 0)} A';
  }

  void _syncDefaultStartMult() {
    if (!ozelKalkis) {
      final def = _startMultiplier(baslatma);
      _startMultCustom.text = def.toStringAsFixed(1).replaceAll('.0', '');
    }
  }

  void hesapla() {
    final kw = _d(_kw);
    final V = _d(_v);

    final cos = gelismisAcik ? _d(_cos) : 0.85;
    final eta = gelismisAcik ? _d(_eta) : 0.90;

    if (kw == null || V == null || cos == null || eta == null) {
      _setError('Lütfen sayısal değer gir (örn: 7.5, 400, 0.85).');
      return;
    }

    if (kw < 0.1 || kw > 500) {
      _setError('Motor gücü çok uç görünüyor. (0.1 kW – 500 kW arası gir)');
      return;
    }

    if (ucFaz) {
      if (V < 300 || V > 690) {
        _setError('3 faz için gerilim mantıksız. (300–690 V, genelde 400V)');
        return;
      }
    } else {
      if (V < 100 || V > 300) {
        _setError('1 faz için gerilim mantıksız. (100–300 V, genelde 230V)');
        return;
      }
    }

    if (cos <= 0 || cos > 1) {
      _setError('cosφ 0 ile 1 arasında olmalı.');
      return;
    }
    if (eta <= 0 || eta > 1) {
      _setError('Verim (η) 0 ile 1 arasında olmalı.');
      return;
    }
    if (cos < 0.2) {
      _setError('cosφ çok düşük görünüyor (0.2 altı). Değeri kontrol et.');
      return;
    }
    if (eta < 0.3) {
      _setError('Verim çok düşük görünüyor (0.3 altı). Değeri kontrol et.');
      return;
    }

    final startMult =
    ozelKalkis ? _d(_startMultCustom) : _startMultiplier(baslatma);
    if (startMult == null) {
      _setError('Kalkış katsayısı sayısal olmalı.');
      return;
    }
    if (startMult < 1.0 || startMult > 12.0) {
      _setError('Kalkış katsayısı uç görünüyor. (1.0 – 12.0 arası gir)');
      return;
    }
    if (baslatma == BaslatmaTipi.vfd && startMult > 3.0) {
      _setError('VFD için kalkış katsayısı çok yüksek görünüyor (genelde ~1.1–1.3).');
      return;
    }

    // Hesaplar
    final pOutW = kw * 1000.0;
    final pInW = pOutW / eta;
    final sVA = pInW / cos;
    final sKva = sVA / 1000.0;

    final inA = ucFaz
        ? (pInW / (sqrt(3) * V * cos))
        : (pInW / (V * cos));

    if (!inA.isFinite || inA <= 0) {
      _setError('Hesap hatası: değerleri kontrol et.');
      return;
    }
    if (inA > 2000) {
      _setError('Hesaplanan akım çok yüksek çıktı (>2000A). Değerler uç olabilir.');
      return;
    }

    final hp = kw * 1.341;
    final iStart = inA * startMult;

    final ayarLow = inA * 1.00;
    final ayarHigh = inA * 1.05;

    final breakerNom = inA * 1.25;
    final curve = _breakerCurveSuggestion(startMult);

    final termikRange = _termikAralikOner(inA);

    // Kopyala için sade metin
    final baseText =
        'Faz: ${ucFaz ? "3 Faz" : "1 Faz"}\n'
        'Gerilim: ${V.toStringAsFixed(0)} V\n'
        'Motor: ${kw.toStringAsFixed(2)} kW (~${hp.toStringAsFixed(2)} HP)\n'
        '${gelismisAcik ? "cosφ: ${cos.toStringAsFixed(2)}   η: ${eta.toStringAsFixed(2)}\n" : ""}'
        'Giriş gücü (yakl.): ${(pInW / 1000).toStringAsFixed(2)} kW\n'
        'Görünür güç: ${sKva.toStringAsFixed(2)} kVA\n'
        'Anma akımı: ${inA.toStringAsFixed(2)} A\n';

    final startText =
        'Başlatma: ${_baslatmaStr(baslatma)}\n'
        'Kalkış katsayısı: ${startMult.toStringAsFixed(2)}x\n'
        'Kalkış akımı: ${iStart.toStringAsFixed(1)} A\n';

    final protectText = (korumaTipi == KorumaTipi.mpcb)
        ? 'Koruma: MPCB\n'
        'Ayar: ${ayarLow.toStringAsFixed(1)} – ${ayarHigh.toStringAsFixed(1)} A\n'
        'Aralık fikri: $termikRange\n'
        : 'Koruma: MCB + Termik\n'
        'Termik ayar: ${ayarLow.toStringAsFixed(1)} – ${ayarHigh.toStringAsFixed(1)} A\n'
        'Aralık fikri: $termikRange\n'
        'MCB nominal: ~${breakerNom.toStringAsFixed(0)} A\n'
        'Eğri: $curve\n';

    setState(() {
      hata = null;
      _hasResult = true;

      _kwVal = kw;
      _VVal = V;
      _cosVal = cos;
      _etaVal = eta;
      _pInKW = pInW / 1000.0;
      _sKva = sKva;
      _inA = inA;
      _hp = hp;

      _startMult = startMult;
      _iStart = iStart;

      _ayarLow = ayarLow;
      _ayarHigh = ayarHigh;
      _termikRange = termikRange;
      _breakerNom = breakerNom;
      _curve = curve;

      sonuc =
      '$baseText\n$startText\n$protectText\n'
          'Not: Bu hesap yaklaşık/ön seçim içindir.';
    });
  }

  Future<void> kopyala() async {
    if (sonuc.trim().isEmpty) return;
    await Clipboard.setData(ClipboardData(text: sonuc));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sonuç panoya kopyalandı.')),
    );
  }

  void temizle() {
    setState(() {
      _kw.clear();
      sonuc = '';
      hata = null;
      _hasResult = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _syncDefaultStartMult();
  }

  @override
  void dispose() {
    _kw.dispose();
    _v.dispose();
    _cos.dispose();
    _eta.dispose();
    _startMultCustom.dispose();
    super.dispose();
  }

  // ---------------- UI helpers ----------------
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

  Widget _flowBox(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _flowArrow() {
    return Row(
      children: [
        const SizedBox(width: 10),
        Icon(Icons.arrow_forward, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _flowSchema() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _flowBox('Şebeke', Icons.power),
          _flowArrow(),
          _flowBox('Kontaktör', Icons.toggle_on),
          _flowArrow(),
          _flowBox('Motor', Icons.electric_bolt),
          _flowArrow(),
          _flowBox('Koruma', Icons.shield),
        ],
      ),
    );
  }

  // ---------------- build ----------------
  @override
  Widget build(BuildContext context) {
    final hasResult = _hasResult && sonuc.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Motor Hesapları')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: ucFaz,
            title: const Text('3 Faz'),
            subtitle: Text(
              ucFaz ? 'V: Faz-Faz (genelde 400V)' : 'V: Faz-Nötr (genelde 230V)',
            ),
            onChanged: (x) {
              setState(() {
                ucFaz = x;
                _v.text = ucFaz ? '400' : '230';
              });
            },
          ),

          _input('Motor Gücü (kW)', _kw, 'Örn: 7.5'),
          _input('Gerilim (V)', _v, ucFaz ? 'Örn: 400' : 'Örn: 230'),

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
            onChanged: (v) {
              setState(() {
                baslatma = v ?? BaslatmaTipi.dol;
                _syncDefaultStartMult();
              });
            },
          ),

          const SizedBox(height: 10),

          SwitchListTile(
            value: ozelKalkis,
            title: const Text('Kalkış katsayısı: Özel'),
            subtitle: Text(
              ozelKalkis ? 'İstediğin katsayıyı gir (örn 5.5)' : 'Otomatik: seçilen başlatmaya göre',
            ),
            onChanged: (x) {
              setState(() {
                ozelKalkis = x;
                _syncDefaultStartMult();
              });
            },
          ),
          if (ozelKalkis)
            _input('Özel kalkış katsayısı (x)', _startMultCustom, 'Örn: 6'),

          const SizedBox(height: 10),

          DropdownButtonFormField<KorumaTipi>(
            value: korumaTipi,
            decoration: const InputDecoration(
              labelText: 'Koruma Tipi',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: KorumaTipi.mpcb, child: Text('MPCB (Motor Koruma Şalteri)')),
              DropdownMenuItem(value: KorumaTipi.mcbTermik, child: Text('MCB + Termik')),
            ],
            onChanged: (v) => setState(() => korumaTipi = v ?? KorumaTipi.mpcb),
          ),

          const SizedBox(height: 12),

          ExpansionTile(
            title: const Text('Gelişmiş'),
            subtitle: const Text('cosφ ve verim (η)'),
            initiallyExpanded: gelismisAcik,
            onExpansionChanged: (open) => setState(() => gelismisAcik = open),
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Expanded(child: _input('cosφ', _cos, 'Örn: 0.85')),
                    const SizedBox(width: 10),
                    Expanded(child: _input('Verim (η)', _eta, 'Örn: 0.90')),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: hesapla,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Hesapla'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: temizle,
                child: const Text('Temizle'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (hata != null) ...[
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
                        hata!,
                        style: const TextStyle(
                          color: Colors.red,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],

          if (hasResult) ...[
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.55),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Sonuç', style: TextStyle(fontWeight: FontWeight.w900)),
                        const Spacer(),
                        _pill(text: 'Hesaplandı', ok: true),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _flowSchema(),
                    const SizedBox(height: 10),
                    _kv('Anma akımı', '${_inA.toStringAsFixed(2)} A', bold: true),
                    _kv('Kalkış akımı', '${_iStart.toStringAsFixed(1)} A  (${_startMult.toStringAsFixed(2)}x)', bold: true),
                    _kv('Koruma tipi', _korumaStr(korumaTipi)),
                  ],
                ),
              ),
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Temel', style: TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    _kv('Faz', ucFaz ? '3 Faz' : '1 Faz', bold: true),
                    _kv('Gerilim', '${_VVal.toStringAsFixed(0)} V'),
                    _kv('Motor', '${_kwVal.toStringAsFixed(2)} kW  (~${_hp.toStringAsFixed(2)} HP)', bold: true),
                    if (gelismisAcik) _kv('cosφ / η', '${_cosVal.toStringAsFixed(2)}  /  ${_etaVal.toStringAsFixed(2)}'),
                    _kv('Giriş gücü (yakl.)', '${_pInKW.toStringAsFixed(2)} kW'),
                    _kv('Görünür güç', '${_sKva.toStringAsFixed(2)} kVA'),
                  ],
                ),
              ),
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kalkış', style: TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    _kv('Başlatma', _baslatmaStr(baslatma), bold: true),
                    _kv('Katsayı', '${_startMult.toStringAsFixed(2)}x'),
                    _kv('Akım', '${_iStart.toStringAsFixed(1)} A', bold: true),
                  ],
                ),
              ),
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Koruma', style: TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    _kv('Tip', _korumaStr(korumaTipi), bold: true),
                    _kv('Pratik ayar', '${_ayarLow.toStringAsFixed(1)} – ${_ayarHigh.toStringAsFixed(1)} A', bold: true),
                    _kv('Seçim aralığı fikri', _termikRange),
                    if (korumaTipi == KorumaTipi.mcbTermik) ...[
                      _kv('MCB nominal', '~${_breakerNom.toStringAsFixed(0)} A'),
                      _kv('Eğri önerisi', _curve, bold: true),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'Not: Bu hesap yaklaşık/ön seçim içindir. Etiket verisi, yük tipi, start süresi, kablo ve kısa devre şartları seçimi değiştirir.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            OutlinedButton.icon(
              onPressed: kopyala,
              icon: const Icon(Icons.copy),
              label: const Text('Kopyala'),
            ),
          ] else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Sonuç burada görünecek.',
                  style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
                ),
              ),
            ),
          ],
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
