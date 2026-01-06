import 'package:flutter/material.dart';

class Direnc6BantSayfasi extends StatefulWidget {
  const Direnc6BantSayfasi({super.key});

  @override
  State<Direnc6BantSayfasi> createState() => _Direnc6BantSayfasiState();
}

class _Direnc6BantSayfasiState extends State<Direnc6BantSayfasi> {
  // 5/6 bant: 1-2-3 (rakam) + çarpan + tolerans (+ tempco opsiyonel)
  static const digitColors = [
    'Siyah',
    'Kahverengi',
    'Kırmızı',
    'Turuncu',
    'Sarı',
    'Yeşil',
    'Mavi',
    'Mor',
    'Gri',
    'Beyaz'
  ];

  static const multiplierMap = <String, double>{
    'Siyah': 1,
    'Kahverengi': 10,
    'Kırmızı': 100,
    'Turuncu': 1e3,
    'Sarı': 10e3,
    'Yeşil': 100e3,
    'Mavi': 1e6,
    'Mor': 10e6,
    'Gri': 100e6,
    'Beyaz': 1e9,
    'Altın': 0.1,
    'Gümüş': 0.01,
  };

  static const toleranceMap = <String, double>{
    'Kahverengi': 1.0,
    'Kırmızı': 2.0,
    'Yeşil': 0.5,
    'Mavi': 0.25,
    'Mor': 0.1,
    'Gri': 0.05,
    'Altın': 5.0,
    'Gümüş': 10.0,
  };

  // 6. bant (TempCo / ppm/°C)
  static const tempcoMap = <String, int>{
    'Kahverengi': 100,
    'Kırmızı': 50,
    'Turuncu': 15,
    'Sarı': 25,
    'Mavi': 10,
    'Mor': 5,
  };

  // ✅ Mod: 5 veya 6 bant
  int bantModu = 6;

  // Seçimler
  String b1 = 'Kahverengi'; // 1. rakam (siyah olamaz)
  String b2 = 'Siyah'; // 2. rakam
  String b3 = 'Siyah'; // 3. rakam
  String mul = 'Kırmızı'; // çarpan
  String tol = 'Altın'; // tolerans
  String tc = 'Kahverengi'; // tempco (sadece 6 bantta)

  // ✅ Kurumsal sonuç için parçalara ayırıyoruz
  double? _rNominal; // ohm
  double? _tolPct; // %
  int? _tempco; // ppm/°C (6 bant)

  int _digit(String c) => digitColors.indexOf(c);

  String _formatOhm(double r) {
    if (r >= 1e9) return '${(r / 1e9).toStringAsFixed(3)} GΩ';
    if (r >= 1e6) return '${(r / 1e6).toStringAsFixed(3)} MΩ';
    if (r >= 1e3) return '${(r / 1e3).toStringAsFixed(3)} kΩ';
    return '${r.toStringAsFixed(3)} Ω';
  }

  void _hesapla() {
    final d1 = _digit(b1);
    final d2 = _digit(b2);
    final d3 = _digit(b3);

    final m = multiplierMap[mul] ?? 1;
    final t = toleranceMap[tol] ?? 5.0;

    final temel = (d1 * 100 + d2 * 10 + d3) * m;

    setState(() {
      _rNominal = temel.toDouble();
      _tolPct = t;
      _tempco = (bantModu == 6) ? (tempcoMap[tc] ?? 100) : null;
    });
  }

