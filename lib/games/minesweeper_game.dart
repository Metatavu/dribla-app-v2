import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";
import "../timer_formatters.dart";

class MineSweeperGame extends Game {
  static const index = 3;
  static const description = "";
  static const int iconAnimationSpeed = 200;
  static List<List<Color>> iconAnimation = [
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.multiple(Colors.red, Colors.lightGreenAccent, [0]),
    IconAnimationUtils.multiple(Colors.red, Colors.lightGreenAccent, [0, 1]),
    IconAnimationUtils.multiple(Colors.red, Colors.lightGreenAccent, [0, 1, 2]),
    IconAnimationUtils.multiple(
        Colors.red, Colors.lightGreenAccent, [0, 1, 2, 3]),
    IconAnimationUtils.multiple(
        Colors.red, Colors.lightGreenAccent, [0, 1, 2, 3, 4]),
    IconAnimationUtils.multiple(
        Colors.red, Colors.lightGreenAccent, [0, 1, 2, 3, 4, 5]),
    IconAnimationUtils.multiple(
        Colors.red, Colors.lightGreenAccent, [0, 1, 2, 3, 4, 5, 6]),
    IconAnimationUtils.multiple(
        Colors.red, Colors.lightGreenAccent, [0, 1, 2, 3, 4, 5, 6, 7]),
  ];
  bool started = false;
  List<int> targetsLeft = [1, 2, 3, 4, 5, 6, 7, 8];

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
    //DeviceConnection.setAllLedColors(onoff ? LedColors.red : LedColors.off);
  }

  @override
  void onGameTimerUpdate(int timeElapsed) {
    onGameScoreUpdate(TimerFormatter.format(timeElapsed));
  }

  @override
  void onSensorValueUpdate(List<int> activeSensors) {
    if (started && activeSensors.isNotEmpty) {
      for (var sensor in activeSensors) {
        if (targetsLeft.remove(sensor)) {
          AudioPlayers.playSuccess();
          DeviceConnection.setLedColor(LedColors.green, sensor - 1);
        }
      }
    }
    if (targetsLeft.isEmpty) {
      finish(true);
    }
  }

  @override
  void setupGame() {
    targetsLeft = List.generate(sensorCount, (index) => index + 1);
  }

  @override
  Future<void> startGame() async {
    await DeviceConnection.setAllLedColors(LedColors.red);
    await Future.delayed(const Duration(milliseconds: 100));
    await DeviceConnection.resetLeds();
    await Future.delayed(const Duration(milliseconds: 100));
    started = true;
  }

  @override
  List<String> getGameSettingKeys() {
    return [];
  }

  @override
  List<int> getAllowedNumberOfSensors() {
    return [5, 8];
  }
}
