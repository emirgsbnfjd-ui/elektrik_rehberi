import 'package:flutter/material.dart';
import '../ad/banner_ad_widget.dart';


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
    bool isDark = Theme.of(context).brightness == Brightness.dark;

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
                  Text('Karışık Soru: ${index + 1} / $toplam'),
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


          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E252D) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
                width: 1.0,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const OverflowBox(
                minHeight: 50,
                maxHeight: 50,
                child: AdBanner(),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ], // ListView'un children listesi burada bitiyor
      ),
    );
  } // build metodunun kapanış parantezi
} //

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
    soru: 'Elektrik yükünün birimi hangisidir?',
    secenekler: ['Volt (V)', 'Ohm (Ω)', 'Watt (W)', 'Coulomb (C)'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'Akım birimi hangisidir?',
    secenekler: ['Watt (W)', 'Amper (A)', 'Volt (V)', 'Henry (H)'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Gerilim birimi hangisidir?',
    secenekler: ['Farad (F)', 'Watt (W)', 'Amper (A)', 'Volt (V)'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'Frekans birimi hangisidir?',
    secenekler: ['Ohm (Ω)', 'Watt (W)', 'Hertz (Hz)', 'Tesla (T)'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Güç faktörü cosφ hangi aralıkta olur?',
    secenekler: ['0 ile 1 arasında', '-1 ile 0 arasında', '0 ile 100 arasında', '1 ile 2 arasında'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: 'Kısa devre akımı artınca koruma elemanının temel amacı nedir?',
    secenekler: ['Cosφ’yi düzeltmek', 'Frekansı artırmak', 'Devreyi hızlıca açmak', 'Gerilimi yükseltmek'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: '230 V şebeke gerilimi genelde hangi değeri ifade eder?',
    secenekler: ['Ortalama değer', 'Tepe değer', 'RMS (etkili) değer', 'Anlık değer'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Sinüzoidal AC’de tepe değer ile RMS değeri arasındaki ilişki yaklaşık nasıldır?',
    secenekler: ['Vtepe ≈ Vrms', 'Vtepe ≈ 0.707 · Vrms', 'Vtepe ≈ 2 · Vrms', 'Vtepe ≈ 1.414 · Vrms'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: '50 Hz şebekede bir periyot süresi yaklaşık kaç ms’dir?',
    secenekler: ['10 ms', '50 ms', '20 ms', '2 ms'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'kWh en iyi hangi büyüklüğü ifade eder?',
    secenekler: ['Anlık gücü', 'Direnci', 'Akımı', 'Enerji tüketimini'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'Bir cihazın etiketi 1000 W ise bu neyi belirtir?',
    secenekler: ['Direncini', 'Topraklama değerini', 'Çalışırken çektiği yaklaşık gücü', 'Ürettiği gerilimi'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Güç üçgeninde aktif güç genelde hangi harfle gösterilir?',
    secenekler: ['P', 'Q', 'S', 'Z'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: 'Güç üçgeninde reaktif güç genelde hangi harfle gösterilir?',
    secenekler: ['R', 'Q', 'P', 'S'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Güç üçgeninde görünür güç genelde hangi harfle gösterilir?',
    secenekler: ['S', 'I', 'P', 'Q'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: 'Trafo primer ve sekonder arasında ne sağlayabilir?',
    secenekler: ['Galvanik izolasyon', 'Topraklamayı yok etme', 'Sigorta görevi', 'Faz sayısını artırma'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: 'Trafolarda gerilim dönüşüm oranı en çok neye bağlıdır?',
    secenekler: ['Toprak direncine', 'Sigorta tipine', 'Kablo rengine', 'Sargı (sarım) sayısı oranına'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'İzolasyon trafosu en çok hangi amaçla kullanılır?',
    secenekler: ['Elektriksel izolasyon ve güvenlik', 'Gerilimi 400 V yapmak', 'Frekansı 60 Hz yapmak', 'Reaktif gücü artırmak'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: 'Oto trafo ile izolasyon trafosu arasındaki temel fark nedir?',
    secenekler: ['Oto trafoda frekans değişir', 'Oto trafoda ortak sargı bulunur', 'Oto trafoda yalnızca 24 V çıkar', 'İzolasyon trafosu DC üretir'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Eşpotansiyel bara temel olarak neyi sağlar?',
    secenekler: ['Akımı sıfırlar', 'Potansiyel farklarını azaltır', 'Frekansı artırır', 'Gerilimi yükseltir'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Topraklama direncinin düşük olması neyi iyileştirir?',
    secenekler: ['Korumanın doğru çalışmasını ve güvenliği', 'Gerilimi yükseltmeyi', 'Kablo kesitini büyütmeyi', 'Harmonikleri artırmayı'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: 'PE iletkeninin ana görevi nedir?',
    secenekler: ['Gövde kaçaklarını toprağa iletmek', 'Frekansı ayarlamak', 'Cosφ’yi ölçmek', 'Yüke enerji vermek'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: 'Nötr ile toprak aynı şey midir?',
    secenekler: ['Sadece trifazede aynıdır', 'Evet, her zaman aynıdır', 'Hayır, görevleri farklıdır', 'Sadece DC’de aynıdır'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'TT sistemde koruma topraklaması genelde ne ile sağlanır?',
    secenekler: ['Tesisin kendi toprak elektrodu ile', 'Nötr üzerinden', 'Faz üzerinden', 'Sadece SPD ile'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: 'RCD ile MCB’nin temel farkı nedir?',
    secenekler: ['İkisi de sadece gerilime bakar', 'MCB sadece kaçak akıma bakar', 'RCD sadece frekansa bakar', 'RCD kaçak akıma, MCB aşırı akım/kısa devreye bakar'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'RCD’nin test (T) butonu ne amaçla kullanılır?',
    secenekler: ['Cosφ’yi artırmak', 'Sigortayı büyütmek', 'Açma mekanizmasını kontrol etmek', 'Topraklamayı iptal etmek'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Selektivite (seçicilik) ne demektir?',
    secenekler: ['Gerilimin sabit kalması', 'Arızaya en yakın korumanın önce açması', 'Frekansın yükselmesi', 'Tüm korumaların aynı anda açması'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Termik rölede \'trip class\' (ör. 10/20) neyi ifade eder?',
    secenekler: ['Kablo rengini', 'Aşırı yükte açma süresi karakteristiğini', 'Gerilim seviyesini', 'Frekansı'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Bir kesicinin kA değeri neyi ifade eder?',
    secenekler: ['Çalışma frekansını', 'Kablo kesitini', 'Kısa devre kesme kapasitesini', 'Toprak direncini'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Kablo kesiti seçerken en kritik kriterlerden biri hangisidir?',
    secenekler: ['Taşıyacağı akım ve ısınma', 'Etiket yazısı', 'Kablo rengi', 'Klemensin markası'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: 'Kablo uzunluğu arttıkça en çok hangi sorun büyür?',
    secenekler: ['Frekans artışı', 'Cosφ artışı', 'Topraklama renginin değişmesi', 'Gerilim düşümü'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'Klemenslerde gevşek bağlantı en çok neye yol açar?',
    secenekler: ['Cosφ’nin artmasına', 'Gerilimin sabitlenmesine', 'Isınma ve ark riski', 'Frekansın düşmesine'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Nötr kopması hangi riski doğurabilir?',
    secenekler: ['Dengesiz yüklerde aşırı/az gerilim', 'Harmonikleri yok eder', 'Kısa devreyi azaltır', 'Topraklamayı güçlendirir'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: 'Kablo ekranı (shield) en çok neyi azaltmaya yardım eder?',
    secenekler: ['EMI/parazit etkilerini', 'Akımı artırmayı', 'Gerilimi yükseltmeyi', 'Toprak direncini yükseltmeyi'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: 'Pens ampermetre en çok hangi ölçüm için pratik bir araçtır?',
    secenekler: ['Direnç ölçümü', 'Kapasite ölçümü', 'Toprak direnci ölçümü', 'Akım ölçümü'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'Megger (izolasyon ölçer) en çok neyi ölçer?',
    secenekler: ['Kısa devre akımını', 'İzolasyon direncini (MΩ)', 'Frekansı', 'Cosφ’yi'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Faz sırası ölçer cihazı ne işe yarar?',
    secenekler: ['Toprak direncini artırır', 'Sigortayı büyütür', 'Kaçak akımı ölçer', 'Motorun dönüş yönünü belirlemeye yardım eder'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'Asenkron motorlarda \'kayma (slip)\' neyi ifade eder?',
    secenekler: ['Toprak direnci farkını', 'Kablo kesiti farkını', 'Senkron hız ile rotor hızı farkını', 'Sigorta akımı farkını'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Motor termiği çok yüksek ayarlanırsa risk nedir?',
    secenekler: ['RCD’nin iptal olması', 'Frekansın sabitlenmesi', 'Gerilim düşümünün azalması', 'Aşırı yükte motorun zarar görmesi'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'Kontaktör yardımcı kontağı (13-14) en çok ne için kullanılır?',
    secenekler: ['Kaçak akım koruması', 'Kısa devre koruması', 'Mühürleme/geri bildirim', 'Gerilim regülasyonu'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Harmonikler en çok hangi tür yüklerle artar?',
    secenekler: ['Sadece motorlarla', 'Doğrultucu/SMPS gibi doğrusal olmayan yüklerle', 'Saf dirençli ısıtıcılarla', 'Toprak elektroduyla'],
    dogruIndex: 1,
  ),
   _Soru(
    soru: 'RJ45 konnektör en çok hangi kablo türüyle kullanılır?',
    secenekler: ['Koaksiyel kablo', 'Fiber optik kablo', 'Bükümlü çift (UTP)', 'Tek damarlı bakır'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'RJ11 konnektör genellikle hangi sistemde kullanılır?',
    secenekler: ['Ethernet ağı', 'Telefon hattı', 'Uydu sistemi', 'Kamera sistemi'],
    dogruIndex: 1,
  ),

  _Soru(
    soru: 'RJ45 T568B standardında 1. ve 2. pinler hangi renktedir?',
    secenekler: ['Turuncu-beyaz / Turuncu', 'Yeşil-beyaz / Yeşil', 'Mavi-beyaz / Mavi', 'Kahverengi-beyaz / Kahverengi'],
    dogruIndex: 0,
  ),

  _Soru(
    soru: 'IP kameralar görüntüyü hangi altyapı üzerinden iletir?',
    secenekler: ['RF sinyali', 'Telefon hattı', 'Network (Ethernet)', 'Uydu'],
    dogruIndex: 2,
  ),

  _Soru(
    soru: 'Analog kameralar görüntüyü genellikle hangi kabloyla iletir?',
    secenekler: ['UTP kablo', 'Fiber kablo', 'Koaksiyel kablo', 'Telefon kablosu'],
    dogruIndex: 2,
  ),

  _Soru(
    soru: 'PoE (Power over Ethernet) ne işe yarar?',
    secenekler: [
      'Sadece veri iletir',
      'Sadece görüntü kalitesini artırır',
      'Ağ kablosu üzerinden enerji ve veri iletir',
      'Kablosuz bağlantı sağlar'
    ],
    dogruIndex: 2,
  ),

  _Soru(
    soru: 'Bir IP kameranın IP adresi ne işe yarar?',
    secenekler: [
      'Görüntü çözünürlüğünü belirler',
      'Kameranın ağ üzerindeki kimliğidir',
      'Enerji tüketimini ölçer',
      'Kayıt süresini uzatır'
    ],
    dogruIndex: 1,
  ),

  _Soru(
    soru: 'Analog kamera sistemlerinde kayıt cihazına ne ad verilir?',
    secenekler: ['NVR', 'Router', 'DVR', 'Switch'],
    dogruIndex: 2,
  ),

  _Soru(
    soru: 'IP kamera sistemlerinde kullanılan kayıt cihazı hangisidir?',
    secenekler: ['DVR', 'Splitter', 'NVR', 'Modem'],
    dogruIndex: 2,
  ),

  _Soru(
    soru: 'CAT6 kablo CAT5e’ye göre ne avantaj sağlar?',
    secenekler: [
      'Daha kısa mesafe',
      'Daha düşük hız',
      'Daha yüksek bant genişliği',
      'Sadece telefon hattı uyumu'
    ],
    dogruIndex: 2,
  ),

  _Soru(
    soru: 'Koaksiyel kabloda sinyal kaybını azaltan en önemli parça hangisidir?',
    secenekler: ['İzole bant', 'F konnektör', 'Anahtar', 'Sigorta'],
    dogruIndex: 1,
  ),

  _Soru(
    soru: 'TV yayınlarında uydu sinyalini alan parça hangisidir?',
    secenekler: ['Multiswitch', 'LNB', 'Receiver', 'HDMI kablo'],
    dogruIndex: 1,
  ),

  _Soru(
    soru: 'Bir televizyonda dahili uydu alıcısı varsa ekstra neye gerek kalmaz?',
    secenekler: ['LNB', 'Çanak anten', 'Receiver', 'Koaksiyel kablo'],
    dogruIndex: 2,
  ),

  _Soru(
    soru: 'RJ45 konnektörde toplam kaç pin bulunur?',
    secenekler: ['4', '6', '8', '10'],
    dogruIndex: 2,
  ),

  _Soru(
    soru: 'RJ11 konnektörde genellikle kaç pin kullanılır?',
    secenekler: ['2 veya 4', '8', '10', '12'],
    dogruIndex: 0,
  ),

  _Soru(
    soru: 'IP kameralar uzaktan izlenirken genellikle hangi protokol kullanılır?',
    secenekler: ['FTP', 'HTTP/HTTPS', 'SMTP', 'SNMP'],
    dogruIndex: 1,
  ),

  _Soru(
    soru: 'Analog kamerada görüntü var ama renk yoksa en muhtemel sebep nedir?',
    secenekler: [
      'Kamera arızalı',
      'Yanlış video standardı (PAL/NTSC)',
      'Harddisk dolu',
      'IP adresi çakışması'
    ],
    dogruIndex: 1,
  ),

  _Soru(
    soru: 'PoE switch kullanılmasının avantajı nedir?',
    secenekler: [
      'Daha fazla kanal kaydı',
      'Kameralar için ayrı adaptör gerektirmez',
      'Görüntü çözünürlüğünü artırır',
      'Kablosuz bağlantı sağlar'
    ],
    dogruIndex: 1,
  ),

  _Soru(
    soru: 'TV headend sistemleri en çok nerelerde kullanılır?',
    secenekler: [
      'Müstakil evlerde',
      'Araç içi sistemlerde',
      'Oteller ve sitelerde',
      'Cep telefonlarında'
    ],
    dogruIndex: 2,
  ),

  _Soru(
    soru: 'IP kamera ile analog kamera arasındaki temel fark nedir?',
    secenekler: [
      'Biri kablosuz diğeri kablolu',
      'Biri ağ üzerinden veri iletir',
      'Biri sadece gece çalışır',
      'Biri sadece TV’ye bağlanır'
    ],
    dogruIndex: 1,
  ),

  _Soru(
    soru: 'CAT kablolarda maksimum önerilen mesafe kaç metredir?',
    secenekler: ['50 m', '75 m', '100 m', '200 m'],
    dogruIndex: 2,
  ),

  _Soru(
    soru: 'Bir IP kamera görüntü vermiyor ama ışıkları yanıyorsa ilk ne kontrol edilir?',
    secenekler: [
      'LNB ayarı',
      'IP adresi ve ağ bağlantısı',
      'HDMI kablosu',
      'Uydu frekansı'
    ],
    dogruIndex: 1,
  ),

  _Soru(
    soru: 'Analog kamera sistemlerinde BNC konnektör ne için kullanılır?',
    secenekler: [
      'Enerji beslemesi',
      'Ses iletimi',
      'Video sinyal iletimi',
      'Network bağlantısı'
    ],
    dogruIndex: 2,
  ),

  _Soru(
    soru: 'Bir TV’de “sinyal yok” uyarısı varsa ilk hangi hat kontrol edilir?',
    secenekler: [
      'HDMI kablosu',
      'Uydu kablosu (koaksiyel)',
      'Ethernet kablosu',
      'USB kablosu'
    ],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Harmoniklerin olası etkilerinden biri hangisidir?',
    secenekler: ['Frekansın 0 olması', 'Nötr akımının artması ve ısınma', 'Topraklamanın yok olması', 'Gerilimin sonsuza çıkması'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Kompanzasyonun yanlış ayarı hangi probleme yol açabilir?',
    secenekler: ['Gerilimin 690 V olması', 'Rezonans ve harmonik büyümesi', 'Nötrün kaybolması', 'Frekansın 0 olması'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: '12 V gerilim uygulanan 12 Ω dirençten geçen akım yaklaşık kaç A’dır?',
    secenekler: ['1.00 A', '2.00 A', '1.50 A', '0.50 A'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: '24 V gerilim uygulanan 8 Ω dirençten geçen akım yaklaşık kaç A’dır?',
    secenekler: ['6.00 A', '1.50 A', '3.00 A', '4.50 A'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: '48 V gerilim uygulanan 33 Ω dirençten geçen akım yaklaşık kaç A’dır?',
    secenekler: ['0.73 A', '1.45 A', '2.91 A', '2.18 A'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: '48 V gerilim uygulanan 47 Ω dirençten geçen akım yaklaşık kaç A’dır?',
    secenekler: ['2.04 A', '1.53 A', '0.51 A', '1.02 A'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: '110 V gerilim uygulanan 5 Ω dirençten geçen akım yaklaşık kaç A’dır?',
    secenekler: ['33.00 A', '22.00 A', '11.00 A', '44.00 A'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: '230 V gerilim uygulanan 47 Ω dirençten geçen akım yaklaşık kaç A’dır?',
    secenekler: ['7.34 A', '4.89 A', '9.79 A', '2.45 A'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: '100 W’lık bir cihaz 2 saat çalışırsa yaklaşık kaç kWh tüketir?',
    secenekler: ['0.30 kWh', '0.10 kWh', '0.50 kWh', '0.20 kWh'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: '500 W’lık bir cihaz 1 saat çalışırsa yaklaşık kaç kWh tüketir?',
    secenekler: ['0.75 kWh', '0.50 kWh', '0.80 kWh', '0.25 kWh'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: '1500 W’lık bir cihaz 6 saat çalışırsa yaklaşık kaç kWh tüketir?',
    secenekler: ['13.50 kWh', '9.30 kWh', '9.00 kWh', '4.50 kWh'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: '2000 W’lık bir cihaz 3 saat çalışırsa yaklaşık kaç kWh tüketir?',
    secenekler: ['6.30 kWh', '6.00 kWh', '3.00 kWh', '9.00 kWh'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'PEN iletkeni hangi sistemlerde görülür?',
    secenekler: ['TT', 'Sadece DC sistemleri', 'IT', 'TN-C / TN-C-S'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'TN-C sistemde N ve PE nasıl kullanılır?',
    secenekler: ['Hiç kullanılmaz', 'Ayrı ayrı', 'Birleşik (PEN) iletken olarak', 'Sadece aydınlatmada'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'IT sistemin tipik özelliği hangisidir?',
    secenekler: ['Sadece DC’de kullanılması', 'İlk izolasyon arızasında sistemin hemen kapanmaması', 'Kısa devre akımının sıfır olması', 'Nötrün hiç olmaması'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Sigorta atıyorsa ilk yapılacak en güvenli adım hangisidir?',
    secenekler: ['Sigorta değerini büyütmek', 'RCD’yi iptal etmek', 'Topraklamayı sökmek', 'Yük/hat üzerinde arıza ihtimalini kontrol etmek'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'Motor ters dönüyorsa en pratik düzeltme hangisidir?',
    secenekler: ['Kablo kesitini küçültmek', 'SPD eklemek', 'İki fazın yerini değiştirmek', 'RCD hassasiyetini artırmak'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Üç faz + nötr sistemde nötr akımı ne zaman artar?',
    secenekler: ['Topraklama çok iyi olduğunda', 'IP sınıfı yüksek olduğunda', 'Yükler dengesiz olduğunda', 'Yükler tamamen dengeli olduğunda'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Bir devrede akım iki katına çıkarsa I²R kaybı ne olur?',
    secenekler: ['Yarıya iner', '2 katına çıkar', '4 katına çıkar', 'Değişmez'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Sigortanın \'gG\' tipi genelde neyi ifade eder?',
    secenekler: ['Sadece motor koruma', 'Sadece elektronik koruma', 'Sadece kaçak akım koruma', 'Genel amaçlı tam aralıklı koruma'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'Motor koruma şalteri (MMS) genelde hangi iki korumayı birleştirir?',
    secenekler: ['Frekans + cosφ', 'Nem + sıcaklık', 'Kaçak akım + yıldırım', 'Aşırı yük + kısa devre'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'Kompanzasyonda detuned reaktör kullanımının amacı nedir?',
    secenekler: ['Nötrü yok etmek', 'Harmonik rezonans riskini azaltmak', 'Frekansı artırmak', 'Gerilimi artırmak'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Yük ayırıcı şalterin ana amacı nedir?',
    secenekler: ['Frekansı değiştirmek', 'Güvenli izolasyon (yük altında açabilme)', 'Kaçak akımı ölçmek', 'Gerilimi regüle etmek'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Enerji analizörü genelde hangi bilgileri ölçer/gösterir?',
    secenekler: ['Sadece kablo kesitini', 'Sadece toprak rengini', 'V, I, P, Q, cosφ, harmonik gibi değerleri', 'Sadece IP sınıfını'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Paralel bağlı iki eşit dirençte toplam direnç nasıl olur?',
    secenekler: ['Tek dirençle aynı', 'Tek direncin yarısı', 'Sonsuz', 'Tek direncin iki katı'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Seri bağlı iki eşit dirençte toplam direnç nasıl olur?',
    secenekler: ['Tek direncin yarısı', 'Sıfır', 'Tek dirençle aynı', 'Tek direncin iki katı'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'Gerilim düşümü azalsın diye en etkili hamle hangisidir?',
    secenekler: ['Kesiti artırmak veya hattı kısaltmak', 'SPD’yi sökmek', 'Sigortayı büyütmek', 'RCD takmak'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: 'AG panoda bara kullanmanın avantajı hangisidir?',
    secenekler: ['Gerilimi düşürmek', 'Frekansı değiştirmek', 'Daha düzenli ve düşük dirençli dağıtım', 'Kaçak akımı artırmak'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Topraklama sürekliliği testinin amacı nedir?',
    secenekler: ['Cosφ’yi artırmak', 'Frekansı düşürmek', 'Gerilimi yükseltmek', 'PE hattının kopuk olmadığını doğrulamak'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'Zayıf sıkılmış pabuç bağlantısında hangi belirti daha olasıdır?',
    secenekler: ['Frekansın artması', 'Gerilimin artması', 'Cosφ’nin 1 olması', 'Klemens/pabuçta kararma ve ısınma'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'Nötr-toprak arası gerilim yüksekse olası sebep hangisidir?',
    secenekler: ['Kablo rengi', 'IP sınıfı', 'Nötr bağlantı/taşıma problemi veya harmonikler', 'Faz sırası'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Faz-toprak arası ölçülen gerilim normalde faz-nötr gerilimine yakınsa bu neyi gösterir?',
    secenekler: ['Toprağın referans potansiyelde olduğunu', 'Sigortanın D tipi olduğunu', 'Nötrün olmadığını', 'Frekansın 60 Hz olduğunu'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: 'Kabloda damar sayısı artırmak doğrudan neyi artırır?',
    secenekler: ['Frekansı', 'İletken sayısını (paralel iletken imkânı)', 'Cosφ’yi', 'Gerilimi'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Kablo izolesi 70°C yerine 90°C ise ne avantaj sağlar?',
    secenekler: ['Daha yüksek cosφ', 'Daha düşük frekans', 'Daha yüksek akım taşıma kapasitesi (şarta bağlı)', 'RCD’nin çalışmaması'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Bara sistemlerinde ek noktaları neden kritik izlenir?',
    secenekler: ['Cosφ’nin sıfırlanması', 'Geçiş direnci ve ısınma riski', 'Gerilim artışı', 'Frekans artışı'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Motor klemens kutusunda U-V-W neyi temsil eder?',
    secenekler: ['Toprak ucunu', 'Sargı uçlarını', 'Sigorta ucunu', 'Nötr ucunu'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Bir asenkron motorun senkron hızı en çok neye bağlıdır?',
    secenekler: ['Topraklama direncine', 'Kablo rengine', 'Frekans ve kutup sayısına', 'RCD hassasiyetine'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: '50 Hz, 4 kutuplu motorda senkron hız yaklaşık kaç rpm’dir?',
    secenekler: ['1500 rpm', '750 rpm', '1000 rpm', '3000 rpm'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: '50 Hz, 2 kutuplu motorda senkron hız yaklaşık kaç rpm’dir?',
    secenekler: ['1500 rpm', '1000 rpm', '3000 rpm', '750 rpm'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Faz dengesizliği motorlarda hangi etkiyi artırır?',
    secenekler: ['Verimi artırmayı', 'Sargı ısınmasını', 'Gerilimi yükseltmeyi', 'Frekansı artırmayı'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Bir yükün direnci artarsa (V sabit), akım nasıl değişir?',
    secenekler: ['Değişmez', 'Sıfır olur', 'Azalır', 'Artar'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Bir pano içinde kabloların çok sıkı toplanması hangi sorunu artırır?',
    secenekler: ['Isınma (soğutma zorlaşır)', 'Cosφ', 'Frekans', 'Toprak direnci'],
    dogruIndex: 0,
  ),
  _Soru(
    soru: 'Kaçak akımın bir kısmı PE üzerinden akarsa RCD ne yapar?',
    secenekler: ['Gerilimi yükseltir', 'Açma yapabilir (fark algılar)', 'Sigortayı büyütür', 'Hiçbir şey'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Bir ölçümde faz-nötr 230 V iken faz-faz kaç V civarıdır (TR standart)?',
    secenekler: ['230 V', '400 V civarı', '690 V', '110 V'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'AG panolarda bakır bara tercihinin sebeplerinden biri hangisidir?',
    secenekler: ['Süper iletkenlik', 'Manyetik alan üretmemesi', 'Yüksek iletkenlik ve güvenilir bağlantı', 'Daha düşük ağırlık'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Kablolarda \'minimum bükülme yarıçapı\' neden önemlidir?',
    secenekler: ['Frekansı düşürmek için', 'Gerilimi yükseltmek için', 'İzolasyona zarar vermemek için', 'Cosφ’yi artırmak için'],
    dogruIndex: 2,
  ),
  _Soru(
    soru: 'Şebeke gerilimi dalgalanmasına karşı hassas cihazlarda ne tercih edilir?',
    secenekler: ['Daha ince kablo', 'Topraklamayı sökmek', 'Daha büyük sigorta', 'Regülatör/UPS'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'Bir devrede seri bağlı iki lambadan biri koparsa ne olur?',
    secenekler: ['Diğeri etkilenmez', 'Sigorta büyür', 'Diğeri daha parlak yanar', 'Diğer lamba da söner'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: 'Paralel bağlı lambalardan biri koparsa diğerine ne olur?',
    secenekler: ['Frekans değişir', 'Diğeri yanmaya devam eder', 'Diğeri de söner', 'Gerilim ikiye bölünür'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'Yalıtım sınıfı \'Class F\' motorlar neyle ilgilidir?',
    secenekler: ['IP kodu', 'Sargı izolasyon sıcaklık dayanımıyla', 'Faz sırası', 'RCD hassasiyeti'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'IP54 ifadesindeki 5 sayısı neyi belirtir?',
    secenekler: ['Suya karşı koruma', 'Toza karşı koruma seviyesini', 'Akım seviyesi', 'Gerilim seviyesi'],
    dogruIndex: 1,
  ),
  _Soru(
    soru: 'IP54 ifadesindeki 4 sayısı neyi belirtir?',
    secenekler: ['Cosφ', 'Frekans', 'Toza karşı koruma', 'Sıçrayan suya karşı korumayı'],
    dogruIndex: 3,
  ),
  _Soru(
    soru: '150 m uzunluğunda hatta 63 A akım çekildiğinde gerilim düşümünü azaltmak için en mantıklı adım hangisidir?',
    secenekler: ['Sigorta değerini büyütmek', 'RCD’yi sökmek', 'hat uzunluğunu iyileştirmek', 'Faz sırasını karıştırmak'],
    dogruIndex: 2,
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
