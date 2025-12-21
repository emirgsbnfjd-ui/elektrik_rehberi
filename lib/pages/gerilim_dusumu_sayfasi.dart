import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GerilimDusumuSayfasi extends StatefulWidget {
  const GerilimDusumuSayfasi({super.key});

  @override
  State<GerilimDusumuSayfasi> createState() => _GerilimDusumuSayfasiState();
}

class _GerilimDusumuSayfasiState extends State<GerilimDusumuSayfasi> {
  // Girişler
  final _lCtrl = TextEditingController(text: '30');    // m (tek yön)
  final _iCtrl = TextEditingController(text: '16');    // A
  final _sCtrl = TextEditingController(text: '2,5');   // mm²

  // İsteğe bağlı alanlar
  final _cosCtrl = TextEditingController(text: '0,95');
  final _vllCtrl = TextEditingController(text: '400'); // trifaze için V(üçgen)

  bool _isThreePhase = false; // Tek faz / Trifaze
  bool _isAluminum = false;   // Bakır / Alüminyum (isteğe bağlı)
  bool _useCos = false;       // cosφ kullan (isteğe bağlı)
  bool _useVll = false;       // Üçgen V kullan (isteğe bağlı)

  // Sonuçlar
  double? _deltaV;    // Volt düşüm
  double? _percent;   // yüzde düşüm
  String? _status;    // uygun/sınırda/riskli

  // 1) Her telefonda virgül/nokta uyumu
  double? _p(String s) {
    final t = s.trim().replaceAll(' ', '').replaceAll(',', '.');
    return double.tryParse(t);
  }

  // 2) Sadece sayı + virgül/nokta izin ver (klavye farklarını minimize eder)
  final _numFmt = FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'));

  void _hesapla() {
    final L = _p(_lCtrl.text); // m
    final I = _p(_iCtrl.text); // A
    final S = _p(_sCtrl.text); // mm²

    if (L == null || I == null || S == null || S <= 0 || L <= 0 || I <= 0) {
      setState(() {
        _deltaV = null;
        _percent = null;
        _status = 'Lütfen L, I, S değerlerini doğru gir.';
      });
      return;
    }

    // Direnç katsayısı (Ω·mm²/m) yaklaşık:
    // Cu: 0.018, Al: 0.028 (yaklaşık)
    final rho = _isAluminum ? 0.028 : 0.018;

    // cosφ isteğe bağlı
    double cosPhi = 1.0;
    if (_useCos) {
      final c = _p(_cosCtrl.text);
      if (c == null || c <= 0 || c > 1) {
        setState(() => _status = 'cosφ 0-1 arası olmalı.');
        return;
      }
      cosPhi = c;
    }

    // Gerilim referansı (yüzde için)
    // Tek faz varsayılan 230V; trifaze varsayılan 400V (üçgen)
    double vRef = _isThreePhase ? 400.0 : 230.0;

    // Üçgen V isteğe bağlı (trifaze için)
    if (_isThreePhase && _useVll) {
      final vll = _p(_vllCtrl.text);
      if (vll == null || vll <= 0) {
        setState(() => _status = 'Üçgen V değerini doğru gir.');
        return;
      }
      vRef = vll;
    }

    // Formül (pratik):
    // Tek faz: ΔV = 2 * I * L * ρ / S * cosφ
    // Trifaze: ΔV = √3 * I * L * ρ / S * cosφ
    // Not: cosφ isteğe bağlı, kapalıysa 1 kabul.
    final k = _isThreePhase ? math.sqrt(3) : 2.0;
    final deltaV = k * I * L * rho / S * cosPhi;

    final percent = (deltaV / vRef) * 100.0;

    // Durum etiketi (basit, anlaşılır)
    // Aydınlatma genelde ≤3%, priz/diğer ≤5% pratik kabul edilir.
    String status;
    if (percent <= 3.0) status = '✅ Uygun (≤ 3%)';
    else if (percent <= 5.0) status = '🟡 Sınırda (3–5%)';
    else status = '⚠️ Riskli (> 5%)';

    setState(() {
      _deltaV = deltaV;
      _percent = percent;
      _status = status;
    });
  }

