import 'package:flutter/material.dart';
import 'ariza_sigorta_atiyor.dart';
import 'ariza_rcd_atiyor.dart';
import 'ariza_prizde_elektrik_yok.dart';
import 'ariza_isik_zayif_sayfa.dart';
import 'ariza_topraklama_sorunu.dart';

// Elektronik sayfaların
import 'elektronik_cihaz_acilmiyor.dart';
import 'elektronik_led_sorunu.dart';
import 'elektronik_sarj_olmuyor.dart';
import 'elektronik_pcb_tamir_rehberi.dart';


class ArizaTeshiAnaSayfa extends StatelessWidget {
  const ArizaTeshiAnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧯 Arıza Teşhis')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ELEKTRİK BÖLÜMÜ
          _BolumBaslik('Elektrik Bölümü'),
          _ArizaKart(
            icon: Icons.electric_bolt,
            title: 'Sigorta / Şalter Atıyor',
            subtitle: 'Kısa devre • Aşırı yük • Isınma',
            page: ArizaSigortaAtiyorSayfa(),
            color: Color(0xFFC62828),
          ),
          _ArizaKart(
            icon: Icons.health_and_safety,
            title: 'Kaçak Akım Rölesi Atıyor',
            subtitle: 'Nem • Cihaz kaçağı • Nötr-toprak',
            page: ArizaRcdAtiyorSayfa(),
            color: Color(0xFFD32F2F),
          ),
          _ArizaKart(
            icon: Icons.electrical_services,
            title: 'Prizde Elektrik Yok',
            subtitle: 'Sigorta • Klemens • Kablo kopuğu',
            page: ArizaPrizdeElektrikYokSayfa(),
            color: Color(0xFFB71C1C),
          ),
          _ArizaKart(
            icon: Icons.lightbulb,
            title: 'Işık Yanıyor Ama Çok Zayıf',
            subtitle: 'Nötr zayıf • Gevşek ek • Faz paylaşımı',
            page: ArizaIsikZayifSayfa(),
            color: Color(0xFFFFA000),
          ),
          _ArizaKart(
            icon: Icons.gpp_bad,
            title: 'Topraklama Sorunu',
            subtitle: 'Çarpma • Kaçak akım atmıyor • Güvensiz tesisat',
            page: ArizaTopraklamaSorunuSayfa(),
            color: Color(0xFF6A1B9A),
          ),
       
          const SizedBox(height: 24),

  // 🔌 ELEKTRONİK BÖLÜMÜ
          _BolumBaslik('Elektronik Bölümü'),
          _ArizaKart(
            icon: Icons.power_settings_new,
            title: 'Cihaz Hiç Açılmıyor',
            subtitle: 'Adaptör • Güç kartı • Batarya',
            page: ElektronikCihazAcilmiyorSayfa(),
            color: const Color(0xFF1565C0),
          ),
          _ArizaKart(
            icon: Icons.lightbulb, // ✅ Icons.light değil
            title: 'LED Yanıp Sönüyor / Yanmıyor',
            subtitle: 'Besleme • Direnç • LED arızası',
            page: ElektronikLedSorunuSayfa(),
            color: const Color(0xFF1976D2),
          ),
          _ArizaKart(
            icon: Icons.battery_alert,
            title: 'Şarj Olmuyor',
            subtitle: 'Kablo • Soket • Şarj entegresi',
            page: ElektronikSarjOlmuyorSayfa(),
            color: const Color(0xFF2E7D32),
          ),
          _ArizaKart(
            icon: Icons.developer_board,
            title: 'PCB Kart Tamiri',
            subtitle: 'Besleme • Kısa devre • Multimetre ile teşhis',
            page: ElektronikPcbTamirRehberiSayfa(),
            color: const Color(0xFF455A64),
          ),
        ],
      ),
    );
  }
}

class _ArizaKart extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget page;
  final Color color;

  const _ArizaKart({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.page,
    required this.color,
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
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        ),
      ),
    );
  }
}
class _BolumBaslik extends StatelessWidget {
  final String text;
  const _BolumBaslik(this.text, {super.key});

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
