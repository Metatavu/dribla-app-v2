import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PaymentsScreen extends StatefulWidget {
  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(_onPurchaseUpdated, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // Handle error here.
    });
    _initialize();
  }

  Future<void> _initialize() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      setState(() {
        _loading = false;
      });
      return;
    }
    const Set<String> _kIds = {
      'sample_product_1',
      'sample_product_2',
      'sample_product_3',
      'sample_product_4',
      'sample_product_5'
    };
    final ProductDetailsResponse response =
        await _iap.queryProductDetails(_kIds);
    setState(() {
      _products = response.productDetails;
      _loading = false;
    });
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        // Verify purchase and deliver product.
        // For now, just complete the purchase.
        print('purchase successful: ${purchase.productID}');
        _iap.completePurchase(purchase);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase successful: ${purchase.productID}')),
        );
      } else if (purchase.status == PurchaseStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase error: ${purchase.error}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _buyProduct(ProductDetails productDetails) {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Payments')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('Payments')),
      body: _products.isEmpty
          ? Center(child: Text('No products available'))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text(product.description),
                  trailing: TextButton(
                    child: Text(product.price),
                    onPressed: () => _buyProduct(product),
                  ),
                );
              },
            ),
    );
  }
}
