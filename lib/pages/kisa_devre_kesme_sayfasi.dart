// lib/pages/kisa_devre_kesme_sayfasi.dart
import 'package:flutter/material.dart';

class KisaDevreKesmeSayfasi extends StatefulWidget {
  const KisaDevreKesmeSayfasi({super.key});

  @override
  State<KisaDevreKesmeSayfasi> createState() => _KisaDevreKesmeSayfasiState();
}

class _KisaDevreKesmeSayfasiState extends State<KisaDevreKesmeSayfasi> {
  final _formKey = GlobalKey<FormState>();

  // Kullanıcı direkt ölçülen/hesaplanan "prospektif kısa devre akımı"nı girsin:
  final _ikKa = TextEditingController(text: '6'); // kA

  // İsteğe bağlı: güvenlik payı (%)
  final _marginPct = TextEditingController(text: '20'); // %

  // Cihaz tipi/standart seçimi (etiket amaçlı)
  String _deviceType = 'MCB (Otomat)'; // MCB / MCCB / ACB
  String _standard = 'IEC 60898 (Icn)'; // 60898 / 60947 (Icu/Ics)

  String? _sonuc;
  String? _uyari;

  @override
  void dispose() {
    _ikKa.dispose();
    _marginPct.dispose();
    super.dispose();
  }

  double _toDouble(String s) {
    // "6,5" gibi girişleri de kabul et
    return double.tryParse(s.trim().replaceAll(',', '.')) ?? 0.0;
  }

  double _clamp(double v, double min, double max) {
    if (v < min) return min;
    if (v > max) return max;
    return v;
  }

  // Standart kesme kapasitesi basamakları (kA)
  // (Uygulamada mühendis/tekniker için pratik seçim: en yakın üst standart)
  static const List<double> _stdKa = [
    1.5,
    3,
    4.5,
    6,
    10,
    15,
    20,
    25,
    36,
    50,
    70,
    100,
  ];

  double _nextStandard(double requiredKa) {
    for (final s in _stdKa) {
      if (requiredKa <= s) return s;
    }
    return _stdKa.last;
  }

  void _calc() {
    FocusScope.of(context).unfocus();

    final ik = _toDouble(_ikKa.text);
    final margin = _toDouble(_marginPct.text);

    if (ik <= 0) {
      setState(() {
        _sonuc = null;
        _uyari = 'Ik (kA) 0’dan büyük olmalı.';
      });
      return;
    }

    final marginClamped = _clamp(margin, 0, 200);
    final required = ik * (1 + marginClamped / 100.0);
    final rec = _nextStandard(required);

    // Açıklama: 60947’de MCCB/ACB için Icu/Ics; 60898’de MCB için Icn
    final stdNote = _standard.contains('60947')
        ? 'Not: 60947 için genelde Icu (nihai kesme) ve Ics (servis kesme) birlikte değerlendirilir.'
        : 'Not: 60898 için MCB üzerinde Icn (kA) değeri yazar.';

    String verdict;
    if (rec < 4.5) {
      verdict =
          'Çok düşük seviyeler (1.5–3kA) genelde uzak nokta/uzun hatlarda çıkar. Yine de saha ölçüm/hesabı önemli.';
    } else if (rec <= 10) {
      verdict = 'Konut/kat panolarında sık görülen aralık (4.5–10kA).';
    } else if (rec <= 25) {
      verdict = 'Tali dağıtım / trafoya daha yakın noktalarda görülebilir (10–25kA).';
    } else {
      verdict = 'Ana dağıtım / trafo çıkışına yakın noktalarda yüksek Ik olabilir (25kA+).';
    }

    setState(() {
      _uyari = null;
      _sonuc = [
        'Girilen prospektif Ik:  ${ik.toStringAsFixed(2)} kA',
        'Güvenlik payı:        %${marginClamped.toStringAsFixed(0)}',
        'Tasarıma esas Ik:     ${required.toStringAsFixed(2)} kA',
        '',
        'Önerilen minimum kesme kapasitesi:',
        '➡️  ${rec.toStringAsFixed(rec % 1 == 0 ? 0 : 1)} kA  ($_deviceType • $_standard)',
        '',
        verdict,
        stdNote,
        '',
        'Kural (pratik): Cihazın kesme kapasitesi (Icn/Icu), bulunduğu noktadaki prospektif kısa devre akımından büyük/eşit seçilir.',
      ].join('\n');
    });
  }

