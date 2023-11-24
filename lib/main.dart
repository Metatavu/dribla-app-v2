import "dart:async";

import "package:dribla_app_v2/audio_players.dart";
import "package:dribla_app_v2/screens/choose_game_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

import "device_connection.dart";

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dribla App V2",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.none,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            fontSize: 28.0,
          ),
          headlineLarge: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.none,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            fontSize: 56.0,
          ),
          bodySmall: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.none,
            fontFamily: "Nunito",
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            fontSize: 16.0,
          ),
        ),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStatePropertyAll(ContinuousRectangleBorder()),
            backgroundColor: MaterialStatePropertyAll(Colors.red),
            shadowColor: MaterialStatePropertyAll(Colors.white),
          ),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const DriblaAppScreen(),
    );
  }
}

class DriblaAppScreen extends StatefulWidget {
  const DriblaAppScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DriblaAppScreenState();
}

class _DriblaAppScreenState extends State<DriblaAppScreen> {
  Future<void> _initApp() async {
    await AudioPlayers.init();
    DeviceConnection.init();
  }

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  @override
  void dispose() {
    super.dispose();
    AudioPlayers.deinit();
  }

  @override
  Widget build(BuildContext context) {
    return const ChooseGameScreen();
  }
}
