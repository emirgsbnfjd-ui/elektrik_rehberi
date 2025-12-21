import 'package:flutter/material.dart';

class ElektronikSarjOlmuyorSayfa extends StatelessWidget {
  const ElektronikSarjOlmuyorSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔋 Şarj Olmuyor')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _InfoCard(
            title: '📌 Kısa Özet',
            body:
                '“Şarj olmuyor” sorunu çoğu zaman basit bir parçadan (kablo, adaptör, soket) çıkar.\n'
                'Önce dış ekipmanları eleyip sonra cihaz tarafına geçmek en doğru teşhistir.',
          ),

          SizedBox(height: 16),

          _Baslik('🔍 Belirtiler'),
          _Madde('Şarj yüzdesi hiç artmıyor / %0’da kalıyor'),
          _Madde('Şarj simgesi geliyor ama “şarj olmuyor” yazıyor'),
          _Madde('Kablo takınca sürekli bağlanıp kopuyor'),
          _Madde('Kablo oynatınca şarj geliyor-gidiyor'),
          _Madde('Cihaz “Nem algılandı” / “Şarj devre dışı” uyarısı veriyor'),
          _Madde('Şarj çok yavaş (normalden 3–5 kat uzun)'),
          _Madde('Şarj sırasında aşırı ısınma oluyor'),

          SizedBox(height: 16),

          _Baslik('🧠 En Yaygın Nedenler'),
          _Madde('Kablo arızalı / içten kopuk (en sık sebep)'),
          _Madde('Adaptör gücü yetersiz veya bozuk'),
          _Madde('Prizde/uzatmada temas sorunu'),
          _Madde('Şarj soketi kirli, oksitli veya gevşek'),
          _Madde('USB port/Type-C pinleri hasarlı (eğilme, gevşeme)'),
          _Madde('Batarya ömrü bitmiş / şişmiş / korumaya geçmiş'),
          _Madde('Yazılımsal donma, arka planda aşırı tüketim'),
          _Madde('Şarj entegresi (IC), flex kablo veya güç hattı arızası'),

          SizedBox(height: 16),

          _Baslik('✅ Evde Yapılacak Güvenli Kontroller (Sırayla)'),
          _Adim(
            no: '1',
            title: 'Başka kablo ile dene',
            body:
                'Mümkünse orijinal veya kaliteli (kalın damar) kablo kullan.\n'
                'Kabloyu farklı cihazda da dene: Diğer cihazda da şarj etmiyorsa kablo kesin bozuk olabilir.',
          ),
          _Adim(
            no: '2',
            title: 'Başka adaptör ile dene',
            body:
                'Adaptörün gücü önemli:\n'
                '• Telefon: genelde 18–33W arası\n'
                '• Tablet: 20–45W\n'
                '• Bazı cihazlar düşük watt ile çok yavaş şarj olur.\n'
                'Başka adaptörde düzeliyorsa sorun adaptördedir.',
          ),
          _Adim(
            no: '3',
            title: 'Farklı priz / uzatma / çoklayıcı dene',
            body:
                'Bazı uzatmalarda klemens gevşer veya anahtar arızalı olur.\n'
                'Direkt duvar prizinde dene. Eğer orada düzeliyorsa uzatma/çoklayıcı şüpheli.',
          ),
          _Adim(
            no: '4',
            title: 'Şarj soketini kontrol et (kir, tüy, toz)',
            body:
                'Özellikle cepte taşınan telefonlarda sokete tüy dolar ve fiş tam oturmaz.\n'
                'FİŞ tam oturuyor mu? “Klik” gibi oturma hissi var mı?\n'
                'Sokette gözle görünen kir varsa basitçe ışık tutup kontrol et.',
          ),
          _Uyari(
            text:
                'Sokete iğne/metal sokma, kısa devre riski var.\n'
                'Temizlik gerekiyorsa en güvenlisi: cihaz kapalıyken, ahşap kürdan benzeri METAL OLMAYAN bir şey ve çok nazikçe.',
          ),
          _Adim(
            no: '5',
            title: 'Kablo takınca oynat-test yap',
            body:
                'Kabloyu hafifçe sağa-sola oynatınca şarj gelip gidiyorsa:\n'
                '• Soket gevşemiş olabilir\n'
                '• İç flex kablo hasarlı olabilir\n'
                'Bu durumda çoğu zaman servisliktir.',
          ),
          _Adim(
            no: '6',
            title: 'Cihazı yeniden başlat / güç döngüsü',
            body:
                'Yazılımsal kilitlenmeler şarjı kesebilir.\n'
                'Önce normal yeniden başlat. Olmazsa “güç tuşu + ses kısma” gibi zorla yeniden başlatma (modele göre değişir) denenir.',
          ),
          _Adim(
            no: '7',
            title: 'Nem uyarısı / sıvı teması varsa',
            body:
                'Cihaz şarjı güvenlik için kapatabilir.\n'
                '• Kabloyu çıkar\n'
                '• Cihazı kuru ortamda beklet\n'
                '• Saç kurutma ile ısıtma yapma (içeride yoğunlaşma/hasar yapabilir)',
          ),

          SizedBox(height: 16),

          _Baslik('🧪 Basit Teşhis Tablosu (Hızlı Sonuç)'),
          _Madde('Başka kablo+adaptörle şarj oluyorsa → %80 dış ekipman sorunu'),
          _Madde('Sadece belli açıda şarj oluyorsa → soket/flex gevşek (servis)'),
          _Madde('Kablosuz şarj var, kablolu yok → şarj soketi veya port devresi'),
          _Madde('Şarj var ama aşırı yavaş → adaptör watt düşük / kablo kalitesiz / arka planda tüketim'),
          _Madde('Şarj sırasında cihaz çok ısınıyorsa → batarya zayıf / kısa devre / güç yönetimi sorunu (servis)'),

          SizedBox(height: 16),

          _Baslik('⚠️ Ne Zaman Servis / Usta?'),
          _Madde('Kablo/adaptör değişmesine rağmen hiç şarj olmuyorsa'),
          _Madde('Şarj soketi gevşekse, fiş tam oturmuyorsa'),
          _Madde('Cihaz şişme belirtileri gösteriyorsa (batarya şişmesi)'),
          _Madde('Isınma + koku + ani kapanma varsa'),
          _Madde('Sıvı teması yaşandıysa ve şarj kesildiyse'),
          _Madde('Şarj olurken “cızz” ses / kıvılcım / yanık kokusu varsa (acil)'),

          SizedBox(height: 16),

          _Baslik('🧯 Güvenlik Uyarıları'),
          _Uyari(
            text:
                '• Yanık kokusu, adaptör aşırı ısınması, prizde kıvılcım varsa hemen fişi çek.\n'
                '• Ucuz/merdiven altı adaptörler cihazı bozabilir.\n'
                '• Batarya şişmesi varsa cihazı kullanma, servise götür.',
          ),

          SizedBox(height: 16),

          _InfoCard(
            title: '💡 Mini İpucu',
            body:
                'En mantıklı sıra: Kablo → Adaptör → Priz → Soket teması → Yazılım → Servis.\n'
                'Bu sırayı takip edersen “boşuna parça değiştirme” işini bitirirsin.',
          ),
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

class _Madde extends StatelessWidget {
  final String text;
  const _Madde(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('• $text'),
    );
  }
}

class _Adim extends StatelessWidget {
  final String no;
  final String title;
  final String body;

  const _Adim({
    required this.no,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  child: Text(
                    no,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(body),
          ],
        ),
      ),
    );
  }
}

class _Uyari extends StatelessWidget {
  final String text;
  const _Uyari({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.redAccent.withValues(alpha: 0.10),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String body;

  const _InfoCard({
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(body),
          ],
        ),
      ),
    );
  }
}
