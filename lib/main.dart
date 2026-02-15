import 'package:flutter/material.dart';
import 'pages/hesaplayici_sayfasi.dart';
import 'pages/hakkinda_sayfasi.dart';
import 'pages/gizlilik_sayfasi.dart';
import 'pages/hesaplamalar_sayfasi.dart';
import 'pages/quiz_sayfasi.dart';
import 'package:flutter/services.dart';
import 'pages/ariza_teshis/ariza_teshis_ana_sayfa.dart';
import 'widgets/tikla_zoom_resim.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad/banner_ad_widget.dart';





final List<String> hesapGecmisi = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const RehberApp());
}

class RehberApp extends StatefulWidget {
  const RehberApp({super.key});

  @override
  State<RehberApp> createState() => _RehberAppState();
}

 class _RehberAppState extends State<RehberApp> {
    ThemeMode _mode = ThemeMode.light; // başlangıç: açık mod


    void _toggleTheme() {
      setState(() {
        _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elektrik Elektronik Rehberi',
      debugShowCheckedModeBanner: false,
      themeMode: _mode, // 🌙 Aydınlık / Karanlık kontrolü
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1E88E5),
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8FAFD),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.black87),
          hintStyle: const TextStyle(color: Colors.black45),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
       ),
      ),

      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF90CAF9),
        useMaterial3: true,
        brightness: Brightness.dark,

        scaffoldBackgroundColor: const Color(0xFF0F1115),
        cardColor: const Color(0xFF151A21),

  
        inputDecorationTheme: InputDecorationTheme(
         filled: true,
         fillColor: const Color(0xFF1E1E1E),

          // Label / Hint
         labelStyle: const TextStyle(color: Colors.white70),
         floatingLabelStyle: const TextStyle(color: Colors.white),
         hintStyle: const TextStyle(color: Colors.white38),

    
         suffixStyle: const TextStyle(color: Colors.white),
         prefixStyle: const TextStyle(color: Colors.white),

         enabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(12),
           borderSide: const BorderSide(color: Color(0xFF2D3642)),
         ),
         focusedBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(12),
           borderSide: const BorderSide(color: Color(0xFF90CAF9), width: 1.5),
         ),
         disabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(12),
           borderSide: const BorderSide(color: Color(0xFF2D3642)),
         ),
        ),

        // 👇 HESAPLAMA SONUÇLARI / NORMAL TEXTLER
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
              
        // İmleç & seçim
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF90CAF9),
          selectionColor: Color(0x3390CAF9),
          selectionHandleColor: Color(0xFF90CAF9),
       ),
      ),      
      // SplashScreen'den başla, sonra AnaSayfa'ya geç
      home: SplashScreen(toggleTheme: _toggleTheme),
    );
  }
}
           

