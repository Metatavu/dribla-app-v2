import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_footer.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/screens/profile_screen.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:dribla_app_v2/widgets/shareable_code_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:sizer/sizer.dart";
import 'package:share_plus/share_plus.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dribla_app_v2/providers/auth_providers.dart';

class CodesScreen extends HookConsumerWidget {
  const CodesScreen({super.key, required this.fromPurchase});

  final bool fromPurchase;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final isAuthExpired = ref.watch(isAuthExpiredProvider);
    final auth = ref.watch(authNotifierProvider);
    String? username = auth.value?.accessToken.preferred_username ?? "";
    final isSubscribed = useState<bool>(false);
    final userAppCodes = useState<Iterable<String>>([]);

    useEffect(() {
      Future<void> fetchProfile() async {
        if (isAuthExpired) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
        }
        if (auth.hasValue && auth.value != null) {
          final userProfileId = auth.value?.accessToken.sub;
          if (!context.mounted) return;
          final profile = await ref
              .read(authNotifierProvider.notifier)
              .getOrUpsertUserProfile(userProfileId!);
          if (profile != null) {
            isSubscribed.value = profile.subscriptionStatus ?? false;
            userAppCodes.value = profile.ownedAppCodes ?? [];
          }
        }
      }

      fetchProfile();
      return null;
    }, [isAuthExpired]);

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: const ConnectionStatusAppBar(),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/dribla_new_background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.codes, style: theme.textTheme.headlineMedium),
                  Text(username, style: theme.textTheme.headlineSmall),
                  SizedBox(height: 2.h),
                  Text(fromPurchase ? loc.thanksForPurchase : ''),
                  Text(userAppCodes.value.isNotEmpty ? loc.herePlayerCodes : '',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontFamily: "Urbanist",
                        fontWeight: FontWeight.w400,
                        fontSize: 17.0.sp,
                      )),
                  SizedBox(height: 2.h),
                  SizedBox(
                    height: 30.h,
                    child: ListView.builder(
                      itemCount: userAppCodes.value.length,
                      itemBuilder: (context, index) {
                        final code = userAppCodes.value.elementAt(index);
                        return Column(children: [
                          ShareableCodeWidget(
                            appCode: code,
                            onIconPressed: (appCode) {
                              SharePlus.instance
                                  .share(ShareParams(text: appCode));
                            },
                          ),
                          SizedBox(height: 2.h),
                        ]);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(fromPurchase ? loc.findCodesLater : '',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontFamily: "Urbanist",
                        fontWeight: FontWeight.w400,
                        fontSize: 17.0.sp,
                      )),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()),
                        );
                      },
                      child: Text(
                        loc.backToProfile,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  SizedBox(height: 50.h),
                ],
              )),
            ),
          ),
          const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
        ],
      ),
    );
  }
}
