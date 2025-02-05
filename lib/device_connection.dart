import "dart:async";
import "dart:io";

import "package:collection/collection.dart";
import "package:dribla_app_v2/led_colors.dart";
import "package:fixnum/fixnum.dart";
import "dart:math";
import "dart:developer" as developer;

import "package:dribla_app_v2/bluetooth_ids.dart";
import "package:flutter/material.dart";
import "package:flutter_reactive_ble/flutter_reactive_ble.dart";
import "package:shared_preferences/shared_preferences.dart";

enum ConnectionStatus {
  bleDisabled,
  bleConnecting,
  bleConnected,
  bleDisconnected
}

class DeviceConnection {
  static FlutterReactiveBle controller = FlutterReactiveBle();
  static StreamSubscription<BleStatus>? bleStatusSubscription;
  static StreamSubscription<ConnectionStateUpdate>? _bleConnectionStream;
  static StreamSubscription<DiscoveredDevice>? _bleScanStream;
  static List<Characteristic> ledCharacteristics = [];
  static Characteristic? resetCharacteristic;
  static Characteristic? shutdownCharacteristic;
  static List<Function(List<int>)> sensorValueListeners = [];
  static bool _connecting = false;
  static bool _resetting = false;
  static bool _reconnecting = false;
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
    bleStatusSubscription = controller.statusStream.listen((status) => {
          if (status == BleStatus.ready)
            {_scanDevices()}
          else
            {
              connectionStatus = ConnectionStatus.bleDisabled,
              connectionStatusController.add(ConnectionStatus.bleDisabled)
            }
        });
  }

  static void clearDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("dribla-device-id");
  }

  static void deinit() {
    controller.deinitialize();
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
      if (connectedDeviceId.isNotEmpty && Platform.isAndroid) {
        connectToDevice(connectedDeviceId);
      } else {
        _bleScanStream = DeviceConnection.controller.scanForDevices(
          withServices: [],
          scanMode: ScanMode.lowLatency,
        ).listen((device) async {
          if (((connectedDeviceId.isNotEmpty &&
                      device.id == connectedDeviceId) ||
                  (connectedDeviceId.isEmpty && device.name == "Dribla")) &&
              !_connecting) {
            connectToDevice(device.id);
          }
        }, onError: (error) {
          developer.log("Error while scanning for devices: $error");
          Timer(const Duration(seconds: 5), () => _scanDevices());
        });
      }
    } catch (e) {
      developer.log("Error while starting scanning for devices: $e");
    }
  }

  static Future<void> connectToDevice(String deviceId) async {
    try {
      developer.log("Connecting to device $deviceId");
      _connecting = true;
      await _bleConnectionStream?.cancel();
      if (Platform.isAndroid) {
        try {
          await DeviceConnection.controller
              .requestConnectionPriority(
            deviceId: deviceId,
            priority: ConnectionPriority.highPerformance,
          )
              .onError((error, stackTrace) {
            developer.log("Connection priority request failed");
            Timer(const Duration(seconds: 5), () => _scanDevices());
          });
          await DeviceConnection.controller.discoverAllServices(deviceId);
        } catch (e) {
          developer.log("Error discovering services: $e");
        }
      }
      _bleConnectionStream = DeviceConnection.controller
          .connectToDevice(
              id: deviceId, connectionTimeout: const Duration(seconds: 30))
          .listen(
            (connectionStateUpdate) =>
                handleDeviceConnectionStateUpdate(connectionStateUpdate),
          );

      _bleConnectionStream?.onError(
        (error) => {
          _connecting = false,
          developer.log("Error connecting to device"),
          Timer(const Duration(seconds: 5), () => connectToDevice(deviceId))
        },
      );
    } catch (e) {
      developer.log("Error while connecting to device: $e");
    }
  }

  static void handleDeviceConnectionStateUpdate(
    ConnectionStateUpdate stateUpdate,
  ) async {
    try {
      developer.log(stateUpdate.toString());
      if (_reconnecting &&
          stateUpdate.connectionState == DeviceConnectionState.disconnected) {
        connectToDevice(connectedDeviceId);
        return;
      }

      if (connectionStatus == ConnectionStatus.bleConnected &&
          stateUpdate.connectionState == DeviceConnectionState.disconnected &&
          connectedDeviceId.isNotEmpty) {
        _reconnecting = true;
        connectionStatus = ConnectionStatus.bleDisconnected;
        connectionStatusController.add(ConnectionStatus.bleDisconnected);
        Timer(const Duration(milliseconds: 1000),
            () => connectToDevice(connectedDeviceId));
      }

      if (stateUpdate.connectionState != DeviceConnectionState.connected) {
        return;
      }

      _reconnecting = false;
      final services = await DeviceConnection.controller
          .getDiscoveredServices(stateUpdate.deviceId);

      final sensorService = services.firstWhere(
        (service) => service.id == BluetoothIds.sensorServiceId,
      );
      DeviceConnection.initSensor(
        sensorService.characteristics.first.subscribe(),
      );

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

      var sensorCountCharasteristic = systemService.characteristics
          .firstWhereOrNull(
              (c) => c.id == BluetoothIds.sensorCountharacteristicsId);

      if (sensorCountCharasteristic != null) {
        connectedSensorsCount = (await sensorCountCharasteristic.read()).first;
      } else {
        connectedSensorsCount = 8;
      }

      DeviceConnection.shutdownCharacteristic = systemService.characteristics
          .firstWhere((c) => c.id == BluetoothIds.shutdownSystemCharastericsId);

      connectionStatus = ConnectionStatus.bleConnected;
      connectionStatusController.add(ConnectionStatus.bleConnected);
      connectedDeviceId = stateUpdate.deviceId;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("dribla-device-id", stateUpdate.deviceId);
      await initLedStatus();
    } catch (e) {
      developer.log("Error during connection state update: $e");
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
      if (c.id == charId) {
        Int32 color32 = Int32(color);
        developer.log(
            "Setting char ${c.id} value to: 0x${color32.toRadixString(16)}");
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
      Int32 color32 = Int32(c.id == charId ? color : bgColor);
      developer
          .log("Setting char ${c.id} value to: 0x${color32.toRadixString(16)}");
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
      var color = charColorPairs.firstWhereOrNull((pair) => pair.$1 == c.id);
      Int32 color32 = Int32(color != null ? color.$2 : bgColor);
      developer
          .log("Setting char ${c.id} value to: 0x${color32.toRadixString(16)}");
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

  static void stopIdleAnimation() {
    idleAnimationTimer?.cancel();
  }

  static void startIdleAnimation() {
    idleAnimationTimer?.cancel();
    idleAnimationTimer =
        Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (connectionStatus == ConnectionStatus.bleConnected) {
        idleAnimationLoop++;
        if (idleAnimationLoop > 7) {
          idleAnimationLoop = 0;
        }
        Color? color = Color.lerp(const Color.fromARGB(0, 0, 0, 255),
            const Color.fromARGB(0, 0, 255, 0), idleAnimRandom.nextDouble());
        setLedColor(LedColors.fromColor(color!), idleAnimationLoop);
        resetLeds();
      }
    });
  }
}
