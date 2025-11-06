import 'package:flutter/material.dart';

void main() {
  runApp(const RehberApp());
}

class RehberApp extends StatelessWidget {
  const RehberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elektrik Elektronik Rehberi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1E88E5),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFD),
      ),
      home: const SplashScreen(), // <-- Splash ekrancı
    );
  }
}

/* -------------------- Splash Screen -------------------- */
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
        MaterialPageRoute(builder: (_) => const AnaSayfa()),
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
        'Akım (I) amper ile ölçülür ve yük taşınmasıdır. Gerilim (V) potansiyel farkıdır. Güç (P) = V × I formülüyle hesaplanır. AC’de görünür/aktif/reaktif güç ayrımına dikkat.',
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
    id: 'el1',
    baslik: 'Direnç-Kapasitör-Endüktans',
    icerik:
        'Direnç ısıya, kapasitör elektrik alanına, bobin manyetik alana enerji depolar. Zaman sabiti: RC devrelerinde τ = R×C, RL devrelerinde τ = L/R.',
    kategori: 'elektronik',
    resim: 'assets/images/elektronik.jpg',
  ),
  Makale(
    id: 'el2',
    baslik: 'Transistör Temelleri (BJT/FET)',
    icerik:
        'BJT akım kontrollü, MOSFET gerilim kontrollüdür. Anahtarlama uygulamalarında MOSFET düşük gate kaybı nedeniyle sık kullanılır.',
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
];

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  final sayfaBasligi = 'Elektrik Elektronik Rehberi';

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
        ],
      ),
      drawer: const _YanMenu(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Card(
            elevation: 0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 92,
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.lightbulb, size: 72),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Bilgi Paneline Hoşgeldiniz!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Elektrik, Elektronik ve Otomasyon başlıklarında temel kavramlar, ipuçları ve mini rehberler.',
                    textAlign: TextAlign.center,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => sayfa),
        ),
        child: Text(etiket, style: const TextStyle(fontSize: 16)),
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
            tileColor: Colors.white,
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
      appBar: AppBar(title: Text(m.baslik)),
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
          Text(m.icerik, style: const TextStyle(fontSize: 16, height: 1.4)),
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
                backgroundImage: AssetImage('assets/images/logo.jpg'),
              ),
              title: const Text('Elektrik Elektronik Rehberi'),
              subtitle: const Text('BYRK •'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Hakkında'),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'Elektrik Elektronik Rehberi',
                applicationVersion: '1.0.0',
                applicationIcon: Image.asset(
                  'assets/images/logo.jpg',
                  height: 36,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.lightbulb_outline),
                ),
                children: const [
                  Text('Temel bilgiler, ipuçları ve mini rehberler. Veri toplamaz, üyelik gerektirmez.')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}