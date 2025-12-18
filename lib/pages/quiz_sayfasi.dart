import 'package:flutter/material.dart';

class QuizSayfasi extends StatefulWidget {
  const QuizSayfasi({super.key});

  @override
  State<QuizSayfasi> createState() => _QuizSayfasiState();
}

class _QuizSayfasiState extends State<QuizSayfasi> {
  // ✅ 100 soru buradan yüklenecek 
  late List<_Soru> sorular;

  int index = 0;
  int dogru = 0;
  int yanlis = 0;
  int gecilen = 0;

  int? secilen;
  bool cevaplandi = false;

  @override
  void initState() {
    super.initState();
    sorular = List<_Soru>.from(_sorular100)..shuffle(); // ✅ karışık başlat
  }

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

  void gec() {
    // cevap vermeden geç
    if (index < sorular.length - 1) {
      setState(() {
        gecilen++;
        index++;
        secilen = null;
        cevaplandi = false;
      });
    } else {
      setState(() {
        gecilen++;
        index++; // bitti ekranı
      });
    }
  }
  void erkenBitir() {
  setState(() {
    // kalanları geçilen say
    gecilen += (sorular.length - index);
    index = sorular.length; // direkt sonuç ekranı
    secilen = null;
    cevaplandi = false;
    });
  }
 
