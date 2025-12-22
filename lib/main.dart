import 'package:flutter/material.dart';
import 'pages/hesaplayici_sayfasi.dart';
import 'pages/hakkinda_sayfasi.dart';
import 'pages/gizlilik_sayfasi.dart';
import 'pages/hesaplamalar_sayfasi.dart';
import 'pages/quiz_sayfasi.dart';
import 'package:flutter/services.dart';
import 'pages/ariza_teshis/ariza_teshis_ana_sayfa.dart';
import 'pages/destek_ol_sayfasi.dart';


final List<String> hesapGecmisi = [];

void main() {
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
            colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
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
                        'assets/logo.png',
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
    baslik: 'Sigorta (MCB) Türleri ve Ev Tesisatında Kullanım Alanları',
    icerik:
        'Sigorta (MCB – Miniature Circuit Breaker), elektrik tesisatlarında hatları aşırı akım ve kısa devreye karşı korumak için kullanılır. Doğru sigorta seçimi hem güvenlik hem de tesisatın sağlıklı çalışması açısından kritik öneme sahiptir.\n\n'
        '🔹 SİGORTA EĞRİLERİ (B – C – D)\n\n'
        '• B Tipi Sigorta:\n'
        '  Anma akımının yaklaşık 3–5 katında açma yapar. Ani kalkış akımı düşük olan rezistif yükler için uygundur. Aydınlatma hatları ve küçük ev içi devrelerde tercih edilir.\n\n'
        '• C Tipi Sigorta:\n'
        '  Anma akımının yaklaşık 5–10 katında açma yapar. Motorlu ve karışık yükler için idealdir. Konutlarda ve iş yerlerinde en yaygın kullanılan sigorta tipidir.\n\n'
        '• D Tipi Sigorta:\n'
        '  Anma akımının yaklaşık 10–20 katında açma yapar. Yüksek ilk kalkış akımı çeken sanayi motorları, kompresörler ve ağır makineler için kullanılır. Ev tesisatlarında genellikle kullanılmaz.\n\n'
        '🔹 EV VE TESİSAT HATLARINDA YAYGIN SİGORTA DEĞERLERİ\n\n'
        '• Aydınlatma Hattı:\n'
        '  Genellikle B10 A veya C10 A sigorta kullanılır. LED ve klasik aydınlatma armatürleri için yeterlidir.\n\n'
        '• Priz Hatları:\n'
        '  Standart priz hatlarında C16 A sigorta tercih edilir. Elektrikli süpürge, ütü, mikrodalga gibi cihazlar için uygundur.\n\n'
        '• Mutfak Priz Hattı:\n'
        '  Yükün fazla olduğu mutfaklarda C16 A veya ayrı hat çekilmişse C20 A sigorta kullanılır.\n\n'
        '• Çamaşır Makinesi / Bulaşık Makinesi:\n'
        '  Ayrı hat çekilmesi önerilir. Genellikle C16 A sigorta kullanılır.\n\n'
        '• Fırın ve Ocak Hatları:\n'
        '  Elektrik gücüne bağlı olarak C20 A veya C25 A sigorta tercih edilir.\n\n'
        '• Klima Hattı:\n'
        '  Küçük klimalar için C16 A, daha yüksek kapasiteli klimalar için C20 A veya C25 A kullanılır.\n\n'
        '• Kombi Hattı:\n'
        '  Genellikle B10 A veya C10 A sigorta yeterlidir.\n\n'
        '🔹 ÖNEMLİ NOTLAR\n\n'
        '• Sigorta amperi, kablo kesiti ile uyumlu olmalıdır.\n'
        '• Sigorta büyütmek tesisatı korumaz, aksine yangın riskini artırır.\n'
        '• Konutlarda genellikle C tipi sigortalar tercih edilir.\n'
        '• Kısa devre kırma kapasitesi (6 kA – 10 kA gibi) tesisat tipine göre seçilmelidir.\n\n'
        'Doğru sigorta seçimi, elektrik tesisatının güvenli, verimli ve uzun ömürlü olmasını sağlar.',
    kategori: 'elektrik',
    resim: 'assets/images/kablokesit.png',
    resimAltta: false,
    resimOrta: 'assets/images/kablo1.png',
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
  baslik: 'Multimetre ile Ölçüm',
  icerik:
      'Multimetre ile Ölçüm Nedir?\n\n'
      'Multimetre, elektriksel büyüklükleri (gerilim, akım ve direnç) ölçmek için kullanılan çok amaçlı bir ölçü aletidir. '
      'Hem dijital hem analog tipleri bulunur. Elektrik devrelerinde arıza tespiti, komponent kontrolü ve sistem doğrulaması için vazgeçilmezdir.\n\n'
      'Pil Gerilimi (DC Voltaj) Ölçümü\n\n'
      '🔹 Multimetre kadranını "DC V" (⎓) sembolü olan bölgeye getir. Genellikle 2 V veya 20 V aralığı seçilir.\n'
      '🔹 Siyah probu COM girişine, kırmızı probu VΩmA girişine tak ve prob uçlarını ölçmek istediğin pilin uçlarına bağla (kırmızı → pozitif (+), siyah → negatif (–) kutup).\n'
      '🔹 Ekrandaki değeri oku. AA pil için 1.2 – 1.6 V arası normaldir. 1.0 V’un altı genellikle pilin zayıf olduğunu gösterir.\n'
      '🔹 Prob yönünü ters bağlarsan ekranda eksi (–) işareti çıkar; bu normaldir.\n\n'
      'Güvenlik ve İpuçları\n\n'
      '🔹 Ölçüm sırasında problar birbirine değmemelidir.\n'
      '🔹 Yüksek gerilim (örneğin 220 V AC) ölçümlerinde mutlaka dikkatli ol ve yalıtımlı prob kullan.\n'
      '🔹 Ölçüm bittikten sonra multimetreyi OFF konumuna getir; akım ölçüm modunda bırakmamaya özen göster, aksi takdirde yanlış bağlantıda sigorta patlayabilir.\n\n'
      'Kullanım Alanı\n\n'
      'Bu yöntem sadece piller için değil; adaptör çıkışları, güç kaynakları, sensör gerilimleri ve devre çıkışlarının kontrolünde de kullanılır.',
  kategori: 'elektrik',
  resim: 'assets/images/multimetre.png',
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
   baslik: 'Kompanzasyon Panosu Bakımında Dikkat Edilecekler',
   icerik: '''
KOMPANZASYON PANOSU NEDİR?

         Kompanzasyon panosu; işletmelerde ve büyük tesislerde reaktif gücü dengelemek, enerji verimliliğini artırmak ve reaktif ceza ödemelerini önlemek amacıyla kullanılan elektrik panosudur. Bu panolar; kondansatörler, kontaktörler, reaktif güç kontrol rölesi, sigortalar ve soğutma elemanlarından oluşur.

         - KOMPANZASYON PANOSU NEDEN BAKIM GEREKTİRİR?

         Kompanzasyon sistemleri sürekli devreye girip çıktığı için zamanla ekipmanlarda yıpranma oluşur. Düzenli bakım yapılmazsa:
         • Reaktif ceza oluşur
         • Kondansatörler zarar görür
         • Kontaktörler yapışır
         • Pano aşırı ısınır
         • Enerji kalitesi bozulur

         Bu nedenle kompanzasyon panoları **periyodik bakım** gerektirir.

         - BAKIM ÖNCESİ GÜVENLİK ÖNLEMLERİ

         Bakım işlemine başlamadan önce mutlaka:
         • Ana şalter kapatılmalı
         • Pano enerjisiz bırakılmalı
         • Kondansatörlerin deşarj olduğu kontrol edilmeli
         • Gerilim yokluğu ölçü aleti ile doğrulanmalı
         • Kişisel koruyucu donanım (eldiven, gözlük) kullanılmalıdır

         🔹 KONDANSATÖRLERİN KONTROLÜ

         Kompanzasyon panosunun en önemli elemanları kondansatörlerdir. Bakım sırasında:
         • Şişme, çatlama veya sızıntı var mı kontrol edilir
         • Aşırı ısınma izleri incelenir
         • Etiket değerleri okunur
         • Devreye girip çıkma süreleri gözlemlenir

         Şişmiş veya aşırı ısınan kondansatörler **kesinlikle değiştirilmelidir**.

         🔹 KONTAKTÖRLERİN KONTROLÜ

         Kondansatör kontaktörleri, normal kontaktörlere göre daha fazla yüke maruz kalır.
         • Kontak yüzeylerinde yanma var mı bakılır
         • Kontaklar yapışıyor mu kontrol edilir
         • Bobinlerde ısınma ve ses kontrolü yapılır
         • Aşırı gürültülü çalışan kontaktörler yenilenmelidir

         🔹 REAKTİF GÜÇ KONTROL RÖLESİ (RGK)

         RGK rölesi, sistemin beyni gibidir.
         • Cosφ hedef değeri kontrol edilmelidir
         • Genellikle hedef cosφ ≈ 0.95 seçilir
         • Kademe sayısı ve sıralaması doğru mu incelenir
         • Röle ayarları saha koşullarına uygun olmalıdır

         Yanlış ayarlanmış röle, kompanzasyon sistemini verimsiz hale getirir.

         🔹 SAYAÇ VE REAKTİF ORAN TAKİBİ

         Enerji sayaçları üzerinden:
         • Aktif enerji (kWh)
         • Reaktif enerji (kVArh)
         • Endüktif ve kapasitif oranlar
         periyodik olarak takip edilmelidir.

         Reaktif oran sınırlarının aşılması durumunda ceza uygulanır.

         🔹 FAN VE HAVALANDIRMA SİSTEMİ

         Kompanzasyon panolarında ısı ciddi bir problemdir.
         • Fanlar çalışıyor mu kontrol edilir
         • Fan filtreleri temizlenir
         • Pano içi tozdan arındırılır
         • Havalandırma menfezleri kapalı olmamalıdır

         Yetersiz soğutma, kondansatör ömrünü ciddi şekilde kısaltır.

         🔹 KABLO VE BAĞLANTI KONTROLLERİ

         • Gevşek klemensler sıkılır
         • Yanmış veya renk değiştirmiş kablolar kontrol edilir
         • Bara bağlantıları gözden geçirilir
         • İzolasyon hasarları tespit edilir

         🔹 SIK YAPILAN HATALAR

          • Bakım sırasında kondansatörleri deşarj etmeden müdahale etmek
          • Yanmış kontaktörü temizleyip tekrar kullanmak
          • Cosφ değerini aşırı yüksek ayarlamak
          • Fanları devre dışı bırakmak
          • Reaktif cezayı sadece fatura geldiğinde fark etmek

         🔹 KISACASI

         Kompanzasyon panosu bakımı; enerji maliyetlerini düşürmek, ekipman ömrünü uzatmak ve reaktif cezalardan kaçınmak için hayati öneme sahiptir. Düzenli ve bilinçli yapılan bakımlar, sistemin uzun yıllar sorunsuz çalışmasını sağlar.
         ''',
    kategori: 'elektrik',
    resim: 'assets/images/kompanzasyon.png',
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
    baslik: 'Transistör Temelleri (BJT/FET)',
    icerik:
        'BJT akım kontrollüdür, MOSFET ise gerilim kontrollüdür. '
        'Anahtarlama uygulamalarında MOSFET, düşük gate kaybı nedeniyle sık kullanılır. '
        'Transistör, küçük akımlar ile büyük akımları kontrol etmeye yarayan yarı iletken bir devre elemanıdır. '
        'NPN ve PNP olmak üzere iki tipi vardır. Anahtarlama, yükseltme ve darbe üretimi gibi işlemlerde kullanılır. '
        'Bölümler: Base (B), Collector (C), Emitter (E). Akım yönü B’den E’ye doğru kontrol edilir.',
    kategori: 'elektronik',
    resim: 'assets/images/transıstor.jpg',  
  ),
  Makale(
    id: 'el3',
    baslik: 'Kondansatör (Kapasitör) Nedir?',
    icerik:
        'Kondansatör, iki iletken levha arasına yalıtkan dielektrik malzeme konularak oluşturulan enerji depolayıcı elemandır. '
        'Elektrik yükünü kısa süreli olarak depolar ve gerektiğinde devreye verir. AC sinyalleri geçirir, DC akımı engeller. '
        'Birimi Farad (F) olup genellikle µF, nF, pF şeklinde kullanılır.',
    kategori: 'elektronik',
    resim: 'assets/images/kondansator.jpg',   
  ),
  Makale(
  id: 'el4',
  baslik: 'Diyot Rehberi: Tipler, Zener, Köprü Doğrultucu ve Uygulamalar',
  icerik:
      'Diyot, akımı temelde tek yönde ileten yarı iletken bir devre elemanıdır. '
      'Elektronikte doğrultma, koruma, regülasyon ve anahtarlama gibi çok kritik görevlerde kullanılır.\n\n'

      '────────────────────────────\n'
      '1) DİYOTUN UÇLARI: ANOT / KATOT\n'
      '• Anot (A): Akımın giriş ucu gibi düşünebilirsin.\n'
      '• Katot (K): Akımın çıkış ucu. Diyot üzerinde genelde çizgi/bant olan taraf katottur.\n\n'

      '2) DOĞRU POLARİZASYON / TERS POLARİZASYON\n'
      '• Doğru polarizasyon (iletim): Anot (+), Katot (–) olduğunda diyot iletir.\n'
      '  Tipik iletim gerilimi (Vf):\n'
      '  - Silikon diyot: ~0.6–0.8V\n'
      '  - Schottky diyot: ~0.2–0.4V (daha düşük kayıp)\n'
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

      '────────────────────────────\n'
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

      '────────────────────────────\n'
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

      '────────────────────────────\n'
      '6) DİYOT SEÇERKEN BAKILACAK 3 KRİTİK PARAMETRE\n'
      '1) Maksimum ters gerilim (VRRM): Diyotun ters yönde dayanacağı gerilim.\n'
      '2) Ortalama iletim akımı (IF): Sürekli taşıyabileceği akım.\n'
      '3) Güç/ısı: Diyot ısınırsa soğutma veya daha güçlü model gerekebilir.\n'
      'Ek: Hız (reverse recovery) → SMPS/inverter gibi işlerde kritik.\n\n'

      '────────────────────────────\n'
      '7) PRATİK ARIZA / TEST (MULTİMETRE DİYOT MODU)\n'
      '• Multimetre “diyot test” modunda:\n'
      '  - Doğru yönde ~0.5–0.8V (silikon) görürsün.\n'
      '  - Ters yönde genelde OL / sonsuz görürsün.\n'
      '• İki yönde de 0V’a yakınsa → kısa devre arızası.\n'
      '• İki yönde de OL ise → açık devre arızası.\n\n'
      'Zener ölçümü: Normal multimetreyle zener gerilimi doğru ölçülemez; besleme + seri direnç ile test gerekir.\n\n'

      '────────────────────────────\n'
      '8) EN YAYGIN UYGULAMALAR (SAHADA ÇOK ÇIKAR)\n'
      '• Adaptör doğrultma (köprü + kondansatör)\n'
      '• Motor bobini/role bobini “flyback” diyotu (ters EMK sönümleme)\n'
      '• Ters kutup koruması (girişte seri diyot veya daha verimli MOSFET çözümü)\n'
      '• Zener ile giriş sınırlama / referans\n'
      '• TVS ile darbe koruma\n\n'

      '────────────────────────────\n'
      '9) ÖNEMLİ UYARI\n'
      'Yanlış diyot yönü (katot/anot karışması) devreyi çalıştırmaz, hatta kısa devre/ısınma yapabilir. '
      'Özellikle güç devrelerinde diyot seçimini VRRM/IF değerlerine göre yap.\n',
  kategori: 'elektronik',
  resim: 'assets/images/diyot.jpg',
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
  id: 'o1',
  baslik: 'PLC Giriş / Çıkış (I/O) Türleri',
  icerik:
      'PLC (Programmable Logic Controller) sistemlerinde giriş ve çıkışlar, '
      'sahadaki sensörlerden ve butonlardan bilgi almak, motor, valf ve röle gibi '
      'elemanları kontrol etmek için kullanılır. PLC giriş/çıkış yapısının doğru '
      'seçilmesi, sistemin güvenilir ve kararlı çalışması açısından kritik öneme sahiptir.\n\n'

      '• Dijital Girişler (Digital Input):\n'
      'Dijital girişler yalnızca iki durumu algılar: 0 veya 1 (Açık / Kapalı). '
      'Butonlar, limit switchler, proximity sensörler ve fotoseller dijital girişlere '
      'bağlanır. Genellikle 24V DC veya 220V AC seviyelerinde çalışırlar.\n\n'

      '• Dijital Çıkışlar (Digital Output):\n'
      'Dijital çıkışlar PLC tarafından kontrol edilen elemanları sürmek için kullanılır. '
      'Röle, kontaktör, ikaz lambası ve solenoid valfler dijital çıkışlara bağlanır. '
      'Röle çıkışlı, transistor çıkışlı ve triac çıkışlı tipleri bulunur.\n\n'

      '• Analog Girişler (Analog Input):\n'
      'Analog girişler sürekli değişen değerleri algılar. '
      'Sıcaklık, basınç, seviye ve hız sensörleri analog girişlere bağlanır. '
      'Yaygın sinyal tipleri 0–10V, 4–20mA ve ±10V’tur.\n\n'

      '• Analog Çıkışlar (Analog Output):\n'
      'Analog çıkışlar, sürücü, inverter ve oransal valf gibi cihazlara '
      'değişken kontrol sinyali göndermek için kullanılır. '
      'Motor hız kontrolü ve proses ayarlamaları bu çıkışlar üzerinden yapılır.\n\n'

      '• Hızlı Sayaç Girişleri (High Speed Counter):\n'
      'Hızlı sayaç girişleri, encoder ve yüksek frekanslı sensörlerden gelen '
      'darbeleri kaçırmadan saymak için kullanılır. '
      'Konum, hız ve adım kontrolü uygulamalarında önemlidir.\n\n'

      '• PWM Çıkışları (Pulse Width Modulation):\n'
      'PWM çıkışları, darbe genişliğini değiştirerek motor hızı, '
      'LED parlaklığı veya güç kontrolü sağlar. '
      'DC motor ve basit hız kontrol uygulamalarında yaygın olarak kullanılır.\n\n'

      '⚠️ Topraklama ve Gürültü Önlemleri:\n'
      'PLC sistemlerinde analog sinyaller gürültüye karşı hassastır. '
      'Sensör beslemeleri doğru topraklanmalı, ekranlı kablolar tek noktadan '
      'toprağa bağlanmalı ve güç kabloları sinyal kablolarından ayrı taşınmalıdır.\n\n'

      '🧰 Tekniker Notu:\n'
      'Analog girişlerde 4–20mA sinyal kullanımı, uzun mesafelerde ve '
      'endüstriyel ortamlarda gürültüye karşı daha güvenilirdir.',
  kategori: 'otomasyon',
  ikonAsset: 'assets/images/otomasyonicon.png',
),
  Makale(
    id: 'o2',
    baslik: 'Kontaktör ve Role Farkları',
    icerik:
        'Kontaktör yüksek akım anahtarlamada; röle düşük akım kumandasında kullanılır. Ark söndürme, AC-3 sınıfı motor uygulamalarında önemlidir.',
    kategori: 'otomasyon',
  ),
  Makale(
  id: 'o3',
  baslik: 'Otomasyon Sistemlerinde Temel Güvenlik ve Uygulama Kuralları',
  icerik:
      '• Acil Durdurma (E-Stop): Tüm sistemlerde kolay erişilebilir konumda olmalıdır.\n'
      '• Topraklama ve Ekranlama: PLC, sürücü ve sensör hatlarında tek noktadan topraklama yapılmalıdır.\n'
      '• Besleme: 24V DC devrelerde polarite koruması ve sigorta kullanımı zorunludur.\n'
      '• I/O Kablolama: Analog ve dijital hatlar ayrı kanal ve borulardan çekilmelidir.\n'
      '• Etiketleme: Tüm kablo, klemens ve cihazlar net şekilde numaralandırılmalıdır.\n'
      '• Yedekleme: PLC ve HMI programları düzenli olarak yedeklenmelidir.\n'
      '• Operatör Güvenliği: Kilitleme/etiketleme (LOTO) prosedürleri uygulanmalıdır.',
  kategori: 'otomasyon',
  resim: 'assets/images/otomasyon_bilgi.jpg',
  ),
  Makale(
    id: 'o4',
    baslik: 'Ladder Diyagramında Temel Mantık',
    icerik:
        'Ladder (merdiven) diyagramı, röleli kumanda mantığının PLC üzerinde grafiksel gösterimidir. Sol hat faz, sağ hat nötr gibi düşünülebilir. Normalde açık ve kapalı kontaklar, bobinler ve timer/counter blokları kullanılır. Elektrikçiler için okunması kolay olması en büyük avantajıdır.',
    kategori: 'otomasyon',
  ),
  Makale(
    id: 'o5',
    baslik: 'Frekans Konvertörü (VFD) Temel Parametreleri',
    icerik:
        'Frekans konvertörleri, motor hızını frekans ve gerilimi değiştirerek kontrol eder. Kurulumda motor plaka değerleri (U, I, f, P, cosφ) doğru girilmelidir. Temel parametreler: rampa süresi, maksimum/minimum frekans, motor koruma akımı ve start/stop komut kaynaklarıdır.',
    kategori: 'otomasyon',
  ),
  Makale(
    id: 'o6',
    baslik: 'Ladder Diyagramında Zaman Röleleri (Timer)',
    icerik:
        'TON (On-delay) ve TOF (Off-delay) timer blokları, çıkışın gecikmeli olarak aktif veya pasif olmasını sağlar. '
        'PLC programlarında motor gecikmeli çalıştırma, fan çıkış gecikmesi gibi senaryolarda sıkça kullanılır.',
    kategori: 'otomasyon',
  ),
  Makale(
    id: 'o7',
    baslik: 'Sayma (Counter) Blokları ile Parça Sayma',
    icerik:
        'CTU (count up) ve CTD (count down) blokları, giriş darbelerini sayarak belirli bir sayıya ulaşıldığında çıkış üretir. '
        'Konveyör sistemlerinde ürün sayma, paketleme makinelerinde adet kontrolü için kullanılır.',
    kategori: 'otomasyon',
  ),
  Makale(
    id: 'o8',
    baslik: 'Frekans Konvertörü Parametrelerine Giriş',
    icerik:
        'Frekans konvertörlerinde temel parametreler; motor plaka verileri, hız sınırları, rampa süreleri ve kontrol modu (V/f, vektör kontrol) olarak öne çıkar. '
        'Yanlış parametre, motor ısınması ve tork kaybına neden olabilir.',
    kategori: 'otomasyon',
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
              etiket: '⚡ Elektrik',
              renk: Colors.blue,
              sayfa: const KategoriSayfasi(kategori: 'elektrik', baslik: 'Elektrik'),
            ),
            _KategoriButonu(
              etiket: '🔧 Elektronik',
              renk: Colors.green,
              sayfa: const KategoriSayfasi(kategori: 'elektronik', baslik: 'Elektronik'),
            ),
            _KategoriButonu(
              etiket: '🤖 Otomasyon',
              renk: Colors.deepOrange,
              sayfa: const KategoriSayfasi(kategori: 'otomasyon', baslik: 'Otomasyon'),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _KategoriButonu(
                    etiket: '🔢 Hesaplamalar',
                    renk: Colors.indigo,
                    sayfa: const HesaplamalarSayfasi(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _KategoriButonu(
                    etiket: '📝 Quiz',
                    renk: Colors.purple,
                    sayfa: const QuizSayfasi(),
                  ),
                ),                
              ],
            ),
              const SizedBox(height: 12),
                                        
              _KategoriButonu(
                  etiket: '🧯 Arıza Teşhis',
                  renk: const Color(0xFFC62828),
                  sayfa: const ArizaTeshiAnaSayfa(),                 
               ), 
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
      appBar: AppBar(
        title: Text(m.baslik),    
      ),  
        body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [          
         // 🔼 ÜST RESİM
         if (m.resim != null && !m.resimAltta) ...[
           ClipRRect(
             borderRadius: BorderRadius.circular(12),
             child: SizedBox(          
             child: Image.asset(
             m.resim!,
             width: double.infinity,           
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
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
        child: SizedBox(
          child: Image.asset(
            m.resimOrta!,
            width: double.infinity,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
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

    // 🔽 ALT RESİM
    if (m.resim != null && m.resimAltta) ...[
  const SizedBox(height: 16),
  ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: InteractiveViewer(
      minScale: 1,
      maxScale: 4,
      child: Image.asset(
        m.resim!,
        width: double.infinity,
        fit: BoxFit.contain, // 🔥 tablo/şema için şart
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),               
               ),
              ),
            ),
          ],
        ],
      ),
    );
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
                backgroundImage: AssetImage('assets/images/logo1.png'),
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
            ListTile(
             leading: const Icon(Icons.star_outline),
             title: const Text("Geliştiriciye Destek Ol"),
             subtitle: const Text("Uygulamanın gelişimine katkı"),
             onTap: () {
                Navigator.pop(context); // Drawer kapansın
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DestekOlSayfasi()),
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
