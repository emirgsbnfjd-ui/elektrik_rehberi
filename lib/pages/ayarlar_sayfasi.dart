import 'package:flutter/material.dart';

class AyarlarSayfasi extends StatelessWidget {
  const AyarlarSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Karanlık Mod'),
            subtitle: Text('Uygulama temasını değiştirir'),
          ),
          ListTile(
            leading: Icon(Icons.calculate),
            title: Text('Hesaplayıcılar'),
            subtitle: Text('Ohm ve Güç hesaplama araçları'),
          ),
        ],
      ),
    );
  }
}