  void bastan() {
    setState(() {
      sorular.shuffle(); // ✅ her seferinde karışsın
      index = 0;
      dogru = 0;
      yanlis = 0;
      gecilen = 0;
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
                    Text('⏭️ Geçilen: $gecilen'),
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
          OutlinedButton(
            onPressed: cevaplandi ? null : gec,
            child: const Text('Soruyu Geç'),
          ),
          const SizedBox(height: 8),        
          OutlinedButton.icon(
            onPressed: erkenBitir,
            icon: const Icon(Icons.flag),
            label: const Text('Testi Bitir'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: bastan,
            icon: const Icon(Icons.refresh),
            label: const Text('Sıfırla'),
          ),
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

// ✅ ŞİMDİLİK 3 SORU — sen burayı 100’e tamamlayacaksın
const List<_Soru> _sorular100 = [
  _Soru(
    soru: '3 fazlı sistemde faz-faz gerilimi yaklaşık kaç volttur?',
    secenekler: ['230 V', '400 V', '110 V', '690 V'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Diyotun temel görevi nedir?',
    secenekler: ['Akımı iki yönde iletmek', 'Tek yönde iletmek', 'Gerilimi yükseltmek', 'Frekansı artırmak'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'PLC’de girişler genelde hangi harfle gösterilir?',
    secenekler: ['Q', 'I', 'M', 'T'],
    dogruIndex: 1,
  ),
 _Soru(
    soru: 'Nikola Tesla en çok hangi akım sistemiyle ilişkilendirilir?',
    secenekler: ['DC (Doğru akım)', 'AC (Alternatif akım)', 'Sadece yüksek frekans DC', 'Pnömatik akım'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Michael Faraday’ın en temel katkılarından biri hangisidir?',
    secenekler: ['Elektromanyetik indüksiyon', 'Transistörün icadı', 'Lityum pil', 'Fiber optik'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: 'Faraday kafesi temel olarak neyi engeller/azaltır?',
    secenekler: ['Manyetik alanı tamamen yok eder', 'Elektrik alanı ve elektromanyetik girişimi azaltır', 'Suyu engeller', 'Isıyı engeller'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Manyetik alan değişimi bir bobinde ne oluşturur? (Faraday Yasası)',
    secenekler: ['Direnç', 'İndüklenen gerilim (EMK)', 'Cosφ', 'Toprak direnci'],
    dogruIndex: 1,
  ),
  _Soru(soru: 'Ev tesisatlarında yaygın kaçak akım rölesi hassasiyeti kaç mA’dır?', 
     secenekler: ['10 mA', '30 mA', '100 mA', '300 mA'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'Topraklama iletkeninin rengi hangisidir?', 
     secenekler: ['Mavi', 'Sarı-yeşil', 'Kahverengi', 'Kırmızı'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'Nötr iletken rengi genellikle hangisidir?', 
     secenekler: ['Mavi', 'Sarı-yeşil', 'Siyah', 'Kahverengi'], 
     dogruIndex: 0,
  ),
  _Soru(soru: 'cosφ neyi ifade eder?', 
     secenekler: ['Güç faktörü', 'Toprak direnci', 'Gerilim', 'Frekans'], 
     dogruIndex: 0,
  ),
  _Soru(soru: 'Parafudr (SPD) neye karşı koruma sağlar?', 
     secenekler: ['Aşırı akım', 'Kaçak akım', 'Gerilim darbeleri', 'Faz sırası'], 
     dogruIndex: 2,
  ),
  _Soru(soru: 'C tipi sigorta genelde hangi yüklerde tercih edilir?', 
     secenekler: ['Aydınlatma', 'Motorlu yükler', 'Zayıf akım', 'Ölçü aletleri'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'D tipi sigorta ne için daha uygundur?', 
     secenekler: ['Düşük ilk akım', 'Yüksek ilk kalkış akımı', 'Aydınlatma', 'Isıtıcı'],
     dogruIndex: 1,
  ),
  _Soru(soru: 'MCB ile MCCB farkı en çok neyle ilgilidir?', 
     secenekler: ['Renk', 'Akım kapasitesi/ayar', 'Kablo rengi', 'Frekans'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'Kompanzasyonun amacı nedir?', 
     secenekler: ['Gerilimi artırmak', 'Reaktif gücü azaltmak', 'Frekansı artırmak', 'Akımı artırmak'], 
     dogruIndex: 1,
  ),

  _Soru(soru: '1 kW kaç watt eder?', 
     secenekler: ['10 W', '100 W', '1000 W', '10.000 W'], 
     dogruIndex: 2,
  ),
  _Soru(soru: 'Tek faz aktif güç formülü hangisidir?', 
     secenekler: ['P=V/I', 'P=V·I·cosφ', 'P=I²/R', 'P=V²·R'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'Trifaze aktif güç formülü hangisidir?', 
     secenekler: ['P=V·I', 'P=√3·V·I·cosφ', 'P=V²/R', 'P=I/R'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'Gerilim düşümü en çok hangi parametre ile artar?', 
     secenekler: ['Hat uzunluğu', 'Sigorta tipi', 'RCD hassasiyeti', 'Etiket'], 
     dogruIndex: 0,
  ),
  _Soru(soru: 'Kesit büyütmek genelde neyi azaltır?', 
     secenekler: ['Frekans', 'Gerilim düşümü', 'Gerilim', 'Güç'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'Kontaktör ne için kullanılır?', 
     secenekler: ['Gerilim düşürmek', 'Uzaktan/sık aç-kapa', 'Topraklama yapmak', 'Kısa devre ölçmek'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'RCD (kaçak akım rölesi) neye göre açar?', 
     secenekler: ['Faz sırası', 'Akım farkı', 'Gerilim artışı', 'Frekans'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'TN-S sistemde PE ve N nasıl olur?', 
     secenekler: ['Birleşik', 'Ayrı', 'Hiç yok', 'Rastgele'],
     dogruIndex: 1,
  ),
  _Soru(soru: 'Kısa devre korumasını genelde kim sağlar?', 
     secenekler: ['RCD', 'Sigorta/MCB', 'SPD', 'Kondansatör'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'Aşırı gerilim darbelerinde ilk koruma elemanı hangisidir?', 
     secenekler: ['SPD', 'RCD', 'Kontaktör', 'Sayaç'], 
     dogruIndex: 0,
  ),
  _Soru(soru: 'Yükler dengeli trifazede nötr akımı neden küçülür?', 
     secenekler: ['Gerilim yüksek', 'Vektörel toplam sıfıra yakın', 'Toprak iyi', 'Faz sırası doğru'], 
     dogruIndex: 1
  ),
  _Soru(soru: 'B tipi sigorta daha çok nerede?', 
     secenekler: ['Aydınlatma/priz', 'Motor', 'Kaynak makinesi', 'Asansör'], 
     dogruIndex: 0,
  ),
  _Soru(soru: 'IP koruma sınıfında ilk rakam neyi gösterir?', 
     secenekler: ['Suya karşı', 'Katı cisim/toz', 'Isıya karşı', 'Şok'], 
     dogruIndex: 1
  ),
  _Soru(soru: 'IP koruma sınıfında ikinci rakam neyi gösterir?', 
     secenekler: ['Suya karşı', 'Toza karşı', 'Kablolamaya', 'Güce'], 
     dogruIndex: 0,
  ),
  _Soru(soru: 'Yıldız bağlantıda faz gerilimi nasıl bulunur?', 
     secenekler: ['Vfaz=Vhat', 'Vfaz=Vhat/√3', 'Vfaz=√3·Vhat', 'Vfaz=Vhat·cosφ'], 
     dogruIndex: 1
  ),

  _Soru(soru: 'Delta bağlantıda hat akımı ile faz akımı ilişkisi?', 
     secenekler: ['Ihat=Ifaz', 'Ihat=Ifaz/√3', 'Ihat=√3·Ifaz', 'Ihat=Ifaz·cosφ'], 
     dogruIndex: 2,
  ),
  _Soru(soru: 'Bir panoda bara ne iş yapar?', 
     secenekler: ['Ölçüm', 'Depolama', 'Dağıtım/kolay bağlantı', 'Akım düşürme'], 
     dogruIndex: 2,
  ),
  _Soru(soru: 'Enerji kesmeden bakım için hangi ekipman kullanılır?', 
     secenekler: ['SPD', 'Yük ayırıcı/şalter', 'RCD', 'Kondansatör'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'Termik manyetik şalterde “termik” neyi korur?', 
     secenekler: ['Kısa devre', 'Aşırı yük', 'Faz sırası', 'Kaçak akım'], 
     dogruIndex: 1,
  ),
  _Soru(soru: '“Manyetik” açma genelde ne içindir?', 
     secenekler: ['Aşırı yük', 'Kısa devre', 'Reaktif', 'Toprak'], 
     dogruIndex: 1,
  ),

  _Soru(soru: 'Kablo ısınmasının temel sebebi nedir?', 
     secenekler: ['V yüksek', 'I²R kaybı', 'cosφ yüksek', 'Frekans düşük'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'Bakırın avantajı?',
     secenekler: ['Ucuz', 'İyi iletkenlik', 'Hafif', 'Daha kalın'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'Alüminyum kabloda dikkat edilen risk?', 
     secenekler: ['Aşırı iletken', 'Gevşek bağlantıda ısınma', 'Hiç ısınmaz', 'Manyetik alan yok'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'Seçilen sigorta neden kablodan büyük olmamalı?', 
     secenekler: ['Gerilim artar', 'Kablo yanabilir', 'Sayaç bozulur', 'cosφ düşer'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'Faz sırası yanlış olursa trifaze motorda ne olur?', 
     secenekler: ['Durur', 'Ters döner', 'Gerilim düşer', 'cosφ artar'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'Direnç birimi nedir?', 
     secenekler: ['Volt', 'Ohm', 'Watt', 'Farad'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'Kondansatör birimi nedir?', 
     secenekler: ['Henry', 'Farad', 'Ohm', 'Watt'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'Bobin (indüktans) birimi nedir?', 
     secenekler: ['Henry', 'Farad', 'Ohm', 'Tesla'], 
     dogruIndex: 0,
  ),
  _Soru(soru: 'Diyot temel görevi nedir?', 
     secenekler: ['Akımı iki yönde iletmek', 'Tek yönde iletmek', 'Gerilimi yükseltmek', 'Gürültü azaltmak'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'Zener diyot genelde ne için kullanılır?',
     secenekler: ['Doğrultma', 'Gerilim referansı/regülasyon', 'Akım artırma', 'Frekans üretme'], 
     dogruIndex: 1,
  ),
  _Soru(soru: 'LED neyi ifade eder?', 
    secenekler: ['Light Emitting Diode', 'Low Energy Device', 'Linear Electric Diode', 'Light Energy Driver'], 
    dogruIndex: 0,
  ),
  _Soru(soru: 'Transistörün 3 bacağı genelde nedir (BJT)?', 
    secenekler: ['Gate-Drain-Source', 'Base-Collector-Emitter', 'A-K-G', 'Input-Output-GND'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'MOSFET’te kontrol ucu hangisidir?', 
    secenekler: ['Drain', 'Source', 'Gate', 'Emitter'], 
    dogruIndex: 2,
  ),
  _Soru(soru: 'Op-amp ne iş için sık kullanılır?', 
    secenekler: ['Mekanik anahtar', 'Sinyal yükseltme/işleme', 'Sigorta', 'Trafo'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'DC güç kaynağında “ripple” ne demektir?', 
    secenekler: ['Aşırı akım', 'Dalgalanma', 'Topraklama', 'Faz sırası'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Seri devrede akım nasıl olur?', 
    secenekler: ['Her yerde aynı', 'Bölünür', 'Sıfır olur', 'Artar'], 
    dogruIndex: 0,
  ),
  _Soru(soru: 'Paralel devrede gerilim nasıl olur?', 
    secenekler: ['Toplanır', 'Her kolda aynı', 'Sıfır', 'Rastgele'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Ohm kanunu hangisidir?', 
    secenekler: ['V=I/R', 'V=I·R', 'I=V·R', 'R=V·I'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Güç formülü hangisi?', 
    secenekler: ['P=V·I', 'P=V/I', 'P=I/R', 'P=R/I'], 
    dogruIndex: 0,
  ),
  _Soru(soru: 'Watt neyin birimidir?', 
    secenekler: ['Gerilim', 'Akım', 'Güç', 'Direnç'], 
    dogruIndex: 2,
  ),
  _Soru(soru: 'AC-DC dönüştürmede ilk aşama genelde nedir?', 
    secenekler: ['Filtre', 'Doğrultma', 'Regülasyon', 'Osilatör'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Kondansatör DC’de uzun süre ne yapabilir?', 
    secenekler: ['Açık devre', 'Kısa devre', 'Şarj tutar', 'Akım üretir'], 
    dogruIndex: 2,
  ),
  _Soru(
    soru: '“Tesla (T)” birimi neyin birimidir?',
    secenekler: ['Akım', 'Gerilim', 'Manyetik akı yoğunluğu', 'Direnç'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Elektrik motorlarında “dönen manyetik alan” hangi sistemle daha tipik oluşur?',
    secenekler: ['Tek faz', 'Trifaze', 'DC', 'Topraklama'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Alternatif akım (AC) sistemlerinde gerilim kolayca ne ile değiştirilebilir?',
    secenekler: ['Transistör', 'Trafo', 'RCD', 'Kondansatör bankı'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Faraday’ın indüksiyon deneyiyle en çok ilişkili eleman hangisidir?',
    secenekler: ['Diyot', 'Bobin ve mıknatıs', 'Sigorta', 'LED'],
    dogruIndex: 1,
  ),
  _Soru(soru: 'Kapasitör paralel bağlanırsa toplam kapasite nasıl değişir?', 
    secenekler: ['Azalır', 'Artar', 'Değişmez', 'Sıfır'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Direnç seri bağlanırsa toplam direnç?', 
    secenekler: ['Azalır', 'Artar', '0 olur', '∞ olur'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Direnç paralel bağlanırsa toplam direnç?', 
    secenekler: ['Azalır', 'Artar', 'Değişmez', '∞ olur'], 
    dogruIndex: 0,
  ),
  _Soru(soru: 'NPN transistörde iletime geçmesi için baz-emiter ne olmalı?', 
    secenekler: ['Ters polarmalı', 'İleri polarmalı', 'Açık devre', 'Kısa devre'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'PCB ne demektir?', 
    secenekler: ['Power Control Box', 'Printed Circuit Board', 'Phase Current Bridge', 'Passive Capacitor Block'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'ADC ne yapar?', 
    secenekler: ['Analogdan dijitale çevirir', 'Dijitalden analoğa', 'Akım ölçer', 'Gerilim üretir'], 
    dogruIndex: 0,
  ),
  _Soru(soru: 'DAC ne yapar?', 
    secenekler: ['Analogdan dijitale', 'Dijitalden analoğa', 'Güç artırır', 'Frekans düşürür'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'RMS neyi ifade eder?', 
    secenekler: ['Anlık değer', 'Etkili değer', 'Tepe değer', 'Ortalama değer'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Kısa devreye en yakın tanım hangisidir?', 
    secenekler: ['Yükün artması', 'Direncin çok düşmesi', 'cosφ yükselmesi', 'Gerilimin artması'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Dijital devrelerde mantık 1 genelde neye yakındır?', 
    secenekler: ['0V', 'Vcc', 'AC', 'Rastgele'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Breadboard ne için kullanılır?', 
    secenekler: ['Kalıcı montaj', 'Deneme/prototip', 'Topraklama', 'Sigorta'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'RC devresi ne içerir?', 
    secenekler: ['Direnç + kondansatör', 'Direnç + bobin', 'Bobin + diyot', 'Trafo + kondansatör'], 
    dogruIndex: 0,
  ),
  _Soru(soru: 'LC devresi ne içerir?', 
    secenekler: ['Direnç + kondansatör', 'Direnç + bobin', 'Bobin + kondansatör', 'Trafo + diyot'], 
    dogruIndex: 2,
  ),
  _Soru(soru: 'Osilatör ne üretir?', 
    secenekler: ['DC akım', 'Sürekli sinyal/dalga', 'Toprak', 'Kısa devre'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Diyot köprüsü kaç diyottan oluşur?', 
    secenekler: ['2', '3', '4', '6'], 
    dogruIndex: 2,
  ),
  _Soru(soru: 'Kapasitörün tehlikesi nedir?', 
    secenekler: ['Şarj tutup çarpabilir', 'Hiçbir şey', 'Gerilimi düşürür', 'Akımı artırır'], 
    dogruIndex: 0,
  ),
  _Soru(soru: 'Regülatör entegresi (ör: 7805) çıkışı genelde nedir?', 
    secenekler: ['5V', '12V', '230V', '400V'], 
    dogruIndex: 0,
  ),
  _Soru(soru: 'PWM ne işe yarar?', 
    secenekler: ['Frekans artırma', 'Ortalama gücü kontrol', 'Toprak ölçme', 'Sigorta atma'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'BJT ile MOSFET farkında MOSFET’in avantajı genelde nedir?', 
    secenekler: ['Baz akımı ister', 'Gate akımı çok az', 'Sadece AC', 'Sadece düşük güç'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Pull-up direnci ne işe yarar?', 
    secenekler: ['Sinyali 0V’a çeker', 'Sinyali Vcc’ye çeker', 'Kısa devre yapar', 'Akımı sonsuz yapar'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Kısa devre akımını sınırlayan en temel şey?', 
    secenekler: ['Direnç/empedans', 'Gerilim', 'cosφ', 'Renk'], 
    dogruIndex: 0,
  ),
  _Soru(soru: 'Sigorta neden “hızlı” veya “yavaş” seçilir?', 
    secenekler: ['Renk için', 'Başlangıç akımları için', 'Gerilim için', 'Toprak için'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Diyot ile LED farkı en basit?', 
    secenekler: ['LED ışık yayar', 'LED tek yön iletmez', 'LED AC iletir', 'LED dirençtir'], 
    dogruIndex: 0,
  ),
  _Soru(soru: 'PLC’de girişler genelde hangi harfle gösterilir?', 
    secenekler: ['Q', 'I', 'M', 'T'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'PLC’de çıkışlar genelde hangi harfle gösterilir?', 
    secenekler: ['I', 'Q', 'M', 'C'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Ladder (Merdiven) diyagramı en çok neye benzer?', 
    secenekler: ['Akış şeması', 'Röle kontakt devresi', 'PCB çizimi', 'Mekanik çizim'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Start-Stop devresinde “mühürleme” ne içindir?', 
    secenekler: ['Motoru ters döndürmek', 'Start bırakınca çalışmayı sürdürmek', 'Sigorta seçmek', 'Gerilim düşürmek'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Acil stop butonu genelde hangi kontakla kullanılır?', 
    secenekler: ['NO', 'NC', 'Her ikisi', 'Fark etmez'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'PLC’de “M” genelde neyi temsil eder?', 
    secenekler: ['Motor', 'Merker/yardımcı bit', 'Manyetik alan', 'Modem'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Timer (T) ne için kullanılır?', 
    secenekler: ['Sayı saymak', 'Zaman gecikmesi', 'Analog ölçmek', 'Hız ölçmek'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Counter (C) ne için kullanılır?', 
    secenekler: ['Zaman', 'Sayma', 'Gerilim', 'Toprak'], 
    dogruIndex: 1,
  ),
   _Soru(soru: 'Sensörler en temel olarak neyi algılar?', 
    secenekler: ['Enerji', 'Fiziksel büyüklük', 'Sigorta', 'Topraklama'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Proximity (endüktif) sensör ne algılar?', 
    secenekler: ['Metal', 'Su', 'Işık', 'Sıcaklık'], 
    dogruIndex: 0,
  ),
  _Soru(soru: 'PNP sensör çıkışı genel olarak nasıl davranır?', 
    secenekler: ['0V verir', '+V verir', 'AC verir', 'Rastgele'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'NPN sensör çıkışı genel olarak nasıl davranır?', 
    secenekler: ['+V verir', '0V’a çeker', 'AC verir', 'Rastgele'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'VFD (sürücü/inverter) temel amacı nedir?', 
    secenekler: ['Gerilim üretmek', 'Motor hız kontrolü', 'Toprak ölçmek', 'Aydınlatma'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'VFD’de frekans artarsa asenkron motor hızı genelde nasıl değişir?', 
    secenekler: ['Azalır', 'Artar', 'Değişmez', 'Sıfır olur'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'HMI ne demektir?', 
    secenekler: ['Human Machine Interface', 'High Motor Input', 'Heat Module Indicator', 'Hybrid Machine Internet'], 
    dogruIndex: 0,
  ),
  _Soru(soru: 'SCADA sistemi genelde ne yapar?', 
    secenekler: ['Saha gözetleme/izleme-kontrol', 'Kablo çekme', 'Sigorta seçme', 'Motor sarma'], 
    dogruIndex: 0,
  ),
  _Soru(soru: 'PID kontrol genelde neyi düzenler?', 
    secenekler: ['Sıcaklık/basınç/hız gibi süreç', 'Kablo kesiti', 'Toprak direnci', 'Faz sırası'], 
    dogruIndex: 0,
  ),
  _Soru(soru: 'Analog giriş örneği hangisi?', 
    secenekler: ['0-10V', 'Start butonu', 'Limit switch', 'NC kontak'], 
    dogruIndex: 0,
  ),
  _Soru(soru: 'Dijital giriş örneği hangisi?', 
    secenekler: ['4-20mA', '0-10V', 'Buton', 'Termokupl'],
     dogruIndex: 2,
  ),
  _Soru(soru: '4-20 mA sinyalinin avantajı genelde nedir?', 
    secenekler: ['Kablosuz', 'Parazite dayanıklı', 'Yüksek voltaj', 'Ucuz'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Emniyet rölesi ne için kullanılır?', 
    secenekler: ['Reaktif', 'Güvenlik devreleri', 'Aydınlatma', 'Şarj'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Start butonu genelde hangi kontaktır?', 
    secenekler: ['NC', 'NO', 'Klemmens', 'RCD'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Stop butonu genelde hangi kontaktır?', 
    secenekler: ['NO', 'NC', 'Analog', 'PWM'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Kontaktör bobini genelde hangi uçlarla gösterilir?', 
    secenekler: ['L-N', 'A1-A2', 'U-V-W', 'R-S-T'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Termik röle en çok neyi korur?', 
    secenekler: ['Kısa devre', 'Aşırı yük', 'Kaçak akım', 'Faz sırası'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Yıldız-üçgen yol verme neden yapılır?', 
    secenekler: ['Hızı artırmak', 'Kalkış akımını azaltmak', 'cosφ artırmak', 'Gerilimi yükseltmek'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Frekans konvertörü hangi parametreyi değiştirerek hız kontrol eder?', 
    secenekler: ['Akım', 'Frekans', 'Renk', 'Toprak'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'Ladder’da paralel kontaklar genelde ne anlama gelir?', 
    secenekler: ['OR', 'AND', 'NOT', 'XOR'], 
    dogruIndex: 0,
  ),
  _Soru(soru: 'Ladder’da seri kontaklar genelde ne anlama gelir?', 
    secenekler: ['OR', 'AND', 'NOT', 'XOR'], 
    dogruIndex: 1,
  ),
  _Soru(soru: 'PLC’de “RET/END” neyi belirtir?', 
    secenekler: ['Döngü', 'Program sonu', 'Başlangıç', 'Kesme'], 
    dogruIndex: 1,
  ),
];
