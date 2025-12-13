import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AdMobBanner extends StatefulWidget {
  const AdMobBanner({super.key});

  @override
  State<AdMobBanner> createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<AdMobBanner> {
  BannerAd? _banner;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) return; // webde banner gösterme

    _banner = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-6404557439064466/7717760726',
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          // İstersen debug için print:
          // debugPrint('Banner failed: $error');
          if (!mounted) return;
          setState(() {
            _banner = null;
            _isLoaded = false;
          });
        },
      ),
    );

    _banner!.load();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || _banner == null || !_isLoaded) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: _banner!.size.width.toDouble(),
      height: _banner!.size.height.toDouble(),
      child: AdWidget(ad: _banner!),
    );
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }
}
