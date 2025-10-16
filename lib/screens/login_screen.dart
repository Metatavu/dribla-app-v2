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
import "package:url_launcher/url_launcher_string.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dribla_app_v2/providers/auth_providers.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final authAsync = ref.watch(authNotifierProvider);

    // Optionally, navigate on successful login
    useEffect(() {
      if (authAsync.hasValue && authAsync.value != null) {
        print('User logged in: ${authAsync.value.toString()}');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('/main');
        });
      }
      return null;
    }, [authAsync.value]);

    return Scaffold(
        extendBodyBehindAppBar: false,
        //appBar: const AppHeaderAppBar(),
        //drawer: const AppDrawer(),
        // TODO if there is too much content, make body scrollable
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
                    Text('Login', style: theme.textTheme.headlineMedium),
                    Text('todo text', style: theme.textTheme.bodyMedium),
                    Image.asset('assets/profile_pic_temp.png',
                        width: 30.w, height: 30.w),
                    SizedBox(height: 2.h),
                    Text('Please log in to continue',
                        style: theme.textTheme.bodySmall),
                    SizedBox(height: 2.h),
                    SizedBox(
                      height: 3.h,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authAsync.isLoading
                            ? null
                            : () async {
                                await ref
                                    .read(authNotifierProvider.notifier)
                                    .login();
                              },
                        child: authAsync.isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                'Login',
                                style: theme.textTheme.bodyMedium,
                              ),
                      ),
                    ),
                    if (authAsync.hasError)
                      Text('Login failed: ${authAsync.error}',
                          style: TextStyle(color: Colors.red)),
                  ],
                )),
          ),
          //const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
          //const AppFooter(),
        ]));
  }
}
