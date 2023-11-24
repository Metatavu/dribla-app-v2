import "package:flutter_reactive_ble/flutter_reactive_ble.dart";

class BluetoothIds {
  static Uuid sensorServiceId =
      Uuid.parse("cb421a98-1247-442f-880d-e8259078f1f4");
  static Uuid ledServiceId = Uuid.parse("4a82064c-e97b-44b3-9006-1871994ebc02");

  static Uuid systemServiceId =
      Uuid.parse("C4EBDC6A-BE6B-477B-8D99-0568CBC1787B");

  static List<Uuid> sensorCharacteristicIds = [
    Uuid.parse("cf6b3e9f-caa7-42ff-89d0-5309b95c9c7b")
  ];

  static List<Uuid> ledCharacteristicIds = [
    Uuid.parse("5444a605-ac7e-4c2f-96ee-170293b4292a"),
    Uuid.parse("3D1264AE-14E4-4E45-8953-DBBBEAD3CB40"),
    Uuid.parse("4858E536-DFE5-4113-8D5C-351483666E64"),
    Uuid.parse("67904C35-A1C5-4341-BE70-7B489CC78C22"),
    Uuid.parse("366CF174-8468-43D5-AD4F-F49502640536"),
    Uuid.parse("A5C6F5BB-01CF-4160-9241-CD351EBEA481"),
    Uuid.parse("ACA76DDC-D46C-429F-841F-9B7B1EF1DCE1"),
    Uuid.parse("A94E3BBC-2170-41D9-9AB2-386BEB5C9558")
  ];

  static Uuid shutdownSystemCharastericsId =
      Uuid.parse("972307C8-FC98-4165-8DD8-AFA17E8FA713");

  static Uuid resetLedsCharacteristicsId =
      Uuid.parse("A3CD1E7F-AE7C-44F0-A18A-BE40D5ADD352");
}
