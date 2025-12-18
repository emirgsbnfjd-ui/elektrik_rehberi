import 'package:flutter/material.dart';
import 'dart:math';

class KompanzasyonSayfasi extends StatefulWidget {
  const KompanzasyonSayfasi({super.key});

  @override
  State<KompanzasyonSayfasi> createState() => _KompanzasyonSayfasiState();
}

class _KompanzasyonSayfasiState extends State<KompanzasyonSayfasi> {
  final _kw = TextEditingController();
  final _cos1 = TextEditingController(text: '0.7');
  final _cos2 = TextEditingController(text: '0.95');
  final _volt = TextEditingController(text: '400'); // 3 faz varsayılan

  double kvar = 0;

  // detaylar
  double phi1Deg = 0, phi2Deg = 0;
  double tan1 = 0, tan2 = 0;
  double iCapA = 0;
  double kvarYuvarlanmis = 0;

  String kademeOneri = '-';

  double _clampCos(double x) => x.clamp(0.01, 0.9999);

  double _ceilToStandardKvar(double q) {
    // yaygın kVAr adımları (isteğe göre genişletebilirsin)
    const List<double> std = [
      2.5, 5.0, 7.5, 10.0, 12.5, 15.0,
      20.0, 25.0, 30.0, 40.0, 50.0,
      60.0, 75.0, 100.0
    ];
    for (final s in std) {
      if (q <= s) return s;
    }
    // daha büyükse 10'ar yuvarla
    return (q / 10).ceil() * 10.0;
  }

  String _kademeKombinasyonu(double q) {
    // basit, anlaşılır kombin önerileri
    // (hesaplanan değerin yuvarlanmış haline göre)
    if (q <= 5) return '5 kVAr (tek kademe)';
    if (q <= 7.5) return '7.5 kVAr (tek kademe) veya 5+2.5';
    if (q <= 10) return '10 kVAr (tek kademe) veya 5+5';
    if (q <= 15) return '5 + 10 = 15 kVAr';
    if (q <= 20) return '5 + 5 + 10 = 20 kVAr';
    if (q <= 25) return '5 + 10 + 10 = 25 kVAr';
    if (q <= 30) return '5 + 5 + 10 + 10 = 30 kVAr';
    if (q <= 40) return '10 + 10 + 10 + 10 = 40 kVAr';
    if (q <= 50) return '10 + 10 + 10 + 20 = 50 kVAr';
    return 'Kademeli (ör. 10/12.5/15/20 gibi) seçmek daha iyi olur.';
  }

  void hesapla() {
    final p = double.tryParse(_kw.text.replaceAll(',', '.')) ?? 0;
    var c1 = double.tryParse(_cos1.text.replaceAll(',', '.')) ?? 0.7;
    var c2 = double.tryParse(_cos2.text.replaceAll(',', '.')) ?? 0.95;
    final v = double.tryParse(_volt.text.replaceAll(',', '.')) ?? 400;

    c1 = _clampCos(c1);
    c2 = _clampCos(c2);

    // φ ve tan
    final phi1 = acos(c1);
    final phi2 = acos(c2);

    final t1 = tan(phi1);
    final t2 = tan(phi2);

    final q = p * (t1 - t2); // kVAr (çünkü P kW ve tan boyutsuz)

    // 3 faz kapasitör akımı yaklaşık (kVAr -> VAr)
    final i = (q.abs() * 1000) / (sqrt(3) * v);

    final qRound = _ceilToStandardKvar(q.abs());
    final komb = _kademeKombinasyonu(qRound);

    setState(() {
      kvar = q;
      phi1Deg = phi1 * 180 / pi;
      phi2Deg = phi2 * 180 / pi;
      tan1 = t1;
      tan2 = t2;
      iCapA = i;
      kvarYuvarlanmis = qRound;
      kademeOneri = komb;
    });
  }

  @override
  void dispose() {
    _kw.dispose();
    _cos1.dispose();
    _cos2.dispose();
    _volt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Kompanzasyon Hesabı')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _kw,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Aktif Güç P (kW)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cos1,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Mevcut cosφ (örn 0.70)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cos2,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Hedef cosφ (örn 0.95)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _volt,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Hat Gerilimi (V) (3 faz) (örn 400)'),
            ),

            const SizedBox(height: 16),
            ElevatedButton(onPressed: hesapla, child: const Text('Hesapla')),
            const SizedBox(height: 16),

            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sonuç',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text('Gerekli Reaktif Güç (Q): ${kvar.abs().toStringAsFixed(2)} kVAr'),
                    const SizedBox(height: 6),
                    Text('Pratik seçim (yuvarlanmış): ${kvarYuvarlanmis.toStringAsFixed(1)} kVAr'),
                    const SizedBox(height: 6),
                    Text('Kondansatör akımı (yaklaşık): ${iCapA.toStringAsFixed(1)} A (3 faz)'),
                    const SizedBox(height: 10),
                    Text('Kademe önerisi: $kademeOneri'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ✅ Detay / rehber alanı
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    ExpansionTile(
                      title: const Text("Hesap Detayı (Formül)"),
                      childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      children: [
                        Text(
                          "Q(kVAr) = P(kW) × (tanφ₁ − tanφ₂)\n"
                          "φ₁ = arccos(mevcut cosφ)\n"
                          "φ₂ = arccos(hedef cosφ)\n\n"
                          "φ₁ = ${phi1Deg.toStringAsFixed(1)}°   tanφ₁ = ${tan1.toStringAsFixed(3)}\n"
                          "φ₂ = ${phi2Deg.toStringAsFixed(1)}°   tanφ₂ = ${tan2.toStringAsFixed(3)}\n",
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text("Kompanzasyon Panosunda Neler Olur?"),
                      childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      children: const [
                        Text(
                          "• Kompanzasyon rölesi\n"
                          "• Akım trafosu (CT)\n"
                          "• Kondansatör kademeleri\n"
                          "• Kondansatör kontaktörü (özel tip)\n"
                          "• Sigorta / MCCB (koruma)\n"
                          "• Deşarj dirençleri (kondansatörde şart)\n"
                          "• (Harmonik varsa) Reaktör/filtre (detuned)\n\n"
                          "Termik röle genelde motor koruması içindir; kompanzasyonda standart değildir.",
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text("Harmonik Uyarısı (Önemli)"),
                      childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      children: const [
                        Text(
                          "Tesiste inverter/VFD, UPS, LED sürücü, kaynak makineleri fazlaysa harmonikler artar.\n"
                          "Bu durumda reaktörlü (detuned) kompanzasyon tercih edilir.\n"
                          "Aksi halde kondansatör ısınma/şişme, sigorta atma gibi sorunlar görülebilir.",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
