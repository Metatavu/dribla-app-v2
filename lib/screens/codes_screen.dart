import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_footer.dart";
import "package:dribla_app_v2/components/app_header_appbar.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/components/game_icon.dart";
import "package:dribla_app_v2/components/game_settings_dialog.dart";
import "package:dribla_app_v2/components/styled_dialog.dart";
import "package:dribla_app_v2/components/styled_elevated_button.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/screens/character_creation_screen.dart";
import "package:dribla_app_v2/screens/outfit_selection_screen.dart";
import "package:dribla_app_v2/screens/profile_screen.dart";
import "package:dribla_app_v2/services/api.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:dribla_app_v2/game_utils.dart";
import "package:dribla_app_v2/screens/choose_game_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_swiper_plus/flutter_swiper_plus.dart";
import "package:sizer/sizer.dart";
import 'package:share_plus/share_plus.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dribla_app_v2/providers/auth_providers.dart';

import "package:dribla_api/src/model/user_profile.dart";

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
    final gamesPlayed = useState<int>(0);
    final latestGame = useState<String>("");
    final totalTimeSpent = useState<String>("");

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
          }
          final gameSessions = await ref
              .read(authNotifierProvider.notifier)
              .getGameSessionsForUser(userProfileId);
          gamesPlayed.value = gameSessions.length;
          final latestSession = await ref
              .read(authNotifierProvider.notifier)
              .getLatestGameSessionForUser(userProfileId);
          if (latestSession != null) {
            latestGame.value = latestSession.game ?? "";
          }
          final totalGameSummary = await ref
              .read(authNotifierProvider.notifier)
              .getAllTimeGameSessionSummaryForUser(userProfileId);
          if (totalGameSummary != null) {
            int time = totalGameSummary.totalDuration ?? 0;
            int hours = time ~/ 3600;
            int minutes = (time % 3600) ~/ 60;
            int seconds = time % 60;
            totalTimeSpent.value =
                '${hours}${loc.hoursCounter} ${minutes}m ${seconds}s';
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
                  Text('Here you can find your purchased player codes:',
                      style: theme.textTheme.bodyMedium),
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
                        'Back to profile',
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
