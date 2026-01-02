import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DestekOlSayfasi extends StatelessWidget {
  const DestekOlSayfasi({super.key});

  static const String _mail = 'emirbayrak001@gmail.com';

  // ✅ Android: packageName otomatik alınıyor (çoğu durumda)
  // ✅ iOS: App Store ID gerekiyor (App Store Connect’te görünüyor)
  static const String _iosAppStoreId = '6754992222';

  Future<void> _storeAc() async {
    final inAppReview = InAppReview.instance;

    // isAvailable true ise store listing açabilir
    if (await inAppReview.isAvailable()) {
      // iOS’ta appStoreId önemli. Android’de çoğu zaman gerekmez.
      await inAppReview.openStoreListing(
        appStoreId: _iosAppStoreId == 'YOUR_APPSTORE_ID' ? null : _iosAppStoreId,
      );
    }
  }

  Future<void> _paylas(BuildContext context) async {
    // İstersen buraya Google Play / App Store linkini koy (en iyisi)
    const text =
        'Elektrik Elektronik Rehberi uygulamamıza göz atar mısın? ⚡\n'
        'Geri bildirimlerin çok değerli 🙏';

    await Share.share(
      text,
      subject: 'Elektrik Elektronik Rehberi',
    );
  }

  Future<void> _mailGonder() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _mail,
      queryParameters: {
        'subject': 'Elektrik Elektronik Rehberi - Geri Bildirim',
        'body': 'Merhaba Emir,\n\nUygulama hakkında geri bildirimim:\n',
      },
    );

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Geliştiriciye Destek Ol')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🙏 Destek olmanın en iyi yolu',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Uygulamayı puanlamak\n'
                    '• Arkadaşlarınla paylaşmak\n'
                    '• Hata/öneri göndermek\n\n'
                    'Bu üçü store tarafında en risksiz ve en etkili destek.',
                    style: TextStyle(height: 1.35),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          ListTile(
            leading: const Icon(Icons.star_rate),
            title: const Text('Uygulamayı Puanla'),
            subtitle: const Text('Store sayfasını açar'),
            onTap: _storeAc,
          ),
          const Divider(height: 0),

          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Paylaş'),
            subtitle: const Text('Link/mesaj ile paylaş'),
            onTap: () => _paylas(context),
          ),
          const Divider(height: 0),

          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Geri Bildirim Gönder'),
            subtitle: const Text('E-posta ile öneri/hata bildir'),
            onTap: _mailGonder,
          ),
        ],
      ),
    );
  }
}
