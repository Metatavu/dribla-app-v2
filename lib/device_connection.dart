import "dart:async";
import "dart:io";
import "dart:typed_data";

import "package:collection/collection.dart";
import "package:dribla_app_v2/led_colors.dart";
import "package:fixnum/fixnum.dart";
import "dart:math";
import "dart:developer" as developer;

import "package:dribla_app_v2/bluetooth_ids.dart";
import "package:flutter_blue_plus/flutter_blue_plus.dart";
import "package:shared_preferences/shared_preferences.dart";

enum ConnectionStatus {
  bleDisabled,
  bleConnecting,
  bleConnected,
  bleDisconnected
}

class DeviceConnection {
  static StreamSubscription<BluetoothAdapterState>? bleAdapterStateSubscription;
  static StreamSubscription<List<ScanResult>>? bleStatusSubscription;
  static StreamSubscription<BluetoothConnectionState>? _bleConnectionStream;
  static StreamSubscription<List<ScanResult>>? _bleScanStream;
  static List<BluetoothCharacteristic> ledCharacteristics = [];
  static BluetoothCharacteristic? resetCharacteristic;
  static BluetoothCharacteristic? shutdownCharacteristic;
  static BluetoothCharacteristic? batteryLevelCharacteristic;
  static List<Function(List<int>)> sensorValueListeners = [];
  static bool _connecting = false;
  static bool _resetting = false;
  static String connectedDeviceId = "";
  static ConnectionStatus connectionStatus = ConnectionStatus.bleDisabled;
  static int currentIdleAnimationColor = LedColors.blue;
  static Random idleAnimRandom = Random();
  static int idleAnimationLoop = 0;
  static Timer? idleAnimationTimer;
  static int connectedSensorsCount = 8;
  static List<int> ledValues = [
    LedColors.off,
    LedColors.off,
    LedColors.off,
    LedColors.off,
    LedColors.off,
    LedColors.off,
    LedColors.off,
    LedColors.off
  ];
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
    bleAdapterStateSubscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      if (state == BluetoothAdapterState.on) {
        _scanDevices();
      } else {
        connectionStatus = ConnectionStatus.bleDisabled;
        connectionStatusController.add(ConnectionStatus.bleDisabled);
      }
    });
  }

  static void clearDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("dribla-device-id");
  }

  static void deinit() {
    bleAdapterStateSubscription?.cancel();
    bleStatusSubscription?.cancel();
    ledCharacteristics.clear();
    resetCharacteristic = null;
    shutdownCharacteristic = null;
    sensorValueListeners.clear();
    connectedDeviceId = "";
    _connecting = false;
    connectionStatus = ConnectionStatus.bleDisabled;
    connectionStatusController.add(ConnectionStatus.bleDisabled);
  }

  static Future<void> _scanDevices() async {
    try {
      _bleScanStream?.cancel();
      final prefs = await SharedPreferences.getInstance();
      connectedDeviceId = prefs.getString("dribla-device-id") ?? "";
      developer.log("Scanning for devices");
      connectionStatus = ConnectionStatus.bleConnecting;
      connectionStatusController.add(ConnectionStatus.bleConnecting);
      if (connectedDeviceId.isNotEmpty) {
        await FlutterBluePlus.startScan(
            withNames: ["Dribla"], // *or* any of the specified names
            timeout: const Duration(seconds: 15));
        connectToDevice(BluetoothDevice.fromId(connectedDeviceId));
      } else {
        _bleScanStream = FlutterBluePlus.onScanResults.listen((results) {
          if (results.isNotEmpty) {
            ScanResult r = results.last; // the most recently found device
            connectToDevice(r.device);
          }
        }, onError: (error) {
          developer.log("Error while scanning for devices: $error");
          Timer(const Duration(seconds: 10), () => _scanDevices());
        });
        await FlutterBluePlus.startScan(
            withNames: ["Dribla"], // *or* any of the specified names
            timeout: const Duration(seconds: 15));

        await FlutterBluePlus.isScanning.where((val) => val == false).first;
        if (!_connecting) {
          developer
              .log("No suitable devices found, restarting scan in 15 seconds");
          Timer(const Duration(seconds: 15), () => _scanDevices());
        }
      }
    } catch (e) {
      developer.log("Error while starting scanning for devices: $e");
      Timer(const Duration(seconds: 15), () => _scanDevices());
    }
  }

  static Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      _connecting = true;
      await _bleScanStream?.cancel();
      developer.log("Connecting to device ${device.remoteId}");
      await _bleConnectionStream?.cancel();
      await device.connect(autoConnect: true, mtu: null);
      _bleConnectionStream = device.connectionState
          .listen((event) => handleDeviceConnectionStateUpdate(device, event));
    } catch (e) {
      developer.log("Error while connecting to device: $e");
      Timer(const Duration(seconds: 15), () => connectToDevice(device));
    }
  }

  static void handleDeviceConnectionStateUpdate(
    BluetoothDevice device,
    BluetoothConnectionState stateUpdate,
  ) async {
    try {
      developer.log(stateUpdate.toString());
      if (connectionStatus == ConnectionStatus.bleConnected &&
          stateUpdate == BluetoothConnectionState.disconnected &&
          connectedDeviceId.isNotEmpty) {
        connectionStatus = ConnectionStatus.bleDisconnected;
        connectionStatusController.add(ConnectionStatus.bleDisconnected);
        Timer(
            const Duration(milliseconds: 1000), () => connectToDevice(device));
      }

      if (stateUpdate != BluetoothConnectionState.connected) {
        return;
      }

      if (Platform.isAndroid) {
        await device.requestConnectionPriority(
            connectionPriorityRequest: ConnectionPriority.high);
      }

      final services = await device.discoverServices();
      final sensorService = services.firstWhere(
        (service) => service.serviceUuid == BluetoothIds.sensorServiceId,
      );
      await sensorService.characteristics.first.setNotifyValue(true);
      DeviceConnection.initSensor(
        sensorService.characteristics.first.onValueReceived,
      );

      final ledService = services.firstWhere(
        (service) => service.serviceUuid == BluetoothIds.ledServiceId,
      );

      DeviceConnection.ledCharacteristics = ledService.characteristics
          .where((c) =>
              c.characteristicUuid != BluetoothIds.resetLedsCharacteristicsId)
          .toList();

      DeviceConnection.resetCharacteristic = ledService.characteristics
          .firstWhereOrNull((c) =>
              c.characteristicUuid == BluetoothIds.resetLedsCharacteristicsId);

      final systemService = services.firstWhere(
        (service) => service.serviceUuid == BluetoothIds.systemServiceId,
      );

      DeviceConnection.batteryLevelCharacteristic =
          systemService.characteristics.firstWhereOrNull((c) =>
              c.characteristicUuid ==
              BluetoothIds.batteryLevelCharacteristicsId);

      var sensorCountCharasteristic = systemService.characteristics
          .firstWhereOrNull((c) =>
              c.characteristicUuid == BluetoothIds.sensorCountharacteristicsId);

      if (sensorCountCharasteristic != null) {
        connectedSensorsCount = (await sensorCountCharasteristic.read()).first;
      } else {
        connectedSensorsCount = 8;
      }

      DeviceConnection.shutdownCharacteristic = systemService.characteristics
          .firstWhere((c) =>
              c.characteristicUuid ==
              BluetoothIds.shutdownSystemCharastericsId);

      connectionStatus = ConnectionStatus.bleConnected;
      connectionStatusController.add(ConnectionStatus.bleConnected);
      connectedDeviceId = device.remoteId.str;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("dribla-device-id", connectedDeviceId);
      await initLedStatus();
    } catch (e) {
      developer.log("Error during connection state update: $e");
      Timer(const Duration(seconds: 5), () => connectToDevice(device));
    }
  }

  static void initSensor(Stream<List<int>> sensorSubscription) {
    sensorSubscription.listen((data) {
      developer.log("${DateTime.now()}: Received sensor value update $data");
      var parsed = parseSensorData(data.first);
      if (!_resetting) {
        for (var listener in sensorValueListeners) {
          listener(parsed);
        }
      }
    });
  }

  static Future<int?> readBatteryLevel() async {
    if (connectionStatus != ConnectionStatus.bleConnected) {
      return null;
    }
    try {
      var bytes = await batteryLevelCharacteristic?.read();
      if (bytes != null) {
        var data = Uint8List.fromList(bytes);
        var batteryLevel = data.buffer.asInt16List();
        return batteryLevel.firstOrNull;
      }
    } catch (e) {
      developer.log("Error reading battery level: $e");
    }
    return null;
  }

  static void addSensorValueListener(Function(List<int>) listener) {
    sensorValueListeners.add(listener);
  }

  static void clearListeners() {
    sensorValueListeners.clear();
  }

  static Future<void> initLedStatus() async {
    for (var (index, color) in ledValues.indexed) {
      await setLedColor(color, index);
    }

    await resetLeds();
  }

  static Future<void> setLedColor(int color, int index) async {
    ledValues[index] = color;
    var charId = BluetoothIds.ledCharacteristicIds[index];
    for (var c in ledCharacteristics) {
      if (c.characteristicUuid == charId) {
        Int32 color32 = Int32(color);
        developer.log(
            "Setting char ${c.characteristicUuid} value to: 0x${color32.toRadixString(16)}");
        await c.write(color32.toBytes()).onError(
            (error, stackTrace) => developer.log("Error setting led color"));
      }
    }
  }

  static Future<void> setSingleLedActive(int color, int index,
      [int bgColor = LedColors.off]) async {
    ledValues = [
      bgColor,
      bgColor,
      bgColor,
      bgColor,
      bgColor,
      bgColor,
      bgColor,
      bgColor
    ];
    ledValues[index] = color;
    var charId = BluetoothIds.ledCharacteristicIds[index];
    for (var c in ledCharacteristics) {
      Int32 color32 = Int32(c.characteristicUuid == charId ? color : bgColor);
      developer.log(
          "Setting char ${c.characteristicUuid} value to: 0x${color32.toRadixString(16)}");
      await c.write(color32.toBytes()).onError(
          (error, stackTrace) => developer.log("Error setting led color"));
    }
  }

  static Future<void> setLedsActive(List<int> color, List<int> indices,
      [int bgColor = LedColors.off]) async {
    ledValues = [
      bgColor,
      bgColor,
      bgColor,
      bgColor,
      bgColor,
      bgColor,
      bgColor,
      bgColor
    ];
    indices.forEachIndexed((index, charIdIndex) {
      ledValues[charIdIndex] = color[index];
    });
    var charColorPairs = indices.mapIndexed((index, charIdIndex) =>
        (BluetoothIds.ledCharacteristicIds[charIdIndex], color[index]));
    for (var c in ledCharacteristics) {
      var color = charColorPairs
          .firstWhereOrNull((pair) => pair.$1 == c.characteristicUuid);
      Int32 color32 = Int32(color != null ? color.$2 : bgColor);
      developer.log(
          "Setting char ${c.characteristicUuid} value to: 0x${color32.toRadixString(16)}");
      await c.write(color32.toBytes()).onError(
          (error, stackTrace) => developer.log("Error setting led color"));
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  static Future<void> setAllLedColors(int color) async {
    ledValues = [color, color, color, color, color, color, color, color];
    Int32 color32 = Int32(color);
    for (var c in ledCharacteristics) {
      await c.write(color32.toBytes()).onError((error, stackTrace) =>
          developer.log("Error writing led value $error"));
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  static Future<void> resetLeds() async {
    if (resetCharacteristic == null) {
      return; // Using new hardware without requirement to perform sensor resets
    }
    _resetting = true;
    await resetCharacteristic?.write([0x01]).onError(
        (error, stackTrace) => developer.log("Error resetting leds"));
    await Future.delayed(const Duration(milliseconds: 100));
    _resetting = false;
  }

  static Future<void> shutDownDevice() async {
    await shutdownCharacteristic?.write([0x01]).onError(
        (error, stackTrace) => developer.log("Error shutting down device"));
  }

  static void startIdleAnimation() {
    setAllLedColors(LedColors.red);
  }
}
