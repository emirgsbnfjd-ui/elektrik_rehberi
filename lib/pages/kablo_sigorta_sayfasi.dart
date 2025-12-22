import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KabloSigortaSayfasi extends StatefulWidget {
  const KabloSigortaSayfasi({super.key});

  @override
  State<KabloSigortaSayfasi> createState() => _KabloSigortaSayfasiState();
}

class _KabloSigortaSayfasiState extends State<KabloSigortaSayfasi> {
  final powerCtrl = TextEditingController();   // kW
  final currentCtrl = TextEditingController(); // A
  final lengthCtrl = TextEditingController();  // m

  // Seçimler
  String faz = 'Tek Faz';          // Tek Faz / Trifaze
  String gerilim = '230 V';        // Tek Faz: 230, Trifaze: 400 (kilitli)
  String girisTuru = 'Güç (kW)';   // Güç (kW) / Akım (A)
  String malzeme = 'Bakır (Cu)';   // Bakır / Alüminyum
  String yukTipi = 'Genel (Priz)'; // Genel / Aydınlatma / Motor

  bool voltajDusumuAktif = false;

  double cosPhi = 0.95;
  double verim = 0.90;

  // Sonuçlar
  String? sonucAkim;
  String? sonucKablo;
  String? sonucSigorta;
  String? sonucGerilimDusumu;
  String? uyari;

  // Kesit listesi
  final List<String> kesitler = const [
    '1.5','2.5','4','6','10','16','25','35','50','70','95',
    '120','150','185','240''300','400','500','630'
  ];

  // Yaklaşık taşıma akımları (A) — saha tahmini
  final Map<String, double> ampCu = const {
    '1.5': 16, '2.5': 25, '4': 32, '6': 40, '10': 63, '16': 80,
    '25': 100, '35': 125, '50': 160, '70': 200, '95': 250,'120': 290,'150': 330,'185': 380,'240': 460,
    '300': 520, '400': 650, '500': 760, '630': 900,
  };

  final Map<String, double> ampAl = const {
    '2.5': 20, '4': 25, '6': 32, '10': 50, '16': 63,
    '25': 80, '35': 100, '50': 125, '70': 160, '95': 200,'120': 230,'150': 260,'185': 300,'240': 360,
    '300': 410, '400': 520, '500': 610, '630': 720,
  };

  final List<int> sigortalar = const [
    6,10,16,20,25,32,40,50,63,80,100,125,160,200,250,
    315,400,500,630,800,1000
  ];

  // --- Yardımcılar ---

  // Virgül/nokta fark etmez
  double _parseNum(String s) {
    final t = s.replaceAll(',', '.').trim();
    return double.tryParse(t) ?? double.nan;
  }

  double _parseCtrl(TextEditingController c) => _parseNum(c.text);

  double _Vnom() => (faz == 'Tek Faz') ? 230.0 : 400.0;

  double _rho() => malzeme.startsWith('Bakır') ? 0.018 : 0.028; // Ω·mm²/m (yaklaşık)

  double _akimHesaplaKw(double kw) {
    final V = _Vnom();
    if (faz == 'Tek Faz') {
      return (kw * 1000.0) / (V * cosPhi * verim);
    } else {
      return (kw * 1000.0) / (math.sqrt(3) * V * cosPhi * verim);
    }
  }

  double _gerilimDusumuVolt({required double I, required double L, required double S}) {
    final rho = _rho();
    if (faz == 'Tek Faz') {
      return 2.0 * I * L * rho / S;
    } else {
      return math.sqrt(3) * I * L * rho / S;
    }
  }

  double _hedefDusumYuzde() {
    if (yukTipi.startsWith('Aydınlatma')) return 3.0;
    return 5.0;
  }

  double _ampLimit(String kesitKey) {
    final map = malzeme.startsWith('Bakır') ? ampCu : ampAl;
    return map[kesitKey] ?? 0;
  }

  double _kesitToDouble(String k) => double.tryParse(k) ?? 0;

