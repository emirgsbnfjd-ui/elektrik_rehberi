import 'package:flutter/material.dart';

class ArizaPrizdeElektrikYokSayfa extends StatelessWidget {
  const ArizaPrizdeElektrikYokSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔌 Prizde Elektrik Yok')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Bolum(
            title: '🚨 Önce Güvenlik',
            items: [
              'Prizi sökme/açma işlemlerinde enerjiyi mutlaka kes.',
              'Yanık kokusu, erime, kıvılcım varsa o hattın sigortasını indir.',
              'Emin değilsen müdahale etme (özellikle buat ve pano içinde).',
            ],
          ),

          _Bolum(
            title: '🔍 Olası Nedenler',
            items: [
              'İlgili sigorta kapalı/atmış olabilir (aynı hattın diğer prizlerini de etkiler).',
              'Priz klemensinde gevşek faz/nötr bağlantısı.',
              'Buat içinde kopuk/gevşek ek (özellikle sonradan yapılan ekler).',
              'Yanmış priz veya erimiş klemens (yük altında ısınma).',
              'Nötr kopukluğu (bazı prizlerde “garip” voltajlar / cihazların çalışmaması).',
              'Şalterli prizde anahtar arızası veya kapalı konumda kalması.',
              'Kablo ezilmesi/çivi teması (duvar içinde hasar).',
            ],
          ),

          _Bolum(
            title: '🧠 Hızlı Teşhis (Belirti → Olası Sebep)',
            items: [
              'Aynı odada tüm prizler yoksa: sigorta/hat sorunu ihtimali.',
              'Sadece tek priz yoksa: o priz veya bir önceki buat bağlantısı.',
              'Işık var priz yoksa: farklı hat olabilir veya priz hattı kopuk.',
              'Bazı cihaz çalışıyor bazıları çalışmıyorsa: gevşek bağlantı/nötr kopuğu ihtimali.',
              'Ara ara geliyorsa: klemens gevşekliği (ısınma-genleşme) ihtimali.',
            ],
          ),

          _Bolum(
            title: '🛠 Kontrol Sırası (En Mantıklı Adımlar)',
            items: [
              '1) Panodan ilgili sigortayı kontrol et (atmış mı / kapalı mı).',
              '2) Aynı hattın diğer prizlerini dene (hat hat ayırma).',
              '3) Şalterli prizse kapat-aç yap ve çalışıp çalışmadığını dene.',
              '4) Farklı bir cihaz/telefon şarjı ile dene (cihaz arızasını elemek için).',
              '5) Eğer tek priz sorunsa: priz kapağı çevresinde ısınma/kararma var mı kontrol et.',
              '6) Yakındaki priz/anahtar/buat bölgelerinde gevşeklik belirtisi var mı gözle kontrol et.',
            ],
          ),

          _Bolum(
            title: '📏 Basit Ölçüm Bilgisi (Eminsen)',
            items: [
              'Prizde normalde Faz–Nötr ≈ 230V, Faz–Toprak ≈ 230V görülür.',
              'Nötr kopuğunda bazen “var gibi” ölçüm çıkabilir ama yük bağlayınca düşer.',
              'Ölçüm yaparken yalıtımlı problar kullan, tek elle çalış, zeminin kuru olsun.',
              'Emin değilsen ölçüm yapma.',
            ],
          ),

          _Bolum(
            title: '🔥 En Sık Saha Arızaları',
            items: [
              'Uzatma kablosu/çoklu priz ile yüksek yük → priz klemensi ısınır ve gevşer.',
              'Buat içinde bantlı ek → zamanla gevşer/oksitlenir, temas kaybı olur.',
              'Priz arkasında gevşek vida → bir süre sonra tamamen keser.',
              'Duvara montaj sırasında kablo hasarı (çivi/dübel) → zamanla kopma.',
              'Eski prizlerde yaylı kontak zayıflaması → fiş tam temas etmez.',
            ],
          ),

          _Bolum(
            title: '❌ Yapılmaması Gerekenler',
            items: [
              'Enerji varken prizi sökmek/bağlantı kurcalamak.',
              'Yanık/erime görmüş prizi kullanmaya devam etmek.',
              '“Bir şekilde çalışıyor” diye gevşek bağlantıyı önemsememek (yangın riski).',
              'Sigorta atmıyor diye güvenli sanmak (gevşek bağlantı çok tehlikelidir).',
            ],
          ),

          _Bolum(
            title: '⚠️ Ne zaman elektrikçi?',
            items: [
              'Nötr kopukluğu şüphesi varsa (özellikle birden fazla priz etkileniyorsa).',
              'Prizde ısınma/yanık izi/erime varsa.',
              'Pano ve hat hakkında emin değilsen.',
              'Sorun ara ara oluyorsa (gevşek klemens ihtimali yüksek).',
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
