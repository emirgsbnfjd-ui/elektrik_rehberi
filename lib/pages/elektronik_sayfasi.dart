import 'package:flutter/material.dart';

// Eğer bu dosya lib/pages/ içindeyse relative import işini görür:
import 'hesaplayici_sayfasi.dart';

// Makale modelini ve tüm listeyi nasıl içe aktarıyorsan ona göre düzenle:
import '../models/makale.dart';
import '../data/tum_makaleler.dart'; // tumMakaleler burada ise

class ElektronikSayfasi extends StatelessWidget {
  const ElektronikSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    // SADECE elektronik kategorisi:
    final List<Makale> elektronik = tumMakaleler
        .where((m) => m.kategori.toLowerCase() == 'elektronik')
        .toList();

    // DEBUG: doğru sayfada mıyız?
    // (Açılışta bir defa çubuk gösterir)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ElektronikSayfasi build() çalıştı'),
          duration: Duration(milliseconds: 800),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Elektronik')),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: elektronik.length + 1, // +1: en üste buton
        itemBuilder: (context, index) {
          if (index == 0) {
            // ⬇️ HESAPLAYICI BUTONU (her zaman ilk sırada)
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.calculate),
                label: const Text('Ohm Kanunu Hesaplayıcı'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HesaplayiciSayfasi()),
                  );
                },
              ),
            );
          }

          final m = elektronik[index - 1];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: (m.resim != null)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        m.resim!,
                        width: 46, height: 46, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                      ),
                    )
                  : const Icon(Icons.article_outlined),
              title: Text(m.baslik, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(m.icerik, maxLines: 2, overflow: TextOverflow.ellipsis),
              onTap: () {
                // İstersen burada detay sayfana git
              },
            ),
          );
        },
      ),
    );
  }
}
