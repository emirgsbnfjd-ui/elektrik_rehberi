import 'package:flutter/material.dart';

class PremiumSayfasi extends StatelessWidget {
  const PremiumSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(Icons.workspace_premium, size: 64),
          const SizedBox(height: 12),
          Text(
            'Reklamları Kaldır',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tek sefer ödeme ile uygulamayı reklamsız kullan.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Premium ile:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('✅ Banner reklamlar kalkar'),
                  Text('✅ Tam ekran reklamlar kalkar'),
                  Text('✅ Daha hızlı kullanım'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Satın alma sistemi yakında eklenecek.')),
              );
            },
            child: const Text('Satın Al (Tek Sefer)'),
          ),

          const SizedBox(height: 8),

          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Satın almaları geri yükleme yakında.')),
              );
            },
            child: const Text('Satın Almaları Geri Yükle'),
          ),

          const SizedBox(height: 12),
          Text(
            'Satın alma Apple / Google hesabın ile doğrulanır.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
