import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_footer.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/screens/profile_screen.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:sizer/sizer.dart";

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dribla_app_v2/providers/auth_providers.dart';

class MainPageScreen extends HookConsumerWidget {
  const MainPageScreen({super.key});

  static String getFinalAsset(int character, int outfit, int shoes) {
    return "assets/avatars/avatar_0${character + 1}/avatar_0${character + 1}_clothes_0${outfit + 1}_shoes_0${shoes + 1}.png";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final isAuthExpired = ref.watch(isAuthExpiredProvider);
    final auth = ref.watch(authNotifierProvider);
    String? username = auth.value?.accessToken.preferred_username ?? "";
    final characterType = useState<int>(0);
    final outfitType = useState<int>(0);
    final shoesType = useState<int>(0);
    final gamesPlayed = useState<int>(0);
    final timeSpent = useState<String>("");

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
              .getUserProfile(userProfileId!);
          if (profile != null) {
            if (!context.mounted) return;
            characterType.value = (profile.characterType ?? 0);
            outfitType.value = (profile.characterOutfitType ?? 0);
            shoesType.value = (profile.characterShoesType ?? 0);
          }
          if (!context.mounted) return;
          final gameSessions = await ref
              .read(authNotifierProvider.notifier)
              .getGameSessionsForUser(userProfileId);
          if (!context.mounted) return;
          gamesPlayed.value = gameSessions.length;
          if (!context.mounted) return;
          final totalGameSummary = await ref
              .read(authNotifierProvider.notifier)
              .getAllTimeGameSessionSummaryForUser(userProfileId);
          if (totalGameSummary != null) {
            if (!context.mounted) return;
            int time = totalGameSummary.totalDuration ?? 0;
            int hours = time ~/ 3600;
            int minutes = (time % 3600) ~/ 60;
            timeSpent.value = '${hours}${loc.hoursCounter} ${minutes}m';
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 5.w),
                      Text(username, style: theme.textTheme.headlineMedium),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                    child: Center(
                      child: Image.asset(
                          getFinalAsset(characterType.value, outfitType.value,
                              shoesType.value),
                          width: 60.w,
                          height: 60.w),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      SizedBox(width: 5.w),
                      Expanded(
                        flex: 1,
                        child: Text(
                          loc.totalHours,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          timeSpent.value,
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 5.w),
                      Expanded(
                        flex: 1,
                        child: Text(
                          loc.gamesPlayed,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          gamesPlayed.value.toString(),
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
                        loc.viewMore,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
        ],
      ),
    );
  }
}
