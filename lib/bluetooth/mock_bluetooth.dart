// Mocks bluetooth connectivity; implemented later.

class BluetoothService {
  // Bluetooth implementation: scan for services
  // CB421A98-1247-442F-880D-E8259078F1F4 and 4A82064C-E97B-44B3-9006-1871994EBC02

  Future<bool> connect() async {
    // some logic, find device id with services and connect
    return Future.delayed(const Duration(seconds: 1), () {
      return true;
    });
  }
}
