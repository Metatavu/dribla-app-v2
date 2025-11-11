import "package:dribla_app_v2/audio_players.dart";
import "package:dribla_app_v2/permission_utils.dart";
import "package:dribla_app_v2/providers/auth_providers.dart";
import "package:dribla_app_v2/screens/character_creation_screen.dart";
import "package:dribla_app_v2/screens/choose_game_screen.dart";
import "package:dribla_app_v2/screens/codes_screen.dart";
import "package:dribla_app_v2/screens/login_screen.dart";
import "package:dribla_app_v2/screens/main_page_screen.dart";
import "package:dribla_app_v2/screens/new_account_screen.dart";
import "package:dribla_app_v2/screens/payments_screen.dart";
import "package:dribla_app_v2/screens/permissions_screen.dart";
import "package:dribla_app_v2/screens/profile_screen.dart";
import "package:dribla_app_v2/screens/sign_in_screen.dart";
import "package:dribla_app_v2/screens/statistics_screen.dart";
import "package:dribla_app_v2/services/api.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:permission_handler/permission_handler.dart";
import "package:wakelock_plus/wakelock_plus.dart";
import "package:sizer/sizer.dart";
import "package:dribla_app_v2/theme/theme.dart";

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import "device_connection.dart";

late Map<Permission, PermissionStatus> permissionStatuses;

void main() async {
  // find user profile from api on startup or upsert a new one
  initDriblaApi();
  WidgetsFlutterBinding.ensureInitialized();
  permissionStatuses = await askAndCheckPermissionStatuses();
  runApp(
    ProviderScope(
      child: const DriblaApp(),
    ),
  );
}

class DriblaApp extends HookConsumerWidget {
  const DriblaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.microtask(() async {
        final auth = ref.read(authNotifierProvider);
        if (auth.value == null || auth.value!.isExpired) {
          await ref
              .read(authNotifierProvider.notifier)
              .tryLoginWithStoredToken();
        }
      });

      AudioPlayers.init();
      DeviceConnection.init();
      SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
      );
      WakelockPlus.enable();
      return () {
        AudioPlayers.deinit();
        WakelockPlus.disable();
        DeviceConnection.deinit();
      };
    }, const []);

    final isExpired = ref.watch(isAuthExpiredProvider);

    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: "Dribla App V2",
          debugShowCheckedModeBanner: false,
          theme: getTheme(context),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: permissionStatuses.values
                  .every((permission) => permission.isGranted)
              ? (isExpired ? const LoginScreen() : const NewAccountScreen())
              : const PermissionsScreen(),
          routes: {
            '/main': (context) => const MainPageScreen(),
            '/character': (context) => const CharacterCreationScreen(),
            '/games': (context) => const ChooseGameScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/payments': (context) => PaymentsScreen(),
            '/login': (context) => const LoginScreen(),
            '/statistics': (context) => const StatisticsScreen(),
            '/codes': (context) => const CodesScreen(fromPurchase: false),
            '/new_user': (context) => const NewAccountScreen(),
          },
        );
      },
    );
  }
}
