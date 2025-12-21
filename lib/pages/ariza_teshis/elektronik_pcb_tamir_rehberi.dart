import 'package:flutter/material.dart';

class ElektronikPcbTamirRehberiSayfa extends StatelessWidget {
  const ElektronikPcbTamirRehberiSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧠 PCB Kart Tamiri Rehberi')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [

          _Info(
            title: '📌 Amaç',
            body:
                'PCB kart tamirinde amaç rastgele parça değiştirmek değil, '
                'arıza olan bölgeyi sistematik şekilde BULMAKTIR. '
                'Bu rehber, multimetre ile adım adım nasıl ilerlemen gerektiğini anlatır.',
          ),

          SizedBox(height: 16),

          _Baslik('🔍 1️⃣ Gözle İnceleme (Multimetreye Geçmeden Önce)'),
          _Madde('Yanık izleri, kararmış PCB yolları var mı?'),
          _Madde('Şişmiş, akmış veya patlamış kondansatör var mı?'),
          _Madde('Kırık, çatlamış, yerinden oynamış parça var mı?'),
          _Madde('Soğuk lehim (mat, çatlak, halka şeklinde) var mı?'),
          _Madde('Oksitlenme, nem izi, yeşillenme var mı?'),
          _Madde('Konnektörler gevşek mi, pinler eğilmiş mi?'),

          _Uyari(
            'Bu aşamada bulunan arızaların %30–40’ı multimetreye gerek kalmadan çözülür.',
          ),

          SizedBox(height: 16),

          _Baslik('⚡ 2️⃣ Besleme Hattı Kontrolü (EN KRİTİK ADIM)'),
          _Madde('Adaptör girişi kartta var mı?'),
          _Madde('Sigorta, PTC, seri direnç sağlam mı?'),
          _Madde('Besleme hattı kısa devre mi?'),
          _Madde('Regülatör çıkışları mevcut mu?'),

          SizedBox(height: 8),

          _AltBaslik('🔧 Multimetre Ayarı'),
          _Madde('DC Volt ölçümü (V⎓)'),
          _Madde('Direnç / Diyot modu'),

          SizedBox(height: 8),

          _AltBaslik('📏 Ölçüm Sırası'),
          _Madde('Giriş voltajı → örn: 12V / 19V / 5V'),
          _Madde('Regülatör çıkışı → 5V / 3.3V / 1.8V'),
          _Madde('Besleme var ama cihaz çalışmıyorsa → sonraki adıma geç'),

          SizedBox(height: 16),

          _Baslik('🚫 3️⃣ Kısa Devre Kontrolü'),
          _Madde('Multimetreyi direnç veya diyot moduna al'),
          _Madde('Besleme hattı ile GND arasını ölç'),
          _Madde('0–5 ohm → büyük ihtimal kısa devre'),
          _Madde('Yüksek direnç → normal'),

          _Uyari(
            'Besleme hattında kısa devre varsa ENTEGRE veya KONDANSATÖR şüphelidir.',
          ),

          SizedBox(height: 16),

          _Baslik('🔋 4️⃣ Kondansatör Kontrolü'),
          _Madde('Seramik kondansatörler kısa devre yapabilir'),
          _Madde('Elektrolitik kondansatörler şişebilir/akabilir'),
          _Madde('Şüpheli kondansatörleri tek tek ölç'),

          SizedBox(height: 8),

          _AltBaslik('📏 Multimetre ile'),
          _Madde('Direnç ölç → iki uç kısa mı?'),
          _Madde('Besleme hattındaki kondansatörler özellikle kontrol edilir'),

          SizedBox(height: 16),

          _Baslik('🔌 5️⃣ Diyot – MOSFET – Transistör Kontrolü'),
          _Madde('Diyotlar diyot modunda tek yön iletmeli'),
          _Madde('Her iki yönde iletim → diyot bozuk'),
          _Madde('MOSFET D–S kısa devre kontrolü yapılır'),
          _Madde('Gate hattında kısa olmamalı'),

          SizedBox(height: 16),

          _Baslik('🧠 6️⃣ Entegre (IC) Mantığı'),
          _Madde('Entegreye besleme geliyor mu?'),
          _Madde('Besleme var ama çıkış yok → entegre arızalı olabilir'),
          _Madde('Entegre aşırı ısınıyor mu?'),
          _Madde('Datasheet bulunabiliyorsa pinout kontrolü yapılır'),

          _Uyari(
            'Entegre değişimi en son aşamadır. Önce etrafındaki pasifleri kontrol et.',
          ),

          SizedBox(height: 16),

          _Baslik('🔁 7️⃣ Hat Takibi (Continuity / Süreklilik)'),
          _Madde('Multimetreyi süreklilik (buzzer) moduna al'),
          _Madde('Kopuk PCB yollarını tespit et'),
          _Madde('Soket → entegre → çıkış hattı sürekliliğini ölç'),
          _Madde('Kırık via (delik geçiş) çok sık arıza sebebidir'),

          SizedBox(height: 16),

          _Baslik('🔥 8️⃣ Isı ile Arıza Bulma (Tecrübe Seviyesi)'),
          _Madde('Arızalı entegre genelde aşırı ısınır'),
          _Madde('Parmak testi (DİKKATLİ!) veya termal kamera'),
          _Madde('Soğuk sprey ile tepki kontrolü yapılabilir'),

          SizedBox(height: 16),

          _Baslik('📋 9️⃣ Sistematik Arıza Akışı (Özet)'),
          _Madde('Gözle kontrol'),
          _Madde('Besleme var mı?'),
          _Madde('Kısa devre var mı?'),
          _Madde('Regülatör çıkışları'),
          _Madde('Pasifler (R, C, D)'),
          _Madde('Aktifler (MOSFET, IC)'),
          _Madde('Hat kopukluğu'),

          SizedBox(height: 16),

          _Info(
            title: '💡 Altın Kural',
            body:
                'Elektronik tamirde hız değil DOĞRU SIRA kazandırır.\n'
                'Besleme çözülmeden sinyal aranmaz.\n'
                'Kısa devre bulunmadan entegre değiştirilmez.',
          ),

          SizedBox(height: 16),

          _Uyari(
            '220V ile çalışan kartlarda izolasyon ve güvenlik önlemleri alınmadan ölçüm yapma.',
          ),
        ],
      ),
    );
  }
}

/* ====== UI BİLEŞENLERİ ====== */

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
      child: Text('• $text'),
    );
  }
}

class _Uyari extends StatelessWidget {
  final String text;
  const _Uyari(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent),
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

class _Info extends StatelessWidget {
  final String title;
  final String body;
  const _Info({required this.title, required this.body});

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
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(body),
          ],
        ),
      ),
    );
  }
}
