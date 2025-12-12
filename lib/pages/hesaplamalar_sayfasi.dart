import 'package:flutter/material.dart';

import 'guc_hesabi_sayfasi.dart';
import 'gerilim_dusumu_sayfasi.dart';
import 'kompanzasyon_sayfasi.dart';
import 'ev_tuketimi_sayfasi.dart';
import 'pano_sigorta_sayfasi.dart';
import 'motor_hesap_sayfasi.dart';
import 'ev_sarj_sayfasi.dart';

class HesaplamalarSayfasi extends StatelessWidget {
  const HesaplamalarSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hesaplamalar")),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _CalcTile(
            icon: Icons.bolt,
            title: "Güç Hesabı (cosφ)",
            subtitle: "Tek faz / Trifaze • kW-kVA-Akım • Faz/Faz arası",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GucHesabiSayfasi()),
            ),
          ),
          _CalcTile(
            icon: Icons.trending_down,
            title: "Gerilim Düşümü",
            subtitle: "Cu/Al • Tek faz/Trifaze • % düşüm",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GerilimDusumuSayfasi()),
            ),
          ),
          _CalcTile(
            icon: Icons.tune,
            title: "Kompanzasyon (kVAr)",
            subtitle: "Mevcut cosφ → Hedef cosφ • Kondansatör ihtiyacı",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KompanzasyonSayfasi()),
            ),
          ),
          _CalcTile(
            icon: Icons.home,
            title: "Ev Tüketimi (kWh/Ay)",
            subtitle: "Cihaz ekle • Saat/gün • Aylık kWh + maliyet",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EvTuketimiSayfasi()),
            ),
          ),
          _CalcTile(
            icon: Icons.factory,
            title: "Pano / Sigorta Seçimi",
            subtitle: "Güce göre akım • Öneri sigorta",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PanoSigortaSayfasi()),
            ),
          ),
          _CalcTile(
            icon: Icons.settings,
            title: "Motor Hesapları",
            subtitle: "kW→Akım • Y/Δ temel hesap",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MotorHesapSayfasi()),
            ),
          ),
          _CalcTile(
            icon: Icons.electric_car,
            title: "EV Şarj (AC)",
            subtitle: "kW→Akım • Sigorta önerisi",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EvSarjSayfasi()),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalcTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CalcTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tileColor: Theme.of(context).cardColor,
        leading: Icon(icon, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
