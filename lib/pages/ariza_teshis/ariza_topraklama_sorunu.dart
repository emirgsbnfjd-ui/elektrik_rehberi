import 'package:flutter/material.dart';

class ArizaTopraklamaSorunuSayfa extends StatelessWidget {
  const ArizaTopraklamaSorunuSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚡ Topraklama Sorunu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Baslik('🔍 Topraklama Sorunu Nedir?'),
          _Paragraf(
            'Topraklama; elektrikli cihazların metal gövdelerinde oluşan '
            'kaçak elektriğin, insan yerine güvenli şekilde toprağa '
            'aktarılmasını sağlar. Topraklama yoksa veya hatalıysa, '
            'cihaz gövdesi gerilim altında kalabilir ve hayati tehlike oluşur.',
          ),

          SizedBox(height: 16),

          _Baslik('🚨 Belirtiler'),
          _Madde('Cihaz gövdesine dokununca hafif elektrik çarpması'),
          _Madde('Islak elle dokununca çarpmanın artması'),
          _Madde('Metal yüzeylerde karıncalanma hissi'),
          _Madde('Kaçak akım rölesinin hiç atmaması'),
          _Madde('Prizde toprak olmasına rağmen ölçümde çıkmaması'),
          _Madde('Bilgisayar kasası, buzdolabı veya çamaşır makinesinin çarpması'),

          SizedBox(height: 16),

          _Baslik('🧠 Olası Nedenler'),
          _Madde('Toprak hattının hiç çekilmemiş olması'),
          _Madde('Toprak kablosunun priz içinde kopuk veya gevşek olması'),
          _Madde('Pano toprak barasının bağlı olmaması'),
          _Madde('Nötr ile toprağın köprülenmiş olması (çok tehlikeli)'),
          _Madde('Topraklama kazığının yetersiz veya kuru toprakta olması'),
          _Madde('Toprak hattında oksitlenmiş veya paslı bağlantılar'),

          SizedBox(height: 16),

          _Baslik('🛠 Multimetre ile Kontrol'),
          _Madde('Faz – Nötr: 220–230 V olmalı'),
          _Madde('Faz – Toprak: 220–230 V olmalı'),
          _Madde('Nötr – Toprak: 0–2 V normal kabul edilir'),
          _Madde('Nötr – Toprak 5 V üzerindeyse sorun vardır'),
          _Madde('Faz – Toprak yoksa toprak hattı kopuk veya yoktur'),

          SizedBox(height: 16),

          _Baslik('🧪 Ölçüm Sonuçlarına Göre Yorum'),
          _Madde('Faz–Toprak yok → Toprak hattı yok veya kopuk'),
          _Madde('Nötr–Toprak yüksek → Nötr zayıf veya ortak nötr'),
          _Madde('Kaçak akım atmıyor → Toprak veya röle arızalı'),
          _Madde('Cihaz çarpıyor → Gövde kaçağı + toprak yok'),

          SizedBox(height: 16),

          _Baslik('🔧 Çözüm Yolları'),
          _Madde('Toprak hattı panodan prizlere kadar yeniden çekilmeli'),
          _Madde('Toprak barası ve bağlantılar sıkılmalı'),
          _Madde('Topraklama kazığı artırılmalı veya yenilenmeli'),
          _Madde('Nötr–toprak köprüsü kesinlikle kaldırılmalı'),
          _Madde('Kaçak akım rölesi test edilmeli ve gerekirse değiştirilmeli'),

          SizedBox(height: 16),

          _Baslik('🚫 Yapılmaması Gerekenler'),
          _Madde('Nötrden topraklama yapmak'),
          _Madde('Toprak hattını iptal etmek'),
          _Madde('Çarpıyor ama idare eder demek'),
          _Madde('Kaçak akım rölesini iptal etmek'),

          SizedBox(height: 16),

          _Baslik('⚠️ Ne Zaman Elektrikçi Şart?'),
          _Madde('Cihaz gövdesi belirgin şekilde çarpıyorsa'),
          _Madde('Kaçak akım rölesi çalışmıyorsa'),
          _Madde('Toprak hattı hiç yoksa'),
          _Madde('Ölçümlerde kararsız değerler çıkıyorsa'),

          SizedBox(height: 20),

          _Baslik('‼️ Hayati Uyarı'),
          _Paragraf(
            'Topraklama sorunu ölümcül kazalara yol açabilir. '
            'Geçici çözümler uygulanmamalı, sorun kalıcı şekilde '
            'giderilmelidir. Şüphe varsa mutlaka yetkili bir '
            'elektrikçi tarafından müdahale edilmelidir.',
            color: Colors.redAccent,
            bold: true,
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
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
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

class _Paragraf extends StatelessWidget {
  final String text;
  final Color? color;
  final bool bold;

  const _Paragraf(
    this.text, {
    this.color,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          height: 1.4,
          color: color,
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