  void _reset() {
    FocusScope.of(context).unfocus();
    setState(() {
      _ikKa.text = '6';
      _marginPct.text = '20';
      _deviceType = 'MCB (Otomat)';
      _standard = 'IEC 60898 (Icn)';
      _sonuc = null;
      _uyari = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kısa Devre Kesme Kapasitesi'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Card(
            elevation: 0,
            color: theme.cardColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bu hesap, bulunduğun noktadaki prospektif kısa devre akımı (Ik) değerine göre\n'
                    'kesme kapasitesi (kA) seçimini pratikleştirir.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  _InfoChipRow(
                    items: const [
                      'Icn / Icu seçimi',
                      'Standart basamaklar',
                      'Güvenlik payı',
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          Form(
            key: _formKey,
            child: Card(
              elevation: 0,
              color: theme.cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _ikKa,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Prospektif kısa devre akımı Ik',
                        suffixText: 'kA',
                        hintText: 'Örn: 6 veya 10',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        final d = _toDouble(v ?? '');
                        if (d <= 0) return 'Ik (kA) 0’dan büyük olmalı';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _marginPct,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Güvenlik payı (opsiyonel)',
                        suffixText: '%',
                        hintText: 'Örn: 20',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: _deviceType,
                      decoration: const InputDecoration(
                        labelText: 'Cihaz tipi',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'MCB (Otomat)', child: Text('MCB (Otomat)')),
                        DropdownMenuItem(value: 'MCCB (Kompakt Şalter)', child: Text('MCCB (Kompakt Şalter)')),
                        DropdownMenuItem(value: 'ACB (Açık Tip Şalter)', child: Text('ACB (Açık Tip Şalter)')),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          _deviceType = v;
                          // Tip değişince standart önerisi:
                          if (v.startsWith('MCB')) {
                            _standard = 'IEC 60898 (Icn)';
                          } else {
                            _standard = 'IEC 60947 (Icu/Ics)';
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: _standard,
                      decoration: const InputDecoration(
                        labelText: 'Standart / ifade',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'IEC 60898 (Icn)', child: Text('IEC 60898 (Icn) — MCB')),
                        DropdownMenuItem(value: 'IEC 60947 (Icu/Ics)', child: Text('IEC 60947 (Icu/Ics) — MCCB/ACB')),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _standard = v);
                      },
                    ),

                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _calc();
                              }
                            },
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

                    if (_uyari != null) ...[
                      const SizedBox(height: 12),
                      _WarnBox(text: _uyari!),
                    ],
                  ],
                ),
              ),
            ),
          ),

          if (_sonuc != null) ...[
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              color: theme.cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  _sonuc!,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: theme.cardColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sahada pratik ipuçları', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const Text(
                    '• Ik değeri; trafo gücü/empedansı, kablo uzunluğu-kesiti, pano konumu gibi faktörlere göre değişir.\n'
                    '• Trafoya yakın noktada MCB yerine MCCB/ACB gerekebilir.\n'
                    '• Kesme kapasitesi yetmezse arıza anında cihaz “kesemez”, tehlikeli arka ark oluşabilir.\n'
                    '• En sağlam yöntem: kısa devre hesabı (IEC 60909) veya saha ölçümü + uygun standart seçimidir.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarnBox extends StatelessWidget {
  final String text;
  const _WarnBox({required this.text});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.colorScheme.errorContainer.withOpacity(0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.colorScheme.error.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: c.colorScheme.error),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _InfoChipRow extends StatelessWidget {
  final List<String> items;
  const _InfoChipRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (t) => Chip(
              label: Text(t),
              visualDensity: VisualDensity.compact,
            ),
          )
          .toList(),
    );
  }
}
