import 'dart:async';
import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_footer.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/screens/codes_screen.dart";
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import "package:sizer/sizer.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:dribla_app_v2/providers/auth_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PaymentsScreen extends HookConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthExpired = ref.watch(isAuthExpiredProvider);
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Payment state hooks
    final iap = InAppPurchase.instance;
    final products = useState<List<ProductDetails>>([]);
    final defaultSubscription = useState<ProductDetails?>(null);
    final loading = useState<bool>(true);
    final subscription =
        useRef<StreamSubscription<List<PurchaseDetails>>?>(null);

    // Listen to purchase updates
    useEffect(() {
      subscription.value = iap.purchaseStream.listen((purchaseDetailsList) {
        for (final purchaseDetails in purchaseDetailsList) {
          if (purchaseDetails.productID == 'basic_test_sub') {
            if (purchaseDetails.status == PurchaseStatus.pending) {
              // Show pending UI if needed
            } else {
              if (purchaseDetails.status == PurchaseStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Purchase error: ${purchaseDetails.error?.message ?? "Unknown error"}')),
                );
              } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                  purchaseDetails.status == PurchaseStatus.restored) {
                // For simplicity, assume all purchases are valid
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Product delivered: ${purchaseDetails.productID}')),
                );
              }
              if (purchaseDetails.pendingCompletePurchase) {
                InAppPurchase.instance.completePurchase(purchaseDetails);
              }
            }
          }
        }
      });
      return () {
        subscription.value?.cancel();
      };
    }, []);

    // Initialize products
    useEffect(() {
      Future.microtask(() async {
        final available = await iap.isAvailable();
        if (!available) {
          loading.value = false;
          return;
        }
        const Set<String> _kIds = {
          'basic_test_sub',
        };
        final response = await iap.queryProductDetails(_kIds);
        products.value = response.productDetails;
        defaultSubscription.value = response.productDetails
            .firstWhere((product) => product.id == 'basic_test_sub');
        loading.value = false;
      });
      return null;
    }, []);

    // Redirect if auth expired
    useEffect(() {
      if (isAuthExpired) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/login');
        });
      }
      return null;
    }, [isAuthExpired]);

    void buySubscription() {
      final productDetails = defaultSubscription.value;
      if (productDetails == null) return;
      final purchaseParam = PurchaseParam(productDetails: productDetails);
      try {
        iap.buyNonConsumable(purchaseParam: purchaseParam);
        // navigate to codes screen after purchase
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CodesScreen(fromPurchase: true)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during purchase attempt: $e')),
        );
      }
    }

    if (loading.value) {
      return Scaffold(
        appBar: AppBar(title: Text('Payments')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: const ConnectionStatusAppBar(),
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
                Text(loc.buySubscription,
                    style: theme.textTheme.headlineMedium),
                Text(loc.earlyAccess, style: theme.textTheme.bodyMedium),
                Image.asset('assets/promo_image_mat.jpg', height: 60.w),
                SizedBox(height: 2.h),
                Text(loc.subscribeInfo, style: theme.textTheme.bodyMedium),
                SizedBox(height: 2.h),
                SizedBox(
                  height: 3.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: buySubscription,
                    child: Text(
                      loc.subscribeNow,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
      ]),
    );
  }
}
