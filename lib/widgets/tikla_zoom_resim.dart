import 'package:flutter/material.dart';

class ZoomluResimSayfa extends StatelessWidget {
  final String assetPath;
  final String? title;

  const ZoomluResimSayfa({
    super.key,
    required this.assetPath,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(title ?? 'Resim'),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 5,
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

class TiklaZoomResim extends StatelessWidget {
  final String assetPath;
  final String? aciklama;
  final BorderRadius borderRadius;

  const TiklaZoomResim({
    super.key,
    required this.assetPath,
    this.aciklama,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // InkWell için şart gibi düşün
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ZoomluResimSayfa(
                assetPath: assetPath,
                title: aciklama,
              ),
            ),
          );
        },
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            ClipRRect(
              borderRadius: borderRadius,
              child: Image.asset(
                assetPath,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.zoom_in, size: 16, color: Colors.white),
                    SizedBox(width: 6),
                    Text('Tıkla', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
