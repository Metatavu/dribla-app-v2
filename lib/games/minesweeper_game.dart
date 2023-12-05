import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";
import "../timer_formatters.dart";

class MineSweeperGame extends Game {
  static const index = 3;
  static const title = "Miinaharava";
  static const description =
      """Interdum accumsan pharetra sociosqu, vehicula class fames, suspendisse
      eleifend dui nulla mollis semper feugiat risus. Congue auctor fusce
      cubilia, pretium sagittis non feugiat hendrerit.""";
  static const int iconAnimationSpeed = 200;
  static List<List<Color>> iconAnimation = [
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.multiple(Colors.red, Colors.white, [0]),
    IconAnimationUtils.multiple(Colors.red, Colors.white, [0, 1]),
    IconAnimationUtils.multiple(Colors.red, Colors.white, [0, 1, 2]),
    IconAnimationUtils.multiple(Colors.red, Colors.white, [0, 1, 2, 3]),
    IconAnimationUtils.multiple(Colors.red, Colors.white, [0, 1, 2, 3, 4]),
    IconAnimationUtils.multiple(Colors.red, Colors.white, [0, 1, 2, 3, 4, 5]),
    IconAnimationUtils.multiple(
        Colors.red, Colors.white, [0, 1, 2, 3, 4, 5, 6]),
    IconAnimationUtils.multiple(
        Colors.red, Colors.white, [0, 1, 2, 3, 4, 5, 6, 7]),
  ];
  bool started = false;
  List<int> targetsLeft = [1, 2, 3, 4, 5, 6, 7, 8];

  @override
  int getIndex() {
    return index;
  }

  @override
  String getFinalScore() {
    return TimerFormatter.format(getElapsedTime());
  }

  @override
  void onBeginTimerTick(bool onoff) {}

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
          DeviceConnection.setLedColor(LedColors.off, sensor - 1);
        }
      }
    }
    if (targetsLeft.isEmpty) {
      finish(true);
    }
  }

  @override
  void setupGame() {}

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
}
