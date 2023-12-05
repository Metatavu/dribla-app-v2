import "dart:async";

import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";

class WormGame extends Game {
  static const index = 5;
  static const title = "Matopeli";
  static const description =
      """Interdum accumsan pharetra sociosqu, vehicula class fames, suspendisse
      eleifend dui nulla mollis semper feugiat risus. Congue auctor fusce
      cubilia, pretium sagittis non feugiat hendrerit.""";

  static const int iconAnimationSpeed = 200;
  static List<List<Color>> iconAnimation = [
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.single(Colors.white, Colors.blue, 0),
    IconAnimationUtils.single(Colors.white, Colors.blue, 2),
    IconAnimationUtils.single(Colors.white, Colors.blue, 3),
    IconAnimationUtils.single(
        Colors.white, const Color.fromARGB(255, 200, 150, 100), 3),
    IconAnimationUtils.single(Colors.white, Colors.blue, 5),
    IconAnimationUtils.single(
        Colors.white, const Color.fromARGB(255, 200, 150, 100), 5),
    IconAnimationUtils.single(
        Colors.white, const Color.fromARGB(255, 230, 100, 70), 5),
    IconAnimationUtils.single(Colors.white, Colors.blue, 4),
    IconAnimationUtils.single(
        Colors.white, const Color.fromARGB(255, 200, 150, 100), 4),
    IconAnimationUtils.single(
        Colors.white, const Color.fromARGB(255, 230, 100, 70), 4),
    IconAnimationUtils.single(
        Colors.white, const Color.fromARGB(255, 230, 70, 50), 4),
    IconAnimationUtils.single(Colors.white, Colors.blue, 1),
    IconAnimationUtils.single(
        Colors.white, const Color.fromARGB(255, 200, 150, 100), 1),
    IconAnimationUtils.single(
        Colors.white, const Color.fromARGB(255, 230, 100, 70), 1),
    IconAnimationUtils.single(
        Colors.white, const Color.fromARGB(255, 230, 70, 50), 1),
    IconAnimationUtils.single(
        Colors.white, const Color.fromARGB(255, 230, 30, 30), 1),
    IconAnimationUtils.single(
        Colors.white, const Color.fromARGB(255, 230, 0, 0), 1),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.all(Colors.white),
  ];
  static const String difficultySettingKey = "WORM_GAME_DIFFICULTY";

  Timer? failTimer;
  double msUntilFail = 10000; // 10s
  double speedMultiplier = 0.95;
  int msOnLastUpdate = 0;
  int currentTarget = 7;
  int points = 0;
  List<List<int>> connectedSensors = [
    [1, 6, 7], // 0
    [0, 6, 2, 3], // 1
    [3, 1, 4], // 2
    [1, 2, 4, 5], // 3
    [3, 2, 5], // 4
    [3, 4, 6, 7], // 5
    [5, 1, 0, 7], // 6
    [5, 6, 0] // 7
  ];

  @override
  int getIndex() {
    return index;
  }

  @override
  String getFinalScore() {
    return points.toString();
  }

  @override
  void onBeginTimerTick(bool onoff) {
    DeviceConnection.setLedColor(
        onoff ? LedColors.red : LedColors.off, currentTarget);
  }

  @override
  void onGameTimerUpdate(int timeElapsed) {
    int elapsedAfterUpdate = timeElapsed - msOnLastUpdate;
    double t = elapsedAfterUpdate / msUntilFail;
    Color? color = Color.lerp(const Color.fromARGB(0, 0, 0, 255),
        const Color.fromARGB(0, 255, 0, 0), t);
    if (color != null) {
      DeviceConnection.setLedColor(LedColors.fromColor(color), currentTarget);
    }
  }

  @override
  void onSensorValueUpdate(List<int> activeSensors) {
    if (activeSensors.contains(currentTarget + 1)) {
      _progressGame();
    }
  }

  @override
  void setupGame() async {
    var settings = await getGameSettings();
    var difficulty = hasSetting(settings, difficultySettingKey)
        ? settings[difficultySettingKey]
        : "NORMAL";

    speedMultiplier = switch (difficulty) {
      "HARD" => 0.85,
      "NORMAL" => 0.95,
      "EASY" => 0.99,
      _ => 0.95
    };
  }

  @override
  void startGame() {
    _updateTargetLed(currentTarget);
    failTimer = Timer(Duration(milliseconds: msUntilFail.round()), () {
      finish(false);
    });
  }

  void _progressGame() {
    failTimer?.cancel();
    points++;
    onGameScoreUpdate(points.toString());
    AudioPlayers.playSuccess();
    msUntilFail = speedMultiplier * msUntilFail;
    msOnLastUpdate = getElapsedTime();

    int nextTarget =
        (connectedSensors[currentTarget].toList()..shuffle()).first;
    currentTarget = nextTarget;
    _updateTargetLed(nextTarget);

    failTimer = Timer(Duration(milliseconds: msUntilFail.round()), () {
      finish(false);
    });
  }

  Future<void> _updateTargetLed(int currentTarget) async {
    await DeviceConnection.resetLeds();
    await DeviceConnection.setSingleLedActive(LedColors.blue, currentTarget);
  }

  @override
  List<String> getGameSettingKeys() {
    return [difficultySettingKey];
  }
}
