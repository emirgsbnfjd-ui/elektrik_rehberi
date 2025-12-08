import 'package:flutter/material.dart';

class HakkindaSayfasi extends StatelessWidget {
  const HakkindaSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hakkında")),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: const [
          Text(
            "Elektrik Elektronik Rehberi",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),

          Text(
            "Elektrik Elektronik Rehberi; elektrik teknisyenleri, mühendis adayları, elektronik meraklıları ve "
            "otomasyon alanında çalışanlar için hazırlanmış kapsamlı bir bilgi, hesaplama ve hızlı erişim aracıdır.",
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
          SizedBox(height: 16),

          Text(
            "Uygulama; Ohm Kanunu, güç hesaplama, direnç renk kodu, gerilim düşümü gibi teknik hesaplayıcılarla "
            "saha çalışmalarını kolaylaştırır. Elektrik, elektronik ve otomasyon kategorilerinde çok sayıda mini rehber içerir.",
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
          SizedBox(height: 16),

          Text(
            "Amacımız, teknik çalışanların ve öğrencilerin ihtiyaç duyduğu temel bilgilere hızlı ve güvenilir biçimde "
            "erişmesini sağlamak, böylece zaman kaybını azaltmak ve iş verimini artırmaktır.",
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
          SizedBox(height: 16),

          Text(
            "Uygulama tamamen çevrimdışı çalışır. Kullanıcıdan herhangi bir kişisel veri toplamaz, saklamaz veya üçüncü "
            "taraflarla paylaşmaz.",
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
          SizedBox(height: 24),

          Text(
            "Geliştirici: Emir Bayrak\nBYRK Elektrik",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
