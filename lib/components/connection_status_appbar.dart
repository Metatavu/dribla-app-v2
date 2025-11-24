import "dart:async";
import "dart:developer" as developer;
import "package:flutter_gen/gen_l10n/app_localizations.dart";

import "package:dribla_app_v2/assets.dart";
import "package:dribla_app_v2/components/styled_dialog.dart";
import "package:dribla_app_v2/components/styled_elevated_button.dart";
import "package:flutter/material.dart";
// need to reimport device policy controller when not debugging
import "package:package_info_plus/package_info_plus.dart";
import "package:sizer/sizer.dart";
import "package:dribla_app_v2/theme/theme.dart";

import "../device_connection.dart";

class ConnectionStatusAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;
  const ConnectionStatusAppBar({
    super.key,
    this.onMenuPressed,
    this.shouldShowMenu = true,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0
  final bool shouldShowMenu;

  @override
  State<StatefulWidget> createState() => _ConnectionStatusAppBar();
}

class _ConnectionStatusAppBar extends State<ConnectionStatusAppBar> {
  Timer? tapResetTimer;
  int lockDeviceTapCount = 0;
  Stream<ConnectionStatus> _connectionStatusStream = const Stream.empty();
  int? _batteryLevel;
  Timer? _batteryCheckTimer;
  PackageInfo _packageInfo = PackageInfo(
    appName: "Unknown",
    packageName: "Unknown",
    version: "Unknown",
    buildNumber: "Unknown",
    buildSignature: "Unknown",
    installerStore: "Unknown",
  );

  @override
  void initState() {
    super.initState();
    _connectionStatusStream =
        DeviceConnection.connectionStatusController.stream;
    _initPackageInfo();
    _checkBatteryLevel();
    _batteryCheckTimer =
        Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      _checkBatteryLevel();
    });
  }

  @override
  void dispose() {
    _batteryCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _checkBatteryLevel() async {
    final batteryLevel = await DeviceConnection.readBatteryLevel();
    //developer.log("Got battery level: " + batteryLevel.toString());
    if (!mounted) return;
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Widget _getConnectionStatusIcon(
      ConnectionStatus connectionStatus, ThemeData theme) {
    return switch (connectionStatus) {
      ConnectionStatus.bleDisabled => IconButton(
          icon: const Icon(Icons.bluetooth_disabled, color: Colors.red),
          onPressed: () {
            _openConnectionStatusDialog(context, theme);
          },
        ),
      ConnectionStatus.bleDisconnected => IconButton(
          icon: const Icon(Icons.bluetooth_disabled, color: Colors.red),
          onPressed: () {
            _openConnectionStatusDialog(context, theme);
          },
        ),
      ConnectionStatus.bleConnecting => IconButton(
          icon: const Icon(Icons.bluetooth_searching, color: Colors.blue),
          onPressed: () {
            _openConnectionStatusDialog(context, theme);
          },
        ),
      ConnectionStatus.bleConnected => IconButton(
          icon: const Icon(Icons.bluetooth_connected, color: Colors.green),
          onPressed: () {
            _openConnectionStatusDialog(context, theme);
          },
        ),
    };
  }

  Widget _getBatteryLevelIcon() {
    var batteryLevel = _batteryLevel ?? 0;
    if (batteryLevel > 415) {
      return Icon(
        Icons.battery_full,
        color: Colors.greenAccent,
        size: 10.w,
      );
    } else if (batteryLevel > 400) {
      return Icon(
        Icons.battery_6_bar,
        color: Colors.greenAccent,
        size: 10.w,
      );
    } else if (batteryLevel > 408) {
      return Icon(
        Icons.battery_5_bar,
        color: Colors.greenAccent,
        size: 10.w,
      );
    } else if (batteryLevel > 398) {
      return Icon(
        Icons.battery_4_bar,
        color: Colors.white,
        size: 10.w,
      );
    } else if (batteryLevel > 387) {
      return Icon(
        Icons.battery_3_bar,
        color: Colors.white,
        size: 10.w,
      );
    } else if (batteryLevel > 384) {
      return Icon(
        Icons.battery_2_bar,
        color: Colors.white,
        size: 10.w,
      );
    } else if (batteryLevel > 375) {
      return Icon(
        Icons.battery_1_bar,
        color: Colors.red,
        size: 10.w,
      );
    } else {
      return Icon(
        Icons.battery_0_bar,
        color: Colors.red,
        size: 10.w,
      );
    }
  }

  String _getDeviceConnectionStatusText(
          ConnectionStatus status, AppLocalizations localizations) =>
      switch (status) {
        ConnectionStatus.bleDisabled => localizations.bluetoothDisabled,
        ConnectionStatus.bleConnecting => switch (
              DeviceConnection.connectedDeviceId.isNotEmpty) {
            true => localizations.lookingForDevice,
            false => localizations.lookingForDevices
          },
        ConnectionStatus.bleConnected => localizations.connected,
        ConnectionStatus.bleDisconnected => localizations.disconnected,
      };

  Widget _buildDeviceInfoDialogContent(
      ConnectionStatus status, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (DeviceConnection.connectionStatus ==
                    ConnectionStatus.bleConnected &&
                _batteryLevel != null) ...[
              _getBatteryLevelIcon(),
            ],
            Text(
              _getDeviceConnectionStatusText(
                  DeviceConnection.connectionStatus, localizations),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (DeviceConnection.connectedDeviceId.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            "${localizations.device}: Dribla (${DeviceConnection.connectedDeviceId})",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        ...[
          const SizedBox(height: 8),
          Text(
            "v${_packageInfo.version}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          )
        ]
      ],
    );
  }

  _toggleDeviceLockMode(
      BuildContext context, AppLocalizations localizations) async {
    // tarvitaan kommentteihin debuggausta varten
    // final dpc = DevicePolicyController.instance;
    // final isLocked = await dpc.isAppLocked();
    // if (isLocked) {
    //   final bool success = await dpc.unlockApp();
    //   if (success && context.mounted) {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text(localizations.appUnlocked)));
    //   }
    // } else {
    //   final bool success = await dpc.lockApp(home: true);
    //   if (success && context.mounted) {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text(localizations.appLocked)));
    //   }
    // }
  }

  Future<void> _openConnectionStatusDialog(
    BuildContext context,
    ThemeData theme,
  ) {
    final localizations = AppLocalizations.of(context)!;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder<ConnectionStatus>(
          stream: _connectionStatusStream,
          builder: (context, state) => StyledDialog(
            actionsDirection: DeviceConnection.connectionStatus !=
                    ConnectionStatus.bleDisabled
                ? Axis.vertical
                : Axis.horizontal,
            title: localizations.deviceInfo,
            content: _buildDeviceInfoDialogContent(
                state.data ?? DeviceConnection.connectionStatus, localizations),
            actions: [
              if (DeviceConnection.connectionStatus ==
                  ConnectionStatus.bleConnected)
                OutlinedButton(
                  onPressed: DeviceConnection.shutDownDevice,
                  child: Text(localizations.shutdown),
                ),
              if (DeviceConnection.connectedDeviceId.isNotEmpty)
                OutlinedButton(
                  onPressed: () => setState(() {
                    DeviceConnection.clearDeviceId();
                    DeviceConnection.deinit();
                    DeviceConnection.init();
                  }),
                  child: Text(localizations.forget),
                ),
              ElevatedButton(
                style: theme.elevatedButtonTheme.style?.copyWith(
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                ),
                child: Text(localizations.ok),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      foregroundColor: Colors.white,
      leading: Row(children: [
        SizedBox(width: 2.w),
        widget.shouldShowMenu
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: widget.onMenuPressed ??
                    () {
                      Scaffold.of(context).openDrawer();
                    },
              )
            : Container(),
      ]),
      title: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0),
        ),
        child: GestureDetector(
            onTap: () {
              if (lockDeviceTapCount == 10) {
                _toggleDeviceLockMode(context, localizations);
              }
              tapResetTimer?.cancel();
              lockDeviceTapCount++;
              tapResetTimer = Timer(const Duration(seconds: 1), () {
                lockDeviceTapCount = 0;
              });
            },
            child: Image(
              image: const AssetImage(Assets.logoAsset),
              width: 30.w,
            )),
      ),
      actions: [
        StreamBuilder<ConnectionStatus>(
          stream: _connectionStatusStream,
          builder: (context, state) => _getConnectionStatusIcon(
              state.data ?? DeviceConnection.connectionStatus, theme),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }
}
