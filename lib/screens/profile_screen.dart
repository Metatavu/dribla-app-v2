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

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final isAuthExpired = ref.watch(isAuthExpiredProvider);

    useEffect(() {
      if (isAuthExpired) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/login');
        });
      }
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Profile', style: theme.textTheme.headlineMedium),
                  Text('Username', style: theme.textTheme.bodyMedium),
                  Image.asset('assets/profile_pic_temp.png',
                      width: 30.w, height: 30.w),
                  SizedBox(height: 2.h),
                  Text('Level 100', style: theme.textTheme.bodyMedium),
                  Text('Challenge coins', style: theme.textTheme.bodySmall),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Games played',
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
                          'Challenges completed',
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
                          'Most played game',
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
                          'Recent game',
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
                          'Total time spent',
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
                        //print('Todo invite to team');
                      },
                      child: Text(
                        'Invite to team',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
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
