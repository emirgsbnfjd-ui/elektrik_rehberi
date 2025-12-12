import 'package:flutter/material.dart';

class QuizSayfasi extends StatefulWidget {
  const QuizSayfasi({super.key});

  @override
  State<QuizSayfasi> createState() => _QuizSayfasiState();
}

class _QuizSayfasiState extends State<QuizSayfasi> {
  // 30 soru
  final List<_Soru> sorular = const [
    _Soru(
      soru: '3 fazlı sistemde faz-faz gerilimi yaklaşık kaç volttur?',
      secenekler: ['230 V', '400 V', '110 V', '690 V'],
      dogruIndex: 1,
    ),
    _Soru(
      soru: 'Kaçak akım rölesi (RCD) hangi duruma karşı koruma sağlar?',
      secenekler: ['Kısa devre', 'Aşırı akım', 'Elektrik çarpması / kaçak akım', 'Faz sırası'],
      dogruIndex: 2,
    ),
    _Soru(
      soru: 'C tipi otomatik sigorta genelde nerelerde kullanılır?',
      secenekler: ['Aydınlatma devresi', 'Elektronik devreler', 'Motorlu yükler', 'Zayıf akım sistemleri'],
      dogruIndex: 2,
    ),
    _Soru(
      soru: 'kW birimi neyi ifade eder?',
      secenekler: ['Akım', 'Gerilim', 'Aktif güç', 'Reaktif güç'],
      dogruIndex: 2,
    ),
    _Soru(
      soru: 'Parafudr (SPD) neye karşı koruma sağlar?',
      secenekler: ['Aşırı akım', 'Toprak kaçağı', 'Gerilim darbeleri', 'Faz hatası'],
      dogruIndex: 2,
    ),
    _Soru(
      soru: 'Ev tesisatlarında yaygın kullanılan kaçak akım hassasiyeti kaç mA’dır?',
      secenekler: ['10 mA', '30 mA', '100 mA', '300 mA'],
      dogruIndex: 1,
    ),
    _Soru(
      soru: 'Topraklama hattının rengi hangisidir?',
      secenekler: ['Mavi', 'Kahverengi', 'Sarı-yeşil', 'Siyah'],
      dogruIndex: 2,
    ),
    _Soru(
      soru: '1 fazlı bir hatta 230 V bulunmasının sebebi nedir?',
      secenekler: ['Faz-faz gerilimi', 'Faz-nötr gerilimi', 'Toprak-nötr', 'Jeneratör çıkışı'],
      dogruIndex: 1,
    ),
    _Soru(
      soru: 'Motorlarda yüksek ilk kalkış akımı için hangi sigorta eğrisi uygundur?',
      secenekler: ['B', 'C', 'D', 'Z'],
      dogruIndex: 2,
    ),
    _Soru(
      soru: 'Kompanzasyonun temel amacı nedir?',
      secenekler: ['Akımı artırmak', 'Gerilimi sabitlemek', 'Reaktif gücü azaltmak', 'Frekansı ayarlamak'],
      dogruIndex: 2,
    ),
    _Soru(
      soru: 'cosφ değeri neyi ifade eder?',
      secenekler: ['Gerilim düşümü', 'Güç faktörü', 'Akım katsayısı', 'Toprak direnci'],
      dogruIndex: 1,
    ),
    _Soru(
      soru: 'Bir sigortanın anma akımı neyi ifade eder?',
      secenekler: ['Anlık akımı', 'Kısa devre akımını', 'Sürekli taşıyabileceği akımı', 'Kaçak akımı'],
      dogruIndex: 2,
    ),
    _Soru(
      soru: 'Bakır kablonun alüminyuma göre avantajı nedir?',
      secenekler: ['Daha ucuz', 'Daha hafif', 'Daha iyi iletkenlik', 'Daha kalın'],
      dogruIndex: 2,
    ),
    _Soru(
      soru: 'Gerilim düşümü en çok hangi faktörden etkilenir?',
      secenekler: ['Sigorta tipi', 'Hat uzunluğu', 'Topraklama', 'Faz sırası'],
      dogruIndex: 1,
    ),
    _Soru(
      soru: 'Bir hatta kesit neden büyütülür?',
      secenekler: ['Gerilimi artırmak', 'Akımı azaltmak', 'Gerilim düşümünü azaltmak', 'Frekansı sabitlemek'],
      dogruIndex: 2,
    ),
    _Soru(
      soru: '3 fazlı sistemde nötr akımı bazen neden sıfıra yakındır?',
      secenekler: ['Gerilim düşük', 'Yükler dengeli', 'Topraklama iyi', 'Faz sırası doğru'],
      dogruIndex: 1,
    ),
    _Soru(
      soru: 'Elektrik panosunda ana şalterin görevi nedir?',
      secenekler: ['Aydınlatmayı açmak', 'Tüm sistemi enerjisiz bırakmak', 'Kaçak akımı algılamak', 'Gerilim düzenlemek'],
      dogruIndex: 1,
    ),
    _Soru(
      soru: 'EV şarj istasyonları neden “sürekli yük” kabul edilir?',
      secenekler: ['Yüksek gerilim', 'Uzun süre tam güç', 'DC olduğu için', 'Taşınabilir'],
      dogruIndex: 1,
    ),
    _Soru(
      soru: 'Elektrik çarpmasında en tehlikeli durum hangisidir?',
      secenekler: ['El-toprak', 'El-el', 'El-ayak', 'Tüm vücuttan akım geçmesi'],
      dogruIndex: 3,
    ),
    _Soru(
      soru: 'MCB ile MCCB arasındaki temel fark nedir?',
      secenekler: ['Renkleri', 'Akım kapasiteleri', 'Gerilimleri', 'Topraklama şekli'],
      dogruIndex: 1,
    ),
    _Soru(
      soru: 'Etiketleme neden önemlidir?',
      secenekler: ['Görsel amaç', 'Enerji tasarrufu', 'Bakım ve güvenlik', 'Faz artırmak'],
      dogruIndex: 2,
    ),
    _Soru(
      soru: 'Yıldırıma açık bölgelerde en çok hangi ekipman önerilir?',
      secenekler: ['RCD', 'MCB', 'SPD', 'Kontaktör'],
      dogruIndex: 2,
    ),
    _Soru(
      soru: 'Kontaktör ne için kullanılır?',
      secenekler: ['Gerilim düşürmek', 'Uzaktan/sık aç-kapa', 'Topraklama', 'Kısa devre koruması'],
      dogruIndex: 1,
    ),
    _Soru(
      soru: 'Aydınlatma devrelerinde genelde hangi sigorta eğrisi tercih edilir?',
      secenekler: ['B', 'C', 'D', 'K'],
      dogruIndex: 0,
    ),
    _Soru(
      soru: 'Sigorta neden kablodan büyük seçilmemelidir?',
      secenekler: ['Gerilim düşer', 'Kablo yanabilir', 'Sayaç bozulur', 'Toprak kaçağı olur'],
      dogruIndex: 1,
    ),
    _Soru(
      soru: 'Faz sırası yanlış olursa ne olur?',
      secenekler: ['Gerilim düşer', 'Motor ters döner', 'Sigorta atar', 'Kaçak akım olur'],
      dogruIndex: 1,
    ),
    _Soru(
      soru: 'Reaktif ceza genelde neden oluşur?',
      secenekler: ['Kısa devre', 'Düşük gerilim', 'Düşük cosφ', 'Faz eksikliği'],
      dogruIndex: 2,
    ),
    _Soru(
      soru: 'Nötr iletken rengi genelde hangisidir?',
      secenekler: ['Mavi', 'Sarı-yeşil', 'Kahverengi', 'Kırmızı'],
      dogruIndex: 0,
    ),
    _Soru(
      soru: 'Faz iletkeni (L) renkleri genelde hangileridir?',
      secenekler: ['Sarı-yeşil', 'Mavi', 'Kahverengi/Siyah/Gri', 'Beyaz'],
      dogruIndex: 2,
    ),
    _Soru(
      soru: 'Bir panoda bara ne işe yarar?',
      secenekler: ['Ölçüm yapmak', 'Gücü depolamak', 'Dağıtım/kolay bağlantı', 'Akımı düşürmek'],
      dogruIndex: 2,
    ),
  ];

