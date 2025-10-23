import "package:dribla_app_v2/components/styled_dialog.dart";
import "package:dribla_app_v2/components/styled_elevated_button.dart";
import "package:dribla_app_v2/game_utils.dart";
import "package:dribla_app_v2/games/memory_game.dart";
import "package:dribla_app_v2/games/star_game.dart";
import "package:dribla_app_v2/games/ten_game_two_players.dart";
import "package:dribla_app_v2/games/ten_turns_game.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:sizer/sizer.dart";
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
      MemoryGame.index => _buildMemoryGameSettingsDialog(context),
      StarGame.index => _buildStarSettingsDialog(context),
      _ => _buildDefaultSettingsDialog(context)
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

  Widget _buildSettingsDialogActions(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropdownMenu<int>(
          width: 80.w,
          enableSearch: false,
          initialSelection: _getIntSetting("start_delay", 10),
          onSelected: (value) => setState(() {
            if (value != null) settings["start_delay"] = value.toString();
          }),
          dropdownMenuEntries: [
            DropdownMenuEntry(value: 10, label: localizations.startDelay10s),
            DropdownMenuEntry(value: 5, label: localizations.startDelay5s),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        ElevatedButton(
          style: theme.elevatedButtonTheme.style?.copyWith(
            fixedSize: WidgetStatePropertyAll(Size(80.w, 5.h)),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
          onPressed: () => Navigator.pop(context, settings),
          child: Text(localizations.save),
        ),
      ],
    );
  }

  Widget _buildTenGameSettingsDialog(BuildContext context) {
    var key = TenGame.numberOfTargetsSettingKey;
    final localizations = AppLocalizations.of(context)!;
    return StyledDialog(
      smallTitle: true,
      title: "${localizations.amountOfTargets}: ${_getIntSetting(key, 10)}",
      content: Slider(
        value: _getIntSetting(key, 10).toDouble(),
        min: 10,
        divisions: 2,
        max: 30,
        onChanged: (value) =>
            setState(() => settings[key] = value.round().toString()),
      ),
      actions: [_buildSettingsDialogActions(context)],
    );
  }

  Widget _buildTenGame2PlayersSettingsDialog(BuildContext context) {
    var key = TenGameTwoPlayers.numberOfTargetsSettingKey;
    final localizations = AppLocalizations.of(context)!;
    return StyledDialog(
      smallTitle: true,
      title: "${localizations.amountOfTargets}: ${_getIntSetting(key, 10)}",
      content: Slider(
        value: _getIntSetting(key, 10).toDouble(),
        min: 10,
        divisions: 2,
        max: 30,
        onChanged: (value) =>
            setState(() => settings[key] = value.round().toString()),
      ),
      actions: [_buildSettingsDialogActions(context)],
    );
  }

  Widget _buildZigZagSettingsDialog(BuildContext context) {
    var key = ZigZagGame.numberOfRoundsSettingKey;
    final localizations = AppLocalizations.of(context)!;
    return StyledDialog(
      smallTitle: true,
      title: "${localizations.amountOfTurns}: ${_getIntSetting(key, 1)}",
      content: Slider(
        value: _getIntSetting(key, 1).toDouble(),
        min: 1,
        max: 5,
        onChanged: (value) =>
            setState(() => settings[key] = value.round().toString()),
      ),
      actions: [_buildSettingsDialogActions(context)],
    );
  }

  Widget _buildStarSettingsDialog(BuildContext context) {
    var key = StarGame.numberOfRoundsSettingKey;
    final localizations = AppLocalizations.of(context)!;
    return StyledDialog(
      smallTitle: true,
      title: "${localizations.amountOfTurns}: ${_getIntSetting(key, 1)}",
      content: Slider(
        value: _getIntSetting(key, 1).toDouble(),
        min: 1,
        max: 5,
        onChanged: (value) =>
            setState(() => settings[key] = value.round().toString()),
      ),
      actions: [_buildSettingsDialogActions(context)],
    );
  }

  Widget _buildLetterGameSettingsDialog(BuildContext context) {
    var key = LetterGame.numberOfRoundsSettingKey;
    final localizations = AppLocalizations.of(context)!;
    return StyledDialog(
      smallTitle: true,
      title: "${localizations.amountOfTurns}: ${_getIntSetting(key, 4)}",
      content: Slider(
        value: _getIntSetting(key, 4).toDouble(),
        min: 1,
        max: 10,
        onChanged: (value) =>
            setState(() => settings[key] = value.round().toString()),
      ),
      actions: [_buildSettingsDialogActions(context)],
    );
  }

  Widget _buildWormGameSettingsDialog(BuildContext context) {
    var key = WormGame.difficultySettingKey;
    final localizations = AppLocalizations.of(context)!;
    return StyledDialog(
      smallTitle: true,
      title: localizations.difficulty,
      content: DropdownMenu<String>(
        enableSearch: false,
        initialSelection: _getStringSetting(key, "NORMAL"),
        onSelected: (value) => setState(() {
          if (value != null) settings[key] = value;
        }),
        dropdownMenuEntries: [
          DropdownMenuEntry(value: "EASY", label: localizations.easy),
          DropdownMenuEntry(value: "NORMAL", label: localizations.normal),
          DropdownMenuEntry(value: "HARD", label: localizations.hard),
        ],
      ),
      actions: [_buildSettingsDialogActions(context)],
    );
  }

  Widget _buildMemoryGameSettingsDialog(BuildContext context) {
    var key = MemoryGame.difficultySettingKey;
    final localizations = AppLocalizations.of(context)!;
    return StyledDialog(
      smallTitle: true,
      title: localizations.difficulty,
      content: DropdownMenu<String>(
        enableSearch: false,
        initialSelection: _getStringSetting(key, "NORMAL"),
        onSelected: (value) => setState(() {
          if (value != null) settings[key] = value;
        }),
        dropdownMenuEntries: [
          DropdownMenuEntry(value: "EASY", label: localizations.easy),
          DropdownMenuEntry(value: "NORMAL", label: localizations.normal),
          DropdownMenuEntry(value: "HARD", label: localizations.hard),
        ],
      ),
      actions: [_buildSettingsDialogActions(context)],
    );
  }

  Widget _buildTenTurnsGameSettingsDialog(BuildContext context) {
    var key = TenTurnsGame.numberOfTargetsSettingKey;
    final localizations = AppLocalizations.of(context)!;
    return StyledDialog(
      smallTitle: true,
      title: "${localizations.amountOfTurns}: ${_getIntSetting(key, 10)}",
      content: Slider(
        value: _getIntSetting(key, 10).toDouble(),
        min: 10,
        divisions: 2,
        max: 30,
        onChanged: (value) =>
            setState(() => settings[key] = value.round().toString()),
      ),
      actions: [_buildSettingsDialogActions(context)],
    );
  }

  Widget _buildDefaultSettingsDialog(BuildContext context) {
    return StyledDialog(
      actions: [_buildSettingsDialogActions(context)],
    );
  }
}
