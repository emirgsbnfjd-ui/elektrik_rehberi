import 'dart:io'; // Platform kontrolü için gerekli
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Sayfa Importları
import 'ariza_sigorta_atiyor.dart';
import 'ariza_rcd_atiyor.dart';
import 'ariza_prizde_elektrik_yok.dart';
import 'ariza_isik_zayif_sayfa.dart';
import 'ariza_topraklama_sorunu.dart';
import 'ariza_motor_calismiyor_sayfa.dart';
import 'ariza_ups_surekli_bipliyor.dart';
import 'elektronik_cihaz_acilmiyor.dart';
import 'elektronik_led_sorunu.dart';
import 'elektronik_sarj_olmuyor.dart';
import 'elektronik_pcb_tamir_rehberi.dart';

class ArizaTeshiAnaSayfa extends StatefulWidget {
  const ArizaTeshiAnaSayfa({super.key});

  @override
  State<ArizaTeshiAnaSayfa> createState() => _ArizaTeshiAnaSayfaState();
}

class _ArizaTeshiAnaSayfaState extends State<ArizaTeshiAnaSayfa> {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;

  // Reklamın en son ne zaman izlendiğini tutan değişken (Static kalmalı)
  static DateTime? _lastAdTime;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    // Cihaza göre doğru reklam birimi ID'sini seçiyoruz
    final String adUnitId = Platform.isIOS
        ? 'ca-app-pub-6404557439064466/9681558944' // ✅ Senin iOS ID'n
        : 'ca-app-pub-6404557439064466/1503686025'; // ✅ Senin Android ID'n

    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (error) {
          setState(() => _isAdLoaded = false);
          // Yükleme başarısız olursa 30 saniye sonra tekrar dene
          Future.delayed(const Duration(seconds: 30), () => _loadRewardedAd());
        },
      ),
    );
  }

  void _handleAdAndNavigation(Widget destinationPage) {
    final now = DateTime.now();

    // 10 dakika kontrolü: Eğer süre dolmadıysa direkt geç
    if (_lastAdTime != null && now.difference(_lastAdTime!).inMinutes < 10) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => destinationPage));
      return;
    }

    // Reklam yüklüyse göster
    if (_isAdLoaded && _rewardedAd != null) {
      _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        _lastAdTime = DateTime.now(); // Süreyi güncelle
        Navigator.push(context, MaterialPageRoute(builder: (context) => destinationPage));
        _loadRewardedAd(); // Bir sonraki kullanım için yükle
      });
    } else {
      // Reklam hazır değilse (yükleniyorsa vb.) kullanıcıyı bekletme, direkt geç
      Navigator.push(context, MaterialPageRoute(builder: (context) => destinationPage));
      _loadRewardedAd();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧯 Arıza Teşhis')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _BolumBaslik('Elektrik Bölümü'),
          _ArizaKart(
            icon: Icons.electric_bolt,
            title: 'Sigorta / Şalter Atıyor',
            subtitle: 'Kısa devre • Aşırı yük • Isınma',
            color: const Color(0xFFC62828),
            onTap: () => _handleAdAndNavigation(ArizaSigortaAtiyorSayfa()),
          ),
          _ArizaKart(
            icon: Icons.health_and_safety,
            title: 'Kaçak Akım Rölesi Atıyor',
            subtitle: 'Nem • Cihaz kaçağı • Nötr-toprak',
            color: const Color(0xFFD32F2F),
            onTap: () => _handleAdAndNavigation(ArizaRcdAtiyorSayfa()),
          ),
          _ArizaKart(
            icon: Icons.electrical_services,
            title: 'Prizde Elektrik Yok',
            subtitle: 'Sigorta • Klemens • Kablo kopuğu',
            color: const Color(0xFFB71C1C),
            onTap: () => _handleAdAndNavigation(ArizaPrizdeElektrikYokSayfa()),
          ),
          _ArizaKart(
            icon: Icons.lightbulb,
            title: 'Işık Yanıyor Ama Çok Zayıf',
            subtitle: 'Nötr zayıf • Gevşek ek • Faz paylaşımı',
            color: const Color(0xFFFFA000),
            onTap: () => _handleAdAndNavigation(ArizaIsikZayifSayfa()),
          ),
          _ArizaKart(
            icon: Icons.gpp_bad,
            title: 'Topraklama Sorunu',
            subtitle: 'Çarpma • Kaçak akım atmıyor • Güvensiz tesisat',
            color: const Color(0xFF6A1B9A),
            onTap: () => _handleAdAndNavigation(ArizaTopraklamaSorunuSayfa()),
          ),
          _ArizaKart(
            icon: Icons.settings,
            title: 'Motor Çalışmıyor',
            subtitle: 'Kontaktör • Termik • Faz eksikliği',
            color: const Color(0xFF455A64),
            onTap: () => _handleAdAndNavigation(ArizaMotorCalismiyorSayfa()),
          ),
          _ArizaKart(
            icon: Icons.battery_alert,
            title: 'UPS Sürekli Bipliyor',
            subtitle: 'Akü zayıf • Aşırı yük • Şebeke sorunu',
            color: const Color(0xFF2E7D32),
            onTap: () => _handleAdAndNavigation(ArizaUpsSurekliBipliyorSayfa()),
          ),

          const SizedBox(height: 24),

          _BolumBaslik('Elektronik Bölümü'),
          _ArizaKart(
            icon: Icons.power_settings_new,
            title: 'Cihaz Hiç Açılmıyor',
            subtitle: 'Adaptör • Güç kartı • Batarya',
            color: const Color(0xFF1565C0),
            onTap: () => _handleAdAndNavigation(ElektronikCihazAcilmiyorSayfa()),
          ),
          _ArizaKart(
            icon: Icons.lightbulb,
            title: 'LED Yanıp Sönüyor / Yanmıyor',
            subtitle: 'Besleme • Direnç • LED arızası',
            color: const Color(0xFF1976D2),
            onTap: () => _handleAdAndNavigation(ElektronikLedSorunuSayfa()),
          ),
          _ArizaKart(
            icon: Icons.battery_alert,
            title: 'Şarj Olmuyor',
            subtitle: 'Kablo • Soket • Şarj entegresi',
            color: const Color(0xFF2E7D32),
            onTap: () => _handleAdAndNavigation(ElektronikSarjOlmuyorSayfa()),
          ),
          _ArizaKart(
            icon: Icons.developer_board,
            title: 'PCB Kart Tamiri',
            subtitle: 'Besleme • Kısa devre • Multimetre ile teşhis',
            color: const Color(0xFF455A64),
            onTap: () => _handleAdAndNavigation(ElektronikPcbTamirRehberiSayfa()),
          ),
        ],
      ),
    );
  }
}

// Alt kısımdaki yardımcı widgetlar
class _ArizaKart extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ArizaKart({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _BolumBaslik extends StatelessWidget {
  final String text;
  const _BolumBaslik(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}