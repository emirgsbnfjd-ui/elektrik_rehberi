import 'dart:math';
import 'package:flutter/material.dart';

enum BaslatmaTipi { dol, yildizUcgen, softStarter, vfd }

class JeneratorHesapSayfasi extends StatefulWidget {
  const JeneratorHesapSayfasi({super.key});

  @override
  State<JeneratorHesapSayfasi> createState() => _JeneratorHesapSayfasiState();
}

class _JeneratorHesapSayfasiState extends State<JeneratorHesapSayfasi> {
  final _toplamKw = TextEditingController();
  final _enBuyukMotorKw = TextEditingController();
  final _cos = TextEditingController(text: '0.8');
  final _yedek = TextEditingController(text: '20');

  bool gelismisAcik = false;
  BaslatmaTipi baslatma = BaslatmaTipi.dol;

  String sonuc = '';
  String? hata;

  double? _d(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '.').trim());

  double _startFactor(BaslatmaTipi t) {
    switch (t) {
      case BaslatmaTipi.dol:
        return 2.0;
      case BaslatmaTipi.yildizUcgen:
        return 1.3;
      case BaslatmaTipi.softStarter:
        return 1.5;
      case BaslatmaTipi.vfd:
        return 1.1;
    }
  }

  String _baslatmaStr(BaslatmaTipi t) {
    switch (t) {
      case BaslatmaTipi.dol:
        return 'Direkt (DOL)';
      case BaslatmaTipi.yildizUcgen:
        return 'Yıldız / Üçgen';
      case BaslatmaTipi.softStarter:
        return 'Soft Starter';
      case BaslatmaTipi.vfd:
        return 'VFD';
    }
  }

  void hesapla() {
    final toplamKw = _d(_toplamKw);
    final motorKw = _d(_enBuyukMotorKw);
    final cos = gelismisAcik ? _d(_cos) : 0.8;
    final yedekPct = _d(_yedek) ?? 20;

    if (toplamKw == null || motorKw == null || cos == null) {
      _setError('Lütfen tüm zorunlu alanları doldur.');
      return;
    }

    if (toplamKw <= 0 || toplamKw > 5000) {
      _setError('Toplam yük mantıksız görünüyor.');
      return;
    }

    if (motorKw < 0 || motorKw > toplamKw) {
      _setError('En büyük motor gücü toplam yükten büyük olamaz.');
      return;
    }

    if (cos < 0.6 || cos > 1) {
      _setError('cosφ değeri 0.6 – 1.0 arasında olmalı.');
      return;
    }

    if (yedekPct < 0 || yedekPct > 50) {
      _setError('Yedek payı %0 – %50 arası girilmeli.');
      return;
    }

    final toplamKva = toplamKw / cos;
    final motorEtkiKva = motorKw * _startFactor(baslatma) / cos;

    final genKva = (toplamKva + motorEtkiKva) * (1 + yedekPct / 100);

    final yukOrani = (toplamKva / genKva) * 100;

    setState(() {
      hata = null;
      sonuc =
          '--- Giriş Bilgileri ---\n'
          'Toplam Yük: ${toplamKw.toStringAsFixed(1)} kW\n'
          'En Büyük Motor: ${motorKw.toStringAsFixed(1)} kW\n'
          'Başlatma Tipi: ${_baslatmaStr(baslatma)}\n'
          'cosφ: ${cos.toStringAsFixed(2)}\n'
          'Yedek Payı: %${yedekPct.toStringAsFixed(0)}\n\n'
          '--- Hesap ---\n'
          'Toplam Güç: ${toplamKva.toStringAsFixed(1)} kVA\n'
          'Motor Kalkış Etkisi: ${motorEtkiKva.toStringAsFixed(1)} kVA\n\n'
          '--- ÖNERİ ---\n'
          '👉 Önerilen Jeneratör: ${genKva.toStringAsFixed(0)} kVA\n'
          'Tahmini Yük Oranı: %${yukOrani.toStringAsFixed(0)}\n\n'
          'Not: Jeneratörün %60–80 yükte çalışması idealdir.\n'
          'Bu hesap ön seçimdir (rakım, sıcaklık, marka etkiler).';
    });
  }

  void _setError(String msg) {
    setState(() {
      hata = msg;
      sonuc = '';
    });
  }

  @override
  void dispose() {
    _toplamKw.dispose();
    _enBuyukMotorKw.dispose();
    _cos.dispose();
    _yedek.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jeneratör Seçimi (kVA)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _input('Toplam Yük (kW)', _toplamKw, 'Örn: 120'),
          _input('En Büyük Motor (kW)', _enBuyukMotorKw, 'Örn: 30'),

          const SizedBox(height: 10),
          DropdownButtonFormField<BaslatmaTipi>(
            value: baslatma,
            decoration: const InputDecoration(
              labelText: 'Motor Başlatma Tipi',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: BaslatmaTipi.dol, child: Text('Direkt (DOL)')),
              DropdownMenuItem(value: BaslatmaTipi.yildizUcgen, child: Text('Yıldız / Üçgen')),
              DropdownMenuItem(value: BaslatmaTipi.softStarter, child: Text('Soft Starter')),
              DropdownMenuItem(value: BaslatmaTipi.vfd, child: Text('VFD')),
            ],
            onChanged: (v) => setState(() => baslatma = v!),
          ),

          const SizedBox(height: 10),
          _input('Yedek Payı (%)', _yedek, 'Örn: 20'),

          ExpansionTile(
            title: const Text('Gelişmiş (İsteğe Bağlı)'),
            subtitle: const Text('cosφ'),
            initiallyExpanded: gelismisAcik,
            onExpansionChanged: (x) => setState(() => gelismisAcik = x),
            children: [
              _input('cosφ', _cos, 'Varsayılan: 0.8'),
            ],
          ),

          const SizedBox(height: 12),
          FilledButton(onPressed: hesapla, child: const Text('Hesapla')),

          if (hata != null) ...[
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  hata!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(sonuc.isEmpty ? 'Sonuç burada görünecek.' : sonuc),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(String label, TextEditingController c, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
