import 'dart:async';
import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_footer.dart";
import "package:dribla_app_v2/components/app_header_appbar.dart";
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import "package:sizer/sizer.dart";

class PaymentsScreen extends StatefulWidget {
  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  ProductDetails? _defaultSubscription;
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
      'sample_product_5',
      'basic_test_sub',
    };
    final ProductDetailsResponse response =
        await _iap.queryProductDetails(_kIds);
    setState(() {
      _products = response.productDetails;
      _defaultSubscription =
          _products.firstWhere((product) => product.id == 'basic_test_sub');
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

  void _buySubscription() {
    ProductDetails productDetails = _defaultSubscription!;
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    try {
      print('Attempting to buy subscription: ${productDetails.id}');
      _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      print('Error during purchase attempt: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Payments')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: const AppHeaderAppBar(),
      drawer: const AppDrawer(),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/dribla_new_background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Buy a subscription',
                      style: theme.textTheme.headlineMedium),
                  Text(
                      'Join now for early access and get up to 6 months of free play time!',
                      style: theme.textTheme.bodyMedium),
                  Image.asset('assets/promo_image_mat.jpg', height: 60.w),
                  SizedBox(height: 2.h),
                  Text(
                      'First 6 months free, then first 12 months for \$39.90. After first year only \$19.90!',
                      style: theme.textTheme.bodyMedium),
                  SizedBox(height: 2.h),
                  SizedBox(
                    height: 3.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _buySubscription();
                      },
                      child: Text(
                        'Subscribe now',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              )),
        ),
        const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
        //const AppFooter(),
      ]),
    );
  }

/*
_products.isEmpty
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
*/
}
