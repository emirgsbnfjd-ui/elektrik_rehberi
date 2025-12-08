import 'package:flutter/material.dart';

class GizlilikSayfasi extends StatelessWidget {
  const GizlilikSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gizlilik Politikası')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: const [
          Text(
            'Gizlilik Politikası',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'Elektrik Elektronik Rehberi uygulaması, kullanıcı gizliliğine önem verir. '
            'Bu uygulama herhangi bir üyelik sistemi, kullanıcı hesabı veya çevrim içi veri toplama '
            'mekanizması kullanmaz.\n',
            style: TextStyle(fontSize: 15, height: 1.4),
          ),
          SizedBox(height: 12),
          Text(
            'Toplanan Veriler',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            '• Uygulama, kullanıcıdan kişisel veri (ad, e-posta vb.) toplamaz.\n'
            '• Hesap geçmişi sadece cihaz üzerinde, geçici olarak tutulur ve sunucuya gönderilmez.\n'
            '• Uygulama çevrim dışı çalışacak şekilde tasarlanmıştır.\n',
            style: TextStyle(fontSize: 15, height: 1.4),
          ),
          SizedBox(height: 12),
          Text(
            'Üçüncü Taraf Hizmetler',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'Şu an için uygulama içinde reklam, analitik veya benzeri üçüncü taraf takip araçları kullanılmamaktadır. '
            'Gelecekte böyle bir entegrasyon yapılması durumunda, gizlilik politikası güncellenecektir.',
            style: TextStyle(fontSize: 15, height: 1.4),
          ),
          SizedBox(height: 12),
          Text(
            'Veri Güvenliği',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'Uygulama, sadece cihaz üzerinde çalışan bir referans ve hesaplama aracıdır. '
            'Herhangi bir sunucuya veri göndermediği için, kullanıcı verilerinin üçüncü kişilere satılması veya '
            'paylaşılması söz konusu değildir.',
            style: TextStyle(fontSize: 15, height: 1.4),
          ),
          SizedBox(height: 12),
          Text(
            'İletişim',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'Gizlilik politikası ile ilgili sorularınız için:\n'
            'E-posta: emirbayrak001@gmail.com',
            style: TextStyle(fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }
}
