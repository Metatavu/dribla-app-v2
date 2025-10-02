import "dart:async";

import "package:dribla_app_v2/dribla_colors.dart";
import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";

class MineFieldGame extends Game {
  static const index = 0;
  static const description = "";
  static const int iconAnimationSpeed = 200;
  static List<List<Color>> iconAnimation = [
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(DriblaColors.orange),
    IconAnimationUtils.all(DriblaColors.orange),
    IconAnimationUtils.all(DriblaColors.orange),
    IconAnimationUtils.all(DriblaColors.orange),
    IconAnimationUtils.single(DriblaColors.orange, Colors.white, 5),
    IconAnimationUtils.single(DriblaColors.orange, Colors.white, 5),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(DriblaColors.orange),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(DriblaColors.orange),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(DriblaColors.orange),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.white),
  ];
  bool failed = false;
  bool started = false;
  int lastBonusSoundMinutes = 0;

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
    //DeviceConnection.setAllLedColors(onoff ? LedColors.red : LedColors.off);
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
      finish(true);
    } else if (timeElapsed > 1000 * 60 * (lastBonusSoundMinutes + 1)) {
      lastBonusSoundMinutes += 1;
      AudioPlayers.playBonus();
    }
  }

  @override
  void onSensorValueUpdate(List<int> activeSensors) {
    if (started && activeSensors.isNotEmpty && !failed) {
      failed = true;
      AudioPlayers.playBeep();
      Timer(const Duration(seconds: 2), () => finish(false));
    }
  }

  @override
  void setupGame() {
    lastBonusSoundMinutes = 0;
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
