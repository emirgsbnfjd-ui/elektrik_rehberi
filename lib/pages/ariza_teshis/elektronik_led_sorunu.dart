import 'package:flutter/material.dart';

class ElektronikLedSorunuSayfa extends StatelessWidget {
  const ElektronikLedSorunuSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('💡 LED Sorunu (Yanıp Sönüyor / Yanmıyor)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Baslik('🔍 Belirtiler'),
          _Madde('LED hiç yanmıyor (tamamen ölü)'),
          _Madde('LED yanıp sönüyor / titriyor (flicker)'),
          _Madde('LED çok loş yanıyor, bazen düzeliyor'),
          _Madde('Renk bozuk: mavi/yeşil kayma, beyaz sararmış gibi'),
          _Madde('Bazı LED’ler yanıyor bazıları yanmıyor (şerit/seri dizilim)'),
          _Madde('Isınınca sönüyor, soğuyunca geri geliyor'),

          SizedBox(height: 14),

          _Baslik('🧠 En Sık Nedenler'),
          _Madde('Besleme/adaptör/driver zayıf veya arızalı (voltaj düşüyor)'),
          _Madde('Kablo/klemens/konnektör temassız (özellikle şerit LED’de)'),
          _Madde('Yanlış voltaj: 5V LED’e 12V, 12V LED’e 24V verilmesi'),
          _Madde('Aşırı akım / hatalı direnç (özellikle tek LED modüllerde)'),
          _Madde('LED çipi ömrünü doldurmuş (ısıdan yıpranma)'),
          _Madde('Kondansatör bozulması (driver içinde flicker yapar)'),
          _Madde('PWM dimmer / kumanda uyumsuzluğu (titreşim yapabilir)'),
          _Madde('Şerit LED’de kesim yeri hatası veya yanlış lehim'),

          SizedBox(height: 14),

          _Baslik('🛠 Hızlı Teşhis (En Pratik Sıra)'),
          _Madde('1) Farklı priz/USB/çıkışta dene (besleme kaynağını ele)'),
          _Madde('2) Farklı kablo kullan (şarj kablosu/konnektör arızası çok olur)'),
          _Madde('3) Adaptör/driver’ı elle kontrol et: aşırı ısınma/koku var mı?'),
          _Madde('4) Temassızlık için kabloyu oynat: yanıp sönme değişiyor mu?'),
          _Madde('5) Şerit LED ise giriş ucunu kontrol et (genelde sorun ilk bağlantıda)'),
          _Madde('6) Dimmer/kumanda varsa devreden çıkarıp direkt besle (uyumsuzluk testi)'),

          SizedBox(height: 14),

          _Baslik('📏 Multimetre ile Kontrol (Güvenli Ölçüm Mantığı)'),
          _Madde('Adaptör etiketi ile çıkışı kıyasla: 5V/12V/24V doğru mu?'),
          _Madde('Yük altında ölç: LED bağlıyken voltaj çok düşüyorsa adaptör zayıf olabilir'),
          _Madde('Konnektör çıkışında voltaj var ama LED yanmıyorsa LED hattı/şerit arızalı olabilir'),
          _Madde('Şerit LED’de “başta var sonda yok” ise arada kopuk/yanık segment olabilir'),
          _Madde('LED modül tek ise seri direnç/driver bağlantısı ters/yanlış olabilir'),

          SizedBox(height: 14),

          _Baslik('🧩 Soruna Göre Net Çözüm Önerileri'),
          _AltBaslik(' LED hiç yanmıyor'),
          _Madde('Adaptör çıkışı yoksa: adaptör/driver değişimi'),
          _Madde('Çıkış var ama LED yok: ters bağlantı, kopuk kablo veya LED çipi yanmış olabilir'),
          _Madde('Şerit LED’de: ilk giriş noktasını ve kesim yerlerini kontrol et'),

          SizedBox(height: 8),

          _AltBaslik(' LED yanıp sönüyor / titriyor'),
          _Madde('Adaptör/driver güçsüz kalıyor olabilir (amper yetmiyor)'),
          _Madde('Temassızlık en sık sebeptir: konnektör-kablo-klemens sıkı mı?'),
          _Madde('Dimmer/PWM uyumsuzluğu: dimmeri çıkarıp test et'),
          _Madde('Driver kondansatörü bozulmuş olabilir (özellikle yıllanmış led trafolarında)'),

          SizedBox(height: 8),

          _AltBaslik(' LED loş yanıyor'),
          _Madde('Uzun ince kabloda voltaj düşümü olur: kabloyu kısalt/kalınlaştır'),
          _Madde('Adaptör nominal voltajı veremiyor olabilir (yük altında düşüyor)'),
          _Madde('Şerit LED’in tamamını tek uçtan beslemek loşluk yapar: uzun hatlarda iki uçtan besleme gerekebilir'),

          SizedBox(height: 8),

          _AltBaslik(' Renk bozulması / beyaz sararması'),
          _Madde('LED ısınmış/yıpranmış olabilir (özellikle kapalı alüminyumsuz profilde)'),
          _Madde('Yanlış voltaj/akım LED fosforunu hızlı öldürür'),
          _Madde('Ucuz şeritlerde renk stabilitesi zayıf olur (kalite kaynaklı)'),

          SizedBox(height: 14),

          _Baslik('🔥 Isı Yönetimi (LED’i Öldüren 1 Numara)'),
          _Madde('Şerit LED’i alüminyum profile yapıştırmak ömrü ciddi uzatır'),
          _Madde('Kapalı kutu/izolesiz ortam aşırı ısıtır → flicker + sararma yapar'),
          _Madde('Adaptörü kapalı yerde boğma: ısınırsa voltaj düşer ve titreme başlar'),

          SizedBox(height: 14),

          _UyariBox(
            title: '⚠️ Ne Zaman Usta Çağırmalı?',
            items: [
              'LED sistemi 220V ile çalışıyor ve driver/armatür içinde işlem gerektiriyorsa',
              'Koku, yanık izi, duman, aşırı ısınma varsa',
              'Sigorta attırma/kaçak akım atma gibi belirtiler eşlik ediyorsa',
              'Evin tesisatıyla bağlantılı bir aydınlatma hattında tekrarlı sorun oluyorsa',
            ],
          ),

          SizedBox(height: 14),

          _Baslik(' Önleme (Sonradan “Niye Bozuldu?” Dememek İçin)'),
          _Madde('LED’in voltajını doğru seç: 5V/12V/24V karıştırma'),
          _Madde('Adaptör amperini yüksek seçmek sorun değil, düşük seçmek flicker yapar'),
          _Madde('Şerit LED’de sağlam konnektör/lehimi tercih et, gevşek temas öldürür'),
          _Madde('Isıyı düşür: alüminyum profil + havalandırma'),
        ],
      ),
    );
  }
}

class _Baslik extends StatelessWidget {
  final String text;
  const _Baslik(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _AltBaslik extends StatelessWidget {
  final String text;
  const _AltBaslik(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Madde extends StatelessWidget {
  final String text;
  const _Madde(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('• $text', style: const TextStyle(height: 1.25)),
    );
  }
}

class _UyariBox extends StatelessWidget {
  final String title;
  final List<String> items;

  const _UyariBox({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 8),
          for (final s in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('• $s'),
            ),
        ],
      ),
    );
  }
}
