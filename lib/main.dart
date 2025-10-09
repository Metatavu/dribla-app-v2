import "package:dribla_app_v2/audio_players.dart";
import "package:dribla_app_v2/permission_utils.dart";
import "package:dribla_app_v2/screens/account_creation_screen.dart";
import "package:dribla_app_v2/screens/character_creation_screen.dart";
import "package:dribla_app_v2/screens/choose_game_screen.dart";
import "package:dribla_app_v2/screens/main_page_screen.dart";
import "package:dribla_app_v2/screens/payments_screen.dart";
import "package:dribla_app_v2/screens/permissions_screen.dart";
import "package:dribla_app_v2/screens/profile_screen.dart";
import "package:dribla_app_v2/screens/sign_in_screen.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:permission_handler/permission_handler.dart";
import "package:wakelock_plus/wakelock_plus.dart";
import "package:sizer/sizer.dart";
import "package:dribla_app_v2/theme/theme.dart";

import "device_connection.dart";

late Map<Permission, PermissionStatus> permissionStatuses;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  permissionStatuses = await askAndCheckPermissionStatuses();
  runApp(const DriblaApp());
}

class DriblaApp extends StatefulWidget {
  const DriblaApp({super.key});

  @override
  State<StatefulWidget> createState() => _DriblaAppState();
}

class _DriblaAppState extends State<DriblaApp> {
  @override
  void initState() {
    super.initState();
    AudioPlayers.init();
    DeviceConnection.init();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    WakelockPlus.enable();
  }

  @override
  void dispose() {
    AudioPlayers.deinit();
    WakelockPlus.disable();
    DeviceConnection.deinit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              ? const ChooseGameScreen()
              : const PermissionsScreen(),
          routes: {
            '/main': (context) => const MainPageScreen(),
            '/character': (context) => const CharacterCreationScreen(),
            '/games': (context) => const ChooseGameScreen(),
            '/login': (context) => const SignInScreen(),
            '/create_account': (context) => const AccountCreationScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/payments': (context) => PaymentsScreen(),
          },
        );
      },
    );
  }
}
