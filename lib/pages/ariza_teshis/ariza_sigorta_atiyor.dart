import 'package:flutter/material.dart';

class ArizaSigortaAtiyorSayfa extends StatelessWidget {
  const ArizaSigortaAtiyorSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚡ Sigorta Atıyor')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Bolum(
            title: '🚨 Önce Güvenlik',
            items: [
              'Islak elle pano/priz müdahalesi yapma.',
              'Yanık kokusu, duman, ark sesi varsa ana şalteri indir.',
              'Sigorta sürekli atıyorsa zorlayıp kaldırma (yangın riski).',
              'Emin değilsen elektrikçi çağır.',
            ],
          ),

          _Bolum(
            title: '🧠 “Hangi eleman atıyor?” (Hızlı Teşhis)',
            items: [
              'MCB (otomatik sigorta) atıyorsa: kısa devre / aşırı yük / gevşek bağlantı ihtimali yüksek.',
              'RCD/RCCB (kaçak akım) atıyorsa: kaçak akım (toprak kaçakları, nem, cihaz arızası) ihtimali yüksek.',
              'RCBO atıyorsa: hem kısa devre/aşırı yük hem kaçak akım aynı cihazda olabilir.',
              'Ana şalter atıyorsa: toplam yük çok yüksek veya panoda ciddi arıza olabilir.',
            ],
          ),

          _Bolum(
            title: '🔍 Olası Nedenler (MCB için)',
            items: [
              'Kısa devre: faz-nötr teması, ezilmiş kablo, arızalı priz.',
              'Aşırı yük: aynı hatta çok cihaz (ısıtıcı, kettle, fırın aynı anda).',
              'Gevşek/yanmış klemens: ısınma → karbonlaşma → atma.',
              'Yanlış sigorta seçimi: hattın kablosuna göre yüksek/uygunsuz amper.',
              'Arızalı cihaz: motor sargısı, rezistans kaçakları, adaptör kısa devresi.',
            ],
          ),

          _Bolum(
            title: '⚡ Olası Nedenler (Kaçak Akım / RCD için)',
            items: [
              'Nem: banyo prizleri, dış ortam armatürleri, buat içine su girmesi.',
              'Rezistanslı cihaz: termosifon, çamaşır makinesi, bulaşık, fırın (ısıtıcı kaçak yapabilir).',
              'Toprak hattı zayıf/kopuk: kaçak akımın “yol” bulamaması yanlış davranışlara sebep olabilir.',
              'Nötr-toprak karışıklığı: panoda/buatta N-PE temas/karışma RCD’yi attırır.',
              'Birden fazla hattın nötrleri ortaklanmışsa: özellikle RCD altında nötr birleşimi sık atma sebebi.',
            ],
          ),

          _Bolum(
            title: '🧯 Sigorta Eğrisi (B–C–D) / “Durduk yere atıyor” konusu',
            items: [
              'B tipi: konut priz/aydınlatma için yaygın (hassas).',
              'C tipi: motorlu yükler (klima, buzdolabı) için daha uygun.',
              'Yanlış tip seçimi: ilk kalkış akımında gereksiz atma yapabilir.',
              'Not: Tip değiştirmek “sorunu çözmek” değil; önce arıza/yük bulunmalı.',
            ],
          ),

          _Bolum(
            title: '🧭 Adım Adım Arıza İzolasyonu (En Etkili Yöntem)',
            items: [
              '1) Sigorta attı → önce aynı hattan çalışan cihazları kapat/çek.',
              '2) Sigortayı kaldır → atıyorsa “tesiste kısa devre/kaçak” ihtimali artar.',
              '3) Atmıyorsa cihazları tek tek tak → atan cihaz arızalı olabilir.',
              '4) Hattın prizlerini sırayla devre dışı bırak (sigorta/pano üzerinden mümkünse).',
              '5) Sonradan yapılan ek/priz/buat varsa ilk orayı kontrol et (en sık arıza orada çıkar).',
            ],
          ),

          _Bolum(
            title: '📏 Multimetre ile Basit Kontroller (Eminsen Yap)',
            items: [
              'Prizde: Faz–Nötr ≈ 230V, Faz–Toprak ≈ 230V, Nötr–Toprak ≈ 0–5V (yaklaşık).',
              'Enerji kesikken: priz/hat üzerinde kısa devre şüphesi için süreklilik (buzzer) kontrolü yapılabilir.',
              'Kablo ısınması/kararma varsa: gevşek bağlantı ihtimali yüksek → klemens/vida sıkılığı kontrol edilir.',
              'Not: Ölçüm yaparken güvenli çalışma şarttır; emin değilsen ölçüm yapma.',
            ],
          ),

          _Bolum(
            title: '🔥 Çok Sık Görülen Saha Arızaları (Gerçek Hayat)',
            items: [
              'Uzatma kablosu üzerinden ısıtıcı çalıştırma → fiş/priz erimesi.',
              'Buat içinde gevşek ek → ısınma, ark, sigorta atması.',
              'Nem alan dış armatür → kaçak akım atması.',
              'Çamaşır makinesi rezistansı kaçak → RCD atar (özellikle ısıtırken).',
              'Klemens kararması → yükte atma (özellikle akşam yüksek kullanımda).',
            ],
          ),

          _Bolum(
            title: '❌ Yapılmaması Gerekenler (Önemli)',
            items: [
              'Sigortayı daha büyük amperle değiştirmek (kablo yanar, yangın).',
              'Sigortayı tel ile sabitlemek veya “atmasın” diye müdahale etmek.',
              'Arıza varken sürekli kaldırıp zorlamak (kontaklar zarar görür).',
              'Kaçak akımı iptal etmek / köprülemek (hayati tehlike).',
            ],
          ),

          _Bolum(
            title: '⚠️ Ne Zaman Elektrikçi? (Kesin)',
            items: [
              'Tehlike belirtisi varsa (koku, duman, kararma) müdahale etme.',
              'Yanık kokusu / duman / ark sesi varsa.',
              'Panoda kararma, erime, aşırı ısınma varsa.',
              'RCD test tuşu çalışmıyorsa veya sürekli atıyorsa.',
              'Sorun belirli saatlerde (yük artınca) oluyorsa: hat/bağlantı ısınması olabilir.',
            ],
          ),

          _Bolum(
            title: '✅ Mini İpucu (Kullanıcıya Efsane Fayda)',
            items: [
              'Atma “cihaz takınca” oluyorsa cihaz arızalı olabilir.',
              'Atma “hiçbir şey yokken” oluyorsa tesisat arızası ihtimali artar.',
              'Atma “akşamları” oluyorsa aşırı yük/ısınma ihtimali artar.',
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
    final t = Theme.of(context);
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
              style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            ...items.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: Icon(Icons.circle, size: 7),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(e, style: t.textTheme.bodyMedium)),
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
