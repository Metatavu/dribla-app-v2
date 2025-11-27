import "dart:async";

import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";

class FollowTheRabbitGame extends Game {
  static const index = 11;
  static const description = "";
  static const int iconAnimationSpeed = 200;
  static List<List<Color>> iconAnimation = [
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 7),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 5),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 4),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 2),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 1),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 0),
    IconAnimationUtils.single(DriblaColors.orange, Colors.lightGreenAccent, 7),
  ];
  bool failed = false;
  bool started = false;
  int lastBonusSoundMinutes = 0;
  int current = 0;
  double speedMs = 3000; // 3s
  Timer? changeTimer;
  List<int> path = [7, 5, 4, 2, 1, 0];

  @override
  int getIndex() {
    return index;
  }

  @override
  String getFinalScore(BuildContext context) {
    return "";
  }

  @override
  void onBeginTimerTick(bool onoff) {
    DeviceConnection.setLedColor(
        onoff ? LedColors.green : LedColors.red, path[current]);
  }

  @override
  String getPointsUnit() {
    return "gameRunning";
  }

  @override
  void onGameTimerUpdate(int timeElapsed) {
    if (!failed && started) {
      onGameScoreUpdate("");
    }
    if (timeElapsed > 1000 * 60 * 10) {
      changeTimer?.cancel();
      finish(true);
    } else if (timeElapsed > 1000 * 60 * (lastBonusSoundMinutes + 1)) {
      lastBonusSoundMinutes += 1;
      AudioPlayers.playBonus();
    }
  }

  @override
  void onSensorValueUpdate(List<int> activeSensors) {
    // Do nothing
  }

  @override
  void setupGame() {
    lastBonusSoundMinutes = 0;
  }

  @override
  Future<void> startGame() async {
    started = true;
    _progressGame();
  }

  void _progressGame() {
    changeTimer?.cancel();
    current++;
    if (current >= path.length) {
      current = 0;
    }
    speedMs = speedMs * 0.8;
    DeviceConnection.setSingleLedActive(
        LedColors.green, path[current], LedColors.red);
    changeTimer = Timer(Duration(milliseconds: speedMs.round()), () {
      _progressGame();
    });
  }

  @override
  List<String> getGameSettingKeys() {
    return [];
  }

  @override
  List<int> getAllowedNumberOfSensors() {
    return [8];
  }
}