/* -------------------- Splash Screen -------------------- */
class SplashScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const SplashScreen({super.key, required this.toggleTheme});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scale = CurvedAnimation(parent: _c, curve: Curves.easeOutBack);
    _fade  = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _c.forward();

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AnaSayfa(toggleTheme: widget.toggleTheme),
      ),
    );
  });
 }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'app_logo',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(
                        'assets/logo.jpg',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) =>
                            const Icon(Icons.lightbulb, size: 72, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Elektrik Elektronik Rehberi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const CircularProgressIndicator(color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/* ------------------ /Splash Screen --------------------- */

enum MakaleBlokTip { text, image }

class MakaleBlok {
  final MakaleBlokTip tip;

  /// text ise: veri = yazı
  /// image ise: veri = asset path
  final String veri;

  /// sadece image için (caption/açıklama)
  final String? aciklama;

  const MakaleBlok({
    required this.tip,
    required this.veri,
    this.aciklama,
  });

  const MakaleBlok.text(String yazi)
      : tip = MakaleBlokTip.text,
        veri = yazi,
        aciklama = null;

  const MakaleBlok.image(String assetPath, {String? aciklama})
      : tip = MakaleBlokTip.image,
        veri = assetPath,
        aciklama = aciklama;
}

/// Basit veri modeli
class Makale {
  final String id;
  final String baslik;
  final String icerik;
  final String kategori; // elektrik | elektronik | otomasyon

  final IconData? ikonData;     // Material icon (Icons.xxx)
  final String? ikonAsset;    // 🔹 PNG / SVG ikon

  final String? resim;     // yeni     // üst/alt için      
  final bool resimAltta;
  final String? resimOrta;   // 👈 yeni (orta resim)

  final List<MakaleBlok> bloklar; // ❗ nullable değil


  const Makale({
    required this.id,
    required this.baslik,
    required this.icerik,
    required this.kategori,
    this.ikonData,
    this.ikonAsset,
    this.resim,
    this.resimAltta = false,
    this.resimOrta,
    this.bloklar = const [], // ✅ default
  });
}

/// Örnek içerikler
const List<Makale> tumMakaleler = [
  Makale(
  id: 'e1',
  baslik: 'Temel Elektrik Kavramları: Akım, Gerilim, Direnç ve Güç',
  icerik:
      'Elektrik; elektronların bir iletken içerisinde kontrollü şekilde hareket etmesiyle ortaya çıkan bir enerji türüdür. '
      'Günlük hayatta aydınlatma, ısıtma, motorlar, elektronik cihazlar ve haberleşme sistemlerinin tamamı elektrik enerjisi ile çalışır.\n\n'

      '🔌 ELEKTRİK NASIL OLUŞUR?\n'
      'Bir iletkende elektronların hareket edebilmesi için iki temel şeye ihtiyaç vardır:\n'
      '• Bir gerilim farkı (itici güç)\n'
      '• Kapalı bir devre yolu\n'
      'Gerilim uygulandığında elektronlar yüksek potansiyelden düşük potansiyele doğru hareket eder ve bu harekete akım denir.\n\n'

      '⚡ AKIM (I) NEDİR?\n'
      'Akım, bir iletkenden birim zamanda geçen elektrik yükü miktarıdır ve amper (A) ile ölçülür.\n'
      'Basitçe: “Elektronların akış miktarı” olarak düşünülebilir.\n'
      'Akımın büyüklüğü; gerilim, devrenin direnci ve yük durumuna bağlıdır.\n\n'

      '🔋 GERİLİM (V) NEDİR?\n'
      'Gerilim, iki nokta arasındaki elektriksel potansiyel farktır ve volt (V) ile ölçülür.\n'
      'Akımı harekete geçiren itici kuvvettir.\n'
      'Gerilim yoksa akım akmaz.\n\n'

      '🧱 DİRENÇ (R) NEDİR?\n'
      'Direnç, bir iletkenin akıma karşı gösterdiği zorluktur ve ohm (Ω) ile ölçülür.\n'
      'Direnç arttıkça akım azalır.\n'
      'Kablo kesiti, uzunluk ve malzeme direnci etkiler.\n\n'

      '📐 OHM KANUNU\n'
      'Elektrik hesaplamalarının temelidir.\n'
      'Formül:\n'
      'V = I × R\n'
      'I = V / R\n'
      'R = V / I\n'
      'Bu kanun sayesinde bir devrede akım, gerilim veya direnç kolayca hesaplanabilir.\n\n'

      '⚙️ GÜÇ (P) NEDİR?\n'
      'Güç, bir devrede harcanan veya üretilen enerji miktarını ifade eder ve watt (W) ile ölçülür.\n'
      'Temel formül:\n'
      'P = V × I\n'
      'Alternatif olarak:\n'
      'P = I² × R\n'
      'P = V² / R\n\n'

      '🔄 AC VE DC AKIM\n'
      '• DC (Doğru Akım): Akım tek yönde akar. (Pil, batarya, adaptör çıkışları)\n'
      '• AC (Alternatif Akım): Akım yönü sürekli değişir. (Ev ve sanayi elektriği)\n'
      'Türkiye’de şebeke gerilimi 230V – 50Hz AC’dir.\n\n'

      '📊 AC GÜÇ TÜRLERİ\n'
      'Alternatif akımda üç farklı güç kavramı vardır:\n'
      '• Aktif Güç (kW): İş yapan gerçek güç\n'
      '• Reaktif Güç (kVAr): Manyetik/kapasitif alan oluşturan güç\n'
      '• Görünür Güç (kVA): Sistemin toplam yükü\n'
      'Aralarındaki ilişki cosφ (güç faktörü) ile ifade edilir.\n\n'

      '🎯 ELEKTRİĞİN AMACI VE KULLANIM ALANLARI\n'
      'Elektrik enerjisi;\n'
      '• Aydınlatma\n'
      '• Isıtma ve soğutma\n'
      '• Motor ve makineler\n'
      '• Elektronik ve otomasyon sistemleri\n'
      '• Haberleşme ve bilişim\n'
      'gibi birçok alanda kullanılır.\n\n'

      '🛠 NEDEN BU TEMEL BİLGİLER ÖNEMLİ?\n'
      'Bu kavramlar bilinmeden;\n'
      '• Kablo kesiti seçilemez\n'
      '• Sigorta doğru seçilemez\n'
      '• Arıza teşhisi yapılamaz\n'
      '• Güvenli tesisat kurulamaz\n\n'

      'Bu nedenle elektrikle çalışan herkesin (kullanıcı, tekniker, elektrikçi, mühendis) '
      'bu temel kavramları iyi anlaması gerekir.',
  kategori: 'elektrik',
  resim: 'assets/images/elektrik.png',
  ),
  Makale(
    id: 'e10',
    baslik: 'Ev Tesisatı: Anahtar ve Priz Sistemleri',
    kategori: 'elektrik',
    ikonAsset: 'assets/images/adianahtar.jpg',
    icerik:
        'Ev tesisatı; konutlarda elektrik enerjisinin güvenli ve düzenli şekilde '
        'kullanıcılara ulaştırılmasını sağlayan sistemlerin tamamıdır.\n\n'
        'Bir ev tesisatında aydınlatma ve priz devreleri ayrı ayrı planlanır. '
        'Anahtarlar, aydınlatma armatürlerini kontrol ederken; prizler elektrikli '
        'cihazlara enerji sağlar.\n\n'
        'Bu bölümde evlerde en sık kullanılan anahtar ve priz çeşitleri, '
        'çalışma mantıkları ve bağlantı şekilleri sade bir dille anlatılacaktır.',
    bloklar: const [
      MakaleBlok.text(
        '🔘 ADİ ANAHTAR NEDİR?\n'
        'Adi anahtar, bir aydınlatma armatürünü tek noktadan açıp kapatmaya yarayan '
        'en basit anahtar türüdür.\n\n'
        'Genellikle salon, oda, banyo ve tuvalet gibi alanlarda kullanılır.\n\n'
        'Çalışma mantığı:\n'
        '• Faz hattı anahtara girer\n'
        '• Anahtar açıldığında faz lambaya iletilir\n'
        '• Nötr hat doğrudan lambaya gider',
      ),
      MakaleBlok.image(
        'assets/images/adianahtar.jpg',
        aciklama:
            'Adi anahtar bağlantı şeması.\n'
            'Faz (L) anahtardan geçirilir, nötr (N) doğrudan lambaya bağlanır.',
      ),

      MakaleBlok.text(
        '🔁 KOMÜTATÖR ANAHTAR NEDİR?\n'
        'Komütatör anahtar, bir aydınlatma armatürünü iki farklı noktadan '
        'kontrol etmeye yarayan anahtar türüdür.\n\n'
        'Merdiven altı–üstü, uzun koridorlar gibi alanlarda kullanılır.\n\n'
        'Sistemde iki adet komütatör anahtar bulunur ve aralarında iki adet '
        'gezgin (kontrol) hattı vardır.',
      ),
      MakaleBlok.image(
        'assets/images/komutatör.jpg',
        aciklama:
            'Komütatör anahtar bağlantı şeması.\n'
            'İki anahtar arasında gezgin hatlar bulunur.',
      ),

      MakaleBlok.text(
        '🔀 VAVİEN ANAHTAR NEDİR?\n'
        'Vavien anahtar sistemi, bir aydınlatma armatürünün üç veya daha fazla '
        'noktadan kontrol edilmesini sağlar.\n\n'
        'Bu sistemde:\n'
        '• 2 adet komütatör anahtar\n'
        '• 1 veya daha fazla vavien (ara) anahtar\n'
        'kullanılır.\n\n'
        'Otel koridorları, büyük salonlar ve geniş alanlarda tercih edilir.',
      ),
      MakaleBlok.image(
        'assets/images/vavien1.jpg',
        aciklama:
            'Vavien anahtar bağlantı şeması.\n'
            'Ara anahtar, gezgin hatlar arasında yön değiştirir.',
      ),
      MakaleBlok.image(
        'assets/images/vavien2.jpg',
      ),
      MakaleBlok.text(
        '🔌 PRİZ NEDİR?\n'
        'Priz, elektrikli cihazların şebeke enerjisine bağlanmasını sağlayan '
        'tesisat elemanıdır.\n\n'
        'Bir prizde üç temel bağlantı bulunur:\n'
        '• Faz (L)\n'
        '• Nötr (N)\n'
        '• Toprak (PE)\n\n'
        'Topraklama hattı, kaçak akımlara karşı can ve mal güvenliği sağlar.',
      ),
      MakaleBlok.image(
        'assets/images/priz.jpg',
        aciklama:
            'Topraklı priz bağlantı şeması.\n'
            'Faz ve nötr çalışma için, toprak ise güvenlik için kullanılır.',
      ),
    ],
  ),
  Makale(
  id: 'e11',
  baslik: 'Trifaze Motor Kumandası: Kontaktör–Termik–Start/Stop–Mühürleme ve Zamanlama',
  kategori: 'elektrik',
  ikonAsset: 'assets/images/motor1.jpg',
  icerik:
      'Trifaze motor devreleri; güç devresi (motoru besleyen hat) ve kumanda devresi '
      '(kontaktörü çektiren kontrol hatları) olmak üzere iki ana bölümden oluşur.\n\n'
      'Bu makalede; kontaktör ve termik röle uçları, motor klemens bağlantıları, '
      'start/stop devresi, mühürleme (self-hold) mantığı ve zaman rölesi/zaman saati ile '
      'gecikmeli çalışma gibi sahada en çok kullanılan uygulamalar pratik şekilde anlatılır.',
  bloklar: const [

    // Güvenlik
    MakaleBlok.text(
      '🚨 ÖNCE GÜVENLİK (KURAL SETİ)\n'
      '• Panoda çalışmadan önce mutlaka enerjiyi kes (şalter/sigorta) ve kontrol kalemi/avometre ile doğrula.\n'
      '• Motor devrelerinde hem 380V güç hem de 24V/220V kumanda olabilir; ikisini de kontrol et.\n'
      '• Klemens sıkılıkları kritik: gevşek klemens → ısınma → kontakt yanması/yangın riski.\n'
      '• Termik ve kontaktör seçimleri motor etiket akımına göre yapılmalıdır.',
    ),
    MakaleBlok.image(
    'assets/images/motor1.jpg',
    ),

    // Genel yapı
    MakaleBlok.text(
      '🧩 MOTOR DEVRESİNİN GENEL YAPISI\n'
      '1) Güç Devresi: Şebeke (L1-L2-L3) → Şalter/Sigorta → Kontaktör ana kontaklar → Termik → Motor\n'
      '2) Kumanda Devresi: Start/Stop butonları → (gerekirse) zaman rölesi → kontaktör bobini (A1-A2)\n\n'
      'Kumanda devresi kontaktörü çektirir, güç devresi motoru besler.',
    ),

    // Kontaktör uçları
    MakaleBlok.text(
      '⚙️ KONTAKTÖR UÇLARI (SAHADA EN ÇOK LAZIM OLANLAR)\n'
      'Kontaktör üzerinde 3 ana bölüm görürsün:\n\n'
      'A) Bobin uçları:\n'
      '• A1 – A2: Kontaktör bobin uçlarıdır.\n'
      '  Bobin 24V DC / 220V AC olabilir (etiketine bak!).\n\n'
      'B) Ana güç kontakları:\n'
      '• 1L1 – 3L2 – 5L3 (Giriş)\n'
      '• 2T1 – 4T2 – 6T3 (Çıkış)\n'
      'Şebeke L1-L2-L3 genelde üst tarafa (L) girer, motor hattı alt taraftan (T) çıkar.\n\n'
      'C) Yardımcı kontaklar (mühürleme için):\n'
      '• 13-14: NO (Normalde Açık)\n'
      '• 21-22: NC (Normalde Kapalı)\n'
      'Mühürleme devresinde çoğunlukla 13-14 kullanılır.',
    ),
    MakaleBlok.image(
    'assets/images/yikama-pompasi-termik-role-baglanti-semasi.jpg',
    aciklama:
      'Kontaktör + termik röle kullanılarak yıkama pompası motorunun güvenli çalıştırılması.\n'
      'Termik röle 95–96 kontağı kumanda devresini keserek motoru korur.',
    ),

    // Termik uçları
    MakaleBlok.text(
      '🛡️ TERMİK RÖLE UÇLARI (95-96 / 97-98 NE?)\n'
      'Termik röle iki taraftan okunur:\n\n'
      'A) Güç hattı (motor akımı buradan geçer):\n'
      '• Genelde kontaktör çıkışından termiğe girilir, termikten motora çıkılır.\n'
      '  (Markaya göre L/T isimleri değişebilir ama mantık aynıdır.)\n\n'
      'B) Yardımcı kontaklar (kumandayı kesmek için):\n'
      '• 95-96: NC kontak (termik attığında AÇAR) → EN ÇOK kullanılan\n'
      '• 97-98: NO kontak (termik attığında KAPANIR) → alarm/ikaz için\n\n'
      'Sahada standart: Kontaktör bobinine giden kumanda hattına 95-96 seri girilir.\n'
      'Termik atınca 95-96 açar → bobin enerjisi kesilir → motor durur.',
    ),

    // Motor klemens
    MakaleBlok.text(
      '🔌 MOTOR KLEMENS BAĞLANTILARI (U1-V1-W1 / U2-V2-W2)\n'
      'Trifaze motor klemens kutusunda genelde 6 uç vardır:\n'
      '• U1 – V1 – W1 (üst sıra)\n'
      '• U2 – V2 – W2 (alt sıra)\n\n'
      'Motorun yıldız/üçgen köprüleri bu uçlarda yapılır.\n'
      'Bu makalede detay yıldız-üçgen değil; ama bilmen gereken şu:\n'
      '• Motorun hangi bağlantıda çalışacağı “motor etiketi”ne göre belirlenir (230/400V gibi).\n\n'
      'Toprak (PE) bağlantısı mutlaka motor gövdesindeki toprak vidasına yapılır.',
    ),

    // Start Stop
    MakaleBlok.text(
      '▶️ START / STOP DEVRESİ (EN KLASİK MOTOR KUMANDASI)\n'
      'Kumanda devresi mantığı:\n'
      '• STOP butonu: NC seçilir (normalde enerji geçirsin, basınca kessin)\n'
      '• START butonu: NO seçilir (basınca enerji versin)\n\n'
      'Tipik sıra:\n'
      'Faz / +24V → Stop (NC) → Termik 95-96 (NC) → Start (NO) → A1 (bobin)\n'
      'A2 → N / 0V\n\n'
      'Bu sayede stopa basınca veya termik atınca bobin düşer ve motor durur.',
    ),

    // Mühürleme
    MakaleBlok.text(
      '🔁 MÜHÜRLEME (SELF-HOLD) – 13-14 NASIL KULLANILIR?\n'
      'Start butonuna basınca motorun sürekli çalışması için mühürleme yapılır.\n\n'
      'Mantık:\n'
      '• Kontaktörün NO yardımcı kontağı (13-14), Start butonuna paralel bağlanır.\n'
      '• Start’a basınca bobin çeker.\n'
      '• Bobin çekince 13-14 kapanır.\n'
      '• Start’tan elini çeksen bile 13-14 üzerinden enerji devam eder.\n\n'
      'Stop’a basınca veya termik atınca seri hat açılır → bobin düşer → 13-14 tekrar açılır.',
    ),

    // İkaz / alarm
    MakaleBlok.text(
      '💡 TERMİK ATTI ALARM YAK (97-98 KULLANIMI)\n'
      'Termik atınca bir ikaz lambası veya buzzer çalıştırmak istersen:\n'
      '• 97-98 (NO) kontağı kullanılır.\n'
      'Termik normaldeyken açık, termik atınca kapanır → alarm devreye girer.\n\n'
      'Bu özellik sahada arızayı hızlı anlamak için çok kullanışlıdır.',
    ),

    // Zaman rölesi ile gecikmeli
    MakaleBlok.text(
      '⏱️ ZAMAN RÖLESİ İLE GECİKMELİ ÇALIŞTIRMA / DURDURMA\n'
      'Zaman rölesi (timer) motoru belirli bir gecikmeyle başlatmak veya durdurmak için kullanılır.\n\n'
      'En yaygın iki senaryo:\n'
      '1) Gecikmeli Çalıştırma:\n'
      '• Start’a basınca zaman rölesi sayar\n'
      '• Süre dolunca kontaktör bobinine enerji verir\n\n'
      '2) Gecikmeli Durdurma:\n'
      '• Stop komutu gelince motor hemen durmaz\n'
      '• Röle belirlenen süre boyunca bobini tutar, sonra bırakır\n\n'
      'Not: Zaman rölesinin kontağı (NO/NC) bobin hattına seri/paralel seçilerek senaryo kurulur.',
    ),

    // Zaman saati (timer switch) ile otomatik çalışma
    MakaleBlok.text(
      '🕒 ZAMAN SAATİ (PROGRAM SAATİ) İLE MOTOR/POMPA OTOMATİĞİ\n'
      'Zaman saati; belirli saatlerde kontaktör bobinine komut vererek motoru otomatik çalıştırabilir.\n\n'
      'Pratik mantık:\n'
      '• Zaman saati çıkışı → kontaktör bobin hattına “izin” verir.\n'
      '• İstersen manuel/otomatik seçici anahtar ekleyip iki modu ayırırsın.\n\n'
      'Sahada çok kullanılan:\n'
      '• Hidrofor pompası saatli çalışma\n'
      '• Sulama pompası programlı çalışma\n'
      '• Havalandırma fanı periyodik çalışma',
    ),

    // Sık hatalar
    MakaleBlok.text(
      '⚠️ SAHADA EN SIK HATALAR (SENİ YAKALAMASIN)\n'
      '• Bobin gerilimini yanlış sanmak (24V bobine 220V vermek → bobin gider)\n'
      '• Termik 95-96’yı kumandaya seri koymamak (termik atsa bile motor çalışır)\n'
      '• Mühürleme kontağını yanlış bağlamak (stop basınca kesmemek)\n'
      '• Motor PE (toprak) bağlantısını boşlamak\n'
      '• Klemens sıkmadan bırakmak → ısınma ve kontak yanması',
    ),

    // Özet
    MakaleBlok.text(
      ' HIZLI ÖZET\n'
      '• Kontaktör: A1-A2 bobin, 1L1-3L2-5L3 giriş / 2T1-4T2-6T3 çıkış, 13-14 mühürleme NO\n'
      '• Termik: 95-96 (NC) kumandayı keser, 97-98 (NO) alarm verir\n'
      '• Start/Stop: Stop NC, Start NO\n'
      '• Mühürleme: 13-14 Start’a paralel\n'
      '• Zaman rölesi/zaman saati: gecikmeli ve otomatik çalışma için süper pratik',
    ),
  ],
),
  Makale(
    id: 'e2',
    baslik: 'Kaçak Akım Rölesi (RCD/RCCB) Seçimi, RCCBO ve Arıza Çözüm Rehberi',
    icerik:
        'Kaçak Akım Rölesi (RCD – RCCB), insanı elektrik çarpmasına karşı ve tesisatı kaçak akım kaynaklı yangın riskine karşı korumak için kullanılır. Mantık basittir: Fazdan çıkan akım ile nötrden dönen akım eşit olmalıdır. Arada fark oluşursa (akım kaçak yaptıysa) röle çok hızlı şekilde açar.\n\n'
        ' 1) RCD / RCCB NEDİR?\n'
        'RCD (Residual Current Device) veya RCCB (Residual Current Circuit Breaker) aynı amaçla kullanılır: kaçak akımı algılar ve devreyi keser. Aşırı akım/kısa devre koruması yapmaz. Yani RCD tek başına “sigorta gibi” kabloyu korumaz; önüne MCB (otomatik sigorta) gerekir.\n\n'
        ' 2) 30 mA – 300 mA NE DEMEK?\n'
        '• 30 mA (0.03 A): Hayat koruma. Daire içi priz ve banyo/ıslak hacim devrelerinde en yaygın tercihtir.\n'
        '• 100 mA: Bazı tesislerde ek koruma için kullanılır (tasarıma göre).\n'
        '• 300 mA (0.3 A): Yangın koruma. İnsan koruması için değil, daha çok izolasyon kaçaklarıyla oluşan yangın riskini azaltmak için kullanılır. Genelde ana girişte/kolon hatlarında, panolarda yangın koruma amaçlı tercih edilir.\n\n'
        ' 3) TİP SEÇİMİ (AC / A / F / B)\n'
        'RCD’nin “tipi” algılayabildiği kaçak akımın şekliyle ilgilidir.\n\n'
        '• Tip AC: Sadece sinüzoidal AC kaçakları algılar. Günümüzde birçok elektronik cihaz nedeniyle her yerde önerilmez.\n'
        '• Tip A: AC + darbeli DC kaçakları algılar. Konutlarda en yaygın ve güvenli tercihlerden biridir. (Çamaşır makinesi, bulaşık, dimmer, SMPS adaptörler vb. için daha uygundur.)\n'
        '• Tip F: İnverterli cihazlar/klima gibi bazı elektronik yüklerde daha stabil çalışması için tercih edilebilir.\n'
        '• Tip B: Düz DC kaçaklarını da algılar. EV şarj, PV inverter, bazı sürücüler gibi özel uygulamalarda gerekir.\n\n'
        ' 4) KAÇ KUTUP? (2P / 4P)\n'
        '• Tek faz daire: 2 kutuplu (faz+nötr) RCD.\n'
        '• Trifaze sistem: 4 kutuplu RCD.\n\n'
        ' 5) ANMA AKIMI (40A – 63A – 80A) NASIL SEÇİLİR?\n'
        'RCD’nin üstünde yazan 40A/63A gibi değer, üzerinden güvenle geçebilecek sürekli akımdır.\n'
        'Kural: RCD anma akımı, önündeki/ardındaki yük ve ana sigorta değerine uygun seçilir. Örneğin ana giriş 40A ise RCD 40A ya da 63A seçilebilir. Büyük seçmek sakıncalı değil, küçük seçmek ısınma ve arıza riskini artırır.\n\n'
        ' 6) SELEKTİF (S) RCD NEDİR?\n'
        'Ana girişte kullanılan bazı RCD’ler “S – selektif/gecikmeli” olabilir. Amaç: Alttaki 30mA RCD önce atsın, ana RCD gereksiz yere tüm binayı/dairenin tamamını karartmasın. Büyük tesislerde çok faydalıdır.\n\n'
        ' 7) RCCBO NEDİR? (RCD + MCB BİR ARADA)\n'
        'RCCBO, hem kaçak akım koruması (RCD) hem de aşırı akım/kısa devre korumasını (MCB) tek cihazda birleştirir.\n\n'
        'RCCBO’nun avantajları:\n'
        '• Arıza olduğunda sadece ilgili hattı düşürür (ör. sadece banyo/priz hattı).\n'
        '• Panoda daha seçici ve düzenli koruma sağlar.\n'
        '• Kaçak akım + kısa devre koruması tek cihazda olduğu için takip kolaydır.\n\n'
        'RCCBO ne zaman tercih edilir?\n'
        '• Islak hacimler (banyo)\n'
        '• Mutfak hatları\n'
        '• Dış hatlar (bahçe, dış priz)\n'
        '• Kritik cihaz hatları (kombi, buzdolabı gibi ayrı hatlarda)\n\n'
        ' 8) TEST DÜĞMESİ (T) NE İŞE YARAR?\n'
        'RCD üzerinde “TEST” düğmesi bulunur. Basıldığında cihazın kaçak akım algılama mekanizması kontrol edilir ve rölenin atması beklenir.\n'
        'Öneri: Ayda 1 kez test etmek iyi bir alışkanlıktır. Teste basınca atmıyorsa cihaz arızalı olabilir veya bağlantıda sorun olabilir.\n\n'
        '────────────────────────────\n'
        '⚠️ 9) DAİRE/İŞYERİ TESİSATINDA EN SIK KARŞILAŞILAN ARIZALAR\n\n'
        'A) “Sigorta atıyor” (MCB açıyor)\n'
        '1) Kısa devre:\n'
        '  Belirti: Sigorta anında atar.\n'
        '  Neden: Faz-nötr temas, ezilmiş kablo, yanık duy, arızalı priz/anahtar, su girmiş buat.\n'
        '  Çözüm (genel yaklaşım):\n'
        '  • Hattı enerjisiz bırak.\n'
        '  • O hattaki priz/anahtar/armatürleri sırayla devre dışı bırak.\n'
        '  • Buat bağlantılarını kontrol et.\n'
        '  • Arızalı elemanı değiştir.\n\n'
        '2) Aşırı yük:\n'
        '  Belirti: Bir süre çalışır, sonra atar.\n'
        '  Neden: Aynı hatta çok cihaz (ısıtıcı+ütü+ketıl vb.).\n'
        '  Çözüm:\n'
        '  • Yükü azalt.\n'
        '  • Yüksek güçlü cihazlara ayrı hat çek.\n'
        '  • Kablo kesiti ve sigorta değeri projeye uygun olmalı.\n\n'
        '3) Gevşek klemens / ısınma:\n'
        '  Belirti: Koku, kararma, sigorta/şalter ısınıyor.\n'
        '  Neden: Klemens gevşekliği, zayıf temas.\n'
        '  Çözüm:\n'
        '  • Enerjiyi kes.\n'
        '  • Klemensleri sık.\n'
        '  • Yanmış klemens/otomatiği değiştir.\n\n'
        'B) “Kaçak akım atıyor” (RCD/RCCB açıyor)\n'
        '1) Nem/su kaçakları:\n'
        '  Belirti: Yağmurda, banyoda, dış hatta daha sık atma.\n'
        '  Neden: Su alan buat/priz, nemli kablo.\n'
        '  Çözüm:\n'
        '  • Islak bölgeyi kurut.\n'
        '  • IP korumalı ürün kullan.\n'
        '  • Kaçak yapan hattı ayır ve arızayı bul.\n\n'
        '2) Cihaz arızası:\n'
        '  Belirti: Belirli bir cihaz takılınca hemen atma.\n'
        '  Neden: Rezistans kaçakları (şofben, çamaşır, bulaşık), motor izolasyonu.\n'
        '  Çözüm:\n'
        '  • Cihazı prizden çek, tekrar dene.\n'
        '  • Sorun cihazdaysa servis/onarım.\n\n'
        '3) Nötr-Toprak karışması (çok sık!):\n'
        '  Belirti: Bazı prizlerde “garip” davranış, RCD düzensiz atma.\n'
        '  Neden: Buatta N ile PE temas, yanlış köprü.\n'
        '  Çözüm:\n'
        '  • Buat/prizlerde N ve PE ayrımını kontrol et.\n'
        '  • RCD sonrası nötr barası ile toprak barası kesinlikle karışmamalı.\n\n'
        '4) Çoklu kaçakların toplamı:\n'
        '  Belirti: Tek tek cihazlar sorun çıkarmaz, hepsi aynı anda çalışınca atar.\n'
        '  Neden: Her cihaz küçük kaçak yapar; toplam 30 mA’ı aşınca RCD açar.\n'
        '  Çözüm:\n'
        '  • Hatları böl.\n'
        '  • Kritik hatlara RCCBO ile ayrı koruma yap.\n\n'
        'C) “Elektrik var ama çalışmıyor / düşük voltaj”\n'
        '• Gevşek nötr, yanmış klemens, zayıf bağlantı, uzun hatlarda gerilim düşümü.\n'
        'Çözüm: Klemensler ve nötr hattı kontrol edilir, gerekiyorsa kesit artırılır.\n\n'
        '────────────────────────────\n'
        ' 10) GÜVENLİK UYARISI\n'
        'Arıza tespiti ve pano müdahaleleri tehlikelidir. Enerjiyi kesmeden işlem yapma. Şüpheli durumlarda yetkili elektrikçiden destek al.\n\n'
        'Bu bilgiler genel eğitim amaçlıdır; proje, kablo kesiti, topraklama kalitesi ve kullanım şartlarına göre seçimler değişebilir.',
    kategori: 'elektrik',
    resim: 'assets/images/rcd.jpg',
  ),
  Makale(
  id: 'e3',
  baslik: 'Sigorta (MCB) Türleri: B-C-D Eğrileri, Amper Seçimi ve Kablo Kesiti Rehberi',
  kategori: 'elektrik',
  ikonAsset: 'assets/images/kablo1.png', // ✅ küçük ikon (koymak istersen)
  icerik:
      'Sigorta (MCB – Miniature Circuit Breaker), elektrik tesisatında hatları '
      'aşırı akım ve kısa devreye karşı koruyan temel elemandır.\n\n'
      'Doğru sigorta seçimi sadece “kaç amper” değildir; kablo kesiti (mm²), '
      'yük tipi (rezistif/motor), hat uzunluğu, ortam ve koruma elemanları (RCD/RCBO) '
      'ile birlikte değerlendirilir.\n\n'
      'Bu makalede B–C–D eğrileri, evde hangi devreye kaç amper sigorta seçileceği '
      've buna uygun kablo kesitleri sade ama dolu dolu şekilde anlatılır.',
  bloklar: const [

    // 1) MCB nedir
    MakaleBlok.text(
      '🧠 MCB (OTOMAT SİGORTA) NEDİR?\n'
      'MCB, hattaki akım normalin üstüne çıktığında devreyi açarak kabloyu ve cihazları korur.\n\n'
      'MCB iki şeye karşı açma yapar:\n'
      '• Aşırı yük (termik açma): Uzun süre fazla akım → kablo ısınır\n'
      '• Kısa devre (manyetik açma): Ani çok yüksek akım → hızlı açma\n\n'
      'Önemli: Sigorta esasen “kabloyu” korur. Kablo kesiti küçükse sigorta büyütülmez!',
    ),

    // 2) Eğriler
    MakaleBlok.text(
      '📈 SİGORTA EĞRİLERİ: B – C – D NE DEMEK?\n'
      'Sigorta eğrisi, sigortanın ani akım artışında ne kadar hızlı açacağını belirler.\n\n'
      '• B Tipi (3–5× In): Rezistif yüklerde idealdir (aydınlatma, prizde hafif yükler)\n'
      '• C Tipi (5–10× In): Karma yükler ve motorlu cihazlar için en yaygın tip (ev-işyeri)\n'
      '• D Tipi (10–20× In): Çok yüksek kalkış akımı olan sanayi motorları/kompresörler\n\n'
      'Evde çoğunlukla C tipi kullanılır. Aydınlatmada B de tercih edilebilir.',
    ),

    MakaleBlok.image(
      'assets/images/kablo1.png',
      aciklama:
          'B–C–D açma karakteristiği şeması.\n'
          'Eğri, ani akımda sigortanın tepkisini gösterir.',
    ),

    // 3) Kırma kapasitesi
    MakaleBlok.text(
      '⚡ KIRMA KAPASİTESİ (kA) NEDİR? 6kA MI 10kA MI?\n'
      'Kırma kapasitesi, sigortanın kısa devre akımını güvenle kesebilme sınırıdır.\n\n'
      '• 6 kA: Konutlarda en yaygın ve çoğu durumda yeterli\n'
      '• 10 kA: Trafoya yakın, kısa devre akımının yüksek olabildiği yerlerde tercih edilir\n\n'
      'Not: Yönetmelik/proje ne diyorsa ona uyulur; şüphede kalırsan 10kA daha güvenli tercihtir.',
    ),

    // 4) Evde standart devreler
    MakaleBlok.text(
      '🏠 EVDE HANGİ HATTA KAÇ AMPER SİGORTA KULLANILIR?\n'
      'Aşağıdaki değerler ev içi standart uygulamalar için pratik rehberdir.\n\n'
      '💡 Aydınlatma hattı:\n'
      '• Sigorta: B10A veya C10A\n'
      '• Kablo: 1.5 mm² (genelde)\n\n'
      '🔌 Genel priz hattı:\n'
      '• Sigorta: C16A\n'
      '• Kablo: 2.5 mm²\n\n'
      '🍳 Mutfak priz hattı (yük fazla):\n'
      '• Sigorta: C16A veya C20A (ayrı hat önerilir)\n'
      '• Kablo: 2.5 mm² (C16) / 4 mm² (C20 daha sağlıklı)\n\n'
      '🧺 Çamaşır / Bulaşık makinesi (ayrı hat önerilir):\n'
      '• Sigorta: C16A\n'
      '• Kablo: 2.5 mm²\n\n'
      '🔥 Fırın / Ocak (cihaz gücüne bağlı):\n'
      '• Sigorta: C20A – C25A\n'
      '• Kablo: 4 mm² (C20) / 6 mm² (C25 için daha güvenli)\n\n'
      '❄️ Klima hattı:\n'
      '• Küçük klima: C16A (2.5 mm²)\n'
      '• Büyük klima: C20A (4 mm²) veya projeye göre\n\n'
      '♨️ Kombi hattı:\n'
      '• Sigorta: B10A veya C10A\n'
      '• Kablo: 1.5 mm² (pratikte) / 2.5 mm² de kullanılabilir\n\n'
      '✅ Özet kural: 1.5 mm² → 10A, 2.5 mm² → 16A, 4 mm² → 20–25A (şartlara göre)',
    ),

    MakaleBlok.image(
      'assets/images/kablokesit.png',
      aciklama:
          'Sigorta amperi – kablo kesiti eşleştirme şeması.\n'
          'Kablo kesiti küçükse sigorta büyütülmez.',
    ),

    // 5) Kablo kesiti seçimi detay
    MakaleBlok.text(
      '📏 KABLO KESİTİ (mm²) NASIL SEÇİLİR? PRATİK KURALLAR\n'
      'Kablo seçimi sadece akıma bakmaz; hat uzunluğu, ortam sıcaklığı, boru/kanal içinde olması, '
      'aynı boruda kaç kablo olduğu gibi etkenler akım taşıma kapasitesini düşürür.\n\n'
      'Pratik ev içi yaklaşım:\n'
      '• 1.5 mm² → aydınlatma\n'
      '• 2.5 mm² → priz hatları\n'
      '• 4 mm² → yüksek güçlü tek cihaz hattı (fırın/klima vb.)\n'
      '• 6 mm² → daha yüksek güç/uzun hat (fırın/ocak vb.)\n\n'
      'Uzun hatlarda (özellikle 25–30m üstü) gerilim düşümü artar → bir üst kesite çıkmak iyi olur.',
    ),

    // 6) RCBO/RCD konusu
    MakaleBlok.text(
      '🛡️ RCD / RCCB / RCBO (KAÇAK AKIM) İLE İLİŞKİSİ\n'
      'MCB aşırı akım ve kısa devreyi keser.\n'
      'Kaçak akım rölesi (RCD/RCCB) ise insanı elektrik çarpmasına karşı korur.\n\n'
      '• RCCB (RCD): Sadece kaçak akımı algılar, aşırı akım koruması yoktur\n'
      '• RCBO: Hem kaçak akım hem sigorta (MCB) koruması bir arada\n\n'
      'Evde yaygın kullanım:\n'
      '• 30 mA: İnsan koruma (banyo, priz devreleri vb.)\n'
      '• 300 mA: Yangın koruma (ana koruma senaryoları)\n\n'
      'Not: Banyo/ıslak hacimde RCD/RCBO kullanımı hayat kurtarır.',
    ),

    // 7) En kritik hatalar
    MakaleBlok.text(
      '🚫 EN SIK YAPILAN HATALAR (DİKKAT)\n'
      '• “Sigorta atıyor” diye amper büyütmek → kablo ısınır, yangın riski artar\n'
      '• Priz hattına 1.5 mm² kablo çekip C16A takmak → yanlış\n'
      '• Mutfak/fırın/klima gibi yüksek yükleri tek priz hattına bindirmek → ayrı hat daha doğru\n'
      '• Topraklamayı ihmal etmek → kaçak akımda hayati risk\n\n'
      'Kural: Sigorta, kablodan büyük seçilmez; önce kablo ve devre planı doğru olmalı.',
    ),

    // 8) Mini özet
    MakaleBlok.text(
      '✅ HIZLI ÖZET\n'
      '• Evde en yaygın: C16A priz (2.5 mm²), B/C10A aydınlatma (1.5 mm²)\n'
      '• Yük arttıkça: C20A + 4 mm², C25A + 6 mm² düşün\n'
      '• Motorlu yüklerde C tipi daha uyumlu\n'
      '• RCD/RCBO, çarpılmaya karşı ana güvenlik katmanıdır\n',
    ),
  ],
),
  Makale(
   id: 'e4',
   baslik: 'Topraklama Ölçümü Adımları',
   icerik:
      'TOPRAKLAMA ÖLÇÜMÜ NEDİR?\n\n'
      'Topraklama ölçümü; elektrik tesisatlarında insanların can güvenliğini sağlamak, cihazları korumak ve kaçak akımların güvenli şekilde toprağa iletilmesini doğrulamak için yapılan ölçümdür. Ölçüm sonucunda elde edilen değer “topraklama direnci (Ω)” olarak ifade edilir.\n\n'

      '🔹 TOPRAKLAMA NEDEN ÖNEMLİDİR?\n\n'
      '• Elektrik çarpmasını önler\n'
      '• Kaçak akımların güvenli şekilde toprağa iletilmesini sağlar\n'
      '• Elektrikli cihazların arızalanmasını önler\n'
      '• Parafudr ve yıldırımdan korunma sistemlerinin doğru çalışmasını sağlar\n'
      '• Yönetmeliklere uygunluk sağlar\n\n'

      '🔹 YÖNETMELİĞE GÖRE TOPRAKLAMA DİRENÇ DEĞERLERİ\n\n'
      'Topraklama direnci sınırları tesisin türüne göre değişir:\n\n'
      '• Konut ve genel tesisler: ≤ 10 Ω\n'
      '• Hassas elektronik cihazlar: ≤ 5 Ω\n'
      '• Yıldırımdan korunma tesisleri: ≤ 10 Ω\n'
      '• Trafo ve enerji tesisleri: ≤ 2 Ω\n\n'
      'Not: Saha koşulları ve yönetmelik maddelerine göre bu değerler değişiklik gösterebilir.\n\n'

      '🔹 TOPRAKLAMA ÖLÇÜMÜNDE KULLANILAN CİHAZ (MEGGER)\n\n'
      'Topraklama ölçümleri için özel olarak üretilmiş “Topraklama Ölçüm Cihazı (Megger)” kullanılır. Bu cihaz, klasik multimetre ile ölçüm yapılamayan toprak direncini doğru şekilde ölçer.\n\n'
      'Megger cihazı üzerinde genellikle şu bağlantılar bulunur:\n'
      '• E (Earth)  → Toprak elektrodu\n'
      '• P (Potential) → Potansiyel kazığı\n'
      '• C (Current) → Akım kazığı\n\n'

      '🔹 3 NOKTA METODU (EN YAYGIN ÖLÇÜM YÖNTEMİ)\n\n'
      'Sahada en sık kullanılan yöntem “3 nokta metodu”dur. Bu yöntemde iki adet yardımcı kazık kullanılır.\n\n'

      'ADIM 1 – TOPRAK ELEKTRODUNU AYIR\n'
      'Ölçüm yapılacak topraklama elektrodu tesisattan ayrılır. Ölçüm sırasında başka topraklamalar devreye girmemelidir.\n\n'

      'ADIM 2 – KAZIKLARIN ÇAKILMASI\n'
      '• Akım kazığı (C): Toprak elektrodundan genellikle 20–30 metre uzağa çakılır\n'
      '• Potansiyel kazığı (P): İki kazık arasının yaklaşık ortasına çakılır\n'
      'Kazıklar nemli toprağa ve sağlam şekilde çakılmalıdır.\n\n'

      'ADIM 3 – MEGGER BAĞLANTILARI\n'
      '• E ucu → Ölçülecek toprak elektrodu\n'
      '• P ucu → Potansiyel kazığı\n'
      '• C ucu → Akım kazığı\n'
      'Bağlantı kabloları düzgün, oksitsiz ve sıkı olmalıdır.\n\n'

      'ADIM 4 – ÖLÇÜMÜ YAP\n'
      'Megger cihazı çalıştırılır ve ölçüm alınır. Cihaz toprağa bir akım gönderir ve direnç değerini hesaplar.\n\n'

      'ADIM 5 – DOĞRULAMA ÖLÇÜMLERİ\n'
      'Potansiyel kazığı birkaç metre ileri ve geri alınarak ölçüm tekrarlanır. Değerler birbirine yakınsa ölçüm sağlıklıdır.\n\n'

      '🔹 ÖLÇÜM SONUCU NASIL DEĞERLENDİRİLİR?\n\n'
      '• Ölçülen değer yönetmelik sınırlarının altındaysa → Topraklama uygundur\n'
      '• Değer yüksekse → İlave topraklama çubuğu çakılmalı veya zemin iyileştirilmelidir\n\n'

      '🔹 TOPRAKLAMA DİRENCİ YÜKSEK ÇIKARSA NE YAPILIR?\n\n'
      '• İlave bakır topraklama çubuğu eklenir\n'
      '• Topraklama çubukları arası mesafe artırılır\n'
      '• Nemlendirici topraklama jelleri kullanılabilir\n'
      '• Daha iletken zeminlere yönelinir\n\n'
           

      '🔹 SIK YAPILAN HATALAR\n\n'
      '• Topraklama elektrodu tesisata bağlıyken ölçüm yapmak\n'
      '• Kazıkları çok yakın çakmak\n'
      '• Oksitli ve gevşek bağlantılar\n'
      '• Multimetre ile toprak direnci ölçmeye çalışmak\n\n'

      '🔹 SONUÇ\n\n'
      'Topraklama ölçümü, elektrik tesisatlarının en kritik güvenlik kontrollerinden biridir. Doğru cihaz, doğru yöntem ve uygun saha koşulları ile yapılan ölçümler; hem can güvenliği hem de tesis güvenliği açısından hayati öneme sahiptir.',
  kategori: 'elektrik',
  ikonAsset: 'assets/images/topraklama_icon.png', // ✅ küçük ikon
  ),
Makale(
  id: 'e5',
  baslik: 'Multimetre Nedir? Kadran Sembolleri, Ölçüm Modları ve Doğru Kullanım',
  kategori: 'elektrik',
  ikonAsset: 'assets/images/multimetre.png',
  icerik:
      'Multimetre, elektrik ve elektronik tesisatlarda gerilim, akım ve '
      'direnç gibi temel büyüklükleri ölçmek için kullanılan en önemli '
      'ölçü aletidir.\n\n'
      'Bir multimetreyi doğru kullanmak; arıza tespitini hızlandırır, '
      'yanlış ölçümden doğabilecek tehlikeleri önler.\n\n'
      'Bu makalede multimetrenin üzerindeki kadran sembolleri, '
      'her modun ne işe yaradığı ve sahada doğru kullanım detaylı şekilde anlatılır.',
  bloklar: const [

    // 1️⃣ Multimetre nedir
    MakaleBlok.text(
      '📟 MULTİMETRE NEDİR?\n'
      'Multimetre; birden fazla ölçüm fonksiyonunu tek gövdede '
      'toplayan çok amaçlı ölçü aletidir.\n\n'
      'Temel ölçümler:\n'
      '• Gerilim (V)\n'
      '• Akım (A)\n'
      '• Direnç (Ω)\n\n'
      'Ek fonksiyonlar (modele göre):\n'
      '• Süreklilik (buzzer)\n'
      '• Diyot testi\n'
      '• Kapasitans (F)\n'
      '• Frekans (Hz)\n'
      '• Sıcaklık (°C)',
 
    ),
    MakaleBlok.image(
    'assets/images/multimetre.png',
    ),

    // 2️⃣ Kadran sembolleri – Gerilim
    MakaleBlok.text(
      '⚡ GERİLİM ÖLÇÜM SEMBOLLERİ (V)\n\n'
      '🔌 AC GERİLİM (ŞEBEKE):\n'
      'Sembol:  V~   veya   ∿\n'
      '• Priz, pano, şebeke ölçümü\n'
      '• 220V / 380V ölçümleri\n\n'
      '🔋 DC GERİLİM:\n'
      'Sembol:  V⎓   veya   V—\n'
      '• Pil, akü, adaptör, elektronik devre\n\n'
      'Not:\n'
      'AC ölçümde prob yönü önemli değildir, '
      'DC ölçümde + / – yönü ölçüm işaretini etkiler.',
    ),

    // 3️⃣ Akım sembolleri
    MakaleBlok.text(
      '🔄 AKIM ÖLÇÜM SEMBOLLERİ (A)\n\n'
      '🔌 AC AKIM:\n'
      'Sembol:  A~\n'
      '• Alternatif akım\n'
      '• Multimetrede nadir, pens ampermetrede yaygın\n\n'
      '🔋 DC AKIM:\n'
      'Sembol:  A⎓   veya   A—\n'
      '• Elektronik devre akımı\n\n'
      '⚠️ UYARI:\n'
      'Akım ölçümü seri yapılır.\n'
      'Akım modunda priz ölçülmez!',
    ),

    // 4️⃣ Direnç
    MakaleBlok.text(
      '🟤 DİRENÇ ÖLÇÜMÜ\n'
      'Sembol:  Ω\n\n'
      'Ne için kullanılır?\n'
      '• Direnç değeri ölçümü\n'
      '• Kablo kopukluk kontrolü\n'
      '• Bobin/sargı sağlamlık kontrolü\n\n'
      '⚠️ KURAL:\n'
      'Direnç ölçümü mutlaka enerjisiz devrede yapılır.',
    ),

    // 5️⃣ Süreklilik (buzzer)
    MakaleBlok.text(
      '🔔 SÜREKLİLİK TESTİ (BUZZER)\n'
      'Sembol:  🔔   veya   )))\n\n'
      'Ne işe yarar?\n'
      '• Kablo sağlam mı?\n'
      '• Sigorta atık mı?\n'
      '• Anahtar çalışıyor mu?\n\n'
      'Problar değdiğinde öterse:\n'
      '→ Hat süreklidir.',
    ),

    // 6️⃣ Diyot
    MakaleBlok.text(
      '🔺 DİYOT TESTİ\n'
      'Sembol:  →|—\n\n'
      'Ne için kullanılır?\n'
      '• Diyot, LED, köprü diyot kontrolü\n\n'
      'Sağlam diyot:\n'
      '• Tek yönde değer\n'
      '• Ters yönde OL / ∞',
    ),

    // 7️⃣ Kapasitans & frekans
    MakaleBlok.text(
      '📦 DİĞER KADRAN SEMBOLLERİ\n\n'
      'Kapasitans:\n'
      'Sembol:  —| |—   veya   F\n'
      '• Kondansatör ölçümü (µF, nF)\n\n'
      'Frekans:\n'
      'Sembol:  Hz\n'
      '• Şebeke ve sürücü çıkışı kontrolü\n\n'
      'Sıcaklık (varsa):\n'
      'Sembol:  °C\n'
      '• Prob ile sıcaklık ölçümü',
    ),

    // 8️⃣ Giriş soketleri
    MakaleBlok.text(
      '🔌 PROB GİRİŞLERİ (ÇOK KRİTİK)\n'
      '• COM → Siyah prob (ortak)\n'
      '• VΩmA → Gerilim, direnç, diyot\n'
      '• 10A / 20A → Yüksek akım ölçümü\n\n'
      'Yanlış soket = sigorta yanar.',
    ),

    // 9️⃣ En sık hatalar
    MakaleBlok.text(
      '🚫 MULTİMETREDE EN SIK YAPILAN HATALAR\n'
      '• Akım modunda priz ölçmek\n'
      '• Enerjili devrede direnç ölçmek\n'
      '• Yanlış sokette ölçüm yapmak\n'
      '• Ölçüm sonrası kadranı açık bırakmak\n\n'
      'Bu hatalar cihazı ve kullanıcıyı riske atar.',
    ),

    // 🔟 Hızlı özet
    MakaleBlok.text(
      '✅ HIZLI ÖZET\n'
      '• V~ → AC gerilim (priz/pano)\n'
      '• V⎓ → DC gerilim (pil/adaptör)\n'
      '• Ω → direnç\n'
      '• 🔔 → süreklilik\n'
      '• →|— → diyot\n'
      '• Akım ölçümü seri yapılır\n'
      '• Doğru kademe = güvenli ölçüm',
    ),
  ],
),
  Makale(
    id: 'e6',
    baslik: 'Pens Ampermetre ve Diğer Ölçüm Cihazları',
    icerik:
        'Pens Ampermetre Nedir?\n\n'
        'Pens ampermetre, bir iletken üzerinden geçen akımı devreyi kesmeden ölçmeye yarayan ölçü aletidir. '
        'Multimetreden farklı olarak kabloyu sökmeden, sadece tek bir iletkeni kavrayarak akım ölçümü yapılmasını sağlar. '
        'Özellikle panolarda, motorlarda ve canlı hatlarda çok tercih edilir.\n\n'

        'Pens Ampermetre ile Akım Ölçümü\n\n'
        '🔹 Cihazın kadranını AC A (∿A) konumuna getir. (DC ölçüm yapılacaksa DC A seçilir.)\n'
        '🔹 Ölçüm yapılacak hatta SADECE TEK FAZ iletkeni (faz veya nötr) pensin içine al.\n'
        '❗ Faz + nötr birlikte ölçülürse değer 0 çıkar.\n'
        '🔹 Pens tamamen kapalı olmalıdır; yarım kapalı ölçüm hatalı sonuç verir.\n'
        '🔹 Ekrandaki değer, hat üzerinden geçen anlık akımdır.\n\n'

        'Pens Ampermetre Güvenlik İpuçları\n\n'
        '🔹 İzolasyonu hasarlı kablolar ölçülmemelidir.\n'
        '🔹 Yüksek akımlı panolarda tek elle ölçüm yap, diğer elini metal yüzeylerden uzak tut.\n'
        '🔹 Ölçüm sırasında pensin metal aksamı ile iletkene temas ettirilmemelidir.\n\n'

        'Meger (İzolasyon Test Cihazı) Nedir?\n\n'
        'Meger, kabloların ve motor sargılarının izolasyon direncini ölçmek için kullanılır. '
        'Genellikle 500 V, 1000 V gibi yüksek DC test gerilimleri uygular.\n\n'

        'Meger ile İzolasyon Ölçümü\n\n'
        '🔹 Ölçüm öncesi hattın GERİLİMSİZ olduğundan emin ol.\n'
        '🔹 Test edilecek faz ile toprak arasına probları bağla.\n'
        '🔹 Test tuşuna bas ve ölçüm süresince problara dokunma.\n'
        '🔹 Ölçüm sonucu genellikle Megaohm (MΩ) cinsindendir.\n'
        '🔹 1 MΩ altı değerler izolasyon zayıflığına işaret eder.\n\n'

        'Faz Kalemi Nedir?\n\n'
        'Faz kalemi, bir hattın enerjili olup olmadığını kontrol etmek için kullanılan basit kontrol cihazıdır.\n\n'

        'Faz Kalemi Kullanımı\n\n'
        '🔹 Ucu iletken veya priz fazına dokundur.\n'
        '🔹 Elinle faz kaleminin arka metal kısmına temas et.\n'
        '🔹 Işık yanıyorsa hat fazdır ve enerjilidir.\n'
        '❗ Faz kalemi ölçüm cihazı değildir; sadece kontrol amaçlı kullanılır.\n\n'

        'Pano Tipi Voltmetre ve Ampermetre\n\n'
        'Pano tipi ölçü aletleri, sürekli izleme amaçlı kullanılır.\n'
        'Voltmetre paralel bağlanır (faz-nötr veya faz-faz).\n'
        'Ampermetre ise genellikle akım trafosu (CT) üzerinden seri ölçüm yapar.\n\n'

        'Akım Trafosu (CT) Kullanımı\n\n'
        '🔹 Ölçülecek faz iletkeni CT içinden geçirilir.\n'
        '🔹 CT sekonder uçları ampermetreye bağlanır.\n'
        '❗ CT sekonderi açık bırakılmamalıdır; tehlikelidir.\n\n'

        'Sahada Pratik Tavsiyeler\n\n'
        '🔹 Akım ölçümü için önce pens ampermetre tercih edilmelidir.\n'
        '🔹 Gerilim var/yok kontrolü için faz kalemi yeterlidir ancak kesin ölçüm için multimetre kullan.\n'
        '🔹 İzolasyon ölçümü yapmadan önce mutlaka hattı ayır.\n'
        '🔹 Ölçüm cihazlarının probları ve pens izolasyonları düzenli kontrol edilmelidir.\n\n'

        'Bu ölçüm cihazları doğru kullanıldığında arıza tespiti hızlanır, yanlış müdahaleler ve iş kazaları önlenir.',
    kategori: 'elektrik',
    resim: 'assets/images/pensampermetre.png',
  ),
  Makale(
  id: 'e7',
  baslik: 'Üç Fazlı Motorlarda Yıldız–Üçgen Yol Verme',
  icerik: '''
YILDIZ–ÜÇGEN YOL VERME NEDİR?

Yıldız–üçgen yol verme; üç fazlı asenkron motorlarda ilk kalkış anında oluşan yüksek akımı düşürmek amacıyla kullanılan bir yol verme yöntemidir. Özellikle orta ve büyük güçlü motorlarda, direkt yol verme ciddi akım ve gerilim düşümlerine sebep olabilir.

🔹 DİREKT YOL VERMEDE OLUŞAN PROBLEM

Üç fazlı motorlar direkt yol verildiğinde:
• Kalkış akımı nominal akımın 5–7 katına çıkabilir
• Şebekede gerilim düşümü oluşur
• Sigorta ve şalterler zorlanır
• Mekanik aksamda darbe meydana gelir

Bu olumsuzlukları azaltmak için yıldız–üçgen yol verme yöntemi tercih edilir.

- YILDIZ BAĞLANTI İLE KALKIŞ

Motor ilk çalıştırıldığında **yıldız bağlantı** yapılır.
• Sargı uçlarına düşen gerilim azalır
• Motor daha düşük tork ile kalkış yapar
• Kalkış akımı yaklaşık **1/3 oranında düşer**

Bu aşamada motor yük altında olmamalıdır.

- ÜÇGEN BAĞLANTIYA GEÇİŞ

Motor belirli bir hıza ulaştıktan sonra (genellikle %80–90):
• Yıldız bağlantı kesilir
• Üçgen bağlantı devreye girer
• Motor tam gerilim ve tam tork ile çalışmaya devam eder

Bu geçiş işlemi **zaman rölesi** ile otomatik olarak yapılır.

- MOTOR ETİKETİ VE BAĞLANTI ŞEMASI

Yıldız–üçgen yol verme uygulanabilmesi için motor etiketinde genellikle:
• 400V / 690V
veya
• Δ / Y
ifadeleri bulunmalıdır.

Motorun klemens kapağı içinde yıldız ve üçgen bağlantı şeması yer alır.

- YILDIZ–ÜÇGEN YOL VERİCİNİN ANA ELEMANLARI

• Ana kontaktör
• Yıldız kontaktörü
• Üçgen kontaktörü
• Zaman rölesi
• Termik röle
• Sigorta veya şalter

Bu elemanlar birlikte çalışarak motorun güvenli şekilde yol almasını sağlar.

- AVANTAJLARI

• Kalkış akımı düşer
• Şebeke daha az zorlanır
• Mekanik darbe azalır
• Ekonomik ve yaygın bir çözümdür

- DEZAVANTAJLARI

• Kalkış torku düşüktür
• Yük altında kalkış için uygun değildir
• Yanlış zaman ayarı motoru zorlayabilir

- NERELERDE KULLANILIR?

• Pompalar
• Fanlar
• Kompresörler
• Konveyör sistemleri
• Sanayi motorları


Yıldız–üçgen yol verme yöntemi, uygun motor ve doğru ayarlamalarla kullanıldığında hem elektriksel hem de mekanik açıdan güvenli bir çözüm sunar. Ancak motor etiket bilgileri mutlaka kontrol edilmeli ve bağlantılar doğru yapılmalıdır.

⚙️ Yıldız–Üçgen Yol Verici Elemanları\n\n
Ana kontaktör, yıldız kontaktörü, üçgen kontaktörü, termik röle ve zaman rölesinin pano içi yerleşimi aşağıda gösterilmiştir.\n\n
Motor gücüne göre sahada en sık kullanılan yaklaşık değerler aşağıdadır.\n\n


⚠️ Not: • Değerler standart asenkron motorlar için yaklaşık saha değerleridir.
• Motor verimi, cosφ, yol verme şekli (direkt / yıldız–üçgen / soft starter) sonucu etkiler.
• Termik röle ayarı, motorun etiket akımına göre yapılmalıdır.

🔧 Motor Akımına Uygun Termik, Kontaktör ve Sigorta Seçimi

''',
  kategori: 'elektrik',
  resim: 'assets/images/Motorsema.png',
  resimAltta: true,
  resimOrta: 'assets/images/ücgenyıldız.png',
),
 Makale(
  id: 'e8',
  baslik: 'Kompanzasyon Panosu Nedir? Ne İşe Yarar? Montaj ve Bağlantı Rehberi',
  kategori: 'elektrik',
  ikonAsset: 'assets/images/kompanzasyon.png',
  icerik:
      'Kompanzasyon panosu; işletmelerde ve büyük tesislerde reaktif gücü dengeleyerek '
      'enerji kalitesini artıran, reaktif ceza riskini azaltan ve trafonun/kabloların '
      'gereksiz yüklenmesini önleyen sistem panosudur.\n\n'
      'Bu makalede kompanzasyonun mantığını, pano içindeki elemanları, '
      '“nereden girer nereden çıkar” bağlantı akışını, montaj adımlarını ve devreye alma '
      'ayarlarını sahada işine yarayacak şekilde anlatıyorum.',
  bloklar: const [
    // 1) Giriş - Tanım
    MakaleBlok.text(
      '⚡ KOMPANZASYON PANOSU NEDİR?\n'
      'Kompanzasyon panosu, tesisin çektiği reaktif gücü (özellikle endüktif yüklerden: motor, trafo, balast, kaynak vb.) '
      'kondansatör kademeleri ile dengeleyip güç katsayısını (cosφ) iyileştiren panodur.\n\n'
      'Basit mantık:\n'
      '• Tesis endüktif reaktif çekince cosφ düşer\n'
      '• RGK (Reaktif Güç Kontrol Rölesi) bunu algılar\n'
      '• Uygun kondansatör kademesini devreye alır\n'
      '• Reaktif dengelenir, cosφ yükselir\n\n'
      'Sonuç:\n'
      '• Reaktif ceza riski azalır\n'
      '• Akım düşer, kablo/trafo daha rahatlar\n'
      '• Gerilim düşümü ve ısınma azalır\n'
      '• Enerji kalitesi ve sistem verimi artar',
    ),

    // 2) Ne işe yarar - nerede kullanılır
    MakaleBlok.text(
      '🎯 NE İŞE YARAR? (PRATİK)\n'
      'Kompanzasyonun sahadaki faydası “boşa akan reaktif akımı azaltmak”tır.\n\n'
      'Kullanım yerleri:\n'
      '• Fabrikalar, atölyeler, AVM’ler, siteler\n'
      '• Büyük motorlu sistemler (hidrofor, havalandırma, chiller)\n'
      '• Trafo merkezli tüm tesisler\n\n'
      'Not:\n'
      'Kompanzasyon “enerjiyi bedava yapmaz”; amaç reaktif akımı azaltıp sistemi rahatlatmak ve cezayı önlemektir.',
    ),

    // 3) Pano içindeki temel elemanlar
    MakaleBlok.text(
      '🧩 KOMPANZASYON PANOSUNDA NELER VAR?\n'
      'Temel elemanlar:\n'
      '• RGK Rölesi (beyin)\n'
      '• Akım Trafosu (CT) (ölçüm gözü)\n'
      '• Kondansatör Kademeleri (reaktif üretir)\n'
      '• Kondansatör Kontaktörleri (kademeyi aç/kapatır)\n'
      '• Sigorta/Şalter (kademeleri korur)\n'
      '• Bara ve kablolama\n'
      '• Fan + termostat (soğutma)\n'
      '• Deşarj dirençleri (kondansatör güvenliği)\n\n'
      'Opsiyonel/ileri seviye:\n'
      '• Reaktör (harmonik filtreli sistem)\n'
      '• Thyristor (hızlı anahtarlama)\n'
      '• Ölçüm analizörü / enerji analizörü',
    ),

    // 4) Genel akış: Nereden girer, nereden çıkar
    MakaleBlok.text(
      '🔁 “NEREDEN GİRER NEREDEN ÇIKAR?” BAĞLANTI AKIŞI (MANTIK)\n'
      'Kompanzasyon panosu genelde ana dağıtım panosuna paralel çalışır.\n\n'
      '1) GÜÇ (KUVVET) TARAFI:\n'
      '• Pano beslemesi ana baradan alınır (L1-L2-L3)\n'
      '• Her kademe kendi korumasından (sigorta/şalter) geçer\n'
      '• Kontaktör üzerinden kondansatöre gider\n'
      '• Kondansatör devreye girince reaktif üretir (paralel dengeleme)\n\n'
      '2) KONTROL (KUMANDA) TARAFI:\n'
      '• RGK rölesi beslenir (genelde L-N 230V veya modele göre)\n'
      '• CT’den ölçüm sinyali RGK’ya gelir (S1-S2)\n'
      '• RGK’nın kademe çıkışları kontaktör bobinlerini sürer\n\n'
      'Özet cümle:\n'
      '• Güç baradan kondansatöre akar\n'
      '• Kontrol ise CT → RGK → kontaktör bobini şeklinde ilerler',
    ),

    // 5) Görsel (genel pano)
    MakaleBlok.image(
      'assets/images/kompanzasyon.png',
      aciklama:
          'Tipik kompanzasyon panosu görünümü. Kademe kontaktörleri, kondansatörler ve RGK rölesi genelde aynı gövdede bulunur.\n'
          'Saha ipucu: Etiketleme (Kademe-1, Kademe-2…) ve bara düzeni bakım/arıza hızını uçurur.',
    ),

    // 6) CT (Akım trafosu) çok kritik bölüm
    MakaleBlok.text(
      '🧲 AKIM TRAFOSU (CT) NASIL BAĞLANIR? (EN KRİTİK NOKTA)\n'
      'CT kompanzasyonun “doğru görmesi” için şarttır.\n\n'
      '• CT, genelde ana beslemenin bir fazına takılır (çoğunlukla L1)\n'
      '• CT yönü önemlidir: P1 → şebeke yönü, P2 → yük yönü (üreticiye göre değişebilir)\n'
      '• Sekonder uçları S1-S2 RGK’nın CT girişine gider\n\n'
      'Çok önemli uyarılar:\n'
      '• CT sekonderini asla açıkta bırakma! (boştayken tehlikeli gerilim oluşabilir)\n'
      '• S1-S2 ters bağlanırsa sistem “ters” çalışır (yanlış kademe davranışı)\n'
      '• CT oranı (örn: 300/5) RGK’ya doğru girilmelidir',
    ),

    // 7) Güç devresi detay: kademe hattı
    MakaleBlok.text(
      '🔌 KADEME GÜÇ DEVRESİ (KUVVET) DETAYI\n'
      'Her kademe şu sırayla gider:\n'
      'ANA BARA (L1-L2-L3) → KADEME SİGORTASI/ŞALTERİ → KONTAKTÖR ANA KONTAKLARI → KONDANSATÖR\n\n'
      'Kondansatörler genelde 3 faz bağlıdır (L1-L2-L3).\n'
      'Bazı sistemlerde kondansatörün kendi iç deşarj direnci vardır; yoksa harici deşarj eklenir.\n\n'
      'Saha ipucu:\n'
      '• Kontaktör “kondansatör kontaktörü” olmalı (ön dirençli/ön kontaklı tip)\n'
      '• Normal kontaktörle uzun vadede kontak yapışma/yanma riski artar',
    ),

    // 8) Kontrol devresi detay: RGK çıkışları
    MakaleBlok.text(
      '🎛️ RGK (REAKTİF GÜÇ KONTROL RÖLESİ) BAĞLANTI MANTIĞI\n'
      'RGK rölesinde genelde şu bağlantılar olur:\n'
      '• Besleme: L-N (veya modele göre farklı)\n'
      '• Ölçüm: CT girişi (S1-S2)\n'
      '• Gerilim ölçümü: L1-L2-L3 veya L-N (modele göre)\n'
      '• Kademe çıkışları: 1…N (kontaktör bobinlerini sürer)\n\n'
      'Kademe çıkış mantığı:\n'
      '• RGK çıkışı aktif olunca → ilgili kontaktör bobini çeker\n'
      '• Kontaktör çekince → kondansatör devreye girer\n\n'
      'Saha notu:\n'
      'Kontaktör bobin beslemesini (A1-A2) hangi gerilimle sürüyorsan (230V/400V) ona göre RGK çıkışını ve ortak hattı düzenle.',
    ),

    // 9) Montaj adımları (pratik saha akışı)
    MakaleBlok.text(
      '🧰 MONTAJ / KURULUM ADIMLARI (SAHA SIRASI)\n'
      '1) Proje/hesap:\n'
      '• Tesis gücü, mevcut cosφ, hedef cosφ belirlenir\n'
      '• Toplam kondansatör kVAr ihtiyacı ve kademe dağılımı planlanır\n\n'
      '2) Mekanik montaj:\n'
      '• Pano yeri havalandırmalı ve erişilebilir olmalı\n'
      '• Fan hava akışı önü kapanmamalı\n'
      '• Topraklama barası düzgün yapılmalı\n\n'
      '3) Bara & kablolama:\n'
      '• Kademe sigortaları ve kontaktör hatları temiz/etiketli çekilir\n'
      '• Kondansatör kabloları kesit uygun seçilir\n\n'
      '4) CT montajı:\n'
      '• Uygun faza takılır, yönü doğru ayarlanır\n'
      '• Sekonder S1-S2 RGK’ya gider (kısa devre köprüsü güvenliği unutulmaz)\n\n'
      '5) RGK ayarları & devreye alma:\n'
      '• CT oranı\n'
      '• Kademe sayısı\n'
      '• Hedef cosφ\n'
      '• Kademe devreye alma gecikmeleri\n\n'
      '6) Test:\n'
      '• Kademeler tek tek devreye giriyor mu?\n'
      '• Kontaktör sesi/ısınma normal mi?\n'
      '• Endüktif/kapasitif taşma var mı?',
    ),

    // 10) Devreye alma ayarları (net)
    MakaleBlok.text(
      '✅ DEVREYE ALMA (EN ÇOK LAZIM OLAN AYARLAR)\n'
      'Genel hedef:\n'
      '• cosφ ≈ 0.95 civarı (tesis ve dağıtım şirketi şartlarına göre)\n\n'
      'RGK’da tipik kontrol listesi:\n'
      '• CT oranı doğru mu? (örn: 400/5)\n'
      '• Kademe sayısı doğru mu?\n'
      '• Kademe kVAr değerleri doğru mu?\n'
      '• Devreye alma gecikmesi: çok kısa olursa “avlanma” yapar\n'
      '• Kapasitif taşma: gece yük azsa fazla kademe kalmasın\n\n'
      'İpucu:\n'
      'Gece yük çok düşüyorsa, kademe sayısını/dağılımını ve “min yük” davranışını iyi ayarla.',
    ),

    // 11) Harmonik / reaktör notu (kısa ama kritik)
    MakaleBlok.text(
      '🎚️ HARMONİK VARSA NE OLUR? (REAKTÖRLÜ SİSTEM)\n'
      'Tesisinde sürücüler (VFD), UPS, LED sürücüleri, kaynak makineleri fazlaysa harmonik yükselir.\n'
      'Bu durumda standart kondansatör sistemi:\n'
      '• aşırı akım/ısınma\n'
      '• kondansatör ömrü kısalması\n'
      '• sigorta atma\n'
      'gibi sorun çıkarabilir.\n\n'
      'Çözüm:\n'
      '• Reaktörlü (detuned) filtreli kompanzasyon veya uygun harmonik filtresi değerlendirilir.',
    ),

    // 12) Sık yapılan hatalar
    MakaleBlok.text(
      '🚫 EN SIK YAPILAN HATALAR (SAHADA)\n'
      '• CT yönünü ters takmak veya S1-S2’yi terslemek\n'
      '• CT oranını RGK’ya yanlış girmek\n'
      '• Normal kontaktör kullanıp kondansatör kontaktörü kullanmamak\n'
      '• Kademe kVAr’larını rastgele dağıtmak (dengesiz kademe)\n'
      '• Yetersiz havalandırma (fan/filtre ihmal)\n'
      '• Kondansatör kablo kesitini küçük seçmek\n'
      '• Topraklama/PE düzenini zayıf bırakmak\n'
      '• Gece kapasitif taşmayı takip etmemek',
    ),

    // 13) Hızlı özet / saha checklist
    MakaleBlok.text(
      '📌 HIZLI ÖZET + CHECKLIST\n'
      'Kompanzasyon panosu:\n'
      '• Reaktif gücü dengeler, cosφ’i yükseltir\n'
      '• CT → RGK → kontaktör → kondansatör kademeleri mantığıyla çalışır\n\n'
      'Devreye almadan önce:\n'
      '□ CT yönü doğru\n'
      '□ S1-S2 doğru\n'
      '□ CT oranı doğru\n'
      '□ Kademe sigortaları ve kontaktörler uygun\n'
      '□ Fan/filtre temiz ve çalışır\n'
      '□ Topraklama tamam\n'
      '□ Hedef cosφ ve gecikmeler ayarlı\n\n'
      'Doğru kurulum + doğru ayar = cezasız, serin çalışan, uzun ömürlü sistem.',
    ),
  ],
),
  Makale(
  id: 'e9',
  baslik:
      'Zaman Saatleri: Astronomik Zaman Saati ve Mekanik Zaman Saati Nedir? Kullanım ve Karşılaştırma Rehberi',
  kategori: 'elektrik',
  ikonAsset: 'assets/images/astronomikzamansaati1.jpg',
  icerik:
      'Zaman saatleri, elektrik devrelerini belirli saatlerde otomatik olarak '
      'açıp kapatmaya yarayan kontrol elemanlarıdır.\n\n'
      'Sokak aydınlatmaları, site bahçe lambaları, tabela ışıkları, '
      'reklam panoları ve benzeri birçok uygulamada manuel müdahaleye gerek '
      'kalmadan enerji kontrolü sağlar.\n\n'
      'Bu makalede mekanik zaman saati ile astronomik zaman saatinin '
      'çalışma mantığı, farkları, nerede hangisinin tercih edilmesi gerektiği '
      'net ve pratik şekilde anlatılır.',
  bloklar: const [

    // 1) Zaman saati nedir
    MakaleBlok.text(
      '⏱️ ZAMAN SAATİ NEDİR?\n'
      'Zaman saati, bağlı olduğu elektrik hattını önceden ayarlanan saatlere '
      'göre otomatik olarak açan veya kapatan cihazdır.\n\n'
      'Genel amaç:\n'
      '• Gereksiz enerji tüketimini önlemek\n'
      '• Manuel aç-kapa ihtiyacını ortadan kaldırmak\n'
      '• Düzenli ve güvenilir çalışma sağlamak\n\n'
      'Zaman saatleri temel olarak ikiye ayrılır:\n'
      '• Mekanik (klasik) zaman saati\n'
      '• Astronomik zaman saati',
    ),

    // 2) Mekanik zaman saati
    MakaleBlok.text(
      '⚙️ MEKANİK ZAMAN SAATİ NEDİR?\n'
      'Mekanik zaman saati, içindeki motor ve döner disk sistemiyle çalışan '
      'klasik zaman saatidir.\n\n'
      'Çalışma mantığı:\n'
      '• Gün 24 saatlik bir diskle temsil edilir\n'
      '• Disk üzerindeki mandallar/pimler açma-kapama zamanını belirler\n'
      '• Saat ayarı manuel yapılır\n\n'
      'Özellikler:\n'
      '• Genelde günlük veya haftalık programlama\n'
      '• Sabit saatlerde çalışır (gün doğumu/batımı dikkate alınmaz)\n'
      '• Kurulumu basit, maliyeti düşüktür\n\n'
      'Kullanım alanları:\n'
      '• Sabit saatli tabela ışıkları\n'
      '• Atölye, depo, basit aydınlatmalar\n'
      '• Gün doğumu/batımı hassasiyeti gerekmeyen sistemler',
    ),
    MakaleBlok.image(
    'assets/images/mekanikzamansaati.webp',
    aciklama:
      'Mekanik zaman saati bağlantı şeması.\n\n'
      '• A1 – A2: Zaman saatinin besleme uçlarıdır (genelde 220V AC).\n'
      '  Faz (L) → A1, Nötr (N) → A2 bağlanır.\n\n'
      '• COM (C): Ortak kontak ucudur.\n'
      '• NO: Ayarlanan saatlerde kapanan kontak (en yaygın kullanılan).\n'
      '• NC: Ayarlanan saatlerde açılan kontak (nadiren kullanılır).\n\n'
      'Bu şemada zaman saati, kontaktör bobinini sürmek için kullanılmıştır.\n'
      'Zaman geldiğinde COM ile NO birleşir, kontaktör çeker ve yük devreye girer.\n\n'
      'Not: Yüksek güçlü aydınlatma veya cihazlar doğrudan zaman saatinden '
      'beslenmemeli, mutlaka kontaktör üzerinden sürülmelidir.',
    ),
    MakaleBlok.image(
        'assets/images/mekanikzamansaati1.png',
    ),

    // 3) Astronomik zaman saati
    MakaleBlok.text(
      '🌅 ASTRONOMİK ZAMAN SAATİ NEDİR?\n'
      'Astronomik zaman saati, bulunduğu konuma göre '
      'gün doğumu ve gün batımı saatlerini otomatik hesaplayan '
      'akıllı zaman saatidir.\n\n'
      'Çalışma mantığı:\n'
      '• Şehir/bölge bilgisi girilir\n'
      '• Gün doğumu ve gün batımı saatlerini otomatik bilir\n'
      '• Mevsimlere göre saatleri kendisi günceller\n\n'
      'Özellikler:\n'
      '• Yaz-kış saati değişimlerinden etkilenmez\n'
      '• Işıklar tam gün batımında yanar, gün doğumunda söner\n'
      '• Manuel ayar ihtiyacı çok azdır\n\n'
      'Kullanım alanları:\n'
      '• Sokak ve site aydınlatmaları\n'
      '• Bahçe ve çevre aydınlatmaları\n'
      '• Otopark, park, yol aydınlatmaları',
    ),
    MakaleBlok.image(
  'assets/images/astronomikzamansaati.jpg',
  aciklama:
    'Entes DTR-10 astronomik zaman saati bağlantı şeması.\n\n'
    '• L – N: DTR-10 besleme uçlarıdır (220V AC).\n'
    '  Faz (L) → L, Nötr (N) → N bağlanır.\n\n'
    '• COM (C): Röle ortak çıkış ucudur.\n'
    '• NO: Gün batımında kapanan, gün doğumunda açılan kontak '
    '(site, sokak ve çevre aydınlatmalarında standart kullanım).\n'
    '• NC: Gün doğumunda kapanan, gün batımında açılan kontak '
    '(özel kontrol senaryolarında kullanılır).\n\n'
    'Bu bağlantıda DTR-10, kontaktör bobinini astronomik '
    'gün doğumu ve gün batımı saatlerine göre otomatik olarak sürer.\n'
    'Zaman geldiğinde COM ile NO birleşir, kontaktör çeker ve '
    'aydınlatma devresi enerjilenir.\n\n'
    'Önemli ayarlar:\n'
    '• Şehir/Bölge doğru seçilmelidir.\n'
    '• Çalışma modu AUTO konumunda olmalıdır.\n'
    '• Gün batımı + / – offset değerleri ihtiyaca göre ayarlanabilir.\n\n'
    'Not: DTR-10 yüksek güçlü yükleri doğrudan sürmek için '
    'kullanılmaz; mutlaka kontaktör ile birlikte kullanılmalıdır.',
   ),
   MakaleBlok.image(
        'assets/images/astronomikzamansaati1.jpg',
    ),


    // 4) Karşılaştırma
    MakaleBlok.text(
      '🆚 MEKANİK vs ASTRONOMİK ZAMAN SAATİ KARŞILAŞTIRMASI\n'
      'Mekanik Zaman Saati:\n'
      '• Sabit saatle çalışır\n'
      '• Gün doğumu/batımı dikkate alınmaz\n'
      '• Ucuz ve basittir\n\n'
      'Astronomik Zaman Saati:\n'
      '• Gün doğumu/batımına göre çalışır\n'
      '• Mevsimsel değişimleri otomatik takip eder\n'
      '• Daha pahalı ama daha verimli\n\n'
      'Özet:\n'
      '• Sabit saat → Mekanik\n'
      '• Doğal ışığa uyum → Astronomik',
    ),

    // 5) Bağlantı ve kullanım
    MakaleBlok.text(
      '🔌 BAĞLANTI VE KULLANIMDA DİKKAT EDİLECEKLER\n'
      '• Zaman saati genelde kontaktör bobinini sürmek için kullanılır\n'
      '• Yük doğrudan zaman saatine bindirilmemelidir (yüksek güçte)\n'
      '• Astronomik saatlerde doğru şehir seçimi önemlidir\n'
      '• Manuel / Auto modu kontrol edilmelidir\n\n'
      'İpucu:\n'
      'Büyük aydınlatma sistemlerinde zaman saati + kontaktör '
      'kombinasyonu en sağlıklı çözümdür.',
    ),

    // 6) Sık yapılan hatalar
    MakaleBlok.text(
      '🚫 EN SIK YAPILAN HATALAR\n'
      '• Astronomik saat yerine mekanik saat kullanıp '
      'mevsimsel sorun yaşamak\n'
      '• Yükü direkt zaman saatinden geçirmek\n'
      '• Saat ayarını yaz-kış değişiminde güncellememek\n'
      '• Auto / Manuel modunu yanlış konumda bırakmak\n\n'
      'Doğru seçim, hem enerji tasarrufu hem sistem ömrü sağlar.',
    ),

    // 7) Mini özet
    MakaleBlok.text(
      ' HIZLI ÖZET\n'
      '• Mekanik zaman saati: Basit, ucuz, sabit saatli\n'
      '• Astronomik zaman saati: Akıllı, gün doğumu/batımına duyarlı\n'
      '• Aydınlatma sistemlerinde astronomik saat daha verimlidir\n'
      '• Yüksek güçte mutlaka kontaktör kullanılmalıdır\n',
    ),
  ],
),
Makale(
  id: 'e10',
  baslik: 'AutoCAD Nedir? Elektrik Projelerinde Kullanımı, Şemalar ve Temel Kavramlar',
  kategori: 'elektrik',
  ikonAsset: 'assets/images/autocad.webp',
  icerik:
      'AutoCAD, teknik çizimlerin bilgisayar ortamında hassas ve ölçekli '
      'şekilde hazırlanmasını sağlayan profesyonel bir çizim programıdır.\n\n'
      'Elektrik projelerinde; aydınlatma, priz, kuvvet, pano, topraklama ve '
      'tek hat şemalarının çizilmesi ve okunması için standart haline gelmiştir.\n\n'
      'Bu makalede AutoCAD’in ne olduğunu, elektrik alanında neden bu kadar '
      'tercih edildiğini, çizim türlerini, şema mantığını ve sahada en çok '
      'karşılaşılan elektrik birimlerini net şekilde anlatıyoruz.',
  bloklar: const [

    // 1) AutoCAD nedir
    MakaleBlok.text(
      '📐 AUTOCAD NEDİR?\n'
      'AutoCAD, teknik çizimlerin bilgisayar destekli (CAD) olarak '
      'hazırlanmasını sağlayan bir çizim yazılımıdır.\n\n'
      'Elle çizime göre avantajları:\n'
      '• Ölçekli ve hatasız çizim\n'
      '• Revizyonun kolay olması\n'
      '• Proje standartlarına uygunluk\n'
      '• Dosya paylaşımı ve arşivleme kolaylığı\n\n'
      'Elektrik projelerinde AutoCAD, adeta ortak dil gibidir.',
    ),

    // 2) Elektrik alanında nerelerde kullanılır
    MakaleBlok.text(
      '⚡ AUTOCAD ELEKTRİKTE NERELERDE KULLANILIR?\n'
      'AutoCAD, elektrik projelerinin hemen her aşamasında kullanılır:\n\n'
      '• Aydınlatma projeleri\n'
      '• Priz ve kuvvet tesisatı\n'
      '• Pano yerleşim planları\n'
      '• Tek hat şemaları\n'
      '• Topraklama ve paratoner projeleri\n'
      '• Kablo güzergâhları ve tray planları\n\n'
      'Sahada uygulama yapan elektrikçi için AutoCAD projesi, '
      '“ne nereye gidecek” sorusunun net cevabıdır.',
    ),

    // 3) Neden bu kadar tercih edilir
    MakaleBlok.text(
      '⭐ NEDEN AUTOCAD BU KADAR TERCİH EDİLİR?\n'
      'AutoCAD’in bu kadar yaygın olmasının temel sebepleri:\n\n'
      '• Tüm mühendislik disiplinlerinde ortak standart\n'
      '• Belediyeler ve dağıtım şirketleri AutoCAD projelerini kabul eder\n'
      '• Ölçek, ölçü ve mesafe birebir gerçeğe uygundur\n'
      '• Sahada hatayı azaltır, işi hızlandırır\n\n'
      'Özetle:\n'
      'AutoCAD bilen elektrikçi, projeyi sadece çizen değil, '
      'okuyabilen ve uygulayabilen elektrikçidir.',
    ),

    // 4) Elektrik AutoCAD çizim türleri
    MakaleBlok.text(
      '🗂️ ELEKTRİK AUTOCAD ÇİZİM TÜRLERİ\n'
      'Elektrik projelerinde en sık karşılaşılan çizimler:\n\n'
      '1️⃣ Aydınlatma Planı\n'
      '• Armatür yerleri\n'
      '• Anahtarlar ve hatlar\n'
      '• Linye ve sorti mantığı\n\n'
      '2️⃣ Priz & Kuvvet Planı\n'
      '• Priz yerleşimleri\n'
      '• Kuvvet hatları\n'
      '• Makine beslemeleri\n\n'
      '3️⃣ Pano Yerleşim Planı\n'
      '• Ana pano, tali pano konumları\n'
      '• Pano numaraları\n\n'
      '4️⃣ Tek Hat Şeması\n'
      '• Enerjinin kaynaktan yüke kadar izlediği yol\n'
      '• Şalter, sigorta, kontaktör, röle gösterimleri',
    ),

    // 5) Tek hat şeması mantığı
    MakaleBlok.text(
      '📊 TEK HAT ŞEMASI (ONE LINE DIAGRAM) MANTIĞI\n'
      'Tek hat şeması, üç fazlı sistemlerin sadeleştirilmiş gösterimidir.\n\n'
      'Tek hat şemasında:\n'
      '• Fazlar tek çizgi ile temsil edilir\n'
      '• Şalter, sigorta ve koruma elemanları sembollerle gösterilir\n'
      '• Panodan çıkan her hat ayrı ayrı takip edilebilir\n\n'
      'Sahadaki en büyük avantajı:\n'
      'Arıza ve bakım sırasında “hangi hat nereye gidiyor” '
      'sorusuna saniyeler içinde cevap verir.',
    ),

    // 6) AutoCAD’de sembol mantığı
    MakaleBlok.text(
      '🔣 AUTOCAD ELEKTRİK SEMBOLLERİ MANTIĞI\n'
      'Elektrik projelerinde kullanılan semboller standarttır.\n\n'
      'Örnek semboller:\n'
      '• Priz sembolleri (topraklı, trifaze, UPS priz)\n'
      '• Aydınlatma armatürleri\n'
      '• Anahtar ve butonlar\n'
      '• Sigorta ve şalter sembolleri\n'
      '• Pano sembolleri\n\n'
      'Bu semboller sayesinde projeyi okuyan herkes, '
      'aynı dili konuşur.',
    ),

    // 7) Elektrik birimleri ve projede nasıl gösterilir
    MakaleBlok.text(
      '📏 ELEKTRİK BİRİMLERİ (PROJE OKURKEN)\n'
      'AutoCAD elektrik projelerinde sık görülen birimler:\n\n'
      '• V (Volt): Gerilim\n'
      '• A (Amper): Akım\n'
      '• W / kW: Güç\n'
      '• VA / kVA: Görünür güç\n'
      '• VAr / kVAr: Reaktif güç\n'
      '• mm²: Kablo kesiti\n\n'
      'Örnek proje notu:\n'
      '“3x2,5 mm² NYM + PE” → üç faz değil, '
      'faz-nötr-toprak kablo kesit bilgisidir.',
    ),

    // 8) Layer (katman) mantığı
    MakaleBlok.text(
      '🧱 LAYER (KATMAN) MANTIĞI – ELEKTRİKÇİ GÖZÜYLE\n'
      'AutoCAD’de her şey layer mantığıyla çizilir.\n\n'
      'Elektrik projelerinde tipik layer’lar:\n'
      '• AYDINLATMA\n'
      '• PRIZ\n'
      '• KUVVET\n'
      '• ZAYIF AKIM\n'
      '• TOPRAKLAMA\n\n'
      'Layer mantığı sayesinde:\n'
      '• İstenmeyen çizimler gizlenebilir\n'
      '• Saha uygulaması daha net olur\n'
      '• Revizyonlar karışmaz',
    ),

    // 9) Sahada AutoCAD projesi nasıl okunur
    MakaleBlok.text(
      '👷 AUTOCAD PROJESİ SAHADA NASIL OKUNUR?\n'
      'Sahacı için altın kurallar:\n\n'
      '• Önce pano numaralarına bak\n'
      '• Hangi linyenin hangi panodan çıktığını kontrol et\n'
      '• Kablo kesitlerini notlardan oku\n'
      '• Tek hat şeması ile planı birlikte değerlendir\n\n'
      'Unutma:\n'
      'AutoCAD çizimi, sahada birebir uygulanmak için vardır.',
    ),

    // 10) Kısa özet
    MakaleBlok.text(
      '📌 KISA ÖZET\n'
      '• AutoCAD elektrik projelerinin standart çizim dilidir\n'
      '• Aydınlatma, priz, pano ve tek hat şemaları burada çizilir\n'
      '• Semboller ve birimler evrenseldir\n'
      '• Layer mantığı projeyi okunur kılar\n'
      '• AutoCAD bilen elektrikçi sahada 1–0 öndedir',
    ),
  ],
),
  Makale(
    id: 'e11',
    baslik: 'UPS (Kesintisiz Güç Kaynağı) Rehberi: Çalışma Mantığı, Bağlantılar ve Arıza Çözümü',
    kategori: 'elektrik',
    ikonAsset: 'assets/images/ups_ikon.jpg',
    icerik:
    'UPS (Uninterruptible Power Supply), elektrik enerjisindeki kesintileri, '
        'gerilim dalgalanmalarını ve ani voltaj değişimlerini süzerek hassas cihazlara '
        'sürekli ve kaliteli enerji sağlayan bir sistemdir.\n\n'
        'Sadece elektrik kesilince devreye giren bir batarya grubu değil, aynı zamanda '
        'şebekedeki "kirli" elektriği temizleyen bir filtredir.\n\n',
    bloklar: const [
      // 1) Temel Mantık
      MakaleBlok.text(
        ' UPS NEDİR VE NASIL ÇALIŞIR?\n'
            'UPS, şebekeden aldığı AC enerjiyi önce DC’ye çevirerek aküleri şarj eder, '
            'ardından bu DC enerjiyi tekrar temiz bir AC sinüs dalgasına çevirerek yüke verir.\n\n'
            'Üç ana UPS türü vardır:\n'
            '1- Offline UPS: Sadece elektrik kesilince devreye girer. (En basit tip)\n'
            '2- Line-Interactive: Voltajı regüle eder, kesintide aküye geçer.\n'
            '3- Online UPS (Çift Çevrim): Şebeke varken de sürekli inverter üzerinden '
            'besleme yapar. En güvenli ve profesyonel çözümdür.',
      ),

      // 2) Bağlantı Şeması
      MakaleBlok.text(
        ' UPS PANOSU VE GÜÇ BAĞLANTILARI\n'
            'UPS kurulumunda bağlantı sırası hayati önem taşır:\n\n'
            '• Giriş (Input): Şebekeden gelen faz, nötr ve toprak hatları.\n'
            '• Çıkış (Output): Kritik yüklerin (bilgisayar, tıbbi cihaz vb.) beslendiği hatlar.\n'
            '• Akü Grubu: Harici akü kabinleri varsa, artı (+) ve eksi (-) kutupların '
            'doğru seri/paralel bağlanması gerekir.\n\n'
            '⚠️ DİKKAT: UPS nötr hattı ile şebeke nötr hattı asla karıştırılmamalı, '
            'mümkünse izole edilmelidir.',
      ),

      // 3) Arızalar ve Çözümler
      MakaleBlok.text(
        '🛠 SIK KARŞILAŞILAN UPS ARIZALARI VE ÇÖZÜMLERİ\n\n'
            ' 1. UPS Sürekli "Bip" Sesi Veriyor (Akü Modu):\n'
            '• Neden: Şebeke elektriği kesilmiş veya giriş sigortası atmış olabilir.\n'
            '• Çözüm: Giriş voltajını kontrol et, sigortaları kontrol et.\n\n'
            ' 2. Overload (Aşırı Yük) Hatası:\n'
            '• Neden: UPS kapasitesinden fazla cihaz bağlanmış.\n'
            '• Çözüm: Gereksiz cihazları fişten çek, UPS’i resetle.\n\n'
            ' 3. Akü Arızası (Battery Fault):\n'
            '• Neden: Akülerin ömrü bitmiş veya bağlantılar gevşemiş.\n'
            '• Çözüm: Akü voltajlarını ölç, ömrü biten (genelde 2-5 yıl) aküleri değiştir.\n\n'
            ' 4. Bypass Moduna Geçme:\n'
            '• Neden: Inverter arızası veya aşırı ısınma.\n'
            '• Çözüm: Havalandırma fanlarını kontrol et, tozları temizle.',
      ),

      // 4) Bakım Kuralları
      MakaleBlok.text(
        '📝 UPS BAKIMINDA ALTIN KURALLAR\n'
            '• Ortam Sıcaklığı: UPS odası 20-25°C olmalıdır. Sıcaklık akü ömrünü yarı yarıya düşürür.\n'
            '• Toz Temizliği: Fanlar tozlanırsa cihaz ısınır ve bypass’a geçer.\n'
            '• Deşarj Testi: Ayda bir kez elektrik kesilerek akülerin sağlıklı çalışıp '
            'çalışmadığı gözlemlenmelidir.\n\n'
            'Unutmayın: UPS, içindeki kondansatörler nedeniyle elektrik kesilse bile '
            'yüksek voltaj barındırabilir. Müdahale etmeden önce mutlaka iç deşarjın '
            'tamamlanmasını bekleyin.',

      ),
    ],
  ),
  Makale(
  id: 'el1',
  baslik: 'Direnç – Kapasitör – Endüktans (RCL) ve Direnç Renk Kodları',
  icerik:
      '🔹 ELEKTRONİK DEVRELERİN TEMEL ELEMANLARI\n\n'

      '🔸 Direnç (R):\n'
      'Elektrik akımına karşı zorluk gösteren devre elemanıdır. '
      'Üzerinden geçen elektrik enerjisini ısı enerjisine dönüştürür. '
      'Akımı sınırlamak, gerilim bölmek ve devreyi korumak amacıyla kullanılır.\n\n'

      '🔸 Kapasitör (C):\n'
      'Elektrik enerjisini elektrik alanında depolayan elemandır. '
      'Ani gerilim değişimlerine karşı dengeleme yapar. '
      'Filtreleme, zamanlama ve enerji depolama devrelerinde yaygın olarak kullanılır.\n\n'

      '🔸 Endüktans / Bobin (L):\n'
      'Elektrik enerjisini manyetik alan şeklinde depolar. '
      'Akım değişimine karşı koyar. '
      'Motor sürücüleri, filtre devreleri ve güç elektroniğinde sıkça kullanılır.\n\n'

      '📐 ZAMAN SABİTİ (τ):\n'
      '• RC devrelerinde: τ = R × C\n'
      '• RL devrelerinde: τ = L / R\n'
      'Zaman sabiti, devrenin %63 seviyesine ulaşma süresini ifade eder.\n\n'

      '────────────────────────\n'
      '🎨 DİRENÇ RENK KODLARI\n\n'

      'Dirençlerin üzerindeki renk halkaları, direnç değerini ve toleransını gösterir. '
      'Bu sayede ölçüm cihazı olmadan direnç değeri okunabilir.\n\n'

      '📌 ÖRNEK OKUMA:\n'
      'Kahverengi (1) – Siyah (0) – Kırmızı (×100)\n'
      '→ 10 × 100 = 1.000 Ω = 1 kΩ\n\n'

      '🟡 Tolerans Halkası:\n'
      'Altın: ±5%\n'
      'Gümüş: ±10%\n\n'

      '🎨 RENK – SAYI KARŞILIĞI:\n'
      'Siyah: 0\n'
      'Kahverengi: 1\n'
      'Kırmızı: 2\n'
      'Turuncu: 3\n'
      'Sarı: 4\n'
      'Yeşil: 5\n'
      'Mavi: 6\n'
      'Mor: 7\n'
      'Gri: 8\n'
      'Beyaz: 9\n\n'

      'Bu renk kodlama sistemi sayesinde elektronik devrelerde hızlı tanımlama yapılır '
      've özellikle sahada çalışan teknikerler için büyük kolaylık sağlar.',
  kategori: 'elektronik',
  resim: 'assets/images/direnc.webp',
  ),
  Makale(
    id: 'el2',
    baslik:
    'Transistör Temelleri (BJT & MOSFET) – Çalışma Mantığı, Uçlar, Anahtarlama ve Saha Uygulamaları',
    kategori: 'elektronik',
    ikonAsset: 'assets/images/transıstor.jpg',
    icerik:
    'Transistör; küçük bir sinyal ile daha büyük akım ve gerilimleri '
        'kontrol etmeye yarayan yarı iletken bir devre elemanıdır. '
        'Elektronik devrelerin temel yapı taşıdır ve anahtarlama, yükseltme, '
        'regülasyon ve darbe üretimi gibi çok geniş bir kullanım alanına sahiptir.\n\n'
        'Bu makalede; BJT ve MOSFET transistörlerin farkları, uçları, '
        'çalışma prensipleri, anahtarlama mantığı, sahada sık yapılan hatalar '
        've multimetre ile temel kontroller tekniker gözüyle anlatılmaktadır.',
    bloklar: const [

      MakaleBlok.text(
        ' 1) Transistör Nedir, Ne İşe Yarar?\n'
            'Transistör, elektronik devrelerde üç temel amaçla kullanılır:\n\n'
            '• Anahtar olarak (aç/kapa)\n'
            '• Yükselteç olarak (zayıf sinyali büyütmek)\n'
            '• Akım/gerilim kontrolü yapmak\n\n'
            'Basit anlatım:\n'
            '👉 Küçük bir sinyal ile büyük bir yükü kontrol edebilmeni sağlar.\n\n'
            'Örnek:\n'
            '• Mikrodenetleyici çıkışı ile röle sürmek\n'
            '• LED, motor, fan, bobin kontrolü\n'
            '• SMPS güç kartlarında anahtarlama',
      ),
      MakaleBlok.image(
        'assets/images/transıstor.jpg',
        aciklama:
        'Transistör görseli ',
      ),

      MakaleBlok.text(
        ' 2) BJT ve MOSFET Arasındaki Temel Farklar\n'
            'Transistörler temel olarak iki ana gruba ayrılır:\n\n'
            '• BJT (Bipolar Junction Transistor)\n'
            '• MOSFET (Metal Oxide Semiconductor FET)\n\n'
            'En önemli fark:\n'
            '• BJT → Akım kontrollüdür\n'
            '• MOSFET → Gerilim kontrollüdür\n\n'
            'Saha yorumu:\n'
            '• Düşük güç ve basit devrelerde BJT\n'
            '• Güç elektroniği ve SMPS devrelerinde MOSFET tercih edilir',
      ),

      MakaleBlok.text(
        ' 3) BJT Transistör (NPN / PNP) Yapısı\n'
            'BJT transistörler üç uçtan oluşur:\n\n'
            '• Base (B)\n'
            '• Collector (C)\n'
            '• Emitter (E)\n\n'
            'BJT tipleri:\n'
            '• NPN (en yaygın)\n'
            '• PNP\n\n'
            'Çalışma mantığı (NPN):\n'
            '• Base–Emitter arasına yaklaşık 0.7 V uygulanır\n'
            '• Base akımı → Collector–Emitter akımını kontrol eder\n\n'
            'Altın kural:\n'
            '❗ Base akımı yoksa transistör kapalıdır',
      ),

      MakaleBlok.text(
        ' 4) BJT Anahtarlama Mantığı (Aç / Kapa)\n'
            'BJT anahtar olarak kullanıldığında iki temel durumu vardır:\n\n'
            '• Kesim (OFF): Base akımı yok → Transistör kapalı\n'
            '• Doyum (ON): Yeterli base akımı var → Transistör tam açık\n\n'
            'Sahada yapılan en büyük hata:\n'
            '❌ Base direnci kullanmamak\n\n'
            'Not:\n'
            '• Base direnci transistörü korur\n'
            '• Mikrodenetleyici çıkışlarını yakmamak için şarttır',
      ),

      MakaleBlok.text(
        '⚡ 5) MOSFET Nedir? Neden Daha Çok Kullanılır?\n'
            'MOSFET’ler de üç uçtan oluşur:\n\n'
            '• Gate (G)\n'
            '• Drain (D)\n'
            '• Source (S)\n\n'
            'MOSFET’in en büyük avantajı:\n'
            '• Gate neredeyse akım çekmez\n'
            '• Gerilim ile kontrol edilir\n\n'
            'Bu yüzden:\n'
            '• Daha az ısınır\n'
            '• Yüksek frekansta çalışabilir\n'
            '• SMPS devrelerinde vazgeçilmezdir',
      ),
      MakaleBlok.image(
        'assets/images/mosfet1.jpg',
        aciklama:
        'Mosfet görseli ',
      ),

      MakaleBlok.text(
        ' 6) N-Channel ve P-Channel MOSFET Farkı\n'
            'MOSFET’ler iki ana tipe ayrılır:\n\n'
            '• N-Channel (en yaygın)\n'
            '• P-Channel\n\n'
            'N-Channel:\n'
            '• Gate gerilimi Source’tan büyük olmalı\n'
            '• Daha düşük Rds(on)\n'
            '• Güç uygulamalarında tercih edilir\n\n'
            'P-Channel:\n'
            '• Genelde high-side anahtarlamada\n'
            '• Kontrolü daha basit ama kayıpları fazla',
      ),

      MakaleBlok.text(
        ' 7) Multimetre ile Transistör Kontrolü\n'
            'Sahada hızlı kontrol için multimetre yeterlidir.\n\n'
            'BJT kontrolü:\n'
            '• Diyot modunda B–E ve B–C ölçülür\n'
            '• Tek yönde ~0.6–0.7 V görülmeli\n'
            '• İki yönde kısa devre varsa transistör bozuk\n\n'
            'MOSFET kontrolü:\n'
            '• Drain–Source kısa devre olmamalı\n'
            '• Gate–Source arası megaohm seviyesinde olmalı\n\n'
            'İpucu:\n'
            '• MOSFET’ler statik elektrikten kolay bozulur',
      ),

      MakaleBlok.text(
        ' 8) Transistör Neden Yanır? (Sahada En Sık Sebepler)\n'
            '• Aşırı akım\n'
            '• Yetersiz soğutma\n'
            '• Yanlış gate/base sürme\n'
            '• Flyback diyotu kullanılmaması (bobinli yüklerde)\n'
            '• Yanlış eşdeğer parça kullanımı\n\n'
            'Örnek:\n'
            'Röle, motor veya bobin sürerken diyot koyulmazsa '
            'transistör ilk kapamada yanar.',
      ),

      MakaleBlok.text(
        ' 9) BJT mi MOSFET mi? Hangisini Seçmeliyim?\n'
            'Basit kural:\n\n'
            '• Küçük akım, basit devre → BJT\n'
            '• Yüksek akım, SMPS, motor sürme → MOSFET\n\n'
            'Tekniker önerisi:\n'
            '• Güncel projelerde MOSFET öğrenmek uzun vadede avantaj sağlar.',
      ),

      MakaleBlok.text(
        '✅ 10) Kısa Özet\n'
            '• Transistör elektronik devrelerin temelidir\n'
            '• BJT akım, MOSFET gerilim kontrollüdür\n'
            '• Base/Gate koruması şarttır\n'
            '• Multimetre ile ön teşhis mümkündür\n'
            '• Soğutma ve doğru sürme transistör ömrünü belirler',
      ),
    ],
  ),
  Makale(
    id: 'el3',
    baslik:
    'Kondansatör (Kapasitör) Nedir? – Çalışma Mantığı, Türleri, Bağlantılar ve Saha Arızaları',
    kategori: 'elektronik',
    ikonAsset: 'assets/images/kondansator.jpg',
    icerik:
    'Kondansatör (kapasitör); elektrik enerjisini elektrik alanı '
        'şeklinde depolayan ve gerektiğinde devreye geri veren temel '
        'elektronik devre elemanlarından biridir. Güç kaynakları, '
        'kontrol kartları, motor sürücüleri, PLC kartları ve '
        'mikrodenetleyici sistemlerinde vazgeçilmezdir.\n\n'
        'Bu makalede; kondansatörün çalışma prensibi, türleri, '
        'doğru kullanım yöntemleri ve sahada sık karşılaşılan '
        'arızalar tekniker bakış açısıyla anlatılmaktadır.',
    bloklar: const [

      MakaleBlok.text(
        ' 1) Kondansatör Nedir, Ne İşe Yarar?\n'
            'Kondansatörün temel görevi:\n\n'
            '• Elektrik yükünü kısa süreli depolamak\n'
            '• Gerilim dalgalanmalarını filtrelemek\n'
            '• AC sinyali geçirmek, DC akımı engellemek\n\n'
            'Basit örnek:\n'
            '• Adaptör çıkışındaki dalgalı DC → daha düzgün DC\n'
            '• Röle çektiğinde oluşan ani gerilim çökmesini önlemek\n\n'
            'Kondansatör olmazsa:\n'
            '❌ Devre kararsız çalışır\n'
            '❌ Mikrodenetleyici reset atar\n'
            '❌ Röle ve kontaktör parazit yapar',
      ),

      MakaleBlok.text(
        ' 2) Çalışma Mantığı (Basit Anlatım)\n'
            'Kondansatör iki iletken plaka ve aralarındaki '
            'yalıtkan (dielektrik) malzemeden oluşur.\n\n'
            '• Gerilim uygulandığında → şarj olur\n'
            '• Gerilim kesildiğinde → enerjisini devreye verir\n\n'
            'Önemli bilgi:\n'
            '• Kondansatör DC akımı sürekli iletmez\n'
            '• AC sinyalleri frekansa bağlı olarak geçirir',
      ),

      MakaleBlok.text(
        ' 3) Kondansatörün Birimi ve Değerleri\n'
            'Kondansatörün birimi Farad (F)\'dır.\n\n'
            'Pratikte kullanılan değerler:\n'
            '• µF (mikrofarad)\n'
            '• nF (nanofarad)\n'
            '• pF (pikofarad)\n\n'
            'Not:\n'
            '1 F çok büyük bir değerdir, sahada nadiren kullanılır.',
      ),
      MakaleBlok.image( 'assets/images/kondansator.jpg', ),

      MakaleBlok.text(
        ' 4) Kondansatör Türleri (En Yaygın)\n'
            'Elektronikte en sık kullanılan kondansatörler:\n\n'
            '1️⃣ Elektrolitik Kondansatör\n'
            '• Yüksek kapasiteli\n'
            '• Polaritelidir (+ / -)\n'
            '• Genelde filtreleme amaçlı\n\n'
            '2️⃣ Seramik Kondansatör\n'
            '• Küçük kapasiteli\n'
            '• Polaritesiz\n'
            '• Yüksek frekans için ideal\n\n'
            '3️⃣ Film (Polyester) Kondansatör\n'
            '• Kararlı yapı\n'
            '• Zamanlama ve sinyal devreleri',
      ),

      MakaleBlok.text(
        ' 5) Elektrolitik Kondansatörlerde Altın Kural\n'
            '❗ Polariteye dikkat edilmezse kondansatör patlar.\n\n'
            'Yanlış bağlantı sonucu:\n'
            '• Şişme\n'
            '• Akma\n'
            '• Patlama\n\n'
            'Saha ipucu:\n'
            '• Artı (+) ucu genelde uzun bacaktır\n'
            '• Gövdedeki şerit eksi (-) tarafı gösterir',
      ),

      MakaleBlok.text(
        ' 6) Kondansatör Nerelerde Kullanılır?\n'
            '• Güç kaynakları (filtreleme)\n'
            '• PLC giriş–çıkış kartları\n'
            '• Röle ve kontaktör bobinleri\n'
            '• Motor sürücüleri\n'
            '• Ses ve sinyal devreleri\n\n'
            'Örnek:\n'
            '• 24V röle bobinine paralel kondansatör → parazit azaltma',
      ),

      MakaleBlok.text(
        ' 7) Kondansatör Arızaları (Sahada Çok Görülür)\n'
            'En sık karşılaşılan arızalar:\n\n'
            '• Şişmiş elektrolitik kondansatör\n'
            '• Değer kaybı (kapasite düşer)\n'
            '• İç kısa devre\n'
            '• Kuruma (yaşlanma)\n\n'
            'Sonuç:\n'
            '• Cihaz geç çalışır\n'
            '• Reset atar\n'
            '• Çıkış gerilimi dalgalanır',
      ),

      MakaleBlok.text(
        ' 8) Multimetre ile Kondansatör Kontrolü\n'
            'Basit saha kontrolü:\n\n'
            '1) Multimetreyi ohm veya kapasitans moduna al\n'
            '2) Prob uçlarını kondansatöre değdir\n'
            '3) Değer yavaş yükselip düşüyorsa → sağlam\n\n'
            'İpucu:\n'
            '• Şüpheli kondansatör en hızlı test için değiştirerek denenir',
      ),

      MakaleBlok.text(
        ' 9) Kondansatör Neden Bozulur?\n'
            '• Aşırı sıcaklık\n'
            '• Yüksek gerilim\n'
            '• Uzun süre çalışma\n'
            '• Kalitesiz ürün\n\n'
            'Tekniker tavsiyesi:\n'
            '• Güç kartlarında mutlaka 105°C kondansatör kullan',
      ),

      MakaleBlok.text(
        '📌 10) Kısa Özet\n'
            '• Kondansatör enerji depolar ve filtreleme yapar\n'
            '• Elektrolitikler polaritelidir\n'
            '• Seramikler yüksek frekansta iyidir\n'
            '• Şişmiş kondansatör arıza sebebidir\n'
            '• Güç kartlarında kondansatör kalitesi kritiktir',
      ),
    ],
  ),
  Makale(
  id: 'el4',
  baslik: 'Diyot Rehberi: Tipler, Zener, Köprü Doğrultucu ve Uygulamalar',
  icerik:
      'Diyot, akımı temelde tek yönde ileten yarı iletken bir devre elemanıdır. '
      'Elektronikte doğrultma, koruma, regülasyon ve anahtarlama gibi çok kritik görevlerde kullanılır.\n\n'


      '1) DİYOTUN UÇLARI: ANOT / KATOT\n'
      '• Anot (A): Akımın giriş ucu gibi düşünebilirsin.\n'
      '• Katot (K): Akımın çıkış ucu. Diyot üzerinde genelde çizgi/bant olan taraf katottur.\n\n'

      '2) DOĞRU POLARİZASYON / TERS POLARİZASYON\n'
      '• Doğru polarizasyon (iletim): Anot (+), Katot (–) olduğunda diyot iletir.\n'
      '  Tipik iletim gerilimi (Vf):\n'
      '  - Silikon(Silisyum) diyot: ~0.6–0.8V\n'
      '  - Schottky(Germanyum) diyot: ~0.2–0.4V (daha düşük kayıp)\n'
      '• Ters polarizasyon (kesim): Anot (–), Katot (+) olduğunda diyot idealde keser.\n'
      '  Çok az “ters kaçak akım” oluşabilir (normaldir).\n\n'

      '3) EN ÇOK KULLANILAN DİYOT TİPLERİ\n'
      'A) Doğrultucu Diyot (1N4007 gibi)\n'
      '• Adaptör/power supply doğrultmada yaygın.\n'
      '• Yavaştır (yüksek frekansta uygun değil).\n\n'
      'B) Hızlı (Fast/Ultrafast) Diyot (UF4007, FR serileri)\n'
      '• SMPS, inverter, yüksek frekanslı anahtarlamada kullanılır.\n\n'
      'C) Schottky Diyot (SS14, 1N5819 vb.)\n'
      '• Düşük Vf → daha az ısınma, daha verimli.\n'
      '• Ters dayanımı bazı modellerde daha düşüktür (etikete bak).\n\n'
      'D) LED (Işık Yayan Diyot)\n'
      '• İletimde ışık üretir.\n'
      '• Mutlaka seri direnç/akım sınırlama gerekir.\n\n'
      'E) TVS Diyot (Transient Voltage Suppressor)\n'
      '• Darbe/ani gerilim yükselmelerine karşı koruma (ESD, şebeke darbeleri).\n\n'

      '4) ZENER DİYOT NEDİR? NE İŞE YARAR?\n'
      'Zener diyot ters yönde belirli bir gerilimde “kontrollü” iletime geçer ve bu gerilimi sabitlemeye yardımcı olur.\n'
      '• Örn: 5.1V zener, ters yönde yaklaşık 5.1V civarında gerilimi sınırlar.\n\n'
      'Zener’in en yaygın kullanım alanları:\n'
      '• Basit gerilim referansı / regülasyon\n'
      '• Aşırı gerilim sınırlama (clamp)\n'
      '• Opamp/ADC giriş koruması (uygun seri dirençle)\n\n'
      'ZENERLİ BASİT REGÜLATÖR (Örnek Mantık)\n'
      '• Besleme → Seri direnç → (Zener + Yük paralel)\n'
      '• Seri direnç, zener akımını sınırlar.\n\n'
      'Not: Zener’in gücü önemlidir (0.5W, 1W vb.). Gücü düşük zener ısınır/bozulur.\n\n'


      '5) KÖPRÜ DOĞRULTUCU (BRIDGE) NEDİR?\n'
      'Köprü doğrultucu, 4 diyotla AC gerilimi DC’ye çeviren en yaygın devredir.\n'
      '• 2 diyot her yarım periyotta iletimde olur.\n'
      '• Çıkış DC olur ama dalgalıdır (ripple).\n\n'
      'KÖPRÜ DOĞRULTUCUDA NEDEN 2×Vf KAYBI VAR?\n'
      'Aynı anda iki diyot seri iletimde olduğundan yaklaşık:\n'
      '• Silikon diyotlarda ~1.2–1.6V toplam düşüm\n'
      '• Schottky kullanılırsa kayıp daha az olabilir.\n\n'
      'FİLTRE KONDANSATÖRÜ (DC’Yİ DÜZELTME)\n'
      'Doğrultma sonrası büyük elektrolitik kondansatör eklenirse dalgalanma azalır.\n'
      'Kondansatör değeri büyüdükçe ripple azalır ama ilk kalkış akımı artabilir.\n\n'


      '6) DİYOT SEÇERKEN BAKILACAK 3 KRİTİK PARAMETRE\n'
      '1) Maksimum ters gerilim (VRRM): Diyotun ters yönde dayanacağı gerilim.\n'
      '2) Ortalama iletim akımı (IF): Sürekli taşıyabileceği akım.\n'
      '3) Güç/ısı: Diyot ısınırsa soğutma veya daha güçlü model gerekebilir.\n'
      'Ek: Hız (reverse recovery) → SMPS/inverter gibi işlerde kritik.\n\n'


      '7) PRATİK ARIZA / TEST (MULTİMETRE DİYOT MODU)\n'
      '• Multimetre “diyot test” modunda:\n'
      '  - Doğru yönde ~0.5–0.8V (silikon) görürsün.\n'
      '  - Ters yönde genelde OL / sonsuz görürsün.\n'
      '• İki yönde de 0V’a yakınsa → kısa devre arızası.\n'
      '• İki yönde de OL ise → açık devre arızası.\n\n'
      'Zener ölçümü: Normal multimetreyle zener gerilimi doğru ölçülemez; besleme + seri direnç ile test gerekir.\n\n'


      '8) EN YAYGIN UYGULAMALAR (SAHADA ÇOK ÇIKAR)\n'
      '• Adaptör doğrultma (köprü + kondansatör)\n'
      '• Motor bobini/role bobini “flyback” diyotu (ters EMK sönümleme)\n'
      '• Ters kutup koruması (girişte seri diyot veya daha verimli MOSFET çözümü)\n'
      '• Zener ile giriş sınırlama / referans\n'
      '• TVS ile darbe koruma\n\n'


      '9) ÖNEMLİ UYARI\n'
      'Yanlış diyot yönü (katot/anot karışması) devreyi çalıştırmaz, hatta kısa devre/ısınma yapabilir. '
      'Özellikle güç devrelerinde diyot seçimini VRRM/IF değerlerine göre yap.\n',
  kategori: 'elektronik',
  resim: 'assets/images/diyot.jpg',
  ),
  Makale(
    id: 'el3',
    baslik:
    'Regülatörler (7805 – LM317 – LM2596) – Çalışma Mantığı, Bağlantılar ve Saha Arızaları',
    kategori: 'elektronik',
    ikonAsset: 'assets/images/7805.png',
    icerik:
    'Regülatörler; elektronik devrelerde giriş gerilimi değişse bile '
        'çıkışta sabit ve kararlı bir gerilim elde etmek için kullanılan '
        'devre elemanlarıdır. Adaptörler, güç kartları, kontrol kartları, '
        'PLC giriş–çıkış devreleri ve mikrodenetleyici sistemlerinde '
        'en kritik bileşenlerden biridir.\n\n'
        'Bu makalede; en yaygın kullanılan 7805, ayarlanabilir LM317 '
        've anahtarlamalı LM2596 regülatörlerin çalışma prensipleri, '
        'bağlantı şekilleri, avantaj–dezavantajları ve sahada sık '
        'karşılaşılan arızalar tekniker gözüyle anlatılmaktadır.',
    bloklar: const [

      MakaleBlok.text(
        ' 1) Regülatör Nedir, Neden Kullanılır?\n'
            'Regülatörün temel görevi:\n\n'
            '• Dalgalı veya yüksek bir DC gerilimi\n'
            '• Devrenin ihtiyacı olan sabit DC gerilime çevirmektir\n\n'
            'Örnek:\n'
            '• Adaptörden gelen 12 V → 5 V\n'
            '• Aküden gelen 24 V → 12 V\n\n'
            'Regülatör olmazsa:\n'
            '❌ Mikrodenetleyici yanar\n'
            '❌ Sensörler yanlış çalışır\n'
            '❌ Cihaz reset atar',
      ),

      MakaleBlok.text(
        ' 2) Regülatör Türleri (Genel Bakış)\n'
            'Elektronikte regülatörler iki ana gruba ayrılır:\n\n'
            '1️⃣ Lineer Regülatörler\n'
            '• 78xx serisi (7805, 7812 vb.)\n'
            '• LM317 (ayarlanabilir)\n\n'
            '2️⃣ Anahtarlamalı (Switching) Regülatörler\n'
            '• LM2596\n'
            '• Buck / Boost / Buck-Boost modüller\n\n'
            'Temel fark:\n'
            '• Lineer → basit ama ısınır\n'
            '• Anahtarlamalı → verimli ama karmaşıktır',
      ),

      MakaleBlok.text(
        ' 3) 7805 Regülatör (Sabit 5V)\n'
            '7805, en yaygın kullanılan lineer regülatörlerden biridir.\n\n'
            'Temel özellikler:\n'
            '• Sabit çıkış: 5 V\n'
            '• Giriş gerilimi: genelde 7 – 35 V\n'
            '• Akım: ~1 A (soğutmaya bağlı)\n\n'
            'Bacaklar (TO-220):\n'
            '• IN – GND – OUT\n\n'
            'Altın kural:\n'
            '❗ Giriş 5 V’un altına düşerse regülasyon bozulur',
      ),
      MakaleBlok.image(
        'assets/images/7805.png',
      ),
      MakaleBlok.image(
        'assets/images/78051.webp',
      ),

      MakaleBlok.text(
        ' 4) 7805’in Dezavantajı: Isınma Problemi\n'
            '7805 lineer çalıştığı için fazla gerilimi ısıya çevirir.\n\n'
            'Örnek:\n'
            '• Giriş: 12 V\n'
            '• Çıkış: 5 V\n'
            '• Aradaki 7 V → ısı olarak harcanır\n\n'
            'Sonuç:\n'
            '• Soğutucu yoksa regülatör aşırı ısınır\n'
            '• Termal korumaya girer veya yanar\n\n'
            'Saha yorumu:\n'
            '• 12V → 5V yüksek akım varsa 7805 yerine LM2596 tercih edilir',
      ),

      MakaleBlok.text(
        ' 5) LM317 (Ayarlanabilir Lineer Regülatör)\n'
            'LM317, çıkış gerilimi ayarlanabilen bir lineer regülatördür.\n\n'
            'Özellikler:\n'
            '• Çıkış: ~1.25 V – 30 V\n'
            '• Harici dirençlerle ayarlanır\n\n'
            'Çıkış formülü:\n'
            'Vout = 1.25 × (1 + R2 / R1)\n\n'
            'Kullanım alanları:\n'
            '• Ayarlı güç kaynağı\n'
            '• Laboratuvar devreleri\n'
            '• Test sistemleri',
      ),

      MakaleBlok.text(
        ' 6) LM317’de Yapılan En Büyük Hatalar\n'
            '• Direnç değerlerini yanlış seçmek\n'
            '• Soğutucu kullanmamak\n'
            '• Giriş–çıkış kondansatörlerini koymamak\n\n'
            'Not:\n'
            'LM317 de lineer olduğu için yüksek akımda ciddi ısınır.',
      ),

      MakaleBlok.text(
        ' 7) LM2596 (Anahtarlamalı Regülatör – Buck)\n'
            'LM2596, anahtarlamalı (switching) bir regülatördür.\n\n'
            'Temel özellikler:\n'
            '• Yüksek verim (%80–90)\n'
            '• Isınma çok az\n'
            '• Geniş giriş aralığı\n\n'
            'Çalışma mantığı:\n'
            '• Girişi yüksek frekansta anahtarlayarak\n'
            '• Bobin ve diyot yardımıyla çıkışı düşürür\n\n'
            'Saha yorumu:\n'
            '• Akülü sistemlerde vazgeçilmezdir',
      ),

      MakaleBlok.text(
        ' 8) LM2596 Nerelerde Kullanılır?\n'
            '• Araç elektroniği\n'
            '• UPS ve inverter kartları\n'
            '• Arduino / ESP beslemeleri\n'
            '• Kamera ve network sistemleri\n\n'
            'Avantaj:\n'
            '• Aynı girişte 7805’e göre çok daha az ısınır',
      ),

      MakaleBlok.text(
        ' 9) Multimetre ile Regülatör Kontrolü\n'
            'Sahada hızlı kontrol için:\n\n'
            '1) Giriş gerilimini ölç\n'
            '2) Çıkış gerilimini ölç\n'
            '3) Yük altında tekrar ölç\n\n'
            'Arıza belirtileri:\n'
            '• Giriş var çıkış yok → regülatör bozuk\n'
            '• Boşta var yükte düşüyor → regülatör zayıf\n'
            '• Çıkış dalgalı → kondansatör sorunu',
      ),

      MakaleBlok.text(
        ' 10) Regülatör Neden Yanır?\n'
            '• Aşırı akım çekilmesi\n'
            '• Kısa devre\n'
            '• Yetersiz soğutma\n'
            '• Ters polarite\n'
            '• Yanlış eşdeğer parça\n\n'
            'İpucu:\n'
            'Yanmış regülatörün etrafındaki kondansatör ve diyotlar mutlaka kontrol edilmelidir.',
      ),

      MakaleBlok.text(
        ' 11) Hangisini Ne Zaman Kullanmalıyım?\n'
            'Hızlı seçim rehberi:\n\n'
            '• Basit, düşük akım → 7805\n'
            '• Ayarlanabilir, test amaçlı → LM317\n'
            '• Yüksek akım, akü, verim → LM2596\n\n'
            'Tekniker önerisi:\n'
            '• Güncel sistemlerde anahtarlamalı regülatörler daha avantajlıdır.',
      ),

      MakaleBlok.text(
        '📌 12) Kısa Özet\n'
            '• Regülatörler sabit DC gerilim üretir\n'
            '• Lineer regülatörler basit ama ısınır\n'
            '• Anahtarlamalı regülatörler verimli ve serindir\n'
            '• Multimetre ile temel teşhis mümkündür\n'
            '• Soğutma ve doğru bağlantı regülatör ömrünü belirler',
      ),
    ],
  ),
  Makale(
  id: 'el5',
  baslik: 'LED ve Breadboard (Deney Tahtası) Temel Kullanımı',
  icerik:
      'LED (Light Emitting Diode – Işık Yayan Diyot), üzerinden doğru yönde akım geçtiğinde '
      'ışık yayan yarı iletken bir elektronik elemandır. '
      'LED\'in çalışması, PN birleşiminde elektronlar ile deliklerin birleşmesi sonucu '
      'enerjinin foton (ışık) olarak açığa çıkmasına dayanır.\n\n'

      '🔹 LED\'in Yapısı ve Çalışma Prensibi:\n'
      'LED\'ler anot (+) ve katot (–) olmak üzere iki uca sahiptir. '
      'Anot ucu daha uzun, katot ucu genellikle daha kısadır. '
      'LED ters bağlanırsa iletime geçmez ve ışık vermez.\n\n'

      'Farklı yarı iletken malzemeler kullanılarak kırmızı, yeşil, mavi, beyaz gibi '
      'farklı LED renkleri elde edilir. '
      'LED\'lerin en önemli avantajları düşük güç tüketimi, uzun ömür, '
      'hızlı tepki süresi ve kompakt yapıya sahip olmalarıdır.\n\n'

      '🔹 LED Kullanım Alanları:\n'
      'LED\'ler aydınlatma sistemleri, elektronik göstergeler, sensörler, '
      'otomotiv uygulamaları ve optik iletişim sistemlerinde yaygın olarak kullanılır.\n\n'

      '🔹 Breadboard (Deney Tahtası) Nedir?\n'
      'Breadboard, elektronik devrelerin lehim yapılmadan kurulmasını sağlayan '
      'delikli bir deney platformudur. '
      'Öğrenciler, teknisyenler ve mühendisler tarafından prototip devreler '
      'oluşturmak için sıkça tercih edilir.\n\n'

      'Breadboard içerisinde yatay ve dikey metal iletken hatlar bulunur. '
      'Genellikle kenarlardaki hatlar besleme (+ ve –), '
      'orta kısımdaki hatlar ise devre elemanlarının bağlanması için kullanılır.\n\n'

      '🔹 LED ve Breadboard Birlikte Kullanımı:\n'
      'LED\'ler breadboard üzerinde seri bir direnç ile birlikte kullanılır. '
      'Direnç, LED üzerinden geçen akımı sınırlandırarak LED\'in yanmasını önler. '
      'Bu yöntem, temel elektronik deneylerinin en yaygın uygulamasıdır.\n\n'

      '🔹 Önemli Uyarılar:\n'
      'Breadboard üzerinde yüksek akım veya yüksek gerilim devreleri denenmemelidir. '
      'Breadboard, düşük güçlü deney ve eğitim amaçlı kullanımlar için uygundur.',
  kategori: 'elektronik',
  resim: 'assets/images/led.png',
  ikonAsset: 'assets/images/ledicon.png',
  ),
  Makale(
    id: 'el6',
    baslik: 'Osiloskop Nedir ve Ne İşe Yarar?',
    icerik:
      'Osiloskop, elektrik sinyallerini zamana bağlı olarak ekranda dalga formu şeklinde gösteren ölçü cihazıdır. '
      'Yatay eksen zamanı, dikey eksen gerilimi temsil eder. '
      'Analog ve dijital türleri vardır. '
      'Kullanım alanları: sinyal analizi, arıza tespiti, frekans ve genlik ölçümleri. '
      'Trigger ayarı, ölçümü sabitlemek için kullanılır.',
    kategori: 'elektronik',
    resim: 'assets/images/osiloskop.jpg',
  ),
  Makale(
    id: 'el7',
    baslik: 'Mikrodenetleyici Nedir?',
    icerik:
      'Mikrodenetleyici, bir çip içinde işlemci (CPU), bellek (RAM/Flash) ve giriş-çıkış birimleri (GPIO) barındıran küçük bir bilgisayardır. '
      'Gömülü sistemlerde belirli bir görevi otomatik olarak yerine getirir. '
      'Arduino, PIC ve STM32 en bilinen mikrodenetleyici serileridir. '
      'Avantajı: düşük maliyet, düşük güç tüketimi ve kolay programlanabilirlik.',
    kategori: 'elektronik',
    resim: 'assets/images/mikrodenetleyici.png',
  ),
  Makale(
  id: 'el8',
  baslik: 'Seri ve Paralel Devre Farkı (Detaylı Anlatım)',
  icerik:
      'Elektrik devrelerinde elemanlar seri veya paralel bağlanabilir. '
      'Bağlantı şekli; akımın, gerilimin ve eşdeğer direncin nasıl değişeceğini belirler.\n\n'

      '- Seri Devre:\n'
      'Seri devrede devre elemanları uç uca bağlanır ve devreden geçen akım her noktada aynıdır. '
      'Toplam gerilim, elemanlar üzerinde paylaştırılır.\n'
      'Formüller:\n'
      'Toplam Gerilim: Vt = V1 + V2 + V3\n'
      'Eşdeğer Direnç: Rt = R1 + R2 + R3\n\n'

      'Seri devrede herhangi bir eleman koparsa tüm devre çalışmaz. '
      'Bu nedenle seri devreler genellikle basit ve düşük maliyetli uygulamalarda kullanılır.\n\n'

      '- Paralel Devre:\n'
      'Paralel devrede tüm elemanlar aynı gerilime bağlıdır. '
      'Toplam akım, dallara ayrılarak akar.\n'
      'Formüller:\n'
      'Toplam Akım: It = I1 + I2 + I3\n'
      'Eşdeğer Direnç: 1/Rt = 1/R1 + 1/R2 + 1/R3\n\n'

      'Paralel devrede bir kol kopsa bile diğer kollar çalışmaya devam eder. '
      'Ev tesisatları ve endüstriyel uygulamalarda bu yüzden paralel bağlantı tercih edilir.\n\n'

      '- Seri ve Paralel Devrelerin Karşılaştırılması:\n'
      'Seri devrelerde akım sabittir, paralel devrelerde gerilim sabittir. '
      'Seri devrede eşdeğer direnç büyürken, paralel devrede eşdeğer direnç küçülür.\n\n'

      '- Kullanım Alanları:\n'
      'Seri devreler LED dizileri ve ölçüm devrelerinde, '
      'paralel devreler ise priz tesisatları, aydınlatma sistemleri ve güç dağıtımında kullanılır.\n\n'

      'Bu kurallar, elektrik-elektronik devre tasarımının temelini oluşturur ve '
      'tüm mühendislik uygulamalarında bilinmesi zorunludur.',
  kategori: 'elektronik',
  resim: 'assets/images/seriparalel.jpg',
),
  Makale(
  id: 'el9',
  baslik: 'Op-Amp (Operation Amplifier) Temel Devreleri',
  icerik:
      'Op-Amp (Operational Amplifier), iki giriş arasındaki gerilim farkını yüksek kazançla yükselten elektronik bir devre elemanıdır. '
      'İdeal bir op-amp; sonsuz kazanç, sonsuz giriş direnci ve sıfır çıkış direncine sahiptir. '
      'Gerçek op-amp\'larda bu değerler sınırlıdır ancak uygulamalar için yeterlidir.\n\n'

      '- Op-Amp Giriş ve Çıkışları:\n'
      'Op-amp\'ın iki girişi vardır: eviren (-) ve evirmeyen (+). '
      'Çıkış gerilimi, bu iki giriş arasındaki farkın kazanç ile çarpılması sonucu oluşur.\n\n'

      '- Eviren Kuvvetlendirici:\n'
      'Eviren devrede giriş sinyali (-) girişine uygulanır. '
      'Çıkış sinyali girişe göre 180° faz terslidir. '
      'Kazanç formülü: A = -Rf / Rin şeklindedir.\n\n'

      '- Evirmeyen Kuvvetlendirici:\n'
      'Evirmeyen devrede giriş sinyali (+) girişine uygulanır. '
      'Çıkış sinyali girişle aynı fazdadır. '
      'Kazanç formülü: A = 1 + (Rf / Rin) olarak hesaplanır.\n\n'

      '- Toplayıcı (Summing) Kuvvetlendirici:\n'
      'Birden fazla giriş sinyalinin toplanarak tek bir çıkışta elde edilmesini sağlar. '
      'Ses mikserleri ve analog sinyal işleme devrelerinde sıkça kullanılır.\n\n'

      '- İntegratör ve Diferansiyatör Devreleri:\n'
      'İntegratör devresi giriş sinyalinin zamanla integralini alır. '
      'Diferansiyatör devresi ise giriş sinyalinin türevini üretir. '
      'Bu devreler sinyal şekillendirme ve kontrol uygulamalarında kullanılır.\n\n'

      '- Besleme Gerilimi:\n'
      'Op-amp\'lar genellikle çift kutuplu besleme ile çalışır (±12V, ±15V). '
      'Bazı op-amp türleri tek besleme (0–5V, 0–12V) ile de çalışabilir.\n\n'

      '- Kullanım Alanları:\n'
      'Op-amp\'lar sensör sinyal kuvvetlendirme, filtre devreleri, ses yükselteçleri, '
      'karşılaştırıcılar (comparator) ve ölçüm sistemlerinde yaygın olarak kullanılır.',
  kategori: 'elektronik',
  resim: 'assets/images/opamp.png',
  ),
  Makale(
  id: 'el10',
  baslik: 'ADC ve DAC Nedir? (Detaylı Anlatım)',
  icerik:
      'ADC (Analog–Dijital Dönüştürücü), analog gerilim veya akım sinyallerini dijital verilere çeviren devrelerdir. '
      'Mikrodenetleyicilerde sensörlerden (sıcaklık, ışık, potansiyometre vb.) veri okumak için kullanılır.\n\n'

      'DAC (Dijital–Analog Dönüştürücü) ise dijital verileri tekrar analog sinyale dönüştürür. '
      'Ses sistemleri, motor sürücüleri ve analog kontrol devrelerinde yaygın olarak kullanılır.\n\n'

      '-ADC ve DAC Türleri:\n'
      'ADC türleri arasında Flash ADC (çok hızlı), SAR ADC (mikrodenetleyicilerde en yaygın), '
      'Sigma-Delta ADC (yüksek çözünürlük) ve Pipeline ADC bulunur.\n'
      'DAC türleri ise R-2R merdiven DAC, ağırlıklı direnç DAC ve PWM tabanlı DAC olarak sınıflandırılır.\n\n'

      'Çözünürlük (Bit Sayısı):\n'
      'ADC çözünürlüğü, ölçüm hassasiyetini belirler. '
      'Örneğin 8 bit ADC = 256 seviye, 10 bit ADC = 1024 seviye, 12 bit ADC = 4096 seviye anlamına gelir.\n\n'

      '-Örnekleme Hızı ve Nyquist Kuralı:\n'
      'Örnekleme hızı, saniyede alınan ölçüm sayısını ifade eder. '
      'Nyquist kuralına göre örnekleme frekansı, sinyal frekansının en az iki katı olmalıdır. '
      'Aksi halde aliasing (örtüşme) hataları meydana gelir.\n\n'

      '-Kullanım Alanları:\n'
      'ADC; sensör okuma, ölçüm cihazları, veri toplama ve otomasyon sistemlerinde kullanılır. '
      'DAC ise ses çıkışı, analog kontrol, motor hız ayarı ve endüstriyel uygulamalarda tercih edilir.\n\n'

      'Mikrodenetleyicilerde ADC genellikle dahili olarak bulunurken, DAC çoğu zaman harici entegreler ile sağlanır.',
  kategori: 'elektronik',
  resim: 'assets/images/adc_dac_full.png',
  ikonAsset: 'assets/images/dacicon.png',
  ),
  Makale(
  id: 'el11',
  baslik: 'Filtre Devreleri: Alçak, Yüksek ve Bant Geçiren', 
  icerik:
      'Filtre devreleri, elektrik ve elektronik devrelerde belirli frekanstaki sinyalleri geçirmek, '
      'istenmeyen frekansları ise zayıflatmak veya engellemek için kullanılır. Filtreleme işlemi, '
      'sinyalin genliğine değil frekansına göre yapılır.\n\n'

      '- Alçak Geçiren Filtre (Low Pass Filter):\n'
      'Alçak geçiren filtre, belirlenen kesim frekansının altındaki düşük frekanslı sinyalleri geçirir, '
      'yüksek frekanslı sinyalleri ise zayıflatır. Genellikle RC devreleri ile yapılır. '
      'Güç kaynaklarında dalgalanmayı (ripple) azaltmak, ses sistemlerinde parazitleri bastırmak için kullanılır.\n\n'

      '- Yüksek Geçiren Filtre (High Pass Filter):\n'
      'Yüksek geçiren filtre, kesim frekansının üzerindeki yüksek frekanslı sinyalleri geçirirken '
      'düşük frekanslı sinyalleri ve DC bileşeni engeller. '
      'Ses giriş devrelerinde, mikrofon ve amplifikatör girişlerinde yaygın olarak kullanılır.\n\n'

      '- Bant Geçiren Filtre (Band Pass Filter):\n'
      'Bant geçiren filtre, sadece belirli bir frekans aralığını geçirir; bu aralığın altındaki ve '
      'üstündeki frekansları zayıflatır. Genellikle RLC devreleri ile oluşturulur. '
      'Radyo alıcılarında, haberleşme sistemlerinde ve sensör uygulamalarında kullanılır.\n\n'

      '🔧 RC ve RLC Filtreler:\n'
      'RC filtreler direnç ve kondansatörden oluşur, yapıları basit ve maliyetleri düşüktür. '
      'RLC filtreler ise direnç, bobin ve kondansatör içerir; daha keskin ve seçici filtreleme sağlar.\n\n'

      '✂️ Kesim Frekansı:\n'
      'Filtrenin sinyali zayıflatmaya başladığı frekansa kesim frekansı denir. '
      'RC devrelerinde kesim frekansı fc = 1 / (2πRC) formülü ile hesaplanır.\n\n'

      '🧰 Tekniker Notu:\n'
      'Güç kaynaklarında alçak geçiren filtre, çıkıştaki AC dalgalanmayı azaltmak için; '
      'ses ve haberleşme devrelerinde ise istenmeyen parazitleri bastırmak için kullanılır.',
  kategori: 'elektronik',
  ikonAsset: 'assets/images/filtreicon.png',
),
  Makale(
  id: 'el12',
  baslik: 'Televizyon Nasıl Çalışır? (Uydu, Headend ve Bağlantı Sistemleri)',
  icerik:
      'Televizyonlar, kaynaktan gelen görüntü ve ses sinyallerini işleyerek ekranda görüntü, '
      'hoparlörde ses oluşturan cihazlardır. Türkiye’de televizyon yayınlarının büyük bölümü '
      'uydu sistemi üzerinden alınır.\n\n'

      '- Türkiye’de TV Yayın Sistemi:\n'
      'Ülkemizde en yaygın yayın türü uydu yayınıdır. '
      'Yer istasyonlarından uydulara gönderilen yayınlar, çanak antenler aracılığıyla alınır. '
      'Bu sinyaller LNB üzerinden alıcıya iletilir.\n\n'

      '- Çanak Anten ve LNB Görevi:\n'
      'Çanak anten, uydu sinyallerini odaklayarak LNB (Low Noise Block) üzerine düşürür. '
      'LNB, yüksek frekanslı uydu sinyalini daha düşük frekansa çevirerek koaksiyel kablo ile '
      'taşınmasını sağlar.\n\n'

      '- Koaksiyel Kablo ve F Konnektör:\n'
      'Uydu sistemlerinde sinyal iletimi için koaksiyel kablo kullanılır. '
      'F konnektörler, koaksiyel kablonun LNB, uydu alıcısı ve headend sistemlerine '
      'sağlam ve düşük kayıplı şekilde bağlanmasını sağlar.\n\n'

      'Erkek F konnektör kablo ucuna takılırken, dişi F konnektör prizlerde ve cihaz girişlerinde bulunur. '
      'Vidalı yapı sayesinde sinyal zayıflaması ve temas problemleri minimuma indirilir.\n\n'

      '- Uydu Alıcısı (Receiver):\n'
      'Uydu alıcısı, LNB’den gelen sinyali çözer ve televizyonun anlayabileceği '
      'ses ve görüntü formatına dönüştürür. '
      'Günümüzde birçok televizyonda uydu alıcısı dahili olarak bulunmaktadır.\n\n'

      '- Headend Sistemi Nedir?\n'
      'Headend sistemi, birden fazla uydu yayınının merkezi bir noktada alınarak '
      'işlenmesi ve bina içi dağıtıma uygun hale getirilmesini sağlayan profesyonel '
      'televizyon yayın sistemidir.\n\n'

      'Oteller, hastaneler, siteler, yurtlar ve büyük iş merkezlerinde '
      'her daireye ayrı uydu alıcısı koymak yerine headend sistemi kullanılır. '
      'Bu sistem sayesinde tüm yayınlar tek merkezden kontrol edilir.\n\n'

      '- Headend Sisteminin Çalışma Prensibi:\n'
      'Çanak antenlerden gelen uydu sinyalleri headend cihazına girer. '
      'Bu cihaz sinyalleri çözer, filtreler ve yeniden modüle eder. '
      'Sonrasında yayınlar, bina içi koaksiyel kablo altyapısı üzerinden '
      'tüm dairelere veya odalara dağıtılır.\n\n'

      '- Headend Sisteminin Avantajları:\n'
      'Merkezi yönetim imkanı sağlar, bakım maliyeti düşüktür ve '
      'her kullanıcı için ayrı uydu alıcısı gerektirmez. '
      'Kanal listesi merkezi olarak ayarlanabilir ve '
      'görüntü kalitesi tüm noktalarda sabit olur.\n\n'

      '- Headend ile Multiswitch Farkı:\n'
      'Multiswitch sistemleri yalnızca uydu sinyalini dağıtırken, '
      'headend sistemleri sinyali işleyerek RF veya IP formatında dağıtım yapar. '
      'Bu nedenle headend sistemleri daha profesyonel ve kapsamlıdır.\n\n'

      '- Özet:\n'
      'Türkiye’de televizyon yayınları; çanak anten, LNB, koaksiyel kablo, '
      'F konnektör, uydu alıcısı ve büyük yapılarda headend sistemleri '
      'kullanılarak dağıtılır. '
      'Doğru sistem seçimi, görüntü kalitesi ve işletme maliyetini doğrudan etkiler.',
  kategori: 'elektronik',
  resim: 'assets/images/tv.jpg',
  resimOrta: 'assets/images/tvorta.jpg',
  ),
  Makale(
  id: 'el18',
  baslik:
      'Satfinder 6 Nedir? Uydu / Karasal / Kablo Yayın Ölçümü, DiSEqC, dB Ayarları ve Kurulum Rehberi (A’dan Z’ye)',
  kategori: 'elektronik',
  ikonAsset: 'assets/images/alpsat.jpg',
  icerik:
      'Satfinder 6; çanak anten ayarı yaparken sinyal seviyesi ve kalitesini ölçmek, '
      'doğru transponder’ı yakalamak, LNB beslemesini kontrol etmek ve bazı modellerde '
      'karasal (DVB-T/T2) ile kablo (DVB-C) yayınlarını test etmek için kullanılan '
      'taşınabilir ölçüm cihazıdır.\n\n'
      'Bu makalede; Satfinder 6’nın doğru bağlantısı, uydu bulma mantığı, DiSEqC '
      '(switch/motor) ayarları, dB – dBµV – MER – BER kavramları, '
      'DVB-S/S2 – DVB-T/T2 – DVB-C farkları ve sahada en sık karşılaşılan arızalar '
      'pratik bir tekniker gözüyle anlatılmaktadır.',
  bloklar: const [

    MakaleBlok.text(
      '🧰 1) Satfinder 6 Ne İşe Yarar?\n'
      'Satfinder 6 ile sahada şunları yapabilirsin:\n\n'
      '• Çanağı doğru uyduya kilitlemek (Level / Quality takibi)\n'
      '• Transponder (TP) tarayıp sinyal doğrulamak\n'
      '• LNB beslemesi (13/18 V) ve 22 kHz ton kontrolünü test etmek\n'
      '• DiSEqC switch (1.0 / 1.1) veya motor (1.2 / USALS) kontrolü yapmak\n'
      '• Combo modellerde karasal (DVB-T/T2) ve kablo (DVB-C) yayınlarını ölçmek\n\n'
      'Not: Menü isimleri cihazdan cihaza değişebilir ancak çalışma mantığı aynıdır.',
    ),

    MakaleBlok.text(
      ' 2) Bağlantı Şeması (Doğru Kurulum)\n'
      'Sahada en sık yapılan hatalar; receiver kapalıyken ölçüm yapmak veya '
      'LNB beslemesi kapalıyken sinyal aramaktır.\n\n'
      'Standart bağlantı şekli:\n'
      '1) Çanaktan gelen koaksiyel kablo → Satfinder “LNB IN”\n'
      '2) Satfinder “REC / TV OUT” → Uydu alıcısı (gerekiyorsa)\n'
      '3) Cihaz harici adaptörlü ise adaptör bağlantısını yap\n\n'
      'Önemli kural:\n'
      '• LNB’ye gücü ya Satfinder ya da receiver vermelidir.\n'
      '• İkisi aynı anda besleme verdiğinde bazı modellerde kararsızlık oluşabilir.',
    ),

    MakaleBlok.text(
      '🛰 3) Uydu Bulmanın Mantığı: Seviye mi Kalite mi?\n'
      'Ekranda genellikle iki ana değer görülür:\n\n'
      '• Level / Strength (Seviye): Hatta sinyal enerjisi var mı?\n'
      '• Quality (Kalite): Asıl önemli değer. Doğru uydu ve doğru TP yakalandı mı?\n\n'
      'Altın kural:\n'
      '✅ Çanak ayarında hedef her zaman “Quality” değerini artırmaktır.\n\n'
      'Level yüksek ama Quality sıfırsa; yanlış uydu, yanlış TP, '
      'yanlış LNB ayarı veya DiSEqC hatası olabilir.',
    ),

    MakaleBlok.text(
      '📡 4) LNB Ayarları (En Kritik Menü)\n'
      'LNB tipi veya LO (Local Oscillator) ayarı yanlışsa '
      'transponder yakalaman mümkün değildir.\n\n'
      'En yaygın LNB tipleri:\n'
      '• Universal (Ku Band): 9750 / 10600 MHz (Türkiye’de en yaygın)\n'
      '• Single LO: Tek frekanslı özel LNB’ler\n'
      '• C Band: Farklı LO değerleri kullanır\n\n'
      '22 kHz Ton Ne İşe Yarar?\n'
      '• Universal LNB’lerde low band / high band geçişini sağlar.\n'
      '• Yanlış ayarda bazı TP’ler gelirken bazıları gelmez.',
    ),

    MakaleBlok.text(
      '🧭 5) Uyduyu Hızlı Bulma (Sahada Zaman Kazandıran Yöntem)\n'
      '1) Uyduyu seç (örnek: Türksat 42°E)\n'
      '2) Güçlü ve yaygın bir TP seç\n'
      '3) Çanağı yavaşça sağ–sol hareket ettir\n'
      '4) Quality geldiği anda dur ve ince ayara geç\n'
      '5) Elevation ve LNB skew ayarlarını küçük dokunuşlarla yap\n\n'
      'İpucu:\n'
      '• Bip sesi varsa önce hassasiyeti kıs, uyduya yaklaşınca artır.\n'
      '• En büyük hata: Çanağı hızlı çevirmek.',
    ),

    MakaleBlok.text(
      '🧩 6) DiSEqC Nedir? (Switch ve Motor Mantığı)\n'
      'DiSEqC; ölçüm cihazı veya receiver ile '
      'switch ya da motor arasında komut iletimini sağlayan protokoldür.\n\n'
      'En yaygın DiSEqC türleri:\n'
      '• DiSEqC 1.0: 4 port switch\n'
      '• DiSEqC 1.1: 8 / 16 port switch\n'
      '• DiSEqC 1.2: Motorlu sistem (manuel hareket)\n'
      '• USALS: Enlem–boylam girilerek otomatik motor kontrolü\n\n'
      'Yanlış port seçilirse Level gelir ama Quality gelmez.',
    ),

    MakaleBlok.text(
      '📈 7) dB / dBµV / MER / BER Değerleri\n'
      'Cihaza göre şu değerler görülebilir:\n\n'
      '• dB: Göreli seviye veya kazanç\n'
      '• dBµV: RF sinyal seviyesi (karasal/kablo sistemlerde yaygın)\n'
      '• MER (dB): Modülasyon kalitesi (yüksek olması iyidir)\n'
      '• BER: Bit hata oranı (düşük olması iyidir)\n\n'
      'Saha yorumu:\n'
      '• Level iyi ama MER düşükse ince ayar veya kablo sorunu vardır.\n'
      '• BER yükseliyorsa sistem sınırdadır.',
    ),

    MakaleBlok.text(
      '🧯 8) En Sık Karşılaşılan Arızalar\n'
      '• Level var Quality yok → yanlış uydu veya TP\n'
      '• Bazı kanallar yok → 22 kHz / LO ayarı hatalı\n'
      '• Yağmurda sinyal gidiyor → çanak sınırda ayarlı\n'
      '• DiSEqC çalışmıyor → port veya switch arızası\n'
      '• Motor dönmüyor → DiSEqC ayarı veya besleme sorunu\n'
      '• Kablo yayında seviye düşük → splitter ve ekler zayıflatıyor\n'
      '• Karasalda sinyal yok → anten yönü veya yükselteç sorunu',
    ),

    MakaleBlok.text(
      '✅ 9) Kısa Özet\n'
      '• Uydu ayarında hedef Quality değeridir\n'
      '• LNB ve DiSEqC ayarları en kritik noktalardır\n'
      '• DVB-S/S2 uydu, DVB-T/T2 karasal, DVB-C kablo yayınıdır\n'
      '• Kablo ve konnektör kalitesi ölçümü doğrudan etkiler',
    ),
  ],
),
  Makale(
  id: 'el13',
  baslik: 'RJ11 ve RJ45 Nedir? Ethernet Kabloları, Renk Sıralaması ve Fiber İnternet',
  kategori: 'elektronik',
  ikonAsset: 'assets/images/rj45.png', 
  icerik:
      'Ev ve iş yerlerinde kullanılan internet ve telefon altyapısının temelinde '
      'RJ11 ve RJ45 konnektörleri bulunur.\n\n'
      'Bu makalede RJ11 ve RJ45 farkları, Türkiye’de yaygın kullanılan bağlantı '
      'renk sıralamaları, Ethernet kabloları ve fiber internet altyapısının '
      'çalışma mantığı detaylı ve sade bir dille anlatılmaktadır.',
  bloklar: const [

    // RJ11
    MakaleBlok.text(
      '☎️ RJ11 NEDİR?\n'
      'RJ11, genellikle sabit telefon ve ADSL/VDSL modem bağlantılarında kullanılan '
      'küçük tip bir konnektördür.\n\n'
      'Özellikleri:\n'
      '• 6 pinli yapıya sahiptir (genelde 2 veya 4 tel kullanılır)\n'
      '• Telefon hattı (PSTN) ve ADSL/VDSL sinyali taşır\n'
      '• İnternet hızları düşüktür, günümüzde yerini fiber altyapıya bırakmaktadır\n\n'
      'Türkiye’de eski binalarda telefon prizlerinde yaygın olarak bulunur.',
    ),

    // RJ45
    MakaleBlok.text(
      '🌐 RJ45 NEDİR?\n'
      'RJ45, Ethernet kablolarında kullanılan ve modem, router, switch, bilgisayar '
      'gibi cihazları birbirine bağlayan konnektördür.\n\n'
      'Özellikleri:\n'
      '• 8 pinlidir (8 damar kullanılır)\n'
      '• Yüksek hızlı veri iletimi sağlar\n'
      '• LAN, WAN ve IP tabanlı tüm ağ sistemlerinde standarttır\n\n'
      'Günümüzde ev interneti, kamera sistemleri (IP kamera), PoE sistemler ve '
      'network altyapılarında temel bağlantı tipidir.',
    ),

    MakaleBlok.image(
      'assets/images/rj45.png',
      aciklama:
          'RJ45 konnektör ve Ethernet kablosu.\n'
          '8 damarlı yapı sayesinde yüksek hız sağlar.',
    ),

    // Kablo türleri
    MakaleBlok.text(
      '🧵 ETHERNET KABLO TÜRLERİ (CAT KABLOLAR)\n'
      'RJ45 konnektörü farklı kategori Ethernet kabloları ile kullanılır.\n\n'
      '• CAT5e:\n'
      '  1000 Mbps (1 Gbps) hız destekler. Ev ve küçük ofisler için yeterlidir.\n\n'
      '• CAT6:\n'
      '  Daha düşük parazit, daha stabil bağlantı. 1 Gbps rahat, kısa mesafede 10 Gbps.\n\n'
      '• CAT6a / CAT7:\n'
      '  Profesyonel ve endüstriyel ağlar için tercih edilir.\n\n'
      'Ev kullanımı için CAT5e veya CAT6 fazlasıyla yeterlidir.',
    ),

    // Renk sıralaması
    MakaleBlok.text(
      '🎨 RJ45 RENK SIRALAMASI (T568A – T568B)\n'
      'Ethernet kablolarında iki uluslararası standart vardır:\n\n'
      '🔹 T568B (Türkiye’de en yaygın):\n'
      '1️⃣ Beyaz-Turuncu\n'
      '2️⃣ Turuncu\n'
      '3️⃣ Beyaz-Yeşil\n'
      '4️⃣ Mavi\n'
      '5️⃣ Beyaz-Mavi\n'
      '6️⃣ Yeşil\n'
      '7️⃣ Beyaz-Kahverengi\n'
      '8️⃣ Kahverengi\n\n'
      '🔹 T568A:\n'
      '1️⃣ Beyaz-Yeşil\n'
      '2️⃣ Yeşil\n'
      '3️⃣ Beyaz-Turuncu\n'
      '4️⃣ Mavi\n'
      '5️⃣ Beyaz-Mavi\n'
      '6️⃣ Turuncu\n'
      '7️⃣ Beyaz-Kahverengi\n'
      '8️⃣ Kahverengi\n\n'
      'Not: İki uçta da aynı standart kullanılırsa “düz kablo” olur.',
    ),

    MakaleBlok.image(
      'assets/images/rj451.jpg',
      aciklama:
          'RJ45 T568A ve T568B renk sıralaması.\n'
          'Türkiye’de genellikle T568B kullanılır.',
    ),

    // Düz / Çapraz
    MakaleBlok.text(
      '🔁 DÜZ KABLO ve ÇAPRAZ KABLO FARKI\n'
      '• Düz Kablo:\n'
      '  İki ucu da aynı standart (T568B–T568B). Günümüzde en yaygın kullanım.\n\n'
      '• Çapraz Kablo:\n'
      '  Bir ucu T568A, diğer ucu T568B. Eski sistemlerde cihaz–cihaz bağlantısı için.\n\n'
      'Modern modem, switch ve router’lar otomatik algılama yaptığı için '
      'çapraz kabloya genelde gerek kalmaz.',
    ),

    // Fiber
    MakaleBlok.text(
      '🚀 FİBER İNTERNET NEDİR?\n'
      'Fiber internet, veriyi elektrik sinyali yerine ışık sinyaliyle ileten '
      'yüksek hızlı internet altyapısıdır.\n\n'
      'Avantajları:\n'
      '• Çok yüksek hız (100 Mbps – 1 Gbps ve üzeri)\n'
      '• Düşük gecikme (ping)\n'
      '• Elektromanyetik parazitten etkilenmez\n\n'
      'Fiber kablo doğrudan RJ45 değildir; modem veya ONT cihazı ile RJ45 Ethernet\'e dönüştürülür.',
    ),

    // Ev internet mantığı
    MakaleBlok.text(
      '🏠 EV İNTERNET ALTYAPISI NASIL ÇALIŞIR?\n'
      '1️⃣ Dış hattan (fiber veya bakır) bina içine gelir\n'
      '2️⃣ Modem veya ONT cihazına bağlanır\n'
      '3️⃣ Modem RJ45 çıkışı ile router/switch’e gider\n'
      '4️⃣ Ev içi prizlere veya cihazlara Ethernet ile dağıtılır\n\n'
      'IP kamera, akıllı TV, bilgisayar ve access point cihazları bu ağ üzerinden çalışır.',
    ),

    // Hatalar
    MakaleBlok.text(
      '⚠️ EN SIK YAPILAN HATALAR\n'
      '• RJ45 renk sıralamasını karıştırmak\n'
      '• CAT kabloyu ezmek veya çok keskin bükmek\n'
      '• Aynı hatta elektrik kablosu ile birlikte çekmek (parazit)\n'
      '• Ucuz konnektör ve pense kullanmak\n\n'
      'Doğru krimpleme ve kaliteli malzeme, ağ performansını doğrudan etkiler.',
    ),

    // Özet
    MakaleBlok.text(
      ' HIZLI ÖZET\n'
      '• RJ11: Telefon ve ADSL/VDSL\n'
      '• RJ45: Ethernet ve LAN bağlantısı\n'
      '• Türkiye’de en yaygın renk sıralaması: T568B\n'
      '• CAT5e/CAT6 ev için yeterlidir\n'
      '• Fiber internet en hızlı ve stabil çözümdür',
    ),
  ],
),
  Makale(
  id: 'el14',
  baslik: 'Kamera Sistemleri: Analog – IP Kamera, PoE Switch, IP Atama ve Telefona Bağlama',
  kategori: 'elektronik',
  ikonAsset: 'assets/images/cctv_tester.webp',
  icerik:
      'Güvenlik kamera sistemleri; ev, iş yeri, site ve endüstriyel alanlarda '
      'can ve mal güvenliği için yaygın olarak kullanılan elektronik sistemlerdir.\n\n'
      'Bu makalede analog kamera ve IP kamera farkları, PoE switch mantığı, '
      'kamera sistemlerinde kullanılan tüm ekipmanlar, IP atama işlemleri '
      've kameraya telefon üzerinden erişim detaylı ve sade bir dille anlatılmaktadır.',
  bloklar: const [

    // 1) Kamera sistemi nedir
    MakaleBlok.text(
      '🎥 KAMERA SİSTEMİ NEDİR?\n'
      'Kamera sistemi; ortamdan görüntü alan kameralar, bu görüntüleri '
      'kaydeden ve izlemeyi sağlayan kayıt cihazları ile bunları birbirine '
      'bağlayan altyapıdan oluşur.\n\n'
      'Temel amaçlar:\n'
      '• Güvenlik\n'
      '• İzleme ve kayıt\n'
      '• Olay sonrası delil\n'
      '• Uzaktan erişim',
    ),

    // 2) Analog kamera
    MakaleBlok.text(
      '📼 ANALOG KAMERA NEDİR?\n'
      'Analog kameralar, görüntüyü analog sinyal olarak ileten ve genellikle '
      'koaksiyel kablo (RG59) ile çalışan kamera türleridir.\n\n'
      'Özellikleri:\n'
      '• Görüntü iletimi: Koaksiyel kablo\n'
      '• Güç beslemesi: Harici adaptör veya merkezi trafo\n'
      '• Kayıt cihazı: DVR (Digital Video Recorder)\n\n'
      'Avantajları:\n'
      '• Kurulumu basit\n'
      '• Maliyeti düşüktür\n\n'
      'Dezavantajları:\n'
      '• Çözünürlük sınırlıdır\n'
      '• IP kameralara göre daha az esnektir',
    ),

    MakaleBlok.image(
      'assets/images/analog.jpg',
      aciklama:
          'Analog kamera sistemi.\n'
          'Koaksiyel kablo ile DVR cihazına bağlanır.',
    ),

    // 3) IP kamera
    MakaleBlok.text(
      '🌐 IP KAMERA NEDİR?\n'
      'IP kameralar, görüntüyü dijital veri olarak ileten ve network üzerinden '
      'çalışan modern kamera sistemleridir.\n\n'
      'Özellikleri:\n'
      '• Görüntü iletimi: Ethernet (RJ45)\n'
      '• Kayıt cihazı: NVR (Network Video Recorder)\n'
      '• Her kameranın bir IP adresi vardır\n\n'
      'Avantajları:\n'
      '• Yüksek çözünürlük (Full HD, 4K)\n'
      '• Uzaktan erişim çok kolay\n'
      '• Akıllı analiz (hareket, yüz tanıma vb.)\n\n'
      'Dezavantajı:\n'
      '• Analog sisteme göre maliyeti daha yüksektir',
    ),

    MakaleBlok.image(
      'assets/images/ipkam1.jpg',
      aciklama:
          'IP kamera sistemi.\n'
          'Ethernet kablo ile ağ üzerinden çalışır.',
    ),

    // 4) DVR / NVR
    MakaleBlok.text(
      '💾 DVR ve NVR ARASINDAKİ FARK\n'
      '• DVR (Analog Sistem):\n'
      '  Analog kameralar DVR’a koaksiyel kablo ile bağlanır.\n\n'
      '• NVR (IP Sistem):\n'
      '  IP kameralar network üzerinden NVR’a bağlanır.\n\n'
      'Özet:\n'
      'Analog = DVR\n'
      'IP = NVR',
    ),

    // 5) PoE mantığı
    MakaleBlok.text(
      '⚡ PoE (POWER OVER ETHERNET) NEDİR?\n'
      'PoE, IP kameraların tek bir Ethernet kablosu üzerinden '
      'hem veri hem de enerji almasını sağlayan teknolojidir.\n\n'
      'Avantajları:\n'
      '• Ayrı adaptör gerekmez\n'
      '• Kablo karmaşası azalır\n'
      '• Kurulum daha düzenli olur\n\n'
      'PoE iki şekilde sağlanır:\n'
      '• PoE Switch\n'
      '• PoE Enjektör',
    ),

    MakaleBlok.image(
      'assets/images/ipkam1.jpg',
      aciklama:
          'PoE switch ile IP kamera bağlantısı.\n'
          'Tek kablo ile görüntü ve enerji taşınır.',
    ),

    // 6) Kamera sisteminde kullanılanlar
    MakaleBlok.text(
      '🧰 KAMERA SİSTEMİNDE KULLANILAN EKİPMANLAR\n'
      '• Kamera (Analog / IP)\n'
      '• DVR veya NVR\n'
      '• PoE Switch (IP sistemlerde)\n'
      '• Router / Modem\n'
      '• Ethernet kablo (CAT5e / CAT6)\n'
      '• Koaksiyel kablo (Analog sistemlerde)\n'
      '• Harddisk (HDD)\n'
      '• Adaptör veya merkezi güç kaynağı\n'
      '• Kamera test cihazı',
    ),

    // 7) IP atama
    MakaleBlok.text(
      '🧠 IP KAMERAYA IP ATAMA NASIL YAPILIR?\n'
      'IP kameralar ağa bağlandığında genellikle otomatik IP alır (DHCP).\n\n'
      'Statik IP vermek için:\n'
      '1️⃣ Bilgisayar ve kamera aynı ağa bağlanır\n'
      '2️⃣ Kamera arayüzüne girilir (web veya yazılım)\n'
      '3️⃣ IP adresi manuel olarak ayarlanır\n'
      'Örnek:\n'
      'IP: 192.168.1.100\n'
      'Gateway: 192.168.1.1\n'
      'Subnet: 255.255.255.0\n\n'
      'Her kameraya farklı IP verilmelidir.',
    ),

    // 8) Telefona bağlama
    MakaleBlok.text(
      '📱 KAMERAYA TELEFONDAN NASIL BAĞLANILIR?\n'
      'Günümüzde çoğu kamera sistemi mobil uygulama ile uzaktan izlenebilir.\n\n'
      'Genel adımlar:\n'
      '1️⃣ NVR/DVR internete bağlanır\n'
      '2️⃣ Cihaza bulut (P2P) aktif edilir\n'
      '3️⃣ Telefon uygulaması yüklenir\n'
      '4️⃣ QR kod veya seri numarası eklenir\n\n'
      'Telefon üzerinden:\n'
      '• Canlı izleme\n'
      '• Geriye dönük kayıt izleme\n'
      '• Hareket bildirimi alma\n'
      'mümkündür.',
    ),

    // 9) Kamera test cihazı
    MakaleBlok.text(
      '🧪 KAMERA TEST CİHAZI NE İŞE YARAR?\n'
      'Kamera test cihazı, montaj sırasında kameranın çalışıp çalışmadığını '
      'kontrol etmek için kullanılır.\n\n'
      'Sağladıkları:\n'
      '• Görüntü test\n'
      '• IP bulma\n'
      '• PoE test\n'
      '• Ping ve network testleri\n\n'
      'Sahada çalışan teknisyenler için büyük kolaylıktır.',
    ),
    MakaleBlok.image(
      'assets/images/cctv_tester.webp',
      aciklama:
          'CCTV Test Cihazı'         
    ),

    // 10) En sık yapılan hatalar
    MakaleBlok.text(
      '⚠️ EN SIK YAPILAN HATALAR\n'
      '• IP çakışması (aynı IP iki kamerada)\n'
      '• PoE gücü yetersiz switch kullanmak\n'
      '• Düşük kalite kablo tercih etmek\n'
      '• Harddisk kapasitesini yanlış hesaplamak\n'
      '• Topraklama ve yıldırımdan korunmayı ihmal etmek\n\n'
      'Doğru malzeme ve planlama sistemin ömrünü uzatır.',
    ),

    // 11) Özet
    MakaleBlok.text(
      ' HIZLI ÖZET\n'
      '• Analog kamera → DVR + koaksiyel\n'
      '• IP kamera → NVR + Ethernet\n'
      '• PoE, tek kablo ile enerji + data sağlar\n'
      '• Her IP kamera ayrı IP adresi kullanır\n'
      '• Telefon üzerinden izleme günümüzde standarttır\n',
    ),
  ],
),
  Makale(
  id: 'o1',
  baslik: 'PLC Giriş / Çıkış (I/O) Türleri – Dijital, Analog, HSC ve PWM',
  kategori: 'otomasyon',
  ikonAsset: 'assets/images/otomasyonicon.png',
  icerik:
      'PLC (Programmable Logic Controller) sistemlerinde giriş ve çıkışlar, '
      'sahadaki sinyaller ile yazılım dünyası arasında köprü görevi görür.\n\n'
      'Bu makalede PLC I/O türleri, çalışma mantıkları, kullanım alanları '
      've sahada dikkat edilmesi gereken teknik detaylar bloklar halinde anlatılmaktadır.',
  bloklar: const [

    // Dijital giriş
    MakaleBlok.text(
      '🔘 DİJİTAL GİRİŞ (DIGITAL INPUT) NEDİR?\n'
      'Dijital girişler yalnızca iki durumu algılar: 0 veya 1 (OFF / ON).\n\n'
      'Bağlanan elemanlar:\n'
      '• Start / Stop butonları\n'
      '• Limit switch (sınır anahtarı)\n'
      '• Proximity sensörler\n'
      '• Fotoseller\n\n'
      'Çalışma gerilimleri:\n'
      '• 24V DC (en yaygın)\n'
      '• 110V / 220V AC\n\n'
      'Not: Endüstride 24V DC, güvenlik ve gürültü bağışıklığı nedeniyle tercih edilir.',
    ),

    // Dijital çıkış
    MakaleBlok.text(
      '🔌 DİJİTAL ÇIKIŞ (DIGITAL OUTPUT) NEDİR?\n'
      'Dijital çıkışlar PLC’nin sahadaki elemanları açıp kapatmasını sağlar.\n\n'
      'Bağlanan elemanlar:\n'
      '• Röle\n'
      '• Kontaktör\n'
      '• Solenoid valf\n'
      '• İkaz lambası\n\n'
      'Dijital çıkış tipleri:\n'
      '• Röle çıkış: AC/DC fark etmez, yavaş ama dayanıklı\n'
      '• Transistör çıkış: Hızlı, DC uygulamalar\n'
      '• Triac çıkış: AC yükler için\n\n'
      'Motor ve büyük yükler doğrudan PLC çıkışına bağlanmaz, araya röle/kontaktör konur.',
    ),

    // Analog giriş
    MakaleBlok.text(
      '📈 ANALOG GİRİŞ (ANALOG INPUT) NEDİR?\n'
      'Analog girişler sürekli değişen fiziksel değerleri sayısal değere çevirir.\n\n'
      'Bağlanan sensörler:\n'
      '• Sıcaklık (PT100, termokupl, transmitter)\n'
      '• Basınç\n'
      '• Seviye\n'
      '• Hız\n\n'
      'Yaygın sinyal tipleri:\n'
      '• 0–10V\n'
      '• 4–20mA (endüstride en güvenilir)\n'
      '• ±10V\n\n'
      '4–20mA sinyal, kablo kopmasını algılayabildiği için tercih edilir.',
    ),

    // Analog çıkış
    MakaleBlok.text(
      '🎚️ ANALOG ÇIKIŞ (ANALOG OUTPUT) NEDİR?\n'
      'Analog çıkışlar, sahadaki cihazlara değişken kontrol sinyali gönderir.\n\n'
      'Kullanım alanları:\n'
      '• Motor hız kontrolü (VFD)\n'
      '• Oransal valf kontrolü\n'
      '• Isıtıcı güç ayarı\n\n'
      'Yaygın çıkış sinyalleri:\n'
      '• 0–10V\n'
      '• 4–20mA\n\n'
      'Analog çıkışlar proses kontrolünün temelidir.',
    ),

    // HSC
    MakaleBlok.text(
      '⚡ HIZLI SAYICI GİRİŞLERİ (HSC – HIGH SPEED COUNTER)\n'
      'HSC girişleri, PLC’nin standart tarama süresinden bağımsız olarak '
      'yüksek frekanslı sinyalleri saymasını sağlar.\n\n'
      'Kullanım alanları:\n'
      '• Encoder\n'
      '• Konum algılama\n'
      '• Hız ölçümü\n'
      '• Adım sayma\n\n'
      'Standart girişlerde kaçabilecek darbeler HSC ile güvenle sayılır.',
    ),

    // PWM
    MakaleBlok.text(
      '〰️ PWM ÇIKIŞLARI (PULSE WIDTH MODULATION)\n'
      'PWM çıkışları, sinyalin açık kalma süresini değiştirerek güç kontrolü sağlar.\n\n'
      'Kullanım alanları:\n'
      '• DC motor hız kontrolü\n'
      '• LED parlaklık ayarı\n'
      '• Basit güç regülasyonu\n\n'
      'PWM, analog çıkış olmayan PLC’lerde ekonomik çözümdür.',
    ),

    // Gürültü
    MakaleBlok.text(
      '🛡️ TOPRAKLAMA ve GÜRÜLTÜ ÖNLEMLERİ\n'
      '• Analog kablolar ekranlı olmalıdır\n'
      '• Ekran tek noktadan topraklanmalıdır\n'
      '• Güç ve sinyal kabloları ayrı tavadan taşınmalıdır\n'
      '• 24V DC beslemeler filtreli olmalıdır\n\n'
      'Yanlış kablolama, ölçüm hatalarına ve kararsız çalışmaya neden olur.',
    ),

    // Özet
    MakaleBlok.text(
      ' HIZLI ÖZET\n'
      '• Dijital = Aç/Kapa\n'
      '• Analog = Değişken değer\n'
      '• HSC = Hızlı darbe\n'
      '• PWM = Güç kontrolü\n'
      '• Doğru I/O seçimi sistemin ömrünü belirler',
    ),
  ],
),
  Makale(
  id: 'o2',
  baslik: 'Kontaktör ve Röle Farkları – Çalışma Mantığı ve Kullanım Alanları',
  kategori: 'otomasyon',
  ikonAsset: 'assets/images/otomasyonicon.png',
  icerik:
      'Kontaktör ve röle, elektrik ve otomasyon sistemlerinde anahtarlama '
      'işlemleri için kullanılan temel kumanda elemanlarıdır.\n\n'
      'Her ikisi de bobin enerjilendiğinde kontaklarını değiştirir; ancak '
      'taşıyabildikleri akım, kullanım alanları ve yapıları farklıdır.\n\n'
      'Bu makalede kontaktör ve röle arasındaki farklar, teknik detaylar '
      've sahada dikkat edilmesi gereken noktalar bloklar halinde anlatılmaktadır.',
  bloklar: const [

    // Röle nedir
    MakaleBlok.text(
      '🔹 RÖLE NEDİR?\n'
      'Röle, düşük akımlı kumanda devreleriyle daha yüksek akımlı devreleri '
      'kontrol etmeye yarayan elektromekanik bir anahtarlama elemanıdır.\n\n'
      'Temel özellikleri:\n'
      '• Küçük ve orta akımlar için uygundur\n'
      '• Genellikle kontrol ve sinyal devrelerinde kullanılır\n'
      '• NO (Normalde Açık) ve NC (Normalde Kapalı) kontaklara sahiptir\n\n'
      'Röleler PLC çıkışları ile saha elemanları arasında arayüz görevi görür.',
    ),

    // Röle kullanım alanları
    MakaleBlok.text(
      '🧰 RÖLE NERELERDE KULLANILIR?\n'
      '• PLC çıkışlarını izole etmek\n'
      '• İkaz lambası ve buzzer kontrolü\n'
      '• Küçük solenoid valfler\n'
      '• Yardımcı kontak ihtiyacı olan devreler\n\n'
      'Not: Röleler motor gibi yüksek akım çeken yükleri doğrudan sürmek için uygun değildir.',
    ),

    // Kontaktör nedir
    MakaleBlok.text(
      '🔹 KONTAKTÖR NEDİR?\n'
      'Kontaktör, yüksek akımlı yüklerin (özellikle motorların) '
      'uzaktan ve güvenli şekilde anahtarlanmasını sağlayan elektromekanik elemandır.\n\n'
      'Temel özellikleri:\n'
      '• Yüksek akım ve güç kapasitesi\n'
      '• Ark söndürme sistemi vardır\n'
      '• Uzun süreli çalışmaya uygundur\n'
      '• Yardımcı kontaklarla genişletilebilir\n\n'
      'Kontaktörler, motor kumanda ve güç devrelerinin vazgeçilmez elemanıdır.',
    ),

    // Kontaktör kullanım alanları
    MakaleBlok.text(
      '⚙️ KONTAKTÖR NERELERDE KULLANILIR?\n'
      '• Asenkron motorlar\n'
      '• Pompalar ve fanlar\n'
      '• Kompresörler\n'
      '• Isıtıcı ve rezistans grupları\n'
      '• Endüstriyel makine güç devreleri\n\n'
      'Kontaktörler genellikle termik röle ile birlikte kullanılır.',
    ),

    // Teknik farklar
    MakaleBlok.text(
      '📊 KONTAKTÖR ve RÖLE ARASINDAKİ TEMEL FARKLAR\n'
      '• Akım kapasitesi:\n'
      '  Röle → Düşük / Orta\n'
      '  Kontaktör → Yüksek\n\n'
      '• Kullanım amacı:\n'
      '  Röle → Kumanda ve sinyal\n'
      '  Kontaktör → Güç devresi\n\n'
      '• Ark dayanımı:\n'
      '  Röle → Sınırlı\n'
      '  Kontaktör → Yüksek (ark söndürme odası vardır)\n\n'
      '• Fiziksel yapı:\n'
      '  Röle → Küçük\n'
      '  Kontaktör → Daha büyük ve ağır',
    ),

    // AC sınıfları
    MakaleBlok.text(
      '📘 KONTAKTÖR AC KULLANIM SINIFLARI (AC-1 / AC-3)\n'
      'Kontaktörler kullanılacak yüke göre sınıflandırılır.\n\n'
      '• AC-1:\n'
      '  Rezistif yükler (ısıtıcı, fırın vb.)\n\n'
      '• AC-3:\n'
      '  Asenkron motorlar (en yaygın kullanım)\n\n'
      'Motor uygulamalarında mutlaka AC-3 değerlerine bakılmalıdır.',
    ),

    // Bobin gerilimleri
    MakaleBlok.text(
      '⚡ BOBİN GERİLİMLERİ (COIL VOLTAGE)\n'
      'Röle ve kontaktör bobinleri farklı gerilimlerde çalışabilir.\n\n'
      'Yaygın bobin gerilimleri:\n'
      '• 24V DC (PLC sistemlerinde en yaygın)\n'
      '• 24V AC\n'
      '• 110V AC\n'
      '• 220V AC\n\n'
      'PLC çıkışlarıyla doğrudan sürmek için genellikle 24V DC bobin tercih edilir.',
    ),

    // Saha hataları
    MakaleBlok.text(
      '⚠️ SAHADA EN SIK YAPILAN HATALAR\n'
      '• Röle ile motor sürmeye çalışmak\n'
      '• Kontaktör akımını motor gücüne göre yanlış seçmek\n'
      '• Bobin gerilimini yanlış bağlamak\n'
      '• Termik röle kullanmamak\n'
      '• Yardımcı kontak ihtiyacını hesaplamamak\n\n'
      'Bu hatalar kontak yanması ve sistem arızalarına yol açar.',
    ),

    // Tekniker notu
    MakaleBlok.text(
      '🧑‍🔧 TEKNİKER NOTU\n'
      'PLC çıkışı → Röle → Kontaktör zinciri, '
      'hem PLC’yi korur hem de sistemin güvenliğini artırır.\n\n'
      'Yük büyüdükçe doğrudan sürme yerine kademeli kumanda tercih edilmelidir.',
    ),

    // Özet
    MakaleBlok.text(
      ' HIZLI ÖZET\n'
      '• Röle: Kumanda ve düşük akım\n'
      '• Kontaktör: Motor ve yüksek güç\n'
      '• Motor uygulamalarında AC-3 kontaktör + termik şart\n'
      '• PLC sistemlerinde 24V DC bobin en güvenli çözümdür',
    ),
  ],
),
 Makale(
  id: 'o3',
  baslik: 'Otomasyon Sistemlerinde Temel Güvenlik ve Uygulama Kuralları',
  kategori: 'otomasyon',
  ikonAsset: 'assets/images/otomasyonicon.png',
  icerik:
      'Otomasyon panoları ve saha ekipmanları; PLC, sürücü, sensör, kontaktör ve '
      'güç devrelerinin birlikte çalıştığı sistemlerdir. Bu sistemlerde güvenlik; '
      'yalnızca elektrik çarpılması değil, makinenin beklenmedik hareket etmesi, '
      'yanlış kablolama, gürültü/EMC kaynaklı hatalı çalışma ve yangın risklerini de kapsar.\n\n'
      'Bu makalede; sahada en çok yapılan hataları engelleyen temel güvenlik ve '
      'uygulama kuralları pratik şekilde anlatılır.',
  resim: 'assets/images/otomasyon_bilgi.jpg', // varsa üst görsel
  resimAltta: false,

  bloklar: const [
    MakaleBlok.text(
      '🛑 1) ACİL DURDURMA (E-STOP) KURALI\n'
      'E-Stop, makinenin tehlikeli hareketini en hızlı ve güvenli şekilde durdurmak için kullanılır.\n\n'
      ' Doğru uygulama:\n'
      '• Kolay erişilebilir ve görünür yerde olmalı\n'
      '• Kilitlenebilir (mantarlı) tip seçilmeli\n'
      '• E-Stop hattı mümkünse “Safety Relay / Safety PLC” üzerinden yönetilmeli\n'
      '• Sadece PLC yazılımı ile stop yapmak yeterli değildir (fail-safe şart)\n\n'
      '⚠️ Kritik Not:\n'
      'E-Stop genelde “enerjiyi kesme” mantığıyla çalışır. Yani kontaktör bobin enerjisini keser; '
      'makine durur. PLC kilitlenirse bile durmayı sağlamalı.',
    ),

    MakaleBlok.text(
      '🔒 2) LOTO (KİLİTLEME / ETİKETLEME) – HAYAT KURTARIR\n'
      'Bakım/arıza sırasında enerji verilmesini engellemek için LOTO uygulanır.\n\n'
      ' Minimum LOTO adımları:\n'
      '1) Sistemi durdur\n'
      '2) Enerjiyi kes (şalter/sigorta)\n'
      '3) Kilitle ve etiketi as\n'
      '4) Kalan enerjiyi boşalt (kapasitör, pnömatik basınç, yaylı mekanizma)\n'
      '5) Ölçerek doğrula (enerji yok)\n\n'
      '⚠️ “Bir dakika bakıp çıkacağım” LOTO yapılmayan en tehlikeli cümle.',
    ),

    MakaleBlok.text(
      '⏚ 3) TOPRAKLAMA – EMC – EKRANLAMA\n'
      'Topraklama sadece çarpılmayı önlemez; sürücü/PLC gürültüsünü de azaltır.\n\n'
      ' Pano ve saha için öneriler:\n'
      '• Pano gövdesi ve kapak köprülemeleri (örgü şerit) yapılmalı\n'
      '• Sürücü (VFD) – motor kablosu ekranlı olmalı\n'
      '• Ekran (shield) bağlantısı mümkünse 360° kelepçe ile pano girişinde yapılmalı\n'
      '• Analog sinyal kabloları ekranlı olmalı, güç kablolarından ayrı taşınmalı\n\n'
      '⚠️ Analog hatlarda “tek noktadan ekran-toprak” çoğu durumda en stabil sonuç verir.',
    ),

    MakaleBlok.text(
      '🧠 4) 24V DC BESLEME KURALI (PLC/SENSÖR)\n'
      'PLC ve sensör beslemesi temiz ve kararlı olmalı.\n\n'
      ' İyi pratikler:\n'
      '• 24V DC güç kaynağına girişte sigorta/MCB kullan\n'
      '• 24V çıkışları gruplara ayır: PLC, sensörler, bobinler (röle/kontaktör)\n'
      '• Bobinler için diyot/varistör/snubber kullan (geri EMK gürültüsünü keser)\n'
      '• 0V (GND) hattını düzgün klemens barasına topla\n\n'
      '⚠️ Bobin gürültüsü yüzünden PLC reset atan çok sistem gördük: önlem şart.',
    ),

    MakaleBlok.text(
      '🧷 5) I/O KABLOLAMA – DİJİTAL / ANALOG AYRIMI\n'
      'Hatalı kablolama ve parazit; sahada “hayalet arıza” üretir.\n\n'
      ' Kural seti:\n'
      '• Analog ve dijital kablolar ayrı kanal/borudan gitsin\n'
      '• Encoder/HSC hatları ekranlı ve kısa tutulmalı\n'
      '• Güç kabloları (motor, 220V) ile sinyal kabloları mümkünse kesişmesin\n'
      '• Kesişmesi gerekiyorsa 90° açıyla kesiştir\n\n'
      '💡 Tekniker tüyosu:\n'
      '4–20mA analog sinyal, 0–10V’a göre uzun mesafede daha dayanıklıdır.',
    ),

    MakaleBlok.text(
      '🧯 6) KORUMA ELEMANLARI: SIGORTA – TERMİK – KAÇAK AKIM\n'
      'Koruma elemanlarını doğru seçmezsen, ekipmanı değil tesisatı yakarsın.\n\n'
      ' Genel yaklaşım:\n'
      '• Motor hatlarında: kontaktör + termik (veya motor koruma şalteri)\n'
      '• PLC/sinyal hatlarında: küçük değerli sigorta/MCB ile bölgesel koruma\n'
      '• Kaçak akım rölesi: can güvenliği için, uygun tip ve değerde seçilmeli\n\n'
      '⚠️ Sigorta büyütmek çözüm değil; yangın riskidir.',
    ),

    MakaleBlok.text(
      '🏷️ 7) ETİKETLEME – NUMARALANDIRMA – DOKÜMANTASYON\n'
      'Etiket yoksa arıza süresi 3 kat uzar.\n\n'
      ' Minimum standart:\n'
      '• Kablo uçları: her iki uçta numara\n'
      '• Klemens: sıra numarası + fonksiyon\n'
      '• Cihaz: K1, F1, Q1, M1, S1 gibi kodlama\n'
      '• Pano kapısında güncel proje/şema bulunmalı\n\n'
      '💡 “Bugün biliyorum” yarın unutulur. Etiket kalır.',
    ),

    MakaleBlok.text(
      '🧪 8) DEVREYE ALMA (COMMISSIONING) CHECKLIST\n'
      'Sistemi enerjiye vermeden önce kısa kontrol listesi hayat kurtarır.\n\n'
      ' Enerji öncesi:\n'
      '• Klemens sıkılığı, PE süreklilik ölçümü\n'
      '• Faz sırası kontrolü (motor yönü)\n'
      '• 24V polarite kontrolü\n'
      '• Sensör çalışma testi (tek tek)\n\n'
      ' Enerji sonrası:\n'
      '• E-Stop testi\n'
      '• Güvenlik kapısı/limit switch testi\n'
      '• Motor akımı ve ısınma kontrolü\n'
      '• PLC giriş/çıkış izleme (monitor)\n',
    ),

    MakaleBlok.image(
      'assets/images/otomasyon1.png',
      aciklama:
          'Örnek: Güç kabloları ile sinyal kablolarının ayrılması ve ekranlama mantığı.\n'
          'Analog/sinyal hatları mümkünse ayrı kanalda taşınmalıdır.',
    ),

    MakaleBlok.text(
      'SONUÇ\n'
      'Otomasyon sisteminde güvenlik; E-Stop + LOTO + doğru topraklama/ekranlama + '
      'düzgün kablolama ve etiketleme ile başlar.\n\n'
      'Bu kurallar hem can güvenliğini artırır hem de arıza bulma süresini ciddi şekilde azaltır.',
    ),
  ],
),
  Makale(
  id: 'o4',
  baslik: 'Ladder Diyagramında Temel Mantık (NO–NC, Bobin, Self Hold, Timer)',
  kategori: 'otomasyon',
  ikonAsset: 'assets/images/otomasyonicon.png',
  icerik:
      'Ladder (Merdiven) diyagramı, klasik röleli kumanda mantığının '
      'PLC üzerinde grafiksel olarak gösterilmesidir.\n\n'
      'Elektrikçiler için ladder diyagramı; kontaktör, röle ve buton '
      'mantığını birebir yansıttığı için en kolay öğrenilen PLC '
      'programlama dilidir.\n\n'
      'Bu makalede ladder diyagramının temel yapısı, kontaklar, bobinler '
      've sahada en sık kullanılan mantıklar adım adım anlatılmaktadır.',
  bloklar: const [

    // Ladder nedir
    MakaleBlok.text(
      '🪜 LADDER DİYAGRAMI NEDİR?\n'
      'Ladder diyagramı, adını merdivene benzeyen yapısından alır.\n\n'
      '• Sol dikey hat: Enerji hattı (faz gibi düşünülür)\n'
      '• Sağ dikey hat: Dönüş hattı (nötr gibi düşünülür)\n'
      '• Yatay çizgiler (rung): Her biri ayrı bir kontrol mantığını temsil eder\n\n'
      'PLC, ladder programını yukarıdan aşağıya ve soldan sağa tarar.',
    ),

    // NO NC
    MakaleBlok.text(
      '🔘 NO ve NC KONTAKLAR (NORMALDE AÇIK / KAPALI)\n'
      'Ladder diyagramında kontaklar, girişlerin durumunu temsil eder.\n\n'
      '• NO (Normally Open – Normalde Açık):\n'
      '  Giriş aktif değilken açık, aktif olunca kapanır.\n\n'
      '• NC (Normally Closed – Normalde Kapalı):\n'
      '  Giriş aktif değilken kapalı, aktif olunca açılır.\n\n'
      'Önemli: PLC’de NO/NC, butonun fiziksel tipi değil; '
      'programdaki mantığı ifade eder.',
    ),

    // Bobin
    MakaleBlok.text(
      '🧲 BOBİN (COIL) NEDİR?\n'
      'Bobin, ladder diyagramında bir çıkışı veya dahili biti temsil eder.\n\n'
      '• Motor kontaktörü\n'
      '• Röle\n'
      '• Lamba\n'
      '• Dahili yardımcı bit (M, Marker)\n\n'
      'Kontaklar true olduğunda bobin enerjilenir.',
    ),

    // Seri paralel
    MakaleBlok.text(
      '🔗 SERİ ve PARALEL MANTIK\n'
      '• Seri bağlanan kontaklar → VE (AND) mantığı\n'
      '• Paralel bağlanan kontaklar → VEYA (OR) mantığı\n\n'
      'Örnek:\n'
      '• Start VE Stop şartı → seri\n'
      '• İki farklı start butonu → paralel\n\n'
      'Bu yapı, röleli kumanda devreleriyle birebir aynıdır.',
    ),

    // Self hold
    MakaleBlok.text(
      '🔁 SELF HOLD (KENDİNİ TUTMA) MANTIĞI\n'
      'Self hold, start butonuna basıldıktan sonra sistemin '
      'çalışmaya devam etmesini sağlar.\n\n'
      'Mantık:\n'
      '• Start butonu NO\n'
      '• Stop butonu NC\n'
      '• Çıkış bobininin NO kontağı paralel bağlanır\n\n'
      'Bu yapı klasik start–stop motor devresinin PLC karşılığıdır.',
    ),

    // Timer
    MakaleBlok.text(
      '⏱️ TIMER (ZAMAN RÖLESİ) BLOKLARI\n'
      'Ladder diyagramında zaman röleleri gecikmeli işlemler için kullanılır.\n\n'
      'En yaygın timer türleri:\n'
      '• TON (On-Delay): Giriş aktif olduktan sonra süre dolunca çıkış verir\n'
      '• TOF (Off-Delay): Giriş pasif olduktan sonra süre dolunca kapanır\n'
      '• TP (Pulse): Belirli süreli darbe üretir\n\n'
      'Fan gecikmesi, motor yumuşak duruşu gibi senaryolarda kullanılır.',
    ),

    // Counter
    MakaleBlok.text(
      '🔢 COUNTER (SAYAÇ) BLOKLARI\n'
      'Counter blokları, giriş darbelerini sayar.\n\n'
      '• CTU (Count Up): Yukarı sayar\n'
      '• CTD (Count Down): Aşağı sayar\n'
      '• Reset girişi ile sıfırlanır\n\n'
      'Konveyör sistemlerinde parça sayma için yaygındır.',
    ),

    // Tarama
    MakaleBlok.text(
      '🔄 PLC TARAMA (SCAN) MANTIĞI\n'
      'PLC çalışma sırası:\n'
      '1️⃣ Girişleri oku\n'
      '2️⃣ Programı çalıştır (ladder tarama)\n'
      '3️⃣ Çıkışları güncelle\n\n'
      'Bu döngü milisaniyeler içinde sürekli tekrar eder.',
    ),

    // Saha hataları
    MakaleBlok.text(
      '⚠️ SAHADA EN SIK YAPILAN HATALAR\n'
      '• Stop butonunu NO yazmak\n'
      '• Self hold kontağını yanlış yere koymak\n'
      '• Aynı bobini birden fazla rung’da kullanmak\n'
      '• Tarama mantığını hesaba katmamak\n\n'
      'Bu hatalar beklenmeyen çalışmalara yol açar.',
    ),

    // Özet
    MakaleBlok.text(
      '✅ HIZLI ÖZET\n'
      '• Ladder, röleli kumandanın PLC karşılığıdır\n'
      '• NO/NC mantıkla çalışır\n'
      '• Seri = AND, Paralel = OR\n'
      '• Self hold en temel motor mantığıdır\n'
      '• Timer ve Counter otomasyonun temel taşlarıdır',
    ),
  ],
),
  Makale(
  id: 'o5',
  baslik: 'Frekans Konvertörü (VFD) Temel Parametreleri',
  kategori: 'otomasyon',
  ikonAsset: 'assets/images/otomasyonicon.png',
  icerik:
      'Frekans konvertörleri (VFD), asenkron motorların hızını '
      'frekans ve gerilimi değiştirerek kontrol etmeyi sağlar.\n\n'
      'Doğru parametre ayarı; motorun verimli, sessiz ve güvenli '
      'çalışması için kritik öneme sahiptir.',
  bloklar: const [

    // Motor plaka
    MakaleBlok.text(
      '🏷️ MOTOR PLAKA BİLGİLERİ (MUTLAKA GİRİLMELİ)\n'
      'VFD devreye alınmadan önce motor etiket bilgileri doğru girilmelidir.\n\n'
      '• Anma gerilimi (V)\n'
      '• Anma akımı (A)\n'
      '• Anma frekansı (Hz)\n'
      '• Motor gücü (kW)\n'
      '• cosφ (güç katsayısı)\n\n'
      'Yanlış plaka bilgisi motorun ısınmasına ve tork kaybına neden olur.',
    ),

    // Frekans sınırları
    MakaleBlok.text(
      '📈 MAKSİMUM ve MİNİMUM FREKANS\n'
      'Motorun çalışacağı hız aralığı bu parametrelerle belirlenir.\n\n'
      '• Minimum frekans: Motorun durmaya yakın çalışacağı hız\n'
      '• Maksimum frekans: Motorun çıkabileceği en yüksek hız\n\n'
      'Genelde:\n'
      '• Min: 5–10 Hz\n'
      '• Max: 50 Hz (özel uygulamalarda 60 Hz)',
    ),

    // Rampa
    MakaleBlok.text(
      '⏱️ HIZLANMA ve YAVAŞLAMA RAMPALARI\n'
      'Rampa süreleri, motorun kalkış ve duruş süresini belirler.\n\n'
      '• Kısa rampa → hızlı tepki ama mekanik zorlanma\n'
      '• Uzun rampa → yumuşak kalkış/duruş\n\n'
      'Fan ve pompa uygulamalarında uzun rampa tercih edilir.',
    ),

    // Start stop
    MakaleBlok.text(
      '▶️ START / STOP KOMUT KAYNAĞI\n'
      'VFD’nin nereden komut alacağı bu parametreyle seçilir.\n\n'
      '• Panel (tuş takımı)\n'
      '• Harici butonlar (dijital giriş)\n'
      '• PLC veya otomasyon sistemi\n\n'
      'Otomasyon sistemlerinde genellikle PLC kontrolü tercih edilir.',
    ),

    // Hız referansı
    MakaleBlok.text(
      '🎚️ HIZ REFERANSI SEÇİMİ\n'
      'Motor hızının nasıl ayarlanacağı bu parametreyle belirlenir.\n\n'
      '• Potansiyometre\n'
      '• 0–10V analog sinyal\n'
      '• 4–20mA analog sinyal\n'
      '• PLC üzerinden haberleşme\n\n'
      '4–20mA sinyal, endüstride daha kararlı çalışır.',
    ),

    // Motor koruma
    MakaleBlok.text(
      '🛡️ MOTOR KORUMA PARAMETRELERİ\n'
      'VFD, motoru aşırı akım ve ısınmaya karşı korur.\n\n'
      '• Motor anma akımı\n'
      '• Termik koruma\n'
      '• Aşırı yük limiti\n\n'
      'Bu değerler doğru ayarlanmazsa motor yanabilir.',
    ),

    // Kontrol modu
    MakaleBlok.text(
      '⚙️ KONTROL MODU (V/f – Vektör)\n'
      '• V/f kontrol:\n'
      '  Basit ve yaygın kullanım\n\n'
      '• Vektör kontrol:\n'
      '  Daha iyi tork ve hassas hız kontrolü\n\n'
      'Fan/pompa için V/f yeterlidir; hassas uygulamalarda vektör tercih edilir.',
    ),

    // Özet
    MakaleBlok.text(
      ' HIZLI ÖZET\n'
      '• Motor plaka bilgileri doğru girilmeli\n'
      '• Frekans ve rampa sınırları uygulamaya göre seçilmeli\n'
      '• Start/stop ve hız referansı net belirlenmeli\n'
      '• Motor koruma parametreleri ihmal edilmemeli',
    ),
  ],
),
  Makale(
  id: 'o6',
  baslik: 'Ladder Diyagramında Zaman Röleleri (Timer)',
  kategori: 'otomasyon',
  ikonAsset: 'assets/images/otomasyonicon.png',
  icerik:
      'PLC programlarında zaman röleleri (Timer), bir işlemin '
      'belirli bir süre sonra veya gecikmeli olarak gerçekleşmesini sağlar.\n\n'
      'Motor, fan, pompa ve otomasyon senaryolarında gecikmeli çalıştırma '
      've durdurma için sıkça kullanılır.',
  bloklar: const [

    // Timer nedir
    MakaleBlok.text(
      '⏱️ TIMER (ZAMAN RÖLESİ) NEDİR?\n'
      'Timer, bir giriş aktif veya pasif olduktan sonra '
      'önceden ayarlanan süre dolunca çıkış üreten fonksiyon bloğudur.\n\n'
      'Röleli kumanda devrelerindeki zaman rölelerinin PLC karşılığıdır.',
    ),

    // TON
    MakaleBlok.text(
      '▶️ TON – ON DELAY (GECİKMELİ ÇEKME)\n'
      'TON timer, giriş aktif olduktan sonra '
      'ayarlanan süre dolunca çıkışı aktif eder.\n\n'
      'Kullanım örnekleri:\n'
      '• Motoru gecikmeli çalıştırma\n'
      '• Fanı geç devreye alma\n'
      '• Yumuşak sistem başlatma\n\n'
      'Giriş pasif olursa süre sıfırlanır.',
    ),

    // TOF
    MakaleBlok.text(
      '⏹️ TOF – OFF DELAY (GECİKMELİ BIRAKMA)\n'
      'TOF timer, giriş pasif olduktan sonra '
      'ayarlanan süre boyunca çıkışı aktif tutar.\n\n'
      'Kullanım örnekleri:\n'
      '• Fanın geç durması\n'
      '• Motor stop sonrası soğutma\n'
      '• Aydınlatma gecikmeli kapanma',
    ),

    // TP
    MakaleBlok.text(
      '🔔 TP – PULSE TIMER (DARBELİ ZAMANLAYICI)\n'
      'TP timer, giriş aktif olduğunda '
      'belirlenen süre boyunca darbe üretir.\n\n'
      'Kullanım örnekleri:\n'
      '• Uyarı lambası yakma\n'
      '• Kısa süreli çıkış tetikleme\n'
      '• Reset sinyali üretme',
    ),

    // Parametreler
    MakaleBlok.text(
      '⚙️ TIMER PARAMETRELERİ\n'
      '• PT (Preset Time): Ayarlanan süre\n'
      '• ET (Elapsed Time): Geçen süre\n'
      '• Q: Timer çıkışı\n\n'
      'Zaman birimi genellikle ms, s veya dk olarak seçilir.',
    ),

    // Saha hataları
    MakaleBlok.text(
      '⚠️ SAHADA SIK YAPILAN HATALAR\n'
      '• Zaman birimini yanlış seçmek\n'
      '• Aynı timerı birden fazla rung’da kullanmak\n'
      '• Giriş sinyalinin kararsız olması\n\n'
      'Timer girişleri mümkünse sabit ve temiz sinyallerden alınmalıdır.',
    ),

    // Özet
    MakaleBlok.text(
      '✅ HIZLI ÖZET\n'
      '• TON → Gecikmeli çalıştırma\n'
      '• TOF → Gecikmeli durdurma\n'
      '• TP → Süreli darbe\n'
      '• Timer’lar otomasyonda zaman kontrolünün temelidir',
    ),
  ],
),
  Makale(
  id: 'o7',
  baslik: 'Sayma (Counter) Blokları ile Parça Sayma',
  kategori: 'otomasyon',
  ikonAsset: 'assets/images/otomasyonicon.png',
  icerik:
      'Counter (sayma) blokları, PLC sistemlerinde giriş darbelerini sayarak '
      'belirli bir değere ulaşıldığında çıkış üretir. Üretim hatlarında adet takibi, '
      'paketleme kontrolü ve proses yönetimi için vazgeçilmezdir.\n\n'
      'Bu makalede CTU, CTD ve Reset mantığı; kullanım örnekleri ve sahada dikkat edilmesi '
      'gereken noktalar bloklar halinde anlatılmaktadır.',
  bloklar: const [

    // Counter nedir
    MakaleBlok.text(
      '🔢 COUNTER (SAYAÇ) BLOKLARI NEDİR?\n'
      'Counter blokları, PLC’ye gelen her darbe (pulse) sinyalini sayar.\n\n'
      'Kullanım amaçları:\n'
      '• Ürün/adet sayma\n'
      '• Batch (parti) kontrolü\n'
      '• Belirli sayıya gelince durdurma/alarmlama\n\n'
      'Not: Sayaç girişine gelen sinyal “temiz” olmalıdır. Zıplayan kontak (bounce) hatalı sayım yapar.',
    ),

    // CTU
    MakaleBlok.text(
      '⬆️ CTU (COUNT UP) – YUKARI SAYICI\n'
      'CTU bloğu, girişine gelen her darbe ile sayacı 1 artırır.\n\n'
      'Genel mantık:\n'
      '• CU (Count Up): Darbe geldikçe +1\n'
      '• PV (Preset Value): Hedef değer\n'
      '• CV (Current Value): Anlık sayaç değeri\n'
      '• Q: CV ≥ PV olduğunda aktif olur\n\n'
      'Kullanım örnekleri:\n'
      '• Konveyör bantta ürün sayma\n'
      '• Paketleme makinelerinde adet kontrolü\n'
      '• 100 adet olunca bant durdurma',
    ),

    // CTD
    MakaleBlok.text(
      '⬇️ CTD (COUNT DOWN) – AŞAĞI SAYICI\n'
      'CTD bloğu, başlangıçta verilen bir değerden geriye doğru sayar.\n\n'
      'Genel mantık:\n'
      '• CD (Count Down): Darbe geldikçe -1\n'
      '• PV (Preset Value): Başlangıç/ayarlı değer\n'
      '• CV (Current Value): Anlık kalan değer\n'
      '• Q: CV = 0 olduğunda (veya eşik değerine indiğinde) aktif olur\n\n'
      'Kullanım örnekleri:\n'
      '• Kalan parça sayısını takip etme\n'
      '• Stok/batch (parti) kontrolü\n'
      '• Sayaç sıfırlanınca alarm verme',
    ),

    // Reset
    MakaleBlok.text(
      '♻️ RESET (SIFIRLAMA) GİRİŞİ\n'
      'CTU ve CTD bloklarında bulunan reset girişi, sayaç değerini sıfırlamak '
      've sistemi yeni sayım döngüsüne hazırlamak için kullanılır.\n\n'
      'Sahada doğru kullanım:\n'
      '• Üretim başlangıcında reset ver\n'
      '• Batch değişiminde reset ver\n'
      '• Operatör panelinden “sıfırla” butonu ile reset ver\n\n'
      'Not: Reset sinyali kısa ve net olmalı (tek darbe). Sürekli reset aktif kalırsa sayaç ilerlemez.',
    ),

    // Saha notları
    MakaleBlok.text(
      '⚠️ SAHADA SIK YAPILAN HATALAR\n'
      '• Sensör sinyalinde seğirme/bounce yüzünden çift sayım\n'
      '• Çok hızlı darbeyi normal dijital girişten saymaya çalışmak (HSC gerekir)\n'
      '• Reset’i yanlış zamanda verip sayımı bozmak\n'
      '• PV/CV mantığını karıştırmak\n\n'
      '💡 İpucu:\n'
      'Hızlı sayım (encoder vb.) gerekiyorsa HSC kullan; normal DI kaçırabilir.',
    ),

    // Özet
    MakaleBlok.text(
      '✅ HIZLI ÖZET\n'
      '• CTU → Darbe geldikçe artırır, hedefe gelince Q aktif\n'
      '• CTD → Darbe geldikçe azaltır, sıfıra inince Q aktif\n'
      '• Reset → Sayacı sıfırlar / yeni döngü başlatır\n'
      '• Temiz sinyal ve doğru giriş seçimi (gerekirse HSC) şart',
    ),
  ],
),
  Makale(
  id: 'o8',
  baslik: 'Frekans Konvertörü Parametrelerine Giriş',
  kategori: 'otomasyon',
  ikonAsset: 'assets/images/otomasyonicon.png',
  icerik:
      'Frekans konvertörlerinde temel parametreler; motor plaka verileri, hız sınırları, rampa süreleri ve kontrol modu (V/f, vektör kontrol) olarak öne çıkar. '
      'Yanlış parametre, motor ısınması ve tork kaybına neden olabilir.',
  bloklar: const [
    MakaleBlok.text(
      '🎯 AMAÇ\n'
      'Bu makale, VFD parametrelerine hızlı bir giriş yapar ve hangi başlıkların kritik olduğunu özetler.',
    ),
    MakaleBlok.text(
      '✅ ÖNE ÇIKANLAR\n'
      '• Motor plaka verileri\n'
      '• Min/Max frekans\n'
      '• Rampa süreleri\n'
      '• Kontrol modu (V/f – vektör)\n'
      '• Koruma parametreleri',
    ),
  ],
),
];

class AnaSayfa extends StatefulWidget {
  final VoidCallback toggleTheme;
  const AnaSayfa({super.key, required this.toggleTheme});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  final sayfaBasligi = '';

  void _ara() {
    showSearch(context: context, delegate: MakaleArama(tumMakaleler));
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(      
        appBar: AppBar(
          title: Text(sayfaBasligi),
          actions: [
            IconButton(onPressed: _ara, icon: const Icon(Icons.search)),
            IconButton(
              icon: const Icon(Icons.calculate),
              onPressed: () => openOhmCalculator(context),
            ),
            IconButton(
              icon: const Icon(Icons.bolt),
              onPressed: () => openPowerCalculator(context),
            ),
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () => openResistorColorCalc(context),
            ),
            IconButton(
              icon: const Icon(Icons.dark_mode),
              onPressed: widget.toggleTheme,
            ),
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => openHistoryPanel(context),           
            ),
          ],
        ),
        drawer: const _YanMenu(),
        body: SafeArea(
         top: false,    // AppBar zaten üstü hallediyor
         bottom: true,  // iPhone home indicator için
         child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Card(
              elevation: 0,
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 220,
                      child: Image.asset(
                        'assets/images/lego12.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.bolt, size: 70),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Visibility(
                      visible: false,
                      child: Text(
                        'Elektrik • Elektronik • Otomasyon',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            _KategoriButonu(
              etiket: ' Elektrik',
              renk: Color(0xFF2C3E50),
              sayfa: const KategoriSayfasi(kategori: 'elektrik', baslik: 'Elektrik'),
            ),
            _KategoriButonu(
              etiket: ' Elektronik',
              renk: Color(0xFF2C3E50),
              sayfa: const KategoriSayfasi(kategori: 'elektronik', baslik: 'Elektronik'),
            ),
            _KategoriButonu(
              etiket: ' Otomasyon',
              renk: Color(0xFF2C3E50),
              sayfa: const KategoriSayfasi(kategori: 'otomasyon', baslik: 'Otomasyon'),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _KategoriButonu(
                    etiket: '🔢 Hesaplamalar',
                    renk: Color(0xFF2C3E50),
                    sayfa: const HesaplamalarSayfasi(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _KategoriButonu(
                    etiket: '📝 Quiz',
                    renk: Color(0xFF2C3E50),
                    sayfa: const QuizSayfasi(),
                  ),
                ),                
              ],
            ),
              const SizedBox(height: 12),
                                        
              _KategoriButonu(
                  etiket: '⚠️ Arıza Teşhis',
                  renk: const Color(0xFFC62828),
                  sayfa: const ArizaTeshiAnaSayfa(),                 
               ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade100
                    : const Color(0xFF1E252D),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const AdBanner(),
              ),
            ),
            // ------------------------------

            const SizedBox(height: 16),
          ],
          ),
        ),
      );
   }
}
class _KategoriButonu extends StatelessWidget {
  final String etiket;
  final Color renk;
  final Widget sayfa;

