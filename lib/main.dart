import "package:dribla_app_v2/audio_players.dart";
import "package:dribla_app_v2/permission_utils.dart";
import "package:dribla_app_v2/screens/choose_game_screen.dart";
import "package:dribla_app_v2/screens/permissions_screen.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:permission_handler/permission_handler.dart";
import "package:wakelock_plus/wakelock_plus.dart";
import "package:sizer/sizer.dart";

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
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            textTheme: TextTheme(
              headlineSmall: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontFamily: "Nunito",
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontSize: 15.0.sp,
              ),
              headlineMedium: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontFamily: "Nunito",
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontSize: 23.0.sp,
              ),
              headlineLarge: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontFamily: "Nunito",
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontSize: 51.0.sp,
              ),
              bodySmall: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontFamily: "Nunito",
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontSize: 11.0.sp,
              ),
            ),
            elevatedButtonTheme: const ElevatedButtonThemeData(
              style: ButtonStyle(
                minimumSize: MaterialStatePropertyAll(Size(108, 54)),
                shape: MaterialStatePropertyAll(ContinuousRectangleBorder()),
                elevation: MaterialStatePropertyAll(0),
                backgroundColor: MaterialStatePropertyAll(Colors.red),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                textStyle: MaterialStatePropertyAll(TextStyle(
                  decoration: TextDecoration.none,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontSize: 28.0,
                )),
              ),
            ),
            outlinedButtonTheme: const OutlinedButtonThemeData(
              style: ButtonStyle(
                minimumSize: MaterialStatePropertyAll(Size(108, 54)),
                side: MaterialStatePropertyAll(
                    BorderSide(color: Colors.white, width: 3)),
                shape: MaterialStatePropertyAll(ContinuousRectangleBorder()),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                textStyle: MaterialStatePropertyAll(TextStyle(
                  decoration: TextDecoration.none,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontSize: 28.0,
                )),
              ),
            ),
            dialogTheme: const DialogTheme(
              elevation: 0,
              backgroundColor: Colors.transparent,
              shape: ContinuousRectangleBorder(),
              titleTextStyle: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontFamily: "Nunito",
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontSize: 28.0,
              ),
              contentTextStyle: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontFamily: "Nunito",
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontSize: 16.0,
              ),
            ),
            sliderTheme: const SliderThemeData(
              thumbColor: Colors.red,
              activeTrackColor: Colors.redAccent,
            ),
            dropdownMenuTheme: const DropdownMenuThemeData(
              inputDecorationTheme: InputDecorationTheme(
                constraints: BoxConstraints.expand(height: 54.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                suffixIconColor: Colors.white,
              ),
              menuStyle: MenuStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white),
                elevation: MaterialStatePropertyAll(0),
                shape: MaterialStatePropertyAll(
                  ContinuousRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
              textStyle: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontFamily: "Nunito",
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontSize: 16.0,
              ),
            ),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: permissionStatuses.values
                  .every((permission) => permission.isGranted)
              ? const ChooseGameScreen()
              : const PermissionsScreen(),
        );
      },
    );
  }
}
