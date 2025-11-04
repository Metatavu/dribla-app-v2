import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_footer.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/screens/profile_screen.dart";
import "package:dribla_app_v2/theme/theme.dart";
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
    final userProfileId = auth.value?.accessToken.sub ?? "";
    final subscriptionStatus = useState<bool>(false);

    useEffect(() {
      Future<void> fetchProfile() async {
        if (isAuthExpired) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
        }
        if (auth.hasValue && auth.value != null) {
          final userProfileId = auth.value?.accessToken.sub;
          final profile = await ref
              .read(authNotifierProvider.notifier)
              .getOrUpsertUserProfile(userProfileId!);
          if (profile != null) {
            // Do something with the profile if needed
            subscriptionStatus.value = profile.subscriptionStatus ?? false;
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
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.codes, style: theme.textTheme.headlineMedium),
                  Text(username, style: theme.textTheme.bodyMedium),
                  SizedBox(height: 2.h),
                  Text(fromPurchase ? loc.thanksForPurchase : ''),
                  Text(loc.herePlayerCodes, style: theme.textTheme.bodyMedium),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'F2165954-0628-45A0-8164-B12217871A08',
                          style: theme.textTheme.bodySmall,
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.share),
                          onPressed: () {
                            SharePlus.instance.share(ShareParams(
                                text: 'F2165954-0628-45A0-8164-B12217871A08'));
                          },
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'DAB6BB3B-2C8C-48F4-9E39-5A1A9913F9AE',
                          style: theme.textTheme.bodySmall,
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.share),
                          onPressed: () {
                            SharePlus.instance.share(ShareParams(
                                text: 'DAB6BB3B-2C8C-48F4-9E39-5A1A9913F9AE'));
                          },
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'DD172171-5AA6-4591-B399-EDF043C88113',
                          style: theme.textTheme.bodySmall,
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.share),
                          onPressed: () {
                            SharePlus.instance.share(ShareParams(
                                text: 'DD172171-5AA6-4591-B399-EDF043C88113'));
                          },
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(fromPurchase ? loc.findCodesLater : ''),
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
                  fromPurchase ? Text('') : Text(loc.appCodeExplanation),
                  SizedBox(height: 2.h),
                  fromPurchase
                      ? Text('')
                      : TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: loc.enterAppCode,
                          ),
                          style: const TextStyle(color: Colors.white),
                          onSubmitted: (value) async {
                            // save the app code to userprofile
                            await ref
                                .read(authNotifierProvider.notifier)
                                .updateUserProfileAppCode(userProfileId, value);
                          },
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
