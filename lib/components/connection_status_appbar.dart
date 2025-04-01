import "dart:async";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

import "package:dribla_app_v2/assets.dart";
import "package:dribla_app_v2/components/styled_dialog.dart";
import "package:dribla_app_v2/components/styled_elevated_button.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:device_policy_controller/device_policy_controller.dart";
import "package:package_info_plus/package_info_plus.dart";

import "../device_connection.dart";

class ConnectionStatusAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const ConnectionStatusAppBar({
    super.key,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0

  @override
  State<StatefulWidget> createState() => _ConnectionStatusAppBar();
}

class _ConnectionStatusAppBar extends State<ConnectionStatusAppBar> {
  Timer? tapResetTimer;
  int lockDeviceTapCount = 0;
  Stream<ConnectionStatus> _connectionStatusStream = const Stream.empty();
  Stream<bool> _lockdownStatusStream = const Stream.empty();
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
    _lockdownStatusStream = DeviceConnection.deviceLockdownController.stream;
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _getConnectionStatusIcon(ConnectionStatus connectionStatus) {
    return switch (connectionStatus) {
      ConnectionStatus.bleDisabled => const Icon(Icons.bluetooth_disabled),
      ConnectionStatus.bleDisconnected => const Icon(Icons.bluetooth_disabled),
      ConnectionStatus.bleConnecting => const Icon(Icons.bluetooth_searching),
      ConnectionStatus.bleConnected => const Icon(Icons.bluetooth_connected)
    };
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
        Text(
          _getDeviceConnectionStatusText(
              DeviceConnection.connectionStatus, localizations),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
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
            "v${_packageInfo.version} - showroom",
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
    final dpc = DevicePolicyController.instance;
    final isLocked = await dpc.isAppLocked();
    if (isLocked) {
      final bool success = await dpc.unlockApp();
      if (success) {
        DeviceConnection.deviceLockdownController.add(false);
      }
      if (success && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(localizations.appUnlocked)));
      }
    } else {
      final bool success = await dpc.lockApp(home: true);
      if (success) {
        DeviceConnection.deviceLockdownController.add(true);
      }
      if (success && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(localizations.appLocked)));
      }
    }
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
              StyledElevatedButton(
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

    return StreamBuilder<bool>(
      stream: _lockdownStatusStream,
      initialData: DeviceConnection.isLocked,
      builder: (context, locked) => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        foregroundColor: Colors.white,
        leading: StreamBuilder<ConnectionStatus>(
          stream: _connectionStatusStream,
          builder: (context, state) => _getConnectionStatusIcon(
            state.data ?? DeviceConnection.connectionStatus,
          ),
        ),
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
            child: SvgPicture.asset(
              Assets.logoAsset,
              width: 150,
            ),
          ),
        ),
        actions: [
          if (locked.hasData && locked.data == false)
            IconButton(
              onPressed: () => _openConnectionStatusDialog(context, theme),
              icon: const Icon(Icons.settings),
            ),
        ],
      ),
    );
  }
}