  const _KategoriButonu({
    super.key,
    required this.etiket,
    required this.renk,
    required this.sayfa,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: renk,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => sayfa),
        ),
        child: Text(
          etiket,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class KategoriSayfasi extends StatelessWidget {
  final String kategori;
  final String baslik;

  const KategoriSayfasi({super.key, required this.kategori, required this.baslik});

  @override
  Widget build(BuildContext context) {
    final liste =
        tumMakaleler.where((m) => m.kategori == kategori).toList(growable: false);

    return Scaffold(
      appBar: AppBar(title: Text(baslik)),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemBuilder: (ctx, i) {
          final m = liste[i];
          return ListTile(
            tileColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: SizedBox(
              width: 54,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: m.ikonAsset != null
        ? Image.asset(
            m.ikonAsset!,
            fit: BoxFit.contain, // küçük ikonlar için daha iyi
            errorBuilder: (_, __, ___) => const Icon(Icons.article_outlined),
          )
        : (m.resim != null
            ? Image.asset(
                m.resim!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.article_outlined),
              )
            : const Icon(Icons.article_outlined)),
              ),
            ),
            title: Text(
              m.baslik,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              m.icerik.length > 110 ? '${m.icerik.substring(0, 110)}…' : m.icerik,
              maxLines: 2,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MakaleDetay(m: m)),
            ),
          );
        },
        separatorBuilder: (context, _) => const SizedBox(height: 10),
        itemCount: liste.length,
        ),
    );
  }
}     

