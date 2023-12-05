import "dart:async";

import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";

class MineFieldGame extends Game {
  static const index = 2;
  static const title = "Miinakenttä";
  static const description =
      """Interdum accumsan pharetra sociosqu, vehicula class fames, suspendisse
      eleifend dui nulla mollis semper feugiat risus. Congue auctor fusce
      cubilia, pretium sagittis non feugiat hendrerit.""";
  static const int iconAnimationSpeed = 200;
  static List<List<Color>> iconAnimation = [
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.single(Colors.red, Colors.white, 5),
    IconAnimationUtils.single(Colors.red, Colors.white, 5),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.white),
  ];
  bool failed = false;
  bool started = false;

  @override
  int getIndex() {
    return index;
  }

  @override
  String getFinalScore() {
    return "";
  }

  @override
  void onBeginTimerTick(bool onoff) {}

  @override
  void onGameTimerUpdate(int timeElapsed) {
    onGameScoreUpdate("Peli käynnissä");
  }

  @override
  void onSensorValueUpdate(List<int> activeSensors) {
    if (started && activeSensors.isNotEmpty && !failed) {
      failed = true;
      AudioPlayers.playExplosion();
      Timer(const Duration(seconds: 5), () => finish(false));
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
