import "dart:async";

import "package:flutter/material.dart";

import "../device_connection.dart";

class ConnectionStatusAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const ConnectionStatusAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  State<StatefulWidget> createState() => _ConnectionStatusAppBar();
}

class _ConnectionStatusAppBar extends State<ConnectionStatusAppBar> {
  Stream<ConnectionStatus> _connectionStatusStream = const Stream.empty();

  @override
  void initState() {
    _connectionStatusStream =
        DeviceConnection.connectionStatusController.stream;
    super.initState();
  }

  Widget _getConnectionStatusIcon(ConnectionStatus? connectionStatus) {
    ConnectionStatus status =
        connectionStatus ?? DeviceConnection.connectionStatus;
    return switch (status) {
      ConnectionStatus.bleDisabled => const Icon(Icons.bluetooth_disabled),
      ConnectionStatus.bleConnecting => const Icon(Icons.bluetooth_searching),
      ConnectionStatus.bleConnected => const Icon(Icons.bluetooth_connected)
    };
  }

  Widget _buildDeviceInfoDialogContent() {
    return switch (DeviceConnection.connectionStatus) {
      ConnectionStatus.bleDisabled => const Text(
          "Bluetooth ei käytössä\nVarmista että puhelimen bluetooth on kytketty päälle\nja että sovelluksella on tarvittavat oikeudet sen käyttöön."),
      ConnectionStatus.bleConnecting =>
        const Text("Yhdistetään laitteeseen..."),
      ConnectionStatus.bleConnected => Container(
          height: 70,
          child: Column(
            children: [
              Text(
                  "Yhdistetty, Dribla (${DeviceConnection.connectedDeviceId})"),
              IconButton(
                  onPressed: () {
                    DeviceConnection.shutDownDevice();
                  },
                  icon: const Icon(Icons.power_off))
            ],
          ))
    };
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Laitteen tiedot"),
          content: _buildDeviceInfoDialogContent(),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        foregroundColor: Colors.white,
        title: StreamBuilder<ConnectionStatus>(
          stream: _connectionStatusStream,
          builder: (context, state) {
            if (!state.hasData) {
              return _getConnectionStatusIcon(
                  DeviceConnection.connectionStatus);
            }
            return _getConnectionStatusIcon(state.data);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                _dialogBuilder(context);
              },
              icon: const Icon(Icons.settings))
        ]);
  }
}