  int index = 0;
  int dogru = 0;
  int yanlis = 0;

  int? secilen;
  bool cevaplandi = false;

  void secenekSec(int i) {
    if (cevaplandi) return;

    final dogruMu = i == sorular[index].dogruIndex;

    setState(() {
      secilen = i;
      cevaplandi = true;
      if (dogruMu) {
        dogru++;
      } else {
        yanlis++;
      }
    });
  }

  void sonraki() {
    if (!cevaplandi) return;

    if (index < sorular.length - 1) {
      setState(() {
        index++;
        secilen = null;
        cevaplandi = false;
      });
    } else {
      setState(() {
        index++; // bitti ekranı
      });
    }
  }

  void bastan() {
    setState(() {
      index = 0;
      dogru = 0;
      yanlis = 0;
      secilen = null;
      cevaplandi = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final toplam = sorular.length;

    // Bitti ekranı
    if (index >= toplam) {
      final net = dogru - yanlis;
      final oran = toplam == 0 ? 0 : (dogru / toplam * 100);

      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Quiz Bitti 🎉',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    Text('Toplam Soru: $toplam'),
                    Text('✅ Doğru: $dogru'),
                    Text('❌ Yanlış: $yanlis'),
                    Text('📌 Net: $net'),
                    Text('🎯 Başarı: ${oran.toStringAsFixed(1)}%'),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: bastan, child: const Text('Baştan Başla')),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final s = sorular[index];

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Soru: ${index + 1} / $toplam'),
                  Text('✅ $dogru  ❌ $yanlis'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                s.soru,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),

          ...List.generate(s.secenekler.length, (i) {
            Color? bg;
            if (cevaplandi) {
              if (i == s.dogruIndex) {
                bg = Colors.green.withOpacity(0.15);
              } else if (secilen == i && secilen != s.dogruIndex) {
                bg = Colors.red.withOpacity(0.15);
              }
            }

            return Card(
              color: bg,
              child: ListTile(
                onTap: () => secenekSec(i),
                title: Text(s.secenekler[i]),
                leading: CircleAvatar(child: Text(String.fromCharCode(65 + i))),
                trailing: cevaplandi
                    ? (i == s.dogruIndex
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : (secilen == i
                            ? const Icon(Icons.cancel, color: Colors.red)
                            : null))
                    : null,
              ),
            );
          }),

          const SizedBox(height: 12),

          FilledButton(
            onPressed: cevaplandi ? sonraki : null,
            child: Text(index == toplam - 1 ? 'Bitir' : 'Sonraki'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: bastan, child: const Text('Sıfırla')),
        ],
      ),
    );
  }
}

class _Soru {
  final String soru;
  final List<String> secenekler;
  final int dogruIndex;

  const _Soru({
    required this.soru,
    required this.secenekler,
    required this.dogruIndex,
  });
}
