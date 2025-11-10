import 'package:flutter/material.dart';

class HesaplayiciSayfasi extends StatefulWidget {
  const HesaplayiciSayfasi({super.key});

  @override
  State<HesaplayiciSayfasi> createState() => _HesaplayiciSayfasiState();
}

class _HesaplayiciSayfasiState extends State<HesaplayiciSayfasi> {
  final TextEditingController vCtrl = TextEditingController(); // Volt
  final TextEditingController iCtrl = TextEditingController(); // Amper
  final TextEditingController rCtrl = TextEditingController(); // Ohm

  String secim = 'I (Akım)'; // Hesaplanacak büyüklük
  String? sonuc;             // Ekranda gösterilecek sonuç

  @override
  void dispose() {
    vCtrl.dispose();
    iCtrl.dispose();
    rCtrl.dispose();
    super.dispose();
  }

  void temizle() {
    vCtrl.clear();
    iCtrl.clear();
    rCtrl.clear();
    setState(() => sonuc = null);
  }

  void hesapla() {
    double? V = double.tryParse(vCtrl.text.replaceAll(',', '.'));
    double? I = double.tryParse(iCtrl.text.replaceAll(',', '.'));
    double? R = double.tryParse(rCtrl.text.replaceAll(',', '.'));

    String hata(String m) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
      return m;
    }

    switch (secim) {
      case 'I (Akım)': // I = V / R
        if (V == null || R == null) { setState(() => sonuc = hata('Lütfen V (Volt) ve R (Ohm) gir.')); return; }
        if (R == 0) { setState(() => sonuc = hata('R sıfır olamaz.')); return; }
        final i = V / R;
        setState(() => sonuc = 'I = ${i.toStringAsFixed(3)} A');
        break;

      case 'V (Gerilim)': // V = I * R
        if (I == null || R == null) { setState(() => sonuc = hata('Lütfen I (Amper) ve R (Ohm) gir.')); return; }
        final v = I * R;
        setState(() => sonuc = 'V = ${v.toStringAsFixed(3)} V');
        break;

      case 'R (Direnç)': // R = V / I
        if (V == null || I == null) { setState(() => sonuc = hata('Lütfen V (Volt) ve I (Amper) gir.')); return; }
        if (I == 0) { setState(() => sonuc = hata('I sıfır olamaz.')); return; }
        final r = V / I;
        setState(() => sonuc = 'R = ${r.toStringAsFixed(3)} Ω');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hesaplananI = secim == 'I (Akım)';
    final hesaplananV = secim == 'V (Gerilim)';
    final hesaplananR = secim == 'R (Direnç)';

    return Scaffold(
      appBar: AppBar(title: const Text('Ohm Kanunu Hesaplayıcı')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const Text('Hesapla: ', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: secim,
                items: const [
                  DropdownMenuItem(value: 'I (Akım)', child: Text('I (Akım)')),
                  DropdownMenuItem(value: 'V (Gerilim)', child: Text('V (Gerilim)')),
                  DropdownMenuItem(value: 'R (Direnç)', child: Text('R (Direnç)')),
                ],
                onChanged: (val) { setState(() { secim = val!; sonuc = null; }); },
              ),
            ],
          ),
          const SizedBox(height: 12),

          TextField(
            controller: vCtrl,
            keyboardType: TextInputType.number,
            enabled: !hesaplananV,
            decoration: InputDecoration(
              labelText: 'Gerilim (V)',
              hintText: 'Örn: 12',
              border: const OutlineInputBorder(),
              suffixText: 'V',
              fillColor: hesaplananV ? Colors.grey.shade200 : null,
              filled: hesaplananV,
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: iCtrl,
            keyboardType: TextInputType.number,
            enabled: !hesaplananI,
            decoration: InputDecoration(
              labelText: 'Akım (I)',
              hintText: 'Örn: 2',
              border: const OutlineInputBorder(),
              suffixText: 'A',
              fillColor: hesaplananI ? Colors.grey.shade200 : null,
              filled: hesaplananI,
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: rCtrl,
            keyboardType: TextInputType.number,
            enabled: !hesaplananR,
            decoration: InputDecoration(
              labelText: 'Direnç (R)',
              hintText: 'Örn: 6',
              border: const OutlineInputBorder(),
              suffixText: 'Ω',
              fillColor: hesaplananR ? Colors.grey.shade200 : null,
              filled: hesaplananR,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: hesapla,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Hesapla'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: temizle,
                icon: const Icon(Icons.refresh),
                label: const Text('Temizle'),
              ),
            ],
          ),

          const SizedBox(height: 16),
          if (sonuc != null)
            Card(
              color: Colors.blueGrey.shade50,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(sonuc!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ),

          const SizedBox(height: 8),
          const Text(
            'Formüller:  V = I × R   |   I = V / R   |   R = V / I',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
