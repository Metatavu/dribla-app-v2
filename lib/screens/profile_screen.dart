import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_footer.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/screens/character_creation_screen.dart";
import "package:dribla_app_v2/screens/codes_screen.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:sizer/sizer.dart";

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dribla_app_v2/providers/auth_providers.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

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
    final latestGame = useState<String>("");
    final totalTimeSpent = useState<String>("");
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
            if (!context.mounted) return;
            characterType.value = (profile.characterType ?? 0);
            outfitType.value = (profile.characterOutfitType ?? 0);
            shoesType.value = (profile.characterShoesType ?? 0);
            userAppCodes.value = profile.ownedAppCodes ?? [];
          }
          if (!context.mounted) return;
          final gameSessions = await ref
              .read(authNotifierProvider.notifier)
              .getGameSessionsForUser(userProfileId);
          gamesPlayed.value = gameSessions.length;
          if (!context.mounted) return;
          final latestSession = await ref
              .read(authNotifierProvider.notifier)
              .getLatestGameSessionForUser(userProfileId);
          if (latestSession != null) {
            if (!context.mounted) return;
            switch (latestSession.game) {
              case 'game_snake':
                latestGame.value = loc.snake;
                break;
              case 'game_tengame':
                latestGame.value = loc.tengame;
                break;
              case 'game_tengame_multiplayer':
                latestGame.value = loc.tengameMultiplayer;
                break;
              case 'game_tenturns':
                latestGame.value = loc.tenturns;
                break;
              case 'game_pick_berries':
                latestGame.value = loc.pickBerries;
                break;
              case 'game_envelope':
                latestGame.value = loc.envelope;
                break;
              case 'game_zigzag':
                latestGame.value = loc.zigzag;
                break;
              case 'game_star_game':
                latestGame.value = loc.starGameText;
                break;
              case 'game_memory_game':
                latestGame.value = loc.memoryGame;
                break;
              default:
                latestGame.value = latestSession.game ?? "";
            }
          }
          if (!context.mounted) return;
          final totalGameSummary = await ref
              .read(authNotifierProvider.notifier)
              .getAllTimeGameSessionSummaryForUser(userProfileId);
          if (totalGameSummary != null) {
            if (!context.mounted) return;
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
              padding: EdgeInsets.fromLTRB(32.0, 0, 32.0, 32.0),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                        child: Column(children: [
                          Text(loc.profile,
                              style: theme.textTheme.headlineMedium),
                          SizedBox(height: 1.h),
                          Text(username, style: theme.textTheme.headlineSmall),
                        ]),
                        width: 25.w),
                    Container(
                      child: Column(children: [
                        SizedBox(height: 5.h),
                        Container(
                            child: Image.asset(
                          getFinalAsset(characterType.value, outfitType.value,
                              shoesType.value),
                          height: 28.h,
                          fit: BoxFit.contain,
                        ))
                      ]),
                      width: 45.w,
                      margin: EdgeInsets.only(left: 13.w),
                    ),
                  ]),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          loc.gamesPlayed,
                          style: theme.textTheme.bodySmall,
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(
                          gamesPlayed.value.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontFamily: "Urbanist",
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0.sp,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          loc.recentGame,
                          style: theme.textTheme.bodySmall,
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(
                          latestGame.value,
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontFamily: "Urbanist",
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0.sp,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          loc.totalTimeSpent,
                          style: theme.textTheme.bodySmall,
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(
                          totalTimeSpent.value,
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontFamily: "Urbanist",
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0.sp,
                          ),
                          textAlign: TextAlign.right,
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        side: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CharacterCreationScreen()),
                        );
                      },
                      child: Text(
                        loc.editAvatar,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: userAppCodes.value.isNotEmpty
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CodesScreen(fromPurchase: false)),
                              );
                            },
                            child: Text(
                              loc.showCodes,
                              style: theme.textTheme.bodyMedium,
                            ),
                          )
                        : Container(),
                  ),
                  SizedBox(
                    height: 2.h,
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
                  SizedBox(height: 20.h),
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
