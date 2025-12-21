import 'package:flutter/material.dart';

class ArizaIsikZayifSayfa extends StatelessWidget {
  const ArizaIsikZayifSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('💡 Işık Yanıyor Ama Çok Zayıf')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Bolum(
            title: '🚨 Önce Güvenlik',
            items: [
              'Aydınlatma arızalarında da enerjiyi kesmeden müdahale etme.',
              'Duy, anahtar veya buat açılacaksa sigortayı indir.',
              'Yanık kokusu veya aşırı ısınma varsa hattı kullanma.',
            ],
          ),

          _Bolum(
            title: '🔍 Olası Nedenler',
            items: [
              'Nötr hattının zayıf veya kopmak üzere olması.',
              'Buat veya anahtar içinde gevşek bağlantı.',
              'Faz paylaşımı (aynı fazdan çok yük beslenmesi).',
              'Eski tesisat / oksitlenmiş klemensler.',
              'LED ampul sürücüsünün arızalı olması.',
            ],
          ),

          _Bolum(
            title: '🧠 Hızlı Teşhis (Belirti → Olası Sebep)',
            items: [
              'Işık çok sönük yanıyorsa: nötr zayıflığı ihtimali.',
              'Aç-kapa yapınca bazen düzeliyorsa: gevşek klemens.',
              'Yük artınca (prizler çalışınca) daha da sönüyorsa: ortak nötr sorunu.',
              'Bazı odalarda normal bazılarında zayıfsa: hat/ek problemi.',
              'LED ampul sürekli titriyorsa: sürücü veya nötr problemi.',
            ],
          ),

          _Bolum(
            title: '🛠 Kontrol Sırası',
            items: [
              '1) Aynı hattan beslenen diğer ışıkları kontrol et.',
              '2) Ampulü sağlam bir ampulle değiştirip dene.',
              '3) Anahtar açıldığında duyda ısınma var mı kontrol et.',
              '4) Yakın buatlarda gevşeklik belirtisi var mı gözle kontrol et.',
              '5) Sorun yük altında artıyorsa nötr hattı ciddi risk altındadır.',
            ],
          ),

          _Bolum(
            title: '📏 Ölçüm Bilgisi (Eminsen)',
            items: [
              'Normalde lamba uçlarında ≈ 230V görülmelidir.',
              'Nötr zayıfsa ölçümde düşük veya dalgalı değerler görülebilir.',
              'Hayalet gerilim ölçümleri yanıltıcı olabilir.',
              'Emin değilsen ölçüm yapma.',
            ],
          ),

          _Bolum(
            title: '🔥 En Sık Saha Arızaları',
            items: [
              'Buat içinde gevşek nötr bağlantısı.',
              'Anahtar klemensinde yarım sıkılmış vida.',
              'Eski duyların iç kontaklarının oksitlenmesi.',
              'Alüminyum tesisatta temas kaybı.',
              'LED ampulün sürücüsünün yanması.',
            ],
          ),

          _Bolum(
            title: '❌ Yapılmaması Gerekenler',
            items: [
              'Sorunu ampul değiştirerek geçiştirmek (tesisat sorunu olabilir).',
              'Sönük yanıyor diye önemsememek.',
              'Enerji varken duy/anahtar sökmek.',
              'Zayıf ışığı normal sanmak (yangın riski).',
            ],
          ),

          _Bolum(
            title: '⚠️ Ne zaman ciddi?',
            items: [
              'Işıklar giderek daha da zayıflıyorsa.',
              'Aynı anda priz yükleri çalışınca ışık belirgin düşüyorsa.',
              'Birkaç farklı noktada aynı sorun varsa.',
              'Anahtar/duy ısınıyorsa.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Bolum extends StatelessWidget {
  final String title;
  final List<String> items;

  const _Bolum({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...items.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: Icon(Icons.circle, size: 6),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e)),
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
