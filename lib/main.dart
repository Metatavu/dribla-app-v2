import "package:dribla_app_v2/bluetooth/mock_bluetooth.dart";
import "package:dribla_app_v2/screens/choose_game_screen.dart";
import "package:dribla_app_v2/screens/index_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You"ll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn"t reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
  bool _btConnected = false;
  final BluetoothService _btService = BluetoothService();

  @override
  void initState() {
    super.initState();
    _btService.connect().then(
          (value) => setState(() {
            _btConnected = value;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: _btConnected ? const ChooseGameScreen() : const IndexScreen(),
    );
  }
}
