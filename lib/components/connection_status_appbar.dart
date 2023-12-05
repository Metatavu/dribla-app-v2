import "dart:async";

import "package:dribla_app_v2/components/styled_dialog.dart";
import "package:dribla_app_v2/components/styled_elevated_button.dart";
import "package:flutter/material.dart";

import "../device_connection.dart";

class ConnectionStatusAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const ConnectionStatusAppBar({super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0

  @override
  State<StatefulWidget> createState() => _ConnectionStatusAppBar();
}

class _ConnectionStatusAppBar extends State<ConnectionStatusAppBar> {
  Stream<ConnectionStatus> _connectionStatusStream = const Stream.empty();

  @override
  void initState() {
    super.initState();
    _connectionStatusStream =
        DeviceConnection.connectionStatusController.stream;
  }

  Widget _getConnectionStatusIcon(ConnectionStatus connectionStatus) {
    return switch (connectionStatus) {
      ConnectionStatus.bleDisabled => const Icon(Icons.bluetooth_disabled),
      ConnectionStatus.bleConnecting => const Icon(Icons.bluetooth_searching),
      ConnectionStatus.bleConnected => const Icon(Icons.bluetooth_connected)
    };
  }

  String _getDeviceConnectionStatusText(ConnectionStatus status) =>
      switch (status) {
        ConnectionStatus.bleDisabled =>
          "Bluetooth ei käytössä. Varmista että puhelimen bluetooth on kytketty päälle ja että sovelluksella on tarvittavat oikeudet sen käyttöön.",
        ConnectionStatus.bleConnecting => switch (
              DeviceConnection.connectedDeviceId.isNotEmpty) {
            true => "Etsitään laitetta...",
            false => "Etsitään laitteita..."
          },
        ConnectionStatus.bleConnected => "Yhdistetty",
      };

  Widget _buildDeviceInfoDialogContent(ConnectionStatus status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _getDeviceConnectionStatusText(DeviceConnection.connectionStatus),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (DeviceConnection.connectedDeviceId.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            "Laite: Dribla (${DeviceConnection.connectedDeviceId})",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _openConnectionStatusDialog(
    BuildContext context,
    ThemeData theme,
  ) {
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
            title: "Laitteen tiedot",
            content: _buildDeviceInfoDialogContent(
              state.data ?? DeviceConnection.connectionStatus,
            ),
            actions: [
              if (DeviceConnection.connectionStatus ==
                  ConnectionStatus.bleConnected)
                const OutlinedButton(
                  onPressed: DeviceConnection.shutDownDevice,
                  child: Text("Sammuta laite"),
                ),
              if (DeviceConnection.connectedDeviceId.isNotEmpty)
                OutlinedButton(
                  onPressed: () => setState(() {
                    DeviceConnection.clearDeviceId();
                    DeviceConnection.deinit();
                    DeviceConnection.init();
                  }),
                  child: const Text("Unohda laite"),
                ),
              StyledElevatedButton(
                child: const Text("OK"),
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

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      foregroundColor: Colors.white,
      title: StreamBuilder<ConnectionStatus>(
        stream: _connectionStatusStream,
        builder: (context, state) => _getConnectionStatusIcon(
          state.data ?? DeviceConnection.connectionStatus,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _openConnectionStatusDialog(context, theme),
          icon: const Icon(Icons.settings),
        )
      ],
    );
  }
}
