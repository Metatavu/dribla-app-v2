import "dart:io";

import "package:device_info_plus/device_info_plus.dart";
import "package:permission_handler/permission_handler.dart";

Future<List<Permission>> _getRequiredPermissions() async {
  if (Platform.isIOS ||
      (await DeviceInfoPlugin().androidInfo).version.sdkInt < 31) {
    return [Permission.bluetooth];
  } else {
    return [Permission.bluetoothScan, Permission.bluetoothConnect];
  }
}

Future<Map<Permission, PermissionStatus>>
    askAndCheckPermissionStatuses() async {
  final requiredPermissions = await _getRequiredPermissions();

  Map<Permission, PermissionStatus> permissionStatuses = {};

  try {
    permissionStatuses = await requiredPermissions.request();
  } catch (e) {
    print("Error while requesting permissions: $e");
  }

  return {
    for (final permission in requiredPermissions)
      permission: permissionStatuses[permission] ?? PermissionStatus.denied,
  };
}
