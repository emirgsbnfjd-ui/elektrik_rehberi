import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class DestekOlSayfasi extends StatefulWidget {
  const DestekOlSayfasi({super.key});

  @override
  State<DestekOlSayfasi> createState() => _DestekOlSayfasiState();
}

class _DestekOlSayfasiState extends State<DestekOlSayfasi> {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  static const Set<String> _productIds = {
    'support_25',
    'support_50',
    'support_100',
  };

  List<ProductDetails> _products = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
    _sub = _iap.purchaseStream.listen(_onPurchaseUpdate);
  }

  Future<void> _init() async {
    final available = await _iap.isAvailable();
    if (!available) {
      setState(() {
        _error = "Satın alma servisi kullanılamıyor.";
        _loading = false;
      });
      return;
    }

    final response = await _iap.queryProductDetails(_productIds);

    if (response.error != null || response.productDetails.isEmpty) {
      setState(() {
        _error =
            "Ürünler bulunamadı. Play Console ürünleri aktif mi?";
        _loading = false;
      });
      return;
    }

    setState(() {
      _products = response.productDetails
        ..sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
      _loading = false;
    });
  }

  void _buy(ProductDetails product) {
    final param = PurchaseParam(productDetails: product);
    _iap.buyConsumable(
      purchaseParam: param,
      autoConsume: true,
    );
  }

  Future<void> _onPurchaseUpdate(
      List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("🙏 Teşekkürler, desteğin alındı!")),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("⭐ Geliştiriciye Destek Ol")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      "Destek tamamen isteğe bağlıdır.\n"
                      "Uygulamanın tüm özellikleri ücretsizdir.",
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 16),
                    ..._products.map((p) => Card(
                          child: ListTile(
                            title: Text(p.title),
                            subtitle: Text(p.description),
                            trailing: Text(p.price),
                            onTap: () => _buy(p),
                          ),
                        )),
                  ],
                ),
    );
  }
}
