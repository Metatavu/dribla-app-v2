import "package:flutter_blue_plus/flutter_blue_plus.dart";

class BluetoothIds {
  static Guid sensorServiceId =
      Guid.fromString("cb421a98-1247-442f-880d-e8259078f1f4");
  static Guid ledServiceId =
      Guid.fromString("4a82064c-e97b-44b3-9006-1871994ebc02");

  static Guid systemServiceId =
      Guid.fromString("C4EBDC6A-BE6B-477B-8D99-0568CBC1787B");

  static List<Guid> sensorCharacteristicIds = [
    Guid.fromString("cf6b3e9f-caa7-42ff-89d0-5309b95c9c7b")
  ];

  static List<Guid> ledCharacteristicIds = [
    Guid.fromString("5444a605-ac7e-4c2f-96ee-170293b4292a"),
    Guid.fromString("3D1264AE-14E4-4E45-8953-DBBBEAD3CB40"),
    Guid.fromString("4858E536-DFE5-4113-8D5C-351483666E64"),
    Guid.fromString("67904C35-A1C5-4341-BE70-7B489CC78C22"),
    Guid.fromString("366CF174-8468-43D5-AD4F-F49502640536"),
    Guid.fromString("A5C6F5BB-01CF-4160-9241-CD351EBEA481"),
    Guid.fromString("ACA76DDC-D46C-429F-841F-9B7B1EF1DCE1"),
    Guid.fromString("A94E3BBC-2170-41D9-9AB2-386BEB5C9558")
  ];

  static Guid shutdownSystemCharastericsId =
      Guid.fromString("972307C8-FC98-4165-8DD8-AFA17E8FA713");

  static Guid resetLedsCharacteristicsId =
      Guid.fromString("A3CD1E7F-AE7C-44F0-A18A-BE40D5ADD352");

  static Guid sensorCountharacteristicsId =
      Guid.fromString("21EF9772-812E-423D-BD4D-C7F2C7819FED");
}
