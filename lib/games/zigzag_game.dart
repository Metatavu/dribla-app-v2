import "package:collection/collection.dart";
import "package:dribla_app_v2/games/game.dart";
import "package:dribla_app_v2/icon_animation_utils.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../led_colors.dart";
import "../timer_formatters.dart";

class ZigZagGame extends Game {
  static const index = 2;
  static const title = "Zig-Zag";
  static const description = "";

  static const int iconAnimationSpeed = 200;
  static List<List<Color>> iconAnimation = [
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.single(Colors.red, Colors.lightGreenAccent, 7),
    IconAnimationUtils.single(Colors.red, Colors.lightGreenAccent, 5),
    IconAnimationUtils.single(Colors.red, Colors.lightGreenAccent, 4),
    IconAnimationUtils.single(Colors.red, Colors.lightGreenAccent, 2),
    IconAnimationUtils.single(Colors.red, Colors.lightGreenAccent, 1),
    IconAnimationUtils.single(Colors.red, Colors.lightGreenAccent, 0),
    IconAnimationUtils.single(Colors.red, Colors.lightGreenAccent, 2),
    IconAnimationUtils.single(Colors.red, Colors.lightGreenAccent, 3),
    IconAnimationUtils.single(Colors.red, Colors.lightGreenAccent, 5),
    IconAnimationUtils.single(Colors.red, Colors.lightGreenAccent, 6),
  ];
  static const String numberOfRoundsSettingKey = "ZIGZAG_NUMBER_OF_ROUNDS";

  List<int> targets = [7, 6, 5, 3, 4, 2, 3, 1, 6, 0];
  int currentTargetIndex = 0;

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
        onoff ? LedColors.green : LedColors.red, targets[currentTargetIndex]);
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
    await DeviceConnection.setAllLedColors(LedColors.red);
    var settings = await getGameSettings();
    int numberOfRounds = hasSetting(settings, numberOfRoundsSettingKey)
        ? int.parse(settings[numberOfRoundsSettingKey]!)
        : 1;

    List<int> targetSeq =
        sensorCount == 8 ? [7, 6, 5, 3, 4, 2, 3, 1, 6, 0] : [4, 2, 1, 0, 2, 3];
    targets =
        List.generate(numberOfRounds, (index) => targetSeq).flattened.toList();
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
    await DeviceConnection.setSingleLedActive(
        LedColors.green, index, LedColors.red);
    await DeviceConnection.resetLeds();
  }

  @override
  List<String> getGameSettingKeys() {
    return [numberOfRoundsSettingKey];
  }

  @override
  List<int> getAllowedNumberOfSensors() {
    return [5, 8];
  }
}
