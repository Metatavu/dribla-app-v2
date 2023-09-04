import "package:dribla_app_v2/led_colors.dart";
import "package:fixnum/fixnum.dart";
import "dart:math";
import "dart:developer" as developer;

import "package:dribla_app_v2/bluetooth_ids.dart";
import "package:flutter_reactive_ble/flutter_reactive_ble.dart";

class DeviceConnection {
  static FlutterReactiveBle controller = FlutterReactiveBle();
  static List<Characteristic> ledCharacteristics = [];
  static List<Function(List<int>)> sensorValueListeners = [];

  static List<int> parseSensorData(int rawValue) {
    List<int> result = [];

    for (int index = 0; index < 8; index++) {
      int bit = pow(2, index).toInt();
      if (bit & rawValue == bit) result.add(index + 1);
    }

    return result;
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
        developer.log("Setting char ${c.id} value to: $color32");
        await c.write(color32.toBytes()).onError(
            (error, stackTrace) => developer.log("Error setting led color"));
      }
    }
  }

  static Future<void> setSingleLedActive(int color, int index) async {
    var charId = BluetoothIds.ledCharacteristicIds[index];
    for (var c in ledCharacteristics) {
      Int32 color32 = Int32(c.id == charId ? color : LedColors.OFF);
      developer.log("Setting char ${c.id} value to: $color32");
      await c.write(color32.toBytes()).onError(
          (error, stackTrace) => developer.log("Error setting led color"));
    }
  }

  static Future<void> setAllLedColors(int color) async {
    Int32 color32 = Int32(color);
    for (var c in ledCharacteristics) {
      await c.write(color32.toBytes()).onError(
          (error, stackTrace) => developer.log("Error writing led value"));
    }
  }
}