  @override
  void dispose() {
    _lCtrl.dispose();
    _iCtrl.dispose();
    _sCtrl.dispose();
    _cosCtrl.dispose();
    _vllCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasResult = _deltaV != null && _percent != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Gerilim Düşümü')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          // Üst kart: seçimler
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Seçimler', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),

                  // Tek faz / trifaze
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment(value: false, label: Text('Tek Faz')),
                            ButtonSegment(value: true, label: Text('Trifaze')),
                          ],
                          selected: {_isThreePhase},
                          onSelectionChanged: (s) {
                            setState(() {
                              _isThreePhase = s.first;
                              // trifaze değilse üçgen V opsiyonunu kapat
                              if (!_isThreePhase) _useVll = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Bakır / Alüminyum (isteğe bağlı)
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment(value: false, label: Text('Bakır (Cu)')),
                            ButtonSegment(value: true, label: Text('Alüminyum (Al)')),
                          ],
                          selected: {_isAluminum},
                          onSelectionChanged: (s) {
                            setState(() => _isAluminum = s.first);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),
                  Text(
                    'Not: Değerler yaklaşık ρ ile hesaplanır (Cu≈0.018, Al≈0.028).',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Girişler kartı
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Giriş Değerleri', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),

                  TextField(
                    controller: _lCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [_numFmt],
                    decoration: const InputDecoration(
                      labelText: 'Hat uzunluğu (m) — tek yön',
                      hintText: 'Örn: 30',
                      suffixText: 'm',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: _iCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [_numFmt],
                    decoration: const InputDecoration(
                      labelText: 'Akım (A)',
                      hintText: 'Örn: 16',
                      suffixText: 'A',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: _sCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [_numFmt],
                    decoration: const InputDecoration(
                      labelText: 'Kablo kesiti (mm²)',
                      hintText: 'Örn: 2,5',
                      suffixText: 'mm²',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // cosφ isteğe bağlı
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('cosφ kullan (isteğe bağlı)'),
                    subtitle: const Text('Kapalıysa cosφ=1 kabul edilir.'),
                    value: _useCos,
                    onChanged: (v) => setState(() => _useCos = v),
                  ),
                  if (_useCos) ...[
                    const SizedBox(height: 6),
                    TextField(
                      controller: _cosCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [_numFmt],
                      decoration: const InputDecoration(
                        labelText: 'cosφ',
                        hintText: 'Örn: 0,95',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),

                  // Üçgen V (trifaze için) isteğe bağlı
                  if (_isThreePhase) ...[
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Üçgen V (hatlar arası) kullan'),
                      subtitle: const Text('Kapalıysa 400V kabul edilir.'),
                      value: _useVll,
                      onChanged: (v) => setState(() => _useVll = v),
                    ),
                    if (_useVll) ...[
                      const SizedBox(height: 6),
                      TextField(
                        controller: _vllCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [_numFmt],
                        decoration: const InputDecoration(
                          labelText: 'Üçgen V (VLL)',
                          hintText: 'Örn: 400',
                          suffixText: 'V',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ],

                  const SizedBox(height: 12),

                  FilledButton.icon(
                    onPressed: _hesapla,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Hesapla'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Sonuçlar
          if (_status != null) ...[
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sonuç', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text(_status!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    if (hasResult) ...[
                      const SizedBox(height: 10),
                      _kv('ΔV (Volt düşüm)', '${_deltaV!.toStringAsFixed(2)} V'),
                      _kv('Düşüm yüzdesi', '${_percent!.toStringAsFixed(2)} %'),
                      _kv('Faz', _isThreePhase ? 'Trifaze' : 'Tek Faz'),
                      _kv('İletken', _isAluminum ? 'Alüminyum (Al)' : 'Bakır (Cu)'),
                    ],
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Şema
          if (hasResult) ...[
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Şema', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 160,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: _VoltageDropPainter(
                          isThreePhase: _isThreePhase,
                          deltaV: _deltaV!,
                          percent: _percent!,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kaynak → Kablo → Yük',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600))),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _VoltageDropPainter extends CustomPainter {
  final bool isThreePhase;
  final double deltaV;
  final double percent;

  _VoltageDropPainter({
    required this.isThreePhase,
    required this.deltaV,
    required this.percent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Şema koordinatları
    final left = Offset(20, size.height / 2);
    final right = Offset(size.width - 20, size.height / 2);
    final mid1 = Offset(size.width * 0.35, size.height / 2);
    final mid2 = Offset(size.width * 0.65, size.height / 2);

    // Renkleri tema belirtmeden default bırakıyoruz, ama stroke görünür olsun:
    p.color = Colors.grey.shade700;

    // Kaynak kutusu
    final srcRect = Rect.fromCenter(center: left, width: 90, height: 60);
    canvas.drawRRect(RRect.fromRectAndRadius(srcRect, const Radius.circular(12)), p);

    // Yük kutusu
    final loadRect = Rect.fromCenter(center: right, width: 90, height: 60);
    canvas.drawRRect(RRect.fromRectAndRadius(loadRect, const Radius.circular(12)), p);

    // Hat
    canvas.drawLine(Offset(srcRect.right, left.dy), Offset(loadRect.left, right.dy), p);

    // Kablo üzerinde küçük “direnç” kırığı
    final zigY = left.dy;
    final startX = mid1.dx;
    final endX = mid2.dx;
    final step = (endX - startX) / 6;

    final path = Path()..moveTo(startX, zigY);
    for (int i = 1; i <= 6; i++) {
      final x = startX + step * i;
      final y = zigY + ((i.isOdd) ? -10 : 10);
      path.lineTo(x, y);
    }
    canvas.drawPath(path, p);

    // Etiketler
    _drawText(canvas, textPainter, 'Kaynak', srcRect.center + const Offset(0, -6));
    _drawText(canvas, textPainter, isThreePhase ? '3~' : '1~', srcRect.center + const Offset(0, 14));

    _drawText(canvas, textPainter, 'Yük', loadRect.center + const Offset(0, -6));
    _drawText(canvas, textPainter, 'ΔV ${deltaV.toStringAsFixed(2)}V', Offset(size.width / 2, zigY - 42));
    _drawText(canvas, textPainter, '% ${percent.toStringAsFixed(2)}', Offset(size.width / 2, zigY + 38));
  }

  void _drawText(Canvas canvas, TextPainter tp, String text, Offset center) {
    tp.text = TextSpan(
      text: text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
    );
    tp.layout();
    final pos = Offset(center.dx - tp.width / 2, center.dy - tp.height / 2);
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant _VoltageDropPainter oldDelegate) {
    return oldDelegate.isThreePhase != isThreePhase ||
        oldDelegate.deltaV != deltaV ||
        oldDelegate.percent != percent;
  }
}
