import "dart:math";

import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";
import "../timer_formatters.dart";

class TenGame extends Game {
  static const index = 4;
  static const description = "";
  static const int iconAnimationSpeed = 200;
  static List<List<Color>> iconAnimation = [
    IconAnimationUtils.all(Colors.white),
    ...List.generate(
        10,
        (index) => IconAnimationUtils.single(
            Colors.red, Colors.lightGreenAccent, Random().nextInt(8)))
  ];

  static const String numberOfTargetsSettingKey = "TEN_GAME_NUMBER_OF_TARGETS";

  int maxPoints = 10;
  int currentTarget = 8;
  int points = 0;

  List<List<int>> getConnectedSensors() {
    if (sensorCount == 8) {
      return [
        [7, 5, 4, 3, 2], // 0
        [4, 5, 7], // 1
        [4, 5, 6, 7, 0], // 2
        [0, 7], // 3
        [2, 1, 6, 0, 7], // 4
        [0, 1, 2], // 5
        [2, 4], // 6
        [0, 1, 2, 3, 4] // 7
      ];
    }
    return [
      [1, 2], // 0
      [0, 2], // 1
      [0, 1, 3, 4], // 2
      [2, 4], // 3
      [2, 3], // 4
    ];
  }

  @override
  int getIndex() {
    return TenGame.index;
  }

  @override
  String getFinalScore() {
    return TimerFormatter.format(getElapsedTime());
  }

  @override
  void onBeginTimerTick(bool onoff) {
    DeviceConnection.setLedColor(
        onoff ? LedColors.green : LedColors.red, currentTarget - 1);
  }

  @override
  void onSensorValueUpdate(List<int> activeSensors) {
    if (activeSensors.contains(currentTarget)) {
      _progressGame();
    }
  }

  @override
  void setupGame() async {
    await DeviceConnection.setAllLedColors(LedColors.red);
    var settings = await getGameSettings();
    maxPoints = hasSetting(settings, numberOfTargetsSettingKey)
        ? int.parse(settings[numberOfTargetsSettingKey]!)
        : 10;
    currentTarget = sensorCount == 8 ? 8 : 5;
  }

  @override
  void startGame() {
    _updateTargetLed(currentTarget);
  }

  void _progressGame() {
    points++;
    AudioPlayers.playSuccess();

    int nextTarget;
    do {
      nextTarget = (getConnectedSensors()[(currentTarget - 1)].toList()
                ..shuffle())
              .first +
          1;
    } while (nextTarget == currentTarget);

    if (points >= maxPoints) {
      finish(true);
    } else {
      currentTarget = nextTarget;
      _updateTargetLed(nextTarget);
    }
  }

  Future<void> _updateTargetLed(int currentTarget) async {
    await DeviceConnection.setSingleLedActive(
        LedColors.green, currentTarget - 1, LedColors.red);
    await DeviceConnection.resetLeds();
  }

  @override
  void onGameTimerUpdate(int timeElapsed) {
    onGameScoreUpdate(TimerFormatter.format(timeElapsed));
  }

  @override
  List<String> getGameSettingKeys() {
    return [numberOfTargetsSettingKey];
  }

  @override
  List<int> getAllowedNumberOfSensors() {
    return [5, 8];
  }
}