  String _kesitSec({required double I, double? L}) {
    final V = _Vnom();
    final hedef = _hedefDusumYuzde();

    final uygunKesitler = kesitler.where((k) {
      if (!malzeme.startsWith('Bakır')) {
        if (k == '1.5') return false;
        if (!ampAl.containsKey(k)) return false;
      }
      return true;
    }).toList();

    // 1) Akıma göre minimum kesit
    String secilen = uygunKesitler.first;
    for (final k in uygunKesitler) {
      if (_ampLimit(k) >= I) {
        secilen = k;
        break;
      }
      secilen = k;
    }

    // 2) ΔV aktifse: hedefi tutturana kadar büyüt
    if (voltajDusumuAktif && L != null) {
      for (final k in uygunKesitler) {
        if (_kesitToDouble(k) < _kesitToDouble(secilen)) continue;
        final S = _kesitToDouble(k);
        final dv = _gerilimDusumuVolt(I: I, L: L, S: S);
        final p = (dv / V) * 100.0;
        if (p <= hedef) {
          secilen = k;
          break;
        }
      }
    }

    return secilen;
  }

  int _sigortaSec(double I) {
    final hedef = I * 1.25;
    for (final s in sigortalar) {
      if (s >= hedef) return s;
    }
    return sigortalar.last;
  }

  String _egriOner() {
    if (yukTipi.startsWith('Aydınlatma')) return 'B';
    if (yukTipi.startsWith('Motor')) return 'C (gerekirse D)';
    return 'C';
  }

  void _sifirlaSonuclar() {
    sonucAkim = null;
    sonucKablo = null;
    sonucSigorta = null;
    sonucGerilimDusumu = null;
    uyari = null;
  }

  void _fazDegisti(String yeni) {
    setState(() {
      faz = yeni;

      // ✅ Faz seçimine göre gerilimi kilitle
      gerilim = (faz == 'Tek Faz') ? '230 V' : '400 V';

      _sifirlaSonuclar();
    });
  }

  void _hesapla() {
  // Önce eski sonuçları temizle
  setState(() {
    sonucKablo = null;
    sonucSigorta = null;
    sonucAkim = null;
    sonucGerilimDusumu = null;
    uyari = null;
  });

  // 1) Akım (I) hesapla / al
  double I;

  if (girisTuru.startsWith('Güç')) {
    final kw = _parseCtrl(powerCtrl);
    if (kw.isNaN || kw <= 0) {
      setState(() => uyari = 'Güç (kW) gir.');
      return;
    }
    I = _akimHesaplaKw(kw);
  } else {
    final a = _parseCtrl(currentCtrl);
    if (a.isNaN || a <= 0) {
      setState(() => uyari = 'Akım (A) gir.');
      return;
    }
    I = a;
  }

  // 1.1) Abartı değer filtresi (tek kablo için mantıksız akım)
  const double maxTekKabloAkim = 1000.0; // istersen 800/1250 yaparız
  if (I > maxTekKabloAkim) {
    setState(() {
      sonucAkim = 'Akım ≈ ${I.toStringAsFixed(2)} A';
      uyari =
          '⚠️ Çok büyük akım! (>${maxTekKabloAkim.toStringAsFixed(0)} A)\n'
          'Bu hesap “tek kablo/tek hat” içindir. Bu seviyelerde genelde paralel kablo, bara (busbar), özel şalt/sigorta seçimi gerekir.';
    });
    return;
  }

  // 2) Uzunluk (ΔV açıksa)
  double? L;
  if (voltajDusumuAktif) {
    final lVal = _parseCtrl(lengthCtrl);
    if (lVal.isNaN || lVal <= 0) {
      setState(() => uyari = 'Hat uzunluğu (m) gir.');
      return;
    }
    L = lVal;
  }

  // 3) Kesit seç
  final secKesitKey = _kesitSec(I: I, L: L);
  final secKesit = _kesitToDouble(secKesitKey);

  final tasima = _ampLimit(secKesitKey);

  // 3.1) Seçilen kesit bile akımı taşımıyorsa: “tek kablo yetmez” uyarısı
  if (tasima <= 0 || tasima < I) {
    setState(() {
      sonucAkim = 'Akım ≈ ${I.toStringAsFixed(2)} A';
      uyari =
          '⚠️ Bu akım için tek kablo yeterli görünmüyor.\n'
          'Seçilebilen en büyük kesitte bile taşıma akımı yetersiz. '
          'Paralel kablo / farklı döşeme / bara sistemi düşünülmeli.';
    });
    return;
  }

  // 4) Sigorta seç
  final sig = _sigortaSec(I);
  final egri = _egriOner();

  // 5) ΔV metni
  String? dvText;
  String ekstra = '';
  if (voltajDusumuAktif && L != null) {
    final dv = _gerilimDusumuVolt(I: I, L: L, S: secKesit);
    final percent = (dv / _Vnom()) * 100.0;
    final hedef = _hedefDusumYuzde();

    dvText =
        'Gerilim düşümü: ΔV ≈ ${dv.toStringAsFixed(2)} V (${percent.toStringAsFixed(2)}%)'
        ' • Hedef ≤ ${hedef.toStringAsFixed(0)}%';

    if (percent > hedef) {
      ekstra = 'Gerilim düşümü hedefi aşıyor; kesiti büyütmek gerekebilir.';
    } else if (percent > hedef * 0.8) {
      ekstra = 'Sınırda: uzun hatlarda 1 kademe büyük kesit daha konforlu olur.';
    }
  }

  // 6) Sonuçları yaz
  setState(() {
    sonucAkim = 'Akım ≈ ${I.toStringAsFixed(2)} A';
    sonucKablo =
        'Öneri kesit: ${secKesit.toStringAsFixed(1)} mm² (${malzeme.startsWith('Bakır') ? 'Cu' : 'Al'})'
        ' • Taşıma ~${tasima.toStringAsFixed(0)} A';
    sonucSigorta = 'Öneri sigorta: $egri $sig (yaklaşık)';
    sonucGerilimDusumu = dvText;

    uyari = ekstra.isEmpty
        ? 'Not: Değerler yaklaşık saha hesabıdır; döşeme şekli/ısı/grup kablo sonucu değiştirir.'
        : '⚠️ $ekstra';
    });
  }

