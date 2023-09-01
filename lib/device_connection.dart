import "dart:math";

import "package:flutter_reactive_ble/flutter_reactive_ble.dart";

class DeviceConnection {
  static FlutterReactiveBle controller = FlutterReactiveBle();
  static List<Characteristic> ledCharacteristics = [];
  static Stream<List<int>> sensorValueStream = Stream.empty();

  static List<int> parseSensorData(int rawValue) {
    List<int> result = [];

    for (int index = 0; index < 8; index++) {
      final bitValue = pow(2, index);
      if (index & rawValue == bitValue) result.add(index + 1);
    }

    return result;
  }
}