class MakaleDetay extends StatelessWidget {
  final Makale m;

  const MakaleDetay({super.key, required this.m});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(m.baslik)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          // 🔼 ÜST RESİM
          if (m.resim != null && !m.resimAltta) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: TiklaZoomResim(
                assetPath: m.resim!,
                aciklama: m.baslik,
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 🔤 BAŞLIK
          Text(
            m.baslik,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),

          // 🟨 ORTA RESİM
          if (m.resimOrta != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: TiklaZoomResim(
                assetPath: m.resimOrta!,
                aciklama: 'Detay görsel',
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 📄 İÇERİK
          Text(
            m.icerik,
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
          ),

          // ✅ İÇERİK ALTINA BLOKLAR (resim / yazı / resim / ...)
          ..._buildBloklar(context, m),

          // 🔽 ALT RESİM
          if (m.resim != null && m.resimAltta) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: TiklaZoomResim(
                assetPath: m.resim!,
                aciklama: m.baslik,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildBloklar(BuildContext context, Makale m) {
    if (m.bloklar.isEmpty) return const <Widget>[];

    final out = <Widget>[];
    out.add(const SizedBox(height: 16));

    for (final b in m.bloklar) {
      if (b.tip == MakaleBlokTip.text) {
        out.add(
          Text(
            b.veri,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
        );
        out.add(const SizedBox(height: 12));
      } else {
        out.add(
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: TiklaZoomResim(
              assetPath: b.veri,
              aciklama: b.aciklama ?? 'Görsel',
            ),
          ),
        );

        if ((b.aciklama ?? '').trim().isNotEmpty) {
          out.add(const SizedBox(height: 8));
          out.add(
            Text(
              b.aciklama!,
              style: TextStyle(
                fontSize: 13,
                height: 1.3,
                color: Colors.grey.shade600,
              ),
            ),
          );
        }

        out.add(const SizedBox(height: 16));
      }
    }

    return out;
  }
}
/// Arama
class MakaleArama extends SearchDelegate {
  final List<Makale> kaynak;
  MakaleArama(this.kaynak);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final q = query.toLowerCase().trim();
    final sonuclar = kaynak.where((m) =>
      m.baslik.toLowerCase().contains(q) || m.icerik.toLowerCase().contains(q));
    return ListView(
      children: sonuclar.map((m) => ListTile(
        title: Text(m.baslik),
        subtitle: Text(
          m.icerik.length > 90 ? '${m.icerik.substring(0, 90)}…' : m.icerik,
        ),
        onTap: () {
          close(context, null);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MakaleDetay(m: m)),
          );
        },
      )).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}

 /// Yan menü
 class _YanMenu extends StatelessWidget {
  const _YanMenu();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/logo.jpg'),
              ),
              title: const Text('Elektrik Elektronik Rehberi'),
              subtitle: const Text(''),
            ),
            const Divider(),
            ListTile(
             leading: const Icon(Icons.info_outline),
             title: const Text('Hakkında'),
             onTap: () {
              Navigator.pop(context);
              Navigator.push(
                 context,
                 MaterialPageRoute(builder: (_) => const HakkindaSayfasi()),
               );
              },
            ),
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text('İletişim / BYRK Elektrik'),
              subtitle: const Text('Telefon, WhatsApp, E-posta'),
              onTap: () {
                Navigator.pop(context); // çekmeceyi kapat
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IletisimSayfasi()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Gizlilik Politikası'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GizlilikSayfasi()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
       
     
                  
               
             
           
          
        
                                  
// Tek dosyalık Ohm Kanunu hesaplayıcı: showModalBottomSheet + StatefulBuilder
void openOhmCalculator(BuildContext context) {
  final vCtrl = TextEditingController(); // Volt
  final iCtrl = TextEditingController(); // Amper
  final rCtrl = TextEditingController(); // Ohm

  String secim = 'I (Akım)'; // Hesaplanacak büyüklük
  String? sonuc;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          bool hesaplananI = secim == 'I (Akım)';
          bool hesaplananV = secim == 'V (Gerilim)';
          bool hesaplananR = secim == 'R (Direnç)';

          void hesapla() {
            double? V = double.tryParse(vCtrl.text.replaceAll(',', '.'));
            double? I = double.tryParse(iCtrl.text.replaceAll(',', '.'));
            double? R = double.tryParse(rCtrl.text.replaceAll(',', '.'));

            String hata(String m) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
              return m;
            }

            switch (secim) {
              case 'I (Akım)': // I = V / R
                if (V == null || R == null) { setState(() => sonuc = hata('V (Volt) ve R (Ohm) gir')); return; }
                if (R == 0) { setState(() => sonuc = hata('R sıfır olamaz')); return; }
                final i = V / R; setState(() => sonuc = 'I = ${i.toStringAsFixed(3)} A'); 
                if (sonuc != null) hesapGecmisi.add('Ohm: $sonuc'); // 
                break;

              case 'V (Gerilim)': // V = I * R
                if (I == null || R == null) { setState(() => sonuc = hata('I (Amper) ve R (Ohm) gir')); return; }
                final v = I * R; setState(() => sonuc = 'V = ${v.toStringAsFixed(3)} V'); 
                if (sonuc != null) hesapGecmisi.add('Ohm: $sonuc'); // 
                break;

              case 'R (Direnç)': // R = V / I
                if (V == null || I == null) { setState(() => sonuc = hata('V (Volt) ve I (Amper) gir')); return; }
                if (I == 0) { setState(() => sonuc = hata('I sıfır olamaz')); return; }
                final r = V / I; setState(() => sonuc = 'R = ${r.toStringAsFixed(3)} Ω'); 
                if (sonuc != null) hesapGecmisi.add('Ohm: $sonuc'); // 
                break;
            }
          }

          return Padding(
            padding: EdgeInsets.only(
              left: 16, right: 16, top: 12,
              bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 4, width: 48, margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(2))),
                const Text('Ohm Kanunu Hesaplayıcı', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Text('Hesapla:'),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: secim,
                      items: const [
                        DropdownMenuItem(value: 'I (Akım)', child: Text('I (Akım)')),
                        DropdownMenuItem(value: 'V (Gerilim)', child: Text('V (Gerilim)')),
                        DropdownMenuItem(value: 'R (Direnç)', child: Text('R (Direnç)')),
                      ],
                      onChanged: (v) { setState(() { secim = v!; sonuc = null; }); },
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                TextField(
                 controller: vCtrl,
                 keyboardType: const TextInputType.numberWithOptions(decimal: true),
                 inputFormatters: [
                   FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                enabled: !hesaplananV,
                decoration: InputDecoration(
                 labelText: 'Gerilim (V)',
                 hintText: 'Örn: 12',
                 border: const OutlineInputBorder(),
                 suffixText: 'V',
                 fillColor: hesaplananV
                     ? Theme.of(context).colorScheme.surfaceContainerHighest
                     : null,
                     filled: hesaplananV, 
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                 controller: iCtrl,
                 keyboardType: const TextInputType.numberWithOptions(decimal: true),
                 inputFormatters: [
                   FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                 ],
                 enabled: !hesaplananI,
                 decoration: InputDecoration(
                  labelText: 'Akım (I)',
                  hintText: 'Örn: 2',
                  border: const OutlineInputBorder(),
                  suffixText: 'A',
                  fillColor: hesaplananI
                      ? Theme.of(context).colorScheme.surfaceContainerHighest
                      : null,
                      filled: hesaplananI,
                  ),
                ),
                const SizedBox(height: 10),
TextField(
  controller: rCtrl,
  keyboardType: const TextInputType.numberWithOptions(decimal: true),
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
  ],
  enabled: !hesaplananR,
  decoration: InputDecoration(
    labelText: 'Direnç (R)',
    hintText: 'Örn: 6',
    border: const OutlineInputBorder(),
    suffixText: 'Ω',
    fillColor: hesaplananR
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : null,
    filled: hesaplananR,
                  ),
                ),

                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: hesapla,
                        icon: const Icon(Icons.calculate),
                        label: const Text('Hesapla'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () { vCtrl.clear(); iCtrl.clear(); rCtrl.clear(); setState(() => sonuc = null); },
                      icon: const Icon(Icons.refresh), label: const Text('Temizle'),
                    ),
                  ],
                ),

                if (sonuc != null) ...[
                  const SizedBox(height: 12),
                  Card(
                    color: Theme.of(context).colorScheme.surface, elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(sonuc!, style: Theme.of(context).textTheme.bodyLarge!.copyWith( fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      );
    },
  );
}
void openPowerCalculator(BuildContext context) {
  final vCtrl = TextEditingController(); // Volt
  final iCtrl = TextEditingController(); // Amper
  final pCtrl = TextEditingController(); // Watt

  String secim = 'P (Güç)'; // hesaplanacak
  String? sonuc;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          final hesaplananP = secim == 'P (Güç)';
          final hesaplananV = secim == 'V (Gerilim)';
          final hesaplananI = secim == 'I (Akım)';

          void hesapla() {
            final V = double.tryParse(vCtrl.text.replaceAll(',', '.'));
            final I = double.tryParse(iCtrl.text.replaceAll(',', '.'));
            final P = double.tryParse(pCtrl.text.replaceAll(',', '.'));

            String hata(String m) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
              return m;
            }

            switch (secim) {
              case 'P (Güç)': // P = V * I
                if (V == null || I == null) { setState(() => sonuc = hata('V ve I gir')); return; }
                final p = V * I;
                setState(() => sonuc = 'P = ${p.toStringAsFixed(3)} W');
                if (sonuc != null) hesapGecmisi.add('P: V=$V V, I=$I A → ${p.toStringAsFixed(3)} W');
                break;
              case 'V (Gerilim)': // V = P / I
                if (P == null || I == null) { setState(() => sonuc = hata('P ve I gir')); return; }
                if (I == 0) { setState(() => sonuc = hata('I sıfır olamaz')); return; }
                final v = P / I;
                setState(() => sonuc = 'V = ${v.toStringAsFixed(3)} V');
                if (sonuc != null) hesapGecmisi.add('V: P=$P W, I=$I A → ${v.toStringAsFixed(3)} V');
                break;
              case 'I (Akım)': // I = P / V
                if (P == null || V == null) { setState(() => sonuc = hata('P ve V gir')); return; }
                if (V == 0) { setState(() => sonuc = hata('V sıfır olamaz')); return; }
                final i = P / V;
                setState(() => sonuc = 'I = ${i.toStringAsFixed(3)} A');
                if (sonuc != null) hesapGecmisi.add('I: P=$P W, V=$V V → ${i.toStringAsFixed(3)} A');
                break;
            }
          }

          return Padding(
            padding: EdgeInsets.only(
              left: 16, right: 16, top: 12,
              bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 4, width: 48, margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(2))),
                const Text('Güç Hesaplayıcı (P, V, I)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Text('Hesapla:'),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: secim,
                      items: const [
                        DropdownMenuItem(value: 'P (Güç)', child: Text('P (Güç)')),
                        DropdownMenuItem(value: 'V (Gerilim)', child: Text('V (Gerilim)')),
                        DropdownMenuItem(value: 'I (Akım)', child: Text('I (Akım)')),
                      ],
                      onChanged: (v) => setState(() { secim = v!; sonuc = null; }),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
TextField(
  controller: vCtrl,
  keyboardType: const TextInputType.numberWithOptions(decimal: true),
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
  ],
  enabled: !hesaplananV,
  decoration: InputDecoration(
    labelText: 'Gerilim (V)',
    hintText: 'Örn: 230',
    border: const OutlineInputBorder(),
    suffixText: 'V',
    fillColor: hesaplananV
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : null,
    filled: hesaplananV,
                  ),
                ),
                const SizedBox(height: 10),
TextField(
  controller: iCtrl,
  keyboardType: const TextInputType.numberWithOptions(decimal: true),
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
  ],
  enabled: !hesaplananI,
  decoration: InputDecoration(
    labelText: 'Akım (I)',
    hintText: 'Örn: 2',
    border: const OutlineInputBorder(),
    suffixText: 'A',
    fillColor: hesaplananI
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : null,
    filled: hesaplananI,
                  ),
                ),
                const SizedBox(height: 10),
TextField(
  controller: pCtrl,
  keyboardType: const TextInputType.numberWithOptions(decimal: true),
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
  ],
  enabled: !hesaplananP,
  decoration: InputDecoration(
    labelText: 'Güç (P)',
    hintText: 'Örn: 460',
    border: const OutlineInputBorder(),
    suffixText: 'W',
    fillColor: hesaplananP
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : null,
    filled: hesaplananP,
                ),
              ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: hesapla,
                        icon: const Icon(Icons.bolt),
                        label: const Text('Hesapla'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () { vCtrl.clear(); iCtrl.clear(); pCtrl.clear(); setState(() => sonuc = null); },
                      icon: const Icon(Icons.refresh), label: const Text('Temizle'),
                    ),
                  ],
                ),

                if (sonuc != null) ...[
                  const SizedBox(height: 12),
                  Card(
                    color: Theme.of(context).colorScheme.surface, elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(sonuc!, style: Theme.of(context).textTheme.bodyLarge!.copyWith( fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      );
    },
  );
}
void openResistorColorCalc(BuildContext context) {
  const renkler = ['Siyah','Kahverengi','Kırmızı','Turuncu','Sarı','Yeşil','Mavi','Mor','Gri','Beyaz'];
  const toleranslar = {
    'Kahverengi': 1.0, 'Kırmızı': 2.0, 'Yeşil': 0.5, 'Mavi': 0.25,
    'Mor': 0.1, 'Gri': 0.05, 'Altın': 5.0, 'Gümüş': 10.0
  };
  final multiplierMap = <String, double>{
    'Siyah': 1,
    'Kahverengi': 10,
    'Kırmızı': 100,
    'Turuncu': 1e3,
    'Sarı': 10e3,
    'Yeşil': 100e3,
    'Mavi': 1e6,
    'Mor': 10e6,
    'Gri': 100e6,
    'Beyaz': 1e9,
    'Altın': 0.1,
    'Gümüş': 0.01,
  };

  String b1 = 'Kahverengi'; // 1. hane (0 olamaz) — 1 default
  String b2 = 'Siyah';      // 2. hane — 0 default
  String b3 = 'Kırmızı';    // çarpan — x100 default
  String tol = 'Altın';     // ±5% default
  String? sonuc;

  double _hanedenSayi(String r) => renkler.indexOf(r).toDouble();

  String _formatOhm(double r) {
    if (r >= 1e9) return '${(r/1e9).toStringAsFixed(3)} GΩ';
    if (r >= 1e6) return '${(r/1e6).toStringAsFixed(3)} MΩ';
    if (r >= 1e3) return '${(r/1e3).toStringAsFixed(3)} kΩ';
    return '${r.toStringAsFixed(3)} Ω';
  }

  void hesapla() {
    final d1 = _hanedenSayi(b1); // 1..9
    final d2 = _hanedenSayi(b2); // 0..9
    final mul = multiplierMap[b3] ?? 1;
    final t  = toleranslar[tol] ?? 5.0;

    final temel = (d1 * 10 + d2) * mul;
    sonuc = 'R = ${_formatOhm(temel)}  ±${t.toStringAsFixed(2)}%';
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16, right: 16, top: 12,
              bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 4, width: 48, margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(2))),
                const Text('Direnç Renk Kodu (4 Bant)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),

                Row(children: [
                  const Text('1. Bant'), const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: b1,
                    items: renkler.where((r)=>r!='Siyah').map((r)=>DropdownMenuItem(value:r, child: Text(r))).toList(),
                    onChanged: (v) => setState(()=> b1 = v!),
                  ),
                ]),
                Row(children: [
                  const Text('2. Bant'), const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: b2,
                    items: renkler.map((r)=>DropdownMenuItem(value:r, child: Text(r))).toList(),
                    onChanged: (v) => setState(()=> b2 = v!),
                  ),
                ]),
                Row(children: [
                  const Text('Çarpan'), const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: b3,
                    items: (multiplierMap.keys).map((r)=>DropdownMenuItem(value:r, child: Text(r))).toList(),
                    onChanged: (v) => setState(()=> b3 = v!),
                  ),
                ]),
                Row(children: [
                  const Text('Tolerans'), const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: tol,
                    items: (toleranslar.keys).map((r)=>DropdownMenuItem(value:r, child: Text(r))).toList(),
                    onChanged: (v) => setState(()=> tol = v!),
                  ),
                ]),

                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () { setState(hesapla); if (sonuc!=null) hesapGecmisi.add('Renk: $b1-$b2-$b3 / Tol: $tol → $sonuc'); },
                  icon: const Icon(Icons.palette),
                  label: const Text('Hesapla'),
                ),

                if (sonuc != null) ...[
                  const SizedBox(height: 12),
                  Card(
                    color: Theme.of(context).colorScheme.surface, elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(sonuc!, style: Theme.of(context).textTheme.bodyLarge!.copyWith( fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      );
    },
  );
}
void openHistoryPanel(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      if (hesapGecmisi.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(24),
          child: Text('Henüz hesap geçmişi yok.'),
        );
      }
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.history),
          title: Text(hesapGecmisi[i]),
        ),
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemCount: hesapGecmisi.length,
      );
    },
  );
}
void openVoltageDropCalculator(BuildContext context) {
  final iCtrl = TextEditingController();
  final lCtrl = TextEditingController();
  final sCtrl = TextEditingController();

  String? sonuc;
  const double roCu = 0.018;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          void hesapla() {
            final I = double.tryParse(iCtrl.text.replaceAll(',', '.'));
            final L = double.tryParse(lCtrl.text.replaceAll(',', '.'));
            final S = double.tryParse(sCtrl.text.replaceAll(',', '.'));

            if (I == null || L == null || S == null) {
              setState(() => sonuc = 'Lütfen tüm alanları doldurun.');
              return;
            }

            final deltaV = 2 * I * L * roCu / S;
            final percent = (deltaV / 230.0) * 100.0;

            setState(() {
              sonuc =
                  'ΔV ≈ ${deltaV.toStringAsFixed(2)} V (${percent.toStringAsFixed(2)} %)';
            });

            hesapGecmisi.add(
                'Gerilim düşümü → I=$I A, L=$L m, S=$S mm² = $sonuc');
          }

          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Gerilim Düşümü Hesaplayıcı',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: iCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Akım (A)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: lCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Hat uzunluğu (m)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: sCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Kablo kesiti (mm²)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: hesapla,
                  child: const Text('Hesapla'),
                ),
                if (sonuc != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    sonuc!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              ],
            ),
          );
        },
      );
    },
  );
}
class IletisimSayfasi extends StatelessWidget {
  const IletisimSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('İletişim')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: const [
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Telefon'),
            subtitle: Text('+90 545 506 73 68'),
          ),
          ListTile(
            leading: Icon(Icons.chat_bubble_outline),
            title: Text('WhatsApp'),
            subtitle: Text('+90 545 506 73 68'),
          ),
          ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text('E-posta'),
            subtitle: Text('emirbayrak001@gmail.com'),
          ),
          ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text('Adres'),
            subtitle: Text('İstanbul / Türkiye'),
          ),
          SizedBox(height: 24),
          Center(
            child: Text(
              '⚡ Elektrik-Elektronik Arızaları İçin Ulaşım Sağlayabilirsiniz ⚡',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
