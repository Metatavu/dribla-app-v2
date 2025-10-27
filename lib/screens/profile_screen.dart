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
import "package:dribla_app_v2/services/api.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:dribla_app_v2/game_utils.dart";
import "package:dribla_app_v2/screens/choose_game_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_swiper_plus/flutter_swiper_plus.dart";
import "package:sizer/sizer.dart";

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dribla_app_v2/providers/auth_providers.dart';

import "package:dribla_api/src/model/user_profile.dart";

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
    String? userProfileId = auth.value?.accessToken.sub;
    String? username = auth.value?.accessToken.preferred_username;
    final characterType = useState<int>(0);
    final outfitType = useState<int>(0);
    final shoesType = useState<int>(0);
    print('user prof. id - profile screen');
    print(userProfileId);

    useEffect(() {
      Future<void> fetchProfile() async {
        if (isAuthExpired) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
        }
        if (auth.hasValue && auth.value != null) {
          print('User in profile screen: ${auth.value.toString()}');
          final userProfileId = auth.value?.accessToken.sub;
          final profile = await ref
              .read(authNotifierProvider.notifier)
              .getOrUpsertUserProfile(userProfileId!);
          if (profile != null) {
            print('profile fetched, updating character info');
            characterType.value = profile.characterType!;
            outfitType.value = profile.characterOutfitType!;
            shoesType.value = profile.characterShoesType!;
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
                  Text(loc.profile, style: theme.textTheme.headlineMedium),
                  Text(username!, style: theme.textTheme.bodyMedium),
                  Image.asset(
                      getFinalAsset(characterType.value, outfitType.value,
                          shoesType.value),
                      width: 40.w,
                      height: 40.w),
                  SizedBox(height: 2.h),
                  Text('${loc.level} 100', style: theme.textTheme.bodyMedium),
                  Text(loc.challengeCoins, style: theme.textTheme.bodySmall),
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
                          '9001',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          loc.challengesCompleted,
                          style: theme.textTheme.bodySmall,
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(
                          '795',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          loc.mostPlayedGame,
                          style: theme.textTheme.bodySmall,
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(
                          'The Pit',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
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
                          'The Pit',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
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
                          '1y 5m 8d 12h 15m',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
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
                    height: 3.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        print('Logging out');
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
          const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
        ],
      ),
    );
  }
}
