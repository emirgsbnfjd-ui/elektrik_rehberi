import 'package:flutter/material.dart';

class ArizaMotorCalismiyorSayfa extends StatelessWidget {
  const ArizaMotorCalismiyorSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚙️ Motor Çalışmıyor')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Bolum(
            title: '🚨 Önce Güvenlik',
            items: [
              'Motor ve pano üzerinde çalışmadan önce mutlaka enerjiyi kes.',
              'Motor ani kalkış yapabileceği için mekanik bölgelere dikkat et.',
              'Dönen parçalara yaklaşma, kaplin/kayış varsa koruyucu sökülüyse çalıştırma.',
              'Emin değilsen pano içine müdahale etme.',
            ],
          ),

          _Bolum(
            title: '🔍 Olası Nedenler',
            items: [
              'Ana şalter veya ilgili sigorta kapalı/atmış olabilir.',
              'Termik röle atmış olabilir (aşırı akım/ısınma).',
              'Kontaktör bobini enerjilenmiyordur.',
              'Acil stop (E-Stop) basılı olabilir.',
              'Faz eksikliği (3 fazlı motorlarda çok yaygın).',
              'Motor kablosu kopuk veya klemens gevşek olabilir.',
              'Motor sargısı arızalı olabilir.',
              'Otomasyon varsa PLC çıkışı gelmiyor olabilir.',
            ],
          ),

          _Bolum(
            title: '🧠 Hızlı Teşhis (Belirti → Olası Sebep)',
            items: [
              'Kontaktör hiç çekmiyorsa: bobin beslemesi / kumanda devresi sorunu.',
              'Kontaktör çekiyor ama motor dönmüyorsa: faz eksikliği veya motor arızası.',
              'Termik hemen atıyorsa: aşırı yük veya motor sargı sorunu.',
              'Motor uğultu yapıyor ama dönmüyorsa: faz eksikliği / mekanik sıkışma.',
              'Ara sıra çalışıyorsa: gevşek klemens veya kontaktör kontağı yanmış olabilir.',
            ],
          ),

          _Bolum(
            title: '🛠 Kontrol Sırası (En Mantıklı Adımlar)',
            items: [
              '1) Panodan motor hattına ait sigortaları kontrol et.',
              '2) Termik rölenin atık olup olmadığını kontrol et (reset dene).',
              '3) Acil stop ve stop butonlarını kontrol et.',
              '4) Kontaktör çekiyor mu gözle ve sesle kontrol et.',
              '5) Motor klemens kutusunda gevşeklik/yanık izi var mı bak.',
              '6) Aynı motor daha önce sorunsuz çalışıyor muydu kontrol et.',
            ],
          ),

          _Bolum(
            title: '📏 Basit Ölçüm Bilgisi (Eminsen)',
            items: [
              '3 fazlı motorlarda faz–faz arası ≈ 400V görülmelidir.',
              'Fazlardan biri yoksa motor çalışmaz veya zorlanır.',
              'Kontaktör bobininde anma gerilimi (ör. 24V DC / 220V AC) görülmeli.',
              'Termik çıkışında süreklilik olmalı (atık değilse).',
              'Ölçüm yaparken tek elle çalış, yalıtımlı prob kullan.',
            ],
          ),

          _Bolum(
            title: '🔥 En Sık Saha Arızaları',
            items: [
              'Bir faz sigortasının atması (faz eksikliği).',
              'Termik ayarının motor akımına göre yanlış seçilmesi.',
              'Kontaktör kontaklarının yanması (çekiyor ama güç iletmiyor).',
              'Motor klemensinde gevşek vida → ısınma ve kopma.',
              'Motor milinin mekanik olarak sıkışması.',
            ],
          ),

          _Bolum(
            title: '❌ Yapılmaması Gerekenler',
            items: [
              'Termik sürekli atıyor diye amperini yükseltmek.',
              'Faz eksik motoru zorlayarak çalıştırmaya çalışmak.',
              'Kontaktör çekiyor diye motor sağlam sanmak.',
              'Yanık kokusu varken motoru tekrar tekrar startlamak.',
            ],
          ),

          _Bolum(
            title: '⚠️ Ne Zaman Elektrikçi / Teknik Servis?',
            items: [
              'Motor sürekli termik attırıyorsa.',
              'Motor çalışırken aşırı ses veya titreşim varsa.',
              'Sargı yanığı şüphesi varsa.',
              'Pano ve motor hattı hakkında emin değilsen.',
              'Üretim hattı kritik ve duruş maliyetliyse.',
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
