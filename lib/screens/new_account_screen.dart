import "package:dribla_api/dribla_api.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/screens/payments_screen.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:sizer/sizer.dart";

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dribla_app_v2/providers/auth_providers.dart';

class NewAccountScreen extends HookConsumerWidget {
  const NewAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final isAuthExpired = ref.watch(isAuthExpiredProvider);
    final auth = ref.watch(authNotifierProvider);
    String? username = auth.value?.accessToken.preferred_username ?? "";
    final userProfileId = auth.value?.accessToken.sub;
    final isProfileLoaded = useState<bool>(false);

    useEffect(() {
      Future<void> fetchProfile() async {
        if (isAuthExpired) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
        }
        if (auth.hasValue && auth.value != null) {
          if (!context.mounted) return;
          final profile = await ref
              .read(authNotifierProvider.notifier)
              .getOrUpsertUserProfile(userProfileId!);
          if (profile != null) {
            isProfileLoaded.value = true;
            if (profile.subscriptionStatus == true) {
              Navigator.pushReplacementNamed(context, '/main');
            }
          }
        }
      }

      fetchProfile();
      return null;
    }, [isAuthExpired]);

    if (isProfileLoaded.value == false) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: const ConnectionStatusAppBar(shouldShowMenu: false),
      extendBodyBehindAppBar: false,
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
                  SizedBox(height: 1.h),
                  Text(loc.welcome, style: theme.textTheme.headlineMedium),
                  Text(username, style: theme.textTheme.bodyMedium),
                  SizedBox(height: 2.h),
                  Text(loc.enterAppCodeOrSubscribe,
                      style: theme.textTheme.bodyMedium),
                  SizedBox(height: 2.h),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: loc.enterAppCode,
                    ),
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (value) async {
                      // save the app code to userprofile
                      AppCodeRegistrationRequest appCodeRegistrationRequest =
                          AppCodeRegistrationRequest((b) => b..code = value);
                      final isCodeRegistrationSuccessful = await ref
                          .read(authNotifierProvider.notifier)
                          .tryUpdateUserProfileAppCode(
                              userProfileId!, appCodeRegistrationRequest);
                      if (isCodeRegistrationSuccessful) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(loc.codeRegistrationSuccessful),
                          ),
                        );
                        Navigator.pushReplacementNamed(context, '/main');
                      } else {
                        // show error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(loc.codeRegistrationFailed),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PaymentsScreen()),
                        );
                      },
                      child: Text(
                        loc.createNewSub,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(authNotifierProvider.notifier).logout();
                      },
                      child: Text(
                        loc.logoutButton,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
