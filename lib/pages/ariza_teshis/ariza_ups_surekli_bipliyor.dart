import 'package:flutter/material.dart';

class ArizaUpsSurekliBipliyorSayfa extends StatelessWidget {
  const ArizaUpsSurekliBipliyorSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔋 UPS Sürekli Bipliyor')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Bolum(
            title: '🚨 Önce Güvenlik',
            items: [
              'UPS fişini çekmeden arka kapağını açma.',
              'Akü uçlarına metal cisim değdirmemeye dikkat et.',
              'Şişmiş, sızdırmış akü varsa UPS’i kullanma.',
              'Yüksek güçlü cihazları UPS’e rastgele bağlama.',
            ],
          ),

          _Bolum(
            title: '🔍 Olası Nedenler',
            items: [
              'UPS aküsü zayıflamış veya ömrünü doldurmuş olabilir.',
              'UPS’e bağlı yük kapasitesini aşmış olabilir.',
              'Şebeke voltajı düzensiz veya sık kesiliyor olabilir.',
              'UPS by-pass veya akü modunda çalışıyor olabilir.',
              'Akü bağlantı soketleri gevşek olabilir.',
            ],
          ),

          _Bolum(
            title: '🧠 Hızlı Teşhis (Belirti → Olası Sebep)',
            items: [
              'Sürekli hızlı bip: aşırı yük veya akü bitik.',
              'Aralıklı bip: şebeke gidip geliyor.',
              'Elektrik varken bipliyorsa: akü zayıf.',
              'UPS hemen kapanıyorsa: akü tamamen bitmiş.',
            ],
          ),

          _Bolum(
            title: '🛠 Kontrol Sırası',
            items: [
              '1) UPS’e bağlı cihazların bir kısmını çıkar.',
              '2) UPS ekranında yük yüzdesini kontrol et.',
              '3) Şebeke fişi takılı mı ve priz sağlam mı kontrol et.',
              '4) UPS’i kapat–aç yap (reset).',
              '5) Akü yaşı 2–3 yıldan büyükse değişimi düşün.',
            ],
          ),

          _Bolum(
            title: '📏 Basit Ölçüm Bilgisi (Eminsen)',
            items: [
              '12V akü boşta 12.6–13V civarı olmalıdır.',
              '10.5V altı aküler zayıf kabul edilir.',
              'Yük altında voltaj aniden düşüyorsa akü bitmiştir.',
              'Ölçüm sırasında kısa devre yaptırma.',
            ],
          ),

          _Bolum(
            title: '🔥 En Sık Saha Sorunları',
            items: [
              'UPS’e yazıcı, kettle, ısıtıcı bağlanması.',
              'Yıllarca akü değişmeden kullanılan UPS.',
              'Uzun süre elektriksiz kalan ortamda akü sülfatlanması.',
              'Düşük kaliteli muadil akü kullanımı.',
            ],
          ),

          _Bolum(
            title: '❌ Yapılmaması Gerekenler',
            items: [
              'Bip sesi kesilsin diye aküyü sökmek.',
              'UPS kapasitesinden büyük yük bağlamak.',
              'Şişmiş aküyü kullanmaya devam etmek.',
              'Akü değişimini ters kutup ile yapmak.',
            ],
          ),

          _Bolum(
            title: '⚠️ Ne Zaman Servis?',
            items: [
              'Akü değişmesine rağmen bip devam ediyorsa.',
              'UPS ısınıyor veya yanık kokusu geliyorsa.',
              'Profesyonel/server tipi UPS ise.',
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
