import "package:collection/collection.dart";
import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";
import "../timer_formatters.dart";

class LetterGame extends Game {
  static const index = 4;
  static const title = "Kirjekuori";
  static const description =
      """Interdum accumsan pharetra sociosqu, vehicula class fames, suspendisse
      eleifend dui nulla mollis semper feugiat risus. Congue auctor fusce
      cubilia, pretium sagittis non feugiat hendrerit.""";
  static const int iconAnimationSpeed = 200;
  static List<List<Color>> iconAnimation = [
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.single(Colors.white, Colors.blue, 7),
    IconAnimationUtils.single(Colors.white, Colors.blue, 6),
    IconAnimationUtils.single(Colors.white, Colors.blue, 1),
    IconAnimationUtils.single(Colors.white, Colors.blue, 0),
    IconAnimationUtils.single(Colors.white, Colors.blue, 7),
    IconAnimationUtils.single(Colors.white, Colors.blue, 6),
    IconAnimationUtils.single(Colors.white, Colors.blue, 1),
    IconAnimationUtils.single(Colors.white, Colors.blue, 0),
    IconAnimationUtils.single(Colors.white, Colors.blue, 7),
    IconAnimationUtils.single(Colors.white, Colors.blue, 6),
    IconAnimationUtils.single(Colors.white, Colors.blue, 1),
    IconAnimationUtils.single(Colors.white, Colors.blue, 0),
  ];
  List<int> targets = [];
  int currentTargetIndex = 0;
  static const String numberOfRoundsSettingKey = "LETTER_NUMBER_OF_ROUNDS";

  @override
  int getIndex() {
    return index;
  }

  @override
  String getFinalScore() {
    return TimerFormatter.format(getElapsedTime());
  }

  @override
  void onBeginTimerTick(bool onoff) {
    DeviceConnection.setLedColor(
        onoff ? LedColors.RED : LedColors.OFF, targets[currentTargetIndex]);
  }

  @override
  void onGameTimerUpdate(int timeElapsed) {
    onGameScoreUpdate(TimerFormatter.format(timeElapsed));
  }

  @override
  void onSensorValueUpdate(List<int> activeSensors) {
    if (currentTargetIndex < targets.length &&
        activeSensors.contains(targets[currentTargetIndex] + 1)) {
      _progressGame();
    }
  }

  @override
  void setupGame() async {
    var settings = await getGameSettings();
    int numberOfRounds = hasSetting(settings, numberOfRoundsSettingKey)
        ? int.parse(settings[numberOfRoundsSettingKey]!)
        : 4;

    targets = List.generate(numberOfRounds, (index) => [7, 0, 4, 2])
        .flattened
        .toList();

    targets.add(7);
  }

  @override
  void startGame() {
    _updateTargetLed(targets[currentTargetIndex]);
  }

  void _progressGame() {
    AudioPlayers.playSuccess();
    currentTargetIndex++;
    if (currentTargetIndex >= targets.length) {
      finish(true);
    } else {
      _updateTargetLed(targets[currentTargetIndex]);
    }
  }

  Future<void> _updateTargetLed(int index) async {
    await DeviceConnection.setSingleLedActive(LedColors.BLUE, index);
  }

  @override
  List<String> getGameSettingKeys() {
    return [numberOfRoundsSettingKey];
  }
}
