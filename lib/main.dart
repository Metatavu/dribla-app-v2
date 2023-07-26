import "package:dribla_app_v2/screens/choose_game_screen.dart";
import "package:dribla_app_v2/screens/index_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_blue/flutter_blue.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

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
  bool _connected = false;

  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  BluetoothDevice? _selectedDevice;

  BluetoothCharacteristic? _sensorCharacteristic;
  BluetoothCharacteristic? _ledCharacteristic;

  void _showErrorDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(loc.unableToConnectTitle),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(loc.unableToConnectTitle),
                  Text(loc.unableToConnectBody),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _connect();
                  Navigator.of(context).pop();
                },
                child: Text(loc.retryButtonText),
              ),
            ],
          );
        });
  }

  Future<void> _connect({
    Duration scanTimeout = const Duration(seconds: 30),
  }) async {
    _flutterBlue.scan(timeout: scanTimeout).listen((scanResult) async {
      if (scanResult.device.name.isNotEmpty && _selectedDevice == null) {
        await scanResult.device.connect();
        List<BluetoothService> bluetoothServices =
            await scanResult.device.discoverServices();
        BluetoothService? service = bluetoothServices
            .where(
              (element) =>
                  element.uuid.toString() ==
                  "cb421a98-1247-442f-880d-e8259078f1f4",
            )
            .firstOrNull;
        BluetoothService? ledService = bluetoothServices
            .where(
              (element) =>
                  element.uuid.toString() ==
                  "4a82064c-e97b-44b3-9006-1871994ebc02",
            )
            .firstOrNull;
        if (service != null) {
          setState(() {
            _connected = true;
            _selectedDevice = scanResult.device;
            _sensorCharacteristic = service.characteristics
                .where(
                  (element) =>
                      element.uuid.toString() ==
                      "cf6b3e9f-caa7-42ff-89d0-5309b95c9c7b",
                )
                .firstOrNull;
            _ledCharacteristic = ledService?.characteristics
                .where(
                  (element) =>
                      element.uuid.toString() ==
                      "5444a605-ac7e-4c2f-96ee-170293b4292a",
                )
                .firstOrNull;
          });
        } else {
          await scanResult.device.disconnect();
        }
      }
    }).onDone(() async {
      if (!_connected) {
        _showErrorDialog();
      }
    });
  }

  Future<void> _disconnect() async {
    _flutterBlue.stopScan();
    _selectedDevice?.disconnect();
  }

  @override
  void dispose() {
    super.dispose();
    _disconnect();
  }

  @override
  void initState() {
    super.initState();
    _connect();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: _connected
          ? ChooseGameScreen(
              sensorCharacteristic: _sensorCharacteristic,
              ledCharacteristic: _ledCharacteristic,
            )
          : const IndexScreen(),
    );
  }
}
