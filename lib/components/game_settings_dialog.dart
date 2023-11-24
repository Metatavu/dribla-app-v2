import "package:dribla_app_v2/game_utils.dart";
import "package:dribla_app_v2/games/ten_game_two_players.dart";
import "package:dribla_app_v2/games/ten_turns_game.dart";
import "package:flutter/material.dart";

import "../games/letter_game.dart";
import "../games/ten_game.dart";
import "../games/worm_game.dart";
import "../games/zigzag_game.dart";

class GameSettingsDialog extends StatefulWidget {
  final int gameIndex;
  const GameSettingsDialog({super.key, required this.gameIndex});

  @override
  State<StatefulWidget> createState() => _GameSettingsDialog();
}

class _GameSettingsDialog extends State<GameSettingsDialog> {
  Map<String, String?> settings = {};

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  _loadCurrentSettings() async {
    var defaultSettings = await GameUtils.getGameSettings(widget.gameIndex);
    setState(() {
      settings = defaultSettings;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.gameIndex) {
      TenGame.index => _buildTenGameSettingsDialog(context),
      ZigZagGame.index => _buildZigZagSettingsDialog(context),
      LetterGame.index => _buildLetterGameSettingsDialog(context),
      WormGame.index => _buildWormGameSettingsDialog(context),
      TenGameTwoPlayers.index => _buildTenGame2PlayersSettingsDialog(context),
      TenTurnsGame.index => _buildTenTurnsGameSettingsDialog(context),
      _ => _buildNoSettingsDialog(context)
    };
  }

  int _getIntSetting(String key, int defaultValue) {
    if (settings.containsKey(key) && settings[key] != null) {
      return int.parse(settings[key]!);
    }
    return defaultValue;
  }

  String _getStringSetting(String key, String defaultValue) {
    if (settings.containsKey(key) && settings[key] != null) {
      return settings[key]!;
    }
    return defaultValue;
  }

  Widget _buildTenGameSettingsDialog(BuildContext context) {
    var key = TenGame.numberOfTargetsSettingKey;
    return AlertDialog(
      title: Column(
        children: [
          Text("Kohteiden määrä: ${_getIntSetting(key, 10)}"),
          Slider(
            value: _getIntSetting(key, 10).toDouble(),
            min: 10,
            divisions: 2,
            max: 30,
            onChanged: (va) {
              setState(() {
                settings[key] = va.round().toString();
              });
            },
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, settings),
            child: const Text("Tallenna"),
          ),
        ],
      ),
    );
  }

  Widget _buildTenGame2PlayersSettingsDialog(BuildContext context) {
    var key = TenGameTwoPlayers.numberOfTargetsSettingKey;
    return AlertDialog(
      title: Column(
        children: [
          Text("Kohteiden määrä: ${_getIntSetting(key, 10)}"),
          Slider(
            value: _getIntSetting(key, 10).toDouble(),
            min: 10,
            divisions: 2,
            max: 30,
            onChanged: (va) {
              setState(() {
                settings[key] = va.round().toString();
              });
            },
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, settings),
            child: const Text("Tallenna"),
          ),
        ],
      ),
    );
  }

  Widget _buildZigZagSettingsDialog(BuildContext context) {
    var key = ZigZagGame.numberOfRoundsSettingKey;
    return AlertDialog(
      title: Column(
        children: [
          Text("Kierrosten määrä: ${_getIntSetting(key, 1)}"),
          Slider(
            value: _getIntSetting(key, 1).toDouble(),
            min: 1,
            max: 5,
            onChanged: (va) {
              setState(() {
                settings[key] = va.round().toString();
              });
            },
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, settings),
            child: const Text("Tallenna"),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterGameSettingsDialog(BuildContext context) {
    var key = LetterGame.numberOfRoundsSettingKey;
    return AlertDialog(
      title: Column(
        children: [
          Text("Kierrosten määrä: ${_getIntSetting(key, 4)}"),
          Slider(
            value: _getIntSetting(key, 4).toDouble(),
            min: 1,
            max: 10,
            onChanged: (va) {
              setState(() {
                settings[key] = va.round().toString();
              });
            },
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, settings),
            child: const Text("Tallenna"),
          ),
        ],
      ),
    );
  }

  Widget _buildWormGameSettingsDialog(BuildContext context) {
    var key = WormGame.difficultySettingKey;
    return AlertDialog(
      title: Column(
        children: [
          const Text("Vaikeustaso"),
          DropdownButton<String>(
              value: _getStringSetting(key, "NORMAL"),
              onChanged: (String? va) {
                // This is called when the user selects an item.
                setState(() {
                  if (va != null) {
                    settings[key] = va;
                  }
                });
              },
              items: const [
                DropdownMenuItem(value: "EASY", child: Text("Helppo")),
                DropdownMenuItem(value: "NORMAL", child: Text("Normaali")),
                DropdownMenuItem(value: "HARD", child: Text("Vaikea")),
              ]),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, settings),
            child: const Text("Tallenna"),
          ),
        ],
      ),
    );
  }

  Widget _buildTenTurnsGameSettingsDialog(BuildContext context) {
    var key = TenTurnsGame.numberOfTargetsSettingKey;
    return AlertDialog(
      title: Column(
        children: [
          Text("Kohteiden määrä: ${_getIntSetting(key, 10)}"),
          Slider(
            value: _getIntSetting(key, 10).toDouble(),
            min: 10,
            divisions: 2,
            max: 30,
            onChanged: (va) {
              setState(() {
                settings[key] = va.round().toString();
              });
            },
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, settings),
            child: const Text("Tallenna"),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSettingsDialog(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          const Text("Ei asetuksia"),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