  void _reset() {
    setState(() {
      bantModu = 6;
      b1 = 'Kahverengi';
      b2 = 'Siyah';
      b3 = 'Siyah';
      mul = 'Kırmızı';
      tol = 'Altın';
      tc = 'Kahverengi';
      _rNominal = null;
      _tolPct = null;
      _tempco = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;

    return Scaffold(
      appBar: AppBar(
        title: Text('Direnç Hesaplama (${bantModu} Bant)'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          // ✅ Üst resim
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/direnc6.png',
              height: 180,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                alignment: Alignment.center,
                color: surface,
                child: const Text('Resim bulunamadı: assets/images/direnc6.png'),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ✅ 5/6 Bant seçimi
          Card(
            elevation: 0,
            color: surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Text('Mod:', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(width: 12),
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 5, label: Text('5 Bant')),
                      ButtonSegment(value: 6, label: Text('6 Bant')),
                    ],
                    selected: {bantModu},
                    onSelectionChanged: (s) {
                      setState(() {
                        bantModu = s.first;
                        // mod değişince sonucu temizle
                        _rNominal = null;
                        _tolPct = null;
                        _tempco = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          Card(
            elevation: 0,
            color: surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${bantModu} Bant Seçimi',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),

                  _dropRow(
                    '1. Bant (1. Rakam)',
                    b1,
                    digitColors.where((r) => r != 'Siyah').toList(),
                        (v) => setState(() => b1 = v!),
                  ),
                  _dropRow(
                    '2. Bant (2. Rakam)',
                    b2,
                    digitColors,
                        (v) => setState(() => b2 = v!),
                  ),
                  _dropRow(
                    '3. Bant (3. Rakam)',
                    b3,
                    digitColors,
                        (v) => setState(() => b3 = v!),
                  ),
                  _dropRow(
                    '4. Bant (Çarpan)',
                    mul,
                    multiplierMap.keys.toList(),
                        (v) => setState(() => mul = v!),
                  ),
                  _dropRow(
                    '5. Bant (Tolerans)',
                    tol,
                    toleranceMap.keys.toList(),
                        (v) => setState(() => tol = v!),
                  ),

                  // ✅ 6. bant sadece 6 modda gözüksün
                  if (bantModu == 6)
                    _dropRow(
                      '6. Bant (TempCo)',
                      tc,
                      tempcoMap.keys.toList(),
                          (v) => setState(() => tc = v!),
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
                      OutlinedButton.icon(
                        onPressed: _reset,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Sıfırla'),
                      ),
                    ],
                  ),

                  // ✅ Kurumsal sonuç kartı
                  if (_rNominal != null && _tolPct != null) ...[
                    const SizedBox(height: 12),
                    _SonucKarti(
                      rNominal: _rNominal!,
                      tolPct: _tolPct!,
                      tempco: _tempco,
                      formatOhm: _formatOhm,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropRow(
      String label,
      String value,
      List<String> items,
      ValueChanged<String?> onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 12),
          DropdownButton<String>(
            value: value,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SonucKarti extends StatelessWidget {
  const _SonucKarti({
    required this.rNominal,
    required this.tolPct,
    required this.tempco,
    required this.formatOhm,
  });

  final double rNominal;
  final double tolPct;
  final int? tempco;
  final String Function(double) formatOhm;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final minR = rNominal * (1 - tolPct / 100);
    final maxR = rNominal * (1 + tolPct / 100);

    return Card(
      elevation: 0,
      color: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified, color: cs.primary),
                const SizedBox(width: 8),
                const Text(
                  'Sonuç',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Nominal',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _InfoRow(
              label: 'Direnç',
              value: formatOhm(rNominal),
              icon: Icons.speed,
            ),
            const SizedBox(height: 8),

            _InfoRow(
              label: 'Tolerans',
              value: '±${tolPct.toStringAsFixed(2)}%',
              icon: Icons.tune,
            ),

            const SizedBox(height: 10),
            Divider(height: 1, color: cs.outlineVariant.withOpacity(0.6)),
            const SizedBox(height: 10),

            _InfoRow(
              label: 'Aralık',
              value: '${formatOhm(minR)}  –  ${formatOhm(maxR)}',
              icon: Icons.swap_horiz,
              valueStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),

            if (tempco != null) ...[
              const SizedBox(height: 10),
              Divider(height: 1, color: cs.outlineVariant.withOpacity(0.6)),
              const SizedBox(height: 10),
              _InfoRow(
                label: 'TempCo',
                value: '$tempco ppm/°C',
                icon: Icons.thermostat,
              ),
            ],

            const SizedBox(height: 6),
            Text(
              'Not: Aralık, tolerans yüzdesine göre min–max değerleri gösterir.',
              style: TextStyle(
                fontSize: 12,
                color: cs.onSurface.withOpacity(0.65),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueStyle,
  });

  final String label;
  final String value;
  final IconData icon;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: cs.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: cs.onSurface.withOpacity(0.75),
            ),
          ),
        ),
        Text(
          value,
          style: valueStyle ??
              const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
        ),
      ],
    );
  }
}
