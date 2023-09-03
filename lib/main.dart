import "dart:developer";
import "dart:io";

import "package:dribla_app_v2/audio_players.dart";
import "package:dribla_app_v2/bluetooth_ids.dart";
import "package:dribla_app_v2/screens/choose_game_screen.dart";
import "package:dribla_app_v2/screens/index_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_reactive_ble/flutter_reactive_ble.dart";

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
  bool _connecting = false;

  Future<void> _scanDevices() async {
    await AudioPlayers.init();
    log("Scanning for devices");
    DeviceConnection.controller.scanForDevices(
      withServices: [],
      scanMode: ScanMode.lowLatency,
    ).listen((device) async {
      if (device.name == "Dribla" && !_connecting) {
        if (Platform.isAndroid) {
          await DeviceConnection.controller
              .requestConnectionPriority(
                deviceId: device.id,
                priority: ConnectionPriority.highPerformance,
              )
              .onError((error, stackTrace) =>
                  log("Connection priority request failed"));
        }

        await DeviceConnection.controller.discoverAllServices(device.id);
        connectToDevice(device.id);
      }
    }, onError: (error) {
      log("Error while scanning for devices: $error");
    });
  }

  Future<void> connectToDevice(String deviceId) async {
    log("Connecting to device $deviceId");
    _connecting = true;

    DeviceConnection.controller.connectToDevice(id: deviceId).listen(
          (connectionStateUpdate) =>
              handleDeviceConnectionStateUpdate(connectionStateUpdate),
        );
  }

  void handleDeviceConnectionStateUpdate(
    ConnectionStateUpdate stateUpdate,
  ) async {
    log(stateUpdate.toString());
    if (stateUpdate.connectionState != DeviceConnectionState.connected) return;

    final services = await DeviceConnection.controller
        .getDiscoveredServices(stateUpdate.deviceId);

    final sensorService = services.firstWhere(
      (service) => service.id == BluetoothIds.sensorServiceId,
    );
    DeviceConnection.initSensor(
        sensorService.characteristics.first.subscribe());

    final ledService = services.firstWhere(
      (service) => service.id == BluetoothIds.ledServiceId,
    );

    DeviceConnection.ledCharacteristics = ledService.characteristics;
    //await DeviceConnection.setAllLedColors(0x00);
    if (context.mounted) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ChooseGameScreen(),
      ));
    }
  }

  void subscribeToDeviceCharacteristic(
      QualifiedCharacteristic characteristic) {}

  @override
  void initState() {
    super.initState();
    _scanDevices();
  }

  @override
  void dispose() {
    super.dispose();
    _connecting = false;
    AudioPlayers.deinit();
  }

  @override
  Widget build(BuildContext context) {
    return const IndexScreen();
  }
}
