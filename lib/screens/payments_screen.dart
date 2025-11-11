import 'dart:async';
import "package:dribla_api/dribla_api.dart";
import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_footer.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/screens/codes_screen.dart";
import "package:dribla_app_v2/services/api.dart";
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import "package:sizer/sizer.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:dribla_app_v2/providers/auth_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:io' show Platform;

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
    final isSubscribed = useState<bool>(false);
    final auth = ref.watch(authNotifierProvider);
    final userProfileId = auth.value?.accessToken.sub ?? "";
    final platform = Platform.isIOS ? 'app_store' : 'google_play';

    Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
      // TODO: Implement real purchase verification logic here
      // final url = Uri.parse('http://$serverIp:8080/verifypurchase');
      // const headers = {
      //   'Content-type': 'application/json',
      //   'Accept': 'application/json',
      // };
      // final response = await http.post(
      //   url,
      //   body: jsonEncode({
      //     'source': purchaseDetails.verificationData.source,
      //     'productId': purchaseDetails.productID,
      //     'verificationData':
      //         purchaseDetails.verificationData.serverVerificationData,
      //     'userId': firebaseNotifier.user?.uid,
      //   }),
      //   headers: headers,
      // );
      // if (response.statusCode == 200) {
      //   return true;
      // } else {
      //   return false;
      // }
      //await driblaApi.getAppCodesApi().
      await Future.delayed(const Duration(seconds: 1));
      return true;
    }

    // Listen to purchase updates
    useEffect(() {
      subscription.value =
          iap.purchaseStream.listen((purchaseDetailsList) async {
        /*
          When the [PurchaseDetails.status] is [PurchaseStatus.purchased], [PurchaseStatus.restored] or [PurchaseStatus.error]
          you should deliver the content or handle the error, then call [completePurchase] to finish the purchasing process.
        */
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
              } else if (purchaseDetails.status == PurchaseStatus.purchased) {
                final isValid = await _verifyPurchase(purchaseDetails);
                if (isValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Product delivered: ${purchaseDetails.productID}')),
                  );
                  await Future.delayed(const Duration(seconds: 1));
                  AppCodeCreationRequest appCodeCreationRequest =
                      AppCodeCreationRequest((b) => b
                        ..store = platform
                        ..receipt = purchaseDetails
                            .verificationData.serverVerificationData);
                  print('creating request');

                  await driblaApi.getAppCodesApi().createAppCodes(
                      userProfileId: userProfileId,
                      appCodeCreationRequest: appCodeCreationRequest);
                  print('App codes created');
                  // await ref
                  //     .read(authNotifierProvider.notifier)
                  //     .createUserProfileAppCodes(
                  //         userProfileId, appCodeCreationRequest);
                  // will be set in backend only
                  // ref
                  //     .read(authNotifierProvider.notifier)
                  //     .updateUserProfileSubscriptionStatus(userProfileId, true);
                  iap.completePurchase(purchaseDetails);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CodesScreen(fromPurchase: true)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Purchase verification failed: ${purchaseDetails.productID}')),
                  );
                }
              } else if (purchaseDetails.status == PurchaseStatus.restored) {
                // if purchase is not completed or user hits buy button again
                // check if user is already subscribed, otherwise will resubscribe on retry
                final isValid = await _verifyPurchase(purchaseDetails);
                if (isValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Product delivered/restored: ${purchaseDetails.productID}')),
                  );
                  await Future.delayed(const Duration(seconds: 1));
                  AppCodeCreationRequest appCodeCreationRequest =
                      AppCodeCreationRequest((b) => b
                        ..store = platform
                        ..receipt = purchaseDetails
                            .verificationData.serverVerificationData);
                  print('creating request');
                  await driblaApi.getAppCodesApi().createAppCodes(
                      userProfileId: userProfileId,
                      appCodeCreationRequest: appCodeCreationRequest);
                  print('App codes created');
                  // ref
                  //     .read(authNotifierProvider.notifier)
                  //     .updateUserProfileSubscriptionStatus(userProfileId, true);
                  iap.completePurchase(purchaseDetails);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CodesScreen(fromPurchase: true)),
                  );
                }
              }
              if (purchaseDetails.pendingCompletePurchase) {
                print('Completing purchase for ${purchaseDetails.productID}');
                iap.completePurchase(purchaseDetails);
              }
            }
          }
        }
      });
      return () {
        subscription.value?.cancel();
      };
    }, []);

    // Initialize products and subscription status
    useEffect(() {
      Future.microtask(() async {
        final profile = await ref
            .read(authNotifierProvider.notifier)
            .getOrUpsertUserProfile(userProfileId!);
        if (profile != null) {
          isSubscribed.value = profile.subscriptionStatus ?? false;
        }
        final available = await iap.isAvailable();
        if (!available) {
          loading.value = false;
          return;
        }
        const Set<String> _productIds = {
          'basic_test_sub',
        };
        final response = await iap.queryProductDetails(_productIds);
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
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during purchase attempt: $e')),
        );
      }
    }

    void removeSubscription() {
      // debug function to remove subscription only from user profile
      ref
          .read(authNotifierProvider.notifier)
          .updateUserProfileSubscriptionStatus(userProfileId, false);
      isSubscribed.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subscription removed (debug)')),
      );
    }

    void navigateBack() {
      Navigator.pop(context);
    }

    if (loading.value) {
      return Scaffold(
        appBar: AppBar(title: Text('Payments')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      //appBar: const ConnectionStatusAppBar(),
      //drawer: const AppDrawer(),
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
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Text(loc.subscriptionHandling,
                    style: theme.textTheme.headlineMedium),
                Text(loc.earlyAccess, style: theme.textTheme.bodyMedium),
                Image.asset('assets/promo_image_mat.jpg', height: 60.w),
                SizedBox(height: 2.h),
                Text(loc.subscribeInfo, style: theme.textTheme.bodyMedium),
                SizedBox(height: 2.h),
                SizedBox(
                  height: 3.h,
                ),
                Text(isSubscribed.value == true
                    ? loc.subscriptionActive
                    : loc.subscriptionInactive),
                SizedBox(height: 4.h),
                isSubscribed.value == false
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: buySubscription,
                          child: Text(
                            isSubscribed.value == true
                                ? loc.renewSubscription
                                : loc.subscribeNow,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      )
                    : Text(''),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: removeSubscription,
                    child: Text(
                      'Remove subscription (debug)',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: navigateBack,
                    child: Text(
                      loc.backButtonText,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
                SizedBox(height: 25.h)
              ],
            )),
          ),
        ),
        //const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
      ]),
    );
  }
}
