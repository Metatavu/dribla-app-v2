import "dart:async";
import "dart:io";

import "package:collection/collection.dart";
import "package:dribla_app_v2/led_colors.dart";
import "package:fixnum/fixnum.dart";
import "dart:math";
import "dart:developer" as developer;

import "package:dribla_app_v2/bluetooth_ids.dart";
import "package:flutter_reactive_ble/flutter_reactive_ble.dart";
import "package:shared_preferences/shared_preferences.dart";

enum ConnectionStatus { bleDisabled, bleConnecting, bleConnected }

class DeviceConnection {
  static FlutterReactiveBle controller = FlutterReactiveBle();
  static List<Characteristic> ledCharacteristics = [];
  static Characteristic? resetCharacteristic;
  static Characteristic? shutdownCharacteristic;
  static List<Function(List<int>)> sensorValueListeners = [];
  static bool _connecting = false;
  static String connectedDeviceId = "";
  static ConnectionStatus connectionStatus = ConnectionStatus.bleDisabled;
  static StreamController<ConnectionStatus> connectionStatusController =
      StreamController.broadcast();

  static List<int> parseSensorData(int rawValue) {
    List<int> result = [];

    for (int index = 0; index < 8; index++) {
      int bit = pow(2, index).toInt();
      if (bit & rawValue == bit) result.add(index + 1);
    }

    return result;
  }

  static void init() {
    controller.statusStream.listen((status) => {
          if (status == BleStatus.ready)
            {_scanDevices()}
          else
            {
              connectionStatus = ConnectionStatus.bleDisabled,
              connectionStatusController.add(ConnectionStatus.bleDisabled)
            }
        });
  }

  static Future<void> _scanDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDeviceId = prefs.getString("dribla-device-id");
    developer.log("Scanning for devices");
    connectionStatus = ConnectionStatus.bleConnecting;
    connectionStatusController.add(ConnectionStatus.bleConnecting);
    if (storedDeviceId != null) {
      if (Platform.isAndroid) {
        await DeviceConnection.controller
            .requestConnectionPriority(
          deviceId: storedDeviceId,
          priority: ConnectionPriority.highPerformance,
        )
            .onError((error, stackTrace) {
          developer.log("Connection priority request failed");
          Timer(const Duration(seconds: 5), () => _scanDevices());
        });
      }

      await DeviceConnection.controller.discoverAllServices(storedDeviceId);
      connectToDevice(storedDeviceId);
    } else {
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
                .onError((error, stackTrace) {
              developer.log("Connection priority request failed");
              Timer(const Duration(seconds: 5), () => _scanDevices());
            });
          }

          await DeviceConnection.controller.discoverAllServices(device.id);
          connectToDevice(device.id);
        }
      }, onError: (error) {
        developer.log("Error while scanning for devices: $error");
        Timer(const Duration(seconds: 5), () => _scanDevices());
      });
    }
  }

  static Future<void> connectToDevice(String deviceId) async {
    developer.log("Connecting to device $deviceId");
    _connecting = true;

    DeviceConnection.controller
        .connectToDevice(
            id: deviceId, connectionTimeout: const Duration(seconds: 30))
        .listen(
          (connectionStateUpdate) =>
              handleDeviceConnectionStateUpdate(connectionStateUpdate),
        )
        .onError((error) => {
              _connecting = false,
              developer.log("Error connecting to device"),
              Timer(const Duration(seconds: 5), () => connectToDevice(deviceId))
            });
  }

  static void handleDeviceConnectionStateUpdate(
    ConnectionStateUpdate stateUpdate,
  ) async {
    developer.log(stateUpdate.toString());
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

    DeviceConnection.ledCharacteristics = ledService.characteristics
        .where((c) => c.id != BluetoothIds.resetLedsCharacteristicsId)
        .toList();

    DeviceConnection.resetCharacteristic = ledService.characteristics
        .firstWhere((c) => c.id == BluetoothIds.resetLedsCharacteristicsId);

    final systemService = services.firstWhere(
      (service) => service.id == BluetoothIds.systemServiceId,
    );

    DeviceConnection.shutdownCharacteristic = systemService.characteristics
        .firstWhere((c) => c.id == BluetoothIds.shutdownSystemCharastericsId);

    connectionStatus = ConnectionStatus.bleConnected;
    connectionStatusController.add(ConnectionStatus.bleConnected);
    connectedDeviceId = stateUpdate.deviceId;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("dribla-device-id", stateUpdate.deviceId);
  }

  static void initSensor(Stream<List<int>> sensorSubscription) {
    sensorSubscription.listen((data) {
      developer.log("Received sensor value update $data");
      var parsed = parseSensorData(data.first);
      for (var listener in sensorValueListeners) {
        listener(parsed);
      }
    });
  }

  static void addSensorValueListerner(Function(List<int>) listener) {
    sensorValueListeners.add(listener);
  }

  static void clearListeners() {
    sensorValueListeners.clear();
  }

  static Future<void> setLedColor(int color, int index) async {
    var charId = BluetoothIds.ledCharacteristicIds[index];
    for (var c in ledCharacteristics) {
      if (c.id == charId) {
        Int32 color32 = Int32(color);
        developer.log(
            "Setting char ${c.id} value to: 0x${color32.toRadixString(16)}");
        await c.write(color32.toBytes()).onError(
            (error, stackTrace) => developer.log("Error setting led color"));
      }
    }
  }

  static Future<void> setSingleLedActive(int color, int index) async {
    var charId = BluetoothIds.ledCharacteristicIds[index];
    for (var c in ledCharacteristics) {
      Int32 color32 = Int32(c.id == charId ? color : LedColors.OFF);
      developer
          .log("Setting char ${c.id} value to: 0x${color32.toRadixString(16)}");
      await c.write(color32.toBytes()).onError(
          (error, stackTrace) => developer.log("Error setting led color"));
    }
  }

  static Future<void> setLedsActive(List<int> color, List<int> indices) async {
    var charColorPairs = indices.mapIndexed((index, charIdIndex) =>
        (BluetoothIds.ledCharacteristicIds[charIdIndex], color[index]));
    for (var c in ledCharacteristics) {
      var color = charColorPairs.firstWhereOrNull((pair) => pair.$1 == c.id);
      Int32 color32 = Int32(color != null ? color.$2 : LedColors.OFF);
      developer
          .log("Setting char ${c.id} value to: 0x${color32.toRadixString(16)}");
      await c.write(color32.toBytes()).onError(
          (error, stackTrace) => developer.log("Error setting led color"));
    }
  }

  static Future<void> setAllLedColors(int color) async {
    Int32 color32 = Int32(color);
    for (var c in ledCharacteristics) {
      await c.write(color32.toBytes()).onError((error, stackTrace) =>
          developer.log("Error writing led value $error"));
    }
  }

  static Future<void> resetLeds() async {
    await resetCharacteristic?.write([0x01]).onError(
        (error, stackTrace) => developer.log("Error resetting leds"));
  }

  static Future<void> shutDownDevice() async {
    await shutdownCharacteristic?.write([0x01]).onError(
        (error, stackTrace) => developer.log("Error shutting down device"));
  }
}
