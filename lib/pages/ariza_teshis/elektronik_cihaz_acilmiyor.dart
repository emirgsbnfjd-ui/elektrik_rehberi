import 'package:flutter/material.dart';

class ElektronikCihazAcilmiyorSayfa extends StatelessWidget {
  const ElektronikCihazAcilmiyorSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔌 Cihaz Hiç Açılmıyor')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Olası Nedenler',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('• Adaptör çıkışı yok'),
          Text('• Güç kartı arızalı'),
          Text('• Batarya tamamen bitmiş'),
          Text('• Güç tuşu veya flex kablo arızalı'),

          SizedBox(height: 16),

          Text(
            'Kontrol Et',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('• Farklı adaptör dene'),
          Text('• Multimetre ile çıkış ölç'),
          Text('• Batarya gerilimini kontrol et'),

          SizedBox(height: 16),

          Text(
            'Çözüm',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            'Sorun devam ediyorsa güç kartı veya entegre seviyesinde arıza olabilir. '
            'Elektronik servis müdahalesi gerekir.',
          ),
        ],
      ),
    );
  }
}
