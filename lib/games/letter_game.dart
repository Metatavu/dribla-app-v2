import "package:collection/collection.dart";
import "package:dribla_app_v2/dribla_colors.dart";
import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";
import "../timer_formatters.dart";

class LetterGame extends Game {
  static const index = 1;
  static const description = "";
  static const int iconAnimationSpeed = 200;
  static List<List<Color>> iconAnimation = [
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 7),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 6),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 1),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 0),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 7),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 6),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 1),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 0),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 7),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 6),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 1),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 0),
  ];
  List<int> targets = [];
  int currentTargetIndex = 0;
  static const String numberOfRoundsSettingKey = "LETTER_NUMBER_OF_ROUNDS";

  @override
  int getIndex() {
    return index;
  }

  @override
  String getFinalScore(BuildContext context) {
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
        : 4;

    List<int> targetSeq = sensorCount == 8 ? [7, 0, 4, 2] : [4, 0, 1, 3];
    int firstTarget = sensorCount == 8 ? 7 : 4;
    targets =
        List.generate(numberOfRounds, (index) => targetSeq).flattened.toList();

    targets.add(firstTarget);
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
