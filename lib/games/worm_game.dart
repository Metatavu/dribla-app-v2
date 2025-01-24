import "dart:async";

import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";

class WormGame extends Game {
  static const index = 7;
  static const description =
      """Yritä ehtiä koskettamaan valoa ennen kuin se muuttuu punaiseksi.""";

  static const int iconAnimationSpeed = 200;
  static List<List<Color>> iconAnimation = [
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.single(Colors.red, Colors.lightGreenAccent, 0),
    IconAnimationUtils.single(Colors.red, Colors.lightGreenAccent, 2),
    IconAnimationUtils.single(Colors.red, Colors.lightGreenAccent, 3),
    IconAnimationUtils.single(
        Colors.white, const Color.fromARGB(255, 200, 150, 100), 3),
    IconAnimationUtils.single(Colors.red, Colors.lightGreenAccent, 5),
    IconAnimationUtils.single(
        Colors.red, const Color.fromARGB(255, 200, 150, 100), 5),
    IconAnimationUtils.single(
        Colors.red, const Color.fromARGB(255, 230, 100, 70), 5),
    IconAnimationUtils.single(Colors.red, Colors.lightGreenAccent, 4),
    IconAnimationUtils.single(
        Colors.red, const Color.fromARGB(255, 200, 150, 100), 4),
    IconAnimationUtils.single(
        Colors.red, const Color.fromARGB(255, 230, 100, 70), 4),
    IconAnimationUtils.single(
        Colors.red, const Color.fromARGB(255, 230, 70, 50), 4),
    IconAnimationUtils.single(Colors.red, Colors.lightGreenAccent, 1),
    IconAnimationUtils.single(
        Colors.red, const Color.fromARGB(255, 200, 150, 100), 1),
    IconAnimationUtils.single(
        Colors.red, const Color.fromARGB(255, 230, 100, 70), 1),
    IconAnimationUtils.single(
        Colors.red, const Color.fromARGB(255, 230, 70, 50), 1),
    IconAnimationUtils.single(
        Colors.red, const Color.fromARGB(255, 230, 30, 30), 1),
    IconAnimationUtils.single(
        Colors.red, const Color.fromARGB(255, 230, 0, 0), 1),
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

  List<List<int>> getConnectedSensors() {
    if (sensorCount == 8) {
      return [
        [1, 6], // 0
        [0, 6, 2, 3], // 1
        [3, 1], // 2
        [1, 2, 4, 5], // 3
        [3, 5], // 4
        [3, 4, 6, 7], // 5
        [5, 1, 0, 7], // 6
        [5, 6] // 7
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
    return index;
  }

  @override
  String getPointsUnit() {
    return "points";
  }

  @override
  String getFinalScore(BuildContext context) {
    return points.toString();
  }

  @override
  void onBeginTimerTick(bool onoff) {
    DeviceConnection.setLedColor(
        onoff ? LedColors.green : LedColors.red, currentTarget);
  }

  @override
  void onGameTimerUpdate(int timeElapsed) {
    int elapsedAfterUpdate = timeElapsed - msOnLastUpdate;
    double t = elapsedAfterUpdate / msUntilFail;
    Color? color = Color.lerp(const Color.fromARGB(0, 0, 255, 0),
        const Color.fromARGB(0, 255, 0, 0), t);
    if (color != null) {
      DeviceConnection.setLedColor(LedColors.fromColor(color), currentTarget);
    }
  }

  @override
  int getGameTimerProgressMs() {
    return 200;
  }

  @override
  void onSensorValueUpdate(List<int> activeSensors) {
    if (activeSensors.contains(currentTarget + 1)) {
      _progressGame();
    }
  }

  @override
  void setupGame() async {
    await DeviceConnection.setAllLedColors(LedColors.red);
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
    currentTarget = sensorCount == 8 ? 7 : 4;
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
        (getConnectedSensors()[currentTarget].toList()..shuffle()).first;
    currentTarget = nextTarget;
    _updateTargetLed(nextTarget);

    failTimer = Timer(Duration(milliseconds: msUntilFail.round()), () {
      finish(false);
    });
  }

  Future<void> _updateTargetLed(int currentTarget) async {
    await DeviceConnection.setSingleLedActive(
        LedColors.green, currentTarget, LedColors.red);
    await DeviceConnection.resetLeds();
  }

  @override
  List<String> getGameSettingKeys() {
    return [difficultySettingKey];
  }

  @override
  List<int> getAllowedNumberOfSensors() {
    return [5, 8];
  }
}