  void _temizle() {
    powerCtrl.clear();
    currentCtrl.clear();
    lengthCtrl.clear();

    setState(() {
      faz = 'Tek Faz';
      gerilim = '230 V';
      girisTuru = 'Güç (kW)';
      malzeme = 'Bakır (Cu)';
      yukTipi = 'Genel (Priz)';
      cosPhi = 0.95;
      verim = 0.90;
      voltajDusumuAktif = false;
      _sifirlaSonuclar();
    });
  }

  @override
  void dispose() {
    powerCtrl.dispose();
    currentCtrl.dispose();
    lengthCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;

    // ✅ Faz’a göre sadece tek gerilim göster
    final gerilimItems = (faz == 'Tek Faz')
        ? const [DropdownMenuItem(value: '230 V', child: Text('230 V'))]
        : const [DropdownMenuItem(value: '400 V', child: Text('400 V'))];

    // (emin olmak için)
    if (faz == 'Tek Faz' && gerilim != '230 V') gerilim = '230 V';
    if (faz == 'Trifaze' && gerilim != '400 V') gerilim = '400 V';

    return Scaffold(
      appBar: AppBar(title: const Text('Kablo Kesiti + Sigorta')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Card(
            elevation: 0,
            color: surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Giriş', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: faz,
                          decoration: const InputDecoration(labelText: 'Faz', border: OutlineInputBorder()),
                          items: const [
                            DropdownMenuItem(value: 'Tek Faz', child: Text('Tek Faz')),
                            DropdownMenuItem(value: 'Trifaze', child: Text('Trifaze')),
                          ],
                          onChanged: (v) {
                            if (v == null) return;
                            _fazDegisti(v);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: gerilim,
                          decoration: const InputDecoration(labelText: 'Gerilim', border: OutlineInputBorder()),
                          items: gerilimItems,
                          onChanged: null, // ✅ kilitli (faz neyse o)
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    value: girisTuru,
                    decoration: const InputDecoration(labelText: 'Giriş türü', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'Güç (kW)', child: Text('Güç (kW)')),
                      DropdownMenuItem(value: 'Akım (A)', child: Text('Akım (A)')),
                    ],
                    onChanged: (v) => setState(() {
                      if (v == null) return;
                      girisTuru = v;
                      _sifirlaSonuclar();
                    }),
                  ),

                  const SizedBox(height: 10),

                  if (girisTuru.startsWith('Güç'))
                    TextField(
                      controller: powerCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                      decoration: const InputDecoration(
                        labelText: 'Güç (kW)',
                        hintText: 'Örn: 5,5 veya 5.5',
                        border: OutlineInputBorder(),
                      ),
                    )
                  else
                    TextField(
                      controller: currentCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                      decoration: const InputDecoration(
                        labelText: 'Akım (A)',
                        hintText: 'Örn: 18',
                        border: OutlineInputBorder(),
                      ),
                    ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: Text('Gerilim düşümü hesabı (ΔV)', style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Switch(
                        value: voltajDusumuAktif,
                        onChanged: (v) {
                          setState(() {
                            voltajDusumuAktif = v;
                            _sifirlaSonuclar();
                            if (!v) lengthCtrl.clear();
                          });
                        },
                      ),
                    ],
                  ),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: !voltajDusumuAktif
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextField(
                              controller: lengthCtrl,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                              decoration: const InputDecoration(
                                labelText: 'Hat uzunluğu (m)',
                                hintText: 'Örn: 25,5 veya 25.5',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: malzeme,
                    decoration: const InputDecoration(labelText: 'Kablo', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'Bakır (Cu)', child: Text('Bakır (Cu)')),
                      DropdownMenuItem(value: 'Alüminyum (Al)', child: Text('Alüminyum (Al)')),
                    ],
                    onChanged: (v) => setState(() {
                      if (v == null) return;
                      malzeme = v;
                      _sifirlaSonuclar();
                    }),
                  ),

                  const SizedBox(height: 12),

                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: const Text('Gelişmiş (Yük tipi, cosφ, verim)'),
                    children: [
                      const SizedBox(height: 8),

                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: yukTipi,
                        decoration: const InputDecoration(labelText: 'Yük tipi (isteğe bağlı)', border: OutlineInputBorder()),
                        items: const [
                          DropdownMenuItem(value: 'Genel (Priz)', child: Text('Genel (Priz)')),
                          DropdownMenuItem(value: 'Aydınlatma', child: Text('Aydınlatma')),
                          DropdownMenuItem(value: 'Motor', child: Text('Motor')),
                        ],
                        onChanged: (v) => setState(() {
                          if (v == null) return;
                          yukTipi = v;
                          _sifirlaSonuclar();
                        }),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                              decoration: InputDecoration(
                                labelText: 'cosφ',
                                hintText: 'Örn: ${cosPhi.toStringAsFixed(2)}',
                                border: const OutlineInputBorder(),
                              ),
                              onChanged: (v) {
                                final x = _parseNum(v);
                                if (!x.isNaN && x > 0 && x <= 1) setState(() => cosPhi = x);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                              decoration: InputDecoration(
                                labelText: 'Verim (η)',
                                hintText: 'Örn: ${verim.toStringAsFixed(2)}',
                                border: const OutlineInputBorder(),
                              ),
                              onChanged: (v) {
                                final x = _parseNum(v);
                                if (!x.isNaN && x > 0 && x <= 1) setState(() => verim = x);
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Not: Bu bölüm isteğe bağlıdır.\n'
                        '- Yük tipi: sigorta eğrisi (B/C/D) ve ΔV hedefini etkiler.\n'
                        '- cosφ ve verim girmezsen varsayılan cosφ=0.95, η=0.90 alınır.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _hesapla,
                          icon: const Icon(Icons.calculate),
                          label: const Text('Hesapla'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _temizle,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Temizle'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (sonucKablo != null || sonucSigorta != null) ...[
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              color: surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sonuç', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    if (sonucAkim != null) _line(Icons.electric_bolt, sonucAkim!),
                    if (sonucKablo != null) _line(Icons.cable, sonucKablo!),
                    if (sonucSigorta != null) _line(Icons.shield, sonucSigorta!),
                    if (sonucGerilimDusumu != null) _line(Icons.trending_down, sonucGerilimDusumu!),
                    if (uyari != null) ...[
                      const SizedBox(height: 10),
                      Text(uyari!, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _line(IconData icon, String t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(t)),
        ],
      ),
    );
  }
}
