import 'dart:async';
import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_header_appbar.dart";
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
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    super.initState();
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

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            _deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void _showPendingUI() {
    // Show UI to indicate that the purchase is pending.
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // Implement your purchase verification logic here.
    return true; // For simplicity, we assume all purchases are valid.
  }

  void _deliverProduct(PurchaseDetails purchaseDetails) {
    // Deliver the product to the user.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Product delivered: ${purchaseDetails.productID}')),
    );
  }

  void _handleError(IAPError error) {
    // Handle the error appropriately.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Purchase error: ${error.message}')),
    );
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // Handle invalid purchase here.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invalid purchase: ${purchaseDetails.productID}')),
    );
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
      appBar: const AppHeaderAppBar(),
      drawer: const AppDrawer(),
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
