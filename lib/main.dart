import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'pages/hesaplayici_sayfasi.dart';
import 'pages/hakkinda_sayfasi.dart';
import 'pages/ayarlar_sayfasi.dart';
import 'pages/gizlilik_sayfasi.dart';
import 'pages/hesaplamalar_sayfasi.dart';
import 'pages/quiz_sayfasi.dart';

final List<String> hesapGecmisi = [];

void main() async {
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
      ),
      darkTheme: ThemeData(
      colorSchemeSeed: const Color(0xFF90CAF9),
      useMaterial3: true,
      brightness: Brightness.dark,
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
                        'assets/images/logo.jpg',
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
  final String? resim;   // assets yolu
  final double? width = 100.0;

  const Makale({
    required this.id,
    required this.baslik,
    required this.icerik,
    required this.kategori,
    this.resim, 
  });
}

/// Örnek içerikler
const List<Makale> tumMakaleler = [
  Makale(
    id: 'e1',
    baslik: 'Temel Kavramlar: Akım, Gerilim, Güç',
    icerik:
        'Akım (I) amper ile ölçülür ve yük taşınmasıdır. Gerilim (V)  farkıdır. Güç (P) = V × I formülüyle hesaplanır. AC’de görünür/aktif/reaktif güç ayrımına dikkat.',
    kategori: 'elektrik',
    resim: 'assets/images/elektrik.jpg',
  ),
  Makale(
    id: 'e2',
    baslik: 'Kaçak Akım Rölesi (RCD) Seçimi',
    icerik:
        '30mA hayat koruma, 300mA yangın koruma olarak tercih edilir. Tip A çoğu konut için uygundur. Test düğmesine aylık basıp fonksiyon kontrolü yapılmalı.',
    kategori: 'elektrik',
  ),
  Makale(
    id: 'e3',
    baslik: 'Kablo Kesiti Seçimi (Hızlı Rehber)',
    icerik:
        'Uzunluk, akım ve izin verilen gerilim düşümüne göre seçilir. Konut için bakır NYA/NYM: 1,5 mm² aydınlatma (~10A), 2,5 mm² priz (~16-20A), 4 mm² tesisat fırın/klima.',
    kategori: 'elektrik',
  ),
  Makale(
    id: 'e4',
    baslik: 'Sigorta (MCB) Eğrileri: B-C-D',
    icerik:
        'B: rezistif yükler; C: motor/karışık; D: ağır kalkış akımı. Konutta genelde C tercih edilir. Seçim anma akımı + kısa devre kırma kapasitesine göre yapılır.',
    kategori: 'elektrik',
  ),
  Makale(
    id: 'e5',
    baslik: 'Topraklama Ölçümü Adımları',
    icerik:
        'Toprak direnci ≤ 10Ω (yönetmeliğe göre saha şartına bağlı). 3 nokta metodu: akım ve potansiyel kazıkları ile ölç; bağlantılar sıkı ve korozyonsuz olmalı.',
    kategori: 'elektrik',
  ),
  Makale(
  id: 'e6',
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
    id: 'e7',
    baslik: 'Üç Fazlı Motorlarda Yıldız–Üçgen Yol Verme',
    icerik:
        'Büyük güçlü üç fazlı motorlarda direkt yol verildiğinde yüksek kalkış akımı oluşur. '
        'Yıldız–üçgen yol vericilerde motor önce yıldız bağlı çalıştırılır, hızlandıktan sonra üçgen bağlantıya geçirilir. '
        'Bu sayede kalkış akımı yaklaşık 1/3 oranında azaltılmış olur.',
    kategori: 'elektrik',
  ),
  Makale(
    id: 'e8',
    baslik: 'Kompanzasyon Panosu Bakımında Dikkat Edilecekler',
    icerik:
        'Kondansatörlerin şişme ve ısınma durumları kontrol edilmeli, kontaktörlerin kontak yüzeyleri ve fanlar temizlenmelidir. '
        'Reaktif oran takibi için sayaç değerleri periyodik olarak izlenmeli, cosφ hedef değeri 0.95 civarında tutulmalıdır.',
    kategori: 'elektrik',
  ),
  Makale(
    id: 'e9',
    baslik: 'Topraklama Direncini Etkileyen Faktörler',
    icerik:
        'Toprak özgül direnci, topraklayıcı elektrot sayısı ve yerleşimi, nem oranı ve sıcaklık topraklama direncini etkiler. '
        'Kuru ve taşlı zeminlerde direnç genellikle yüksektir; gerektiğinde kimyasal topraklama veya ek elektrotlar kullanılmalıdır.',
    kategori: 'elektrik',
  ),
  Makale(
    id: 'el1',
    baslik: 'Direnç-Kapasitör-Endüktans',
    icerik:
        'Direnç ısıya, kapasitör elektrik alanına, bobin manyetik alana enerji depolar. '
        'RC devrelerinde zaman sabiti τ = R×C, RL devrelerinde τ = L/R.',
    kategori: 'elektronik',
    resim: 'assets/images/elektronik.jpg',
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
    resim: 'assets/images/transistör.jpg',  
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
    baslik: 'Diyot ve Uygulama Alanları',
    icerik:
      'Diyot, akımı sadece bir yönde geçiren yarı iletken devre elemanıdır. Anot (+) ve Katot (–) uçlarından oluşur. '
      'Doğru yönde düşük direnç, ters yönde yüksek direnç gösterir. '
      'Doğrultma devrelerinde, sinyal ayırıcı ve koruma devrelerinde sıkça kullanılır.',
    kategori: 'elektronik',
    resim: 'assets/images/diyot.jpg',
  ),
  Makale(
    id: 'el5',
    baslik: 'LED (Işık Yayan Diyot) Çalışma Prensibi',
    icerik:
      'LED (Light Emitting Diode), üzerinden akım geçtiğinde ışık yayan yarı iletken bir elemandır. '
      'Pn birleşiminde elektronlar ile deliklerin birleşmesi sonucunda enerji foton olarak açığa çıkar. '
      'Farklı malzemeler kullanılarak kırmızı, yeşil, mavi gibi farklı renkler elde edilir. '
      'Avantajları: düşük güç tüketimi, uzun ömür, hızlı tepki süresi ve kompakt yapı. '
      'Kullanım alanları: aydınlatma, göstergeler, sensörler ve optik iletişim sistemleri.',
    kategori: 'elektronik',
    resim: 'assets/images/led.jpg',
  ),
  Makale(
    id: 'el6',
    baslik: 'Breadboard (Deney Tahtası) Nedir?',
    icerik:
      'Breadboard, elektronik devreleri lehim yapmadan kurmaya yarayan delikli bir platformdur. '
      'İçinde metal iletken hatlar bulunur; yatay ve dikey hatlar bağlantı noktalarını oluşturur. '
      'Besleme hatları genellikle + ve – olarak ayrılır. '
      'Öğrenciler ve teknisyenler için hızlı prototipleme imkânı sağlar. '
      'En önemli kural: yüksek akım devreleri breadboard’da denenmemelidir.',
    kategori: 'elektronik',
    resim: 'assets/images/breadboard.jpg',
  ),
  Makale(
    id: 'el7',
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
    id: 'el8',
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
    id: 'el9',
    baslik: 'Ohm Kanunu ve Güç Hesaplaması',
    icerik:
      'Ohm Kanunu: V = I × R formülüyle gerilim (V), akım (I) ve direnç (R) arasındaki ilişkiyi açıklar. '
      'Güç hesabı için: P = V × I veya P = I² × R formülleri kullanılır. '
      'Uygulama: 12V devrede 6Ω direnç varsa, akım = 12 / 6 = 2A olur. Güç = 12 × 2 = 24W. '
      'Bu hesaplamalar elektronik devre tasarımında bileşen seçimi için temel önemdedir.',
    kategori: 'elektronik',
    resim: 'assets/images/ohm.jpg',
  ),
  Makale(
    id: 'el10',
    baslik: 'Direnç Renk Kodları ve Değer Hesaplama',
    icerik:
      'Dirençler üzerindeki renk halkaları değerini gösterir. '
      'Örneğin: Kahverengi (1), Siyah (0), Kırmızı (×100) → 10 × 100 = 1.000Ω yani 1kΩ. '
      'Altın halka ±5% toleransı temsil eder. '
      'Renk sırası: Siyah(0), Kahverengi(1), Kırmızı(2), Turuncu(3), Sarı(4), Yeşil(5), Mavi(6), Mor(7), Gri(8), Beyaz(9). '
      'Bu sistem, dirençleri ölçüm cihazı olmadan tanımlamayı sağlar.',
    kategori: 'elektronik',
    resim: 'assets/images/direnc.webp',
  ),
  Makale(
    id: 'el11',
    baslik: 'Seri ve Paralel Devre Farkı',
    icerik:
      'Seri devrede akım sabittir, gerilim dirençler arasında paylaştırılır: Vt = V1 + V2 + V3. '
      'Paralel devrede gerilim sabittir, akım dallara bölünür: It = I1 + I2 + I3. '
      'Eşdeğer direnç formülleri: Seri → Rt = R1 + R2 + R3, Paralel → 1/Rt = 1/R1 + 1/R2 + 1/R3. '
      'Bu kurallar devre tasarımının temelini oluşturur.',
    kategori: 'elektronik',
    resim: 'assets/images/seri_paralel.jpg',
  ),
  Makale(
    id: 'el12',
    baslik: 'Op-Amp (Operation Amplifier) Temel Devreleri',
    icerik:
        'Op-amp, çok yüksek kazançlı bir fark kuvvetlendiricisidir. En sık kullanılan yapılar: eviren, evirmeyen ve toplayıcı kuvvetlendiriciler. Eviren yapıda giriş sinyali terslenerek çıkışa taşınır, kazanç -Rf/Rin ile belirlenir. Besleme gerilimi ±12V veya ±15V olabilir.',
    kategori: 'elektronik',
  ),
  Makale(
    id: 'el13',
    baslik: 'ADC ve DAC Nedir?',
    icerik:
        'ADC (Analog-Dijital Dönüştürücü), analog gerilimi sayısal veriye çevirir. Mikrodenetleyicilerde sensör okuma için kullanılır. DAC (Dijital-Analog Dönüştürücü) ise sayısal veriden analog sinyal üretir. Çözünürlük (örneğin 10 bit, 12 bit) ve örnekleme hızı en kritik parametrelerdir.',
    kategori: 'elektronik',
  ),
  Makale(
    id: 'el14',
    baslik: 'Filtre Devreleri: Alçak, Yüksek ve Bant Geçiren',
    icerik:
        'RC ve RLC devreleri kullanılarak alçak geçiren, yüksek geçiren ve bant geçiren filtreler yapılabilir. '
        'Alçak geçiren filtre, belirli bir kesim frekansının altındaki sinyalleri geçirip üstünü zayıflatır. '
        'Ses, güç kaynakları ve sinyal işleme devrelerinde sık kullanılır.',
    kategori: 'elektronik',
  ),
  Makale(
    id: 'el15',
    baslik: 'Zener Diyot ile Gerilim Regülasyonu',
    icerik:
        'Zener diyot, ters polarmada belirli bir gerilimde iletime geçerek sabit çıkış gerilimi sağlar. '
        'Basit regülatör devrelerinde seri direnç ile birlikte kullanılır. Yük akımı değişse bile zener gerilimi büyük oranda sabit kalır.',
    kategori: 'elektronik',
  ),
  Makale(
    id: 'el16',
    baslik: 'Pull-up ve Pull-down Dirençleri',
    icerik:
        'Mikrodenetleyici giriş pinlerinin kararsız (floating) kalmaması için pull-up veya pull-down dirençleri kullanılır. '
        'Pull-up direnç pin ile besleme arasına, pull-down direnç ise pin ile GND arasına bağlanarak kararlı lojik seviye sağlanır.',
    kategori: 'elektronik',
  ),
  Makale(
    id: 'o1',
    baslik: 'PLC Giriş/Çıkış Türleri',
    icerik:
        'Dijital giriş/çıkış, analog giriş/çıkış, hızlı sayaç ve PWM kanalları. Sensör beslemeleri ve topraklama düzeni gürültüden korunmada kritiktir.',
    kategori: 'otomasyon',
    resim: 'assets/images/otomasyon.jpg',
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
  IconButton(                   // 
    icon: const Icon(Icons.calculate),
    onPressed: () => openOhmCalculator(context),
   ),

  IconButton( // Güç (eklediysen)
    icon: const Icon(Icons.bolt),
    onPressed: () => openPowerCalculator(context),

   ),

  IconButton( // Renk Kodu (eklediysen)
    icon: const Icon(Icons.palette),
    onPressed: () => openResistorColorCalc(context),

   ),

  IconButton(
    icon: const Icon(Icons.dark_mode),
    onPressed: widget.toggleTheme,
   ),

  IconButton( // 🔥 Geçmiş
    icon: const Icon(Icons.history),
    onPressed: () => openHistoryPanel(context),
   ),

  IconButton(
    icon: const Icon(Icons.electrical_services),
    onPressed: () => openVoltageDropCalculator(context),
   ),
 ],
), 

      drawer: const _YanMenu(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Card(
            elevation: 0,
            color: Theme.of(context).cardColor, // otomatik tema uyumu
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 220,
                    child: Image.asset(
                      'assets/images/',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.bolt, size: 70),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Elektrik ve Elektronik için Hesaplama, Bilgi ve Pratik Rehber.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                   ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
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
            sayfa: KategoriSayfasi(kategori: 'elektrik', baslik: 'Elektrik'),
          ),
          _KategoriButonu(
            etiket: '🔧 Elektronik',
            renk: Colors.green,
            sayfa: KategoriSayfasi(kategori: 'elektronik', baslik: 'Elektronik'),
          ),
          _KategoriButonu(
            etiket: '🤖 Otomasyon',
            renk: Colors.deepOrange,
            sayfa: KategoriSayfasi(kategori: 'otomasyon', baslik: 'Otomasyon'),
          ),
          const SizedBox(height: 12),

          Row(
           children: [
            Expanded(
             child: _KategoriButonu(
            etiket: '🔢 Hesaplamalar',
            renk: Colors.indigo,
            sayfa: HesaplamalarSayfasi(),
          ),
         ),
           const SizedBox(width: 12),
           Expanded(
            child: _KategoriButonu(
            etiket: '📝 Quiz',
            renk: Colors.purple,
            sayfa: QuizSayfasi(),
          ),
         ),
        ],
       ),
      ],
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
                child: m.resim != null
                    ? Image.asset(
                        m.resim!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.article_outlined),
                      )
                    : const Icon(Icons.article_outlined),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share('${m.baslik}\n\n${m.icerik}');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          if (m.resim != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                m.resim!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
          const SizedBox(height: 12),
          Text(
            m.baslik,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            m.icerik,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
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
                backgroundImage: AssetImage('assets/images/appicon.jpg'),
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
                  keyboardType: TextInputType.number,
                  enabled: !hesaplananV,
                  decoration: InputDecoration(
                    labelText: 'Gerilim (V)', hintText: 'Örn: 12',
                    border: const OutlineInputBorder(), suffixText: 'V',
                    fillColor: hesaplananV ? Colors.grey.shade200 : null, filled: hesaplananV,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: iCtrl,
                  keyboardType: TextInputType.number,
                  enabled: !hesaplananI,
                  decoration: InputDecoration(
                    labelText: 'Akım (I)', hintText: 'Örn: 2',
                    border: const OutlineInputBorder(), suffixText: 'A',
                    fillColor: hesaplananI ? Colors.grey.shade200 : null, filled: hesaplananI,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: rCtrl,
                  keyboardType: TextInputType.number,
                  enabled: !hesaplananR,
                  decoration: InputDecoration(
                    labelText: 'Direnç (R)', hintText: 'Örn: 6',
                    border: const OutlineInputBorder(), suffixText: 'Ω',
                    fillColor: hesaplananR ? Colors.grey.shade200 : null, filled: hesaplananR,
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
                    color: Colors.blueGrey.shade50, elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(sonuc!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
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
                  keyboardType: TextInputType.number,
                  enabled: !hesaplananV,
                  decoration: InputDecoration(
                    labelText: 'Gerilim (V)', hintText: 'Örn: 230',
                    border: const OutlineInputBorder(), suffixText: 'V',
                    fillColor: hesaplananV ? Colors.grey.shade200 : null, filled: hesaplananV,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: iCtrl,
                  keyboardType: TextInputType.number,
                  enabled: !hesaplananI,
                  decoration: InputDecoration(
                    labelText: 'Akım (I)', hintText: 'Örn: 2',
                    border: const OutlineInputBorder(), suffixText: 'A',
                    fillColor: hesaplananI ? Colors.grey.shade200 : null, filled: hesaplananI,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: pCtrl,
                  keyboardType: TextInputType.number,
                  enabled: !hesaplananP,
                  decoration: InputDecoration(
                    labelText: 'Güç (P)', hintText: 'Örn: 460',
                    border: const OutlineInputBorder(), suffixText: 'W',
                    fillColor: hesaplananP ? Colors.grey.shade200 : null, filled: hesaplananP,
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
                    color: Colors.blueGrey.shade50, elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(sonuc!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
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
                    color: Colors.blueGrey.shade50, elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(sonuc!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
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