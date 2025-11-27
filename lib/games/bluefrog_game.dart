import "dart:async";

import "package:dribla_app_v2/theme/theme.dart";
import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";

class BluefrogGame extends Game {
  static const index = 10;
  static const description =
      """Yritä ehtiä koskettamaan valoa ennen kuin se muuttuu punaiseksi.""";

  static const int iconAnimationSpeed = 200;
  static List<List<Color>> iconAnimation = [
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.multipleColors(
        DriblaColors.orange, {0: Colors.lightGreenAccent, 1: Colors.cyan}),
    IconAnimationUtils.multipleColors(
        DriblaColors.orange, {2: Colors.lightGreenAccent, 3: Colors.cyan}),
    IconAnimationUtils.multipleColors(
        DriblaColors.orange, {5: Colors.lightGreenAccent, 3: Colors.cyan}),
    IconAnimationUtils.multipleColors(DriblaColors.orange,
        {0: const Color.fromARGB(255, 60, 120, 20), 6: Colors.cyan}),
    IconAnimationUtils.multipleColors(DriblaColors.orange,
        {0: const Color.fromARGB(255, 230, 70, 50), 6: Colors.cyan}),
    IconAnimationUtils.multipleColors(DriblaColors.orange,
        {0: const Color.fromARGB(255, 230, 70, 50), 6: Colors.cyan}),
    IconAnimationUtils.multipleColors(DriblaColors.orange,
        {0: const Color.fromARGB(255, 230, 0, 0), 6: Colors.cyan}),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(DriblaColors.orange),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(DriblaColors.orange),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(DriblaColors.orange),
    IconAnimationUtils.all(Colors.white),
  ];
  static const String difficultySettingKey = "BLUEFROG_GAME_DIFFICULTY";

  Timer? failTimer;
  double msUntilFail = 10000; // 10s
  double speedMultiplier = 0.95;
  int msOnLastUpdate = 0;
  int currentTarget = 7;
  int points = 0;

  List<List<(int, int)>> getConnectedSensors() {
    return [
      [(2, 1), (5, 6)], // 0
      [(4, 3), (7, 6)], // 1
      [(0, 1), (5, 3)], // 2
      [(2, 1)], // 3 (should never happen)
      [(1, 3), (7, 5)], // 4
      [(2, 3), (0, 6)], // 5
      [(2, 1)], // 6 (should never happen)
      [(1, 6), (4, 5)] // 7
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
    _updateTargetLed(currentTarget, null);
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

    (int, int) nextTarget =
        (getConnectedSensors()[currentTarget].toList()..shuffle()).first;
    currentTarget = nextTarget.$1;
    _updateTargetLed(nextTarget.$1, nextTarget.$2);

    failTimer = Timer(Duration(milliseconds: msUntilFail.round()), () {
      finish(false);
    });
  }

  Future<void> _updateTargetLed(int currentTarget, int? path) async {
    await DeviceConnection.setSingleLedActive(
        LedColors.green, currentTarget, LedColors.red);
    if (path != null) {
      await DeviceConnection.setLedColor(LedColors.blue, path);
    }
    await DeviceConnection.resetLeds();
  }

  @override
  List<String> getGameSettingKeys() {
    return [difficultySettingKey];
  }

  @override
  List<int> getAllowedNumberOfSensors() {
    return [8];
  }
}
