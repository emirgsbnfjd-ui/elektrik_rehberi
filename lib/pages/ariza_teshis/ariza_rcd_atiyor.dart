import 'package:flutter/material.dart';

class ArizaRcdAtiyorSayfa extends StatelessWidget {
  const ArizaRcdAtiyorSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧯 RCD / Kaçak Akım Atıyor')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Bolum(
            title: '🚨 Önce Güvenlik',
            items: [
              'Islak elle pano/priz müdahalesi yapma.',
              'Yanık kokusu, duman, ark sesi varsa ana şalteri indir.',
              'RCD’yi “atmasın” diye köprülemek/iptal etmek hayati tehlikedir.',
              'Emin değilsen profesyonel destek al.',
            ],
          ),

          _Bolum(
            title: '🧠 RCD Ne İşe Yarar? (Kısa ve Net)',
            items: [
              'RCD (Kaçak akım rölesi), fazdan çıkan akım ile nötrden dönen akımı karşılaştırır.',
              'Arada fark (kaçak) oluşursa insanı/yangını korumak için çok hızlı açar.',
              'RCD; kısa devreyi değil, kaçak akımı algılar (kısa devrede MCB atar).',
            ],
          ),

          _Bolum(
            title: '📌 “Ne atıyor?” Hızlı Teşhis',
            items: [
              'Sadece MCB (otomatik sigorta) atıyorsa: kısa devre / aşırı yük ihtimali daha yüksek.',
              'Sadece RCD atıyorsa: kaçak akım (nem, cihaz kaçağı, N-PE karışması, ortak nötr) ihtimali yüksek.',
              'Hem RCD hem MCB birlikte atıyorsa: ciddi arıza veya panoda bağlantı sorunu olabilir.',
              'RCBO kullanılıyorsa: hem kaçak akım hem kısa devre/aşırı yük aynı cihazda toplanmış olabilir.',
            ],
          ),

          _Bolum(
            title: '🔍 Olası Nedenler (En Sık)',
            items: [
              'Nem / su alan priz-buat (özellikle banyo, balkon, dış hat, bahçe aydınlatması).',
              'Cihaz kaçağı: şofben/termosifon, çamaşır, bulaşık, kombi, kettle, fırın (rezistanslı cihazlar).',
              'Nötr-toprak karışması (çok sık): buat/pano içinde N ile PE temas etmesi.',
              'Birden fazla hattın nötrlerinin ortaklanması: RCD altında nötrler karışırsa sürekli atma yapar.',
              'Toplam kaçak akım: tek tek cihaz sorun çıkarmasa da hepsi birlikte çalışınca eşik aşılır.',
              'Dış ortam kablosu ezilmesi/izolasyon zayıflaması (yağmurda daha çok atar).',
            ],
          ),

          _Bolum(
            title: '🧪 RCD “TEST” Tuşu Ne Anlatır?',
            items: [
              'TEST tuşu, RCD mekanizmasının çalışıp çalışmadığını kontrol eder (aylık önerilir).',
              'TEST’e basınca atmıyorsa: RCD arızalı olabilir veya besleme/bağlantı hatası vardır.',
              'TEST’e basınca atması: “RCD çalışıyor” demektir ama tesisatta kaçak olmadığı anlamına gelmez.',
            ],
          ),

          _Bolum(
            title: '🛠 Adım Adım İzolasyon (En Etkili Yöntem)',
            items: [
              '1) RCD’yi kaldırmadan önce: tüm prizlerdeki cihazları fişten çek.',
              '2) RCD’yi kaldır: atıyorsa tesisat/nem/N-PE karışması ihtimali yükselir.',
              '3) Atmıyorsa: cihazları tek tek tak → atan cihaz kaçak yapıyor olabilir.',
              '4) Hat hat ayır: RCD altında hangi MCB hattında kaçak var bulmak için sigortaları tek tek aç.',
              '5) Banyo/dış hat/armatür hatlarını en sona bırak (en sık sorun çıkan yer).',
            ],
          ),

          _Bolum(
            title: '⏱ Atma Şekline Göre Yorum (Çok İşe Yarar)',
            items: [
              'Anında atıyorsa: N-PE karışması, ciddi kaçak veya ıslak buat/priz olası.',
              'Bazı cihazlar çalışınca atıyorsa: cihaz kaçağı (özellikle ısıtma devresinde).',
              'Yağmurda/ıslakta atıyorsa: dış ortam armatürü, ek kutusu veya kablo izolasyonu sorunu olası.',
              'Gece/kimse yokken atıyorsa: dış aydınlatma, nem, otomatik cihazlar veya kaçak bir hat olabilir.',
              'Sadece yüksek yükte atıyorsa: ısınan izolasyon/ek yeri kaçak oluşturuyor olabilir.',
            ],
          ),

          _Bolum(
            title: '🔥 En Sık Görülen Saha Hataları',
            items: [
              'Buat içinde bantla yapılan ek → zamanla nem alır, kaçak yapar.',
              'Dış mekan buatının kapağı açık/contası bozuk → yağmurda atma.',
              'Nötrlerin ortak baradan yanlış köprülenmesi (RCD sonrası nötrler karışması).',
              'Toprak hattının kopuk olması: koruma zayıflar, risk artar.',
              'Eski/sertleşmiş kablo izolasyonu: özellikle dış ortamlarda kaçak.',
            ],
          ),

          _Bolum(
            title: '❌ Yapılmaması Gerekenler (Hayati)',
            items: [
              'RCD’yi köprülemek/iptal etmek.',
              '“Atmasın” diye daha büyük değerli RCD takmak (yanlış yaklaşım).',
              'Islak ortamda priz/armatür açıp kurcalamak.',
              'Arıza varken sürekli kaldırıp zorlamak.',
            ],
          ),

          _Bolum(
            title: '⚠️ Ne zaman elektrikçi? (Kesin)',
            items: [
              'RCD sürekli ve anında atıyorsa (tesisat arızası olası).',
              'Yanık kokusu / ısınma / kararma varsa.',
              'Pano içinde N-PE karışıklığı veya nötr ortaklama şüphesi varsa.',
              'Dış ortam hatlarında su/nem şüphesi varsa.',
              'TEST tuşu çalışmıyorsa veya RCD fiziksel olarak gevşek/ısınmışsa.',
            ],
          ),

          _Bolum(
            title: '📞 Profesyonel Destek',
            items: [
              'Sorun devam ediyorsa profesyonel müdahale gerekebilir.',
              'Uygulamadaki İletişim sayfasından BYRK Elektrik’e ulaşabilirsiniz.',
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
