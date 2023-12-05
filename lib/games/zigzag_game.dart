import "package:collection/collection.dart";
import "package:dribla_app_v2/games/game.dart";
import "package:dribla_app_v2/icon_animation_utils.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../led_colors.dart";
import "../timer_formatters.dart";

class ZigZagGame extends Game {
  static const index = 1;
  static const title = "Zig-Zag";
  static const description = """• Harjoittele sisä-ja ulkosyrjäkäännöksiä
      • Pidä hyvä peliasento
      • Pyri nostamaan katsetta pois pallosta, jotta voit havannoida paremmin""";

  static const int iconAnimationSpeed = 200;
  static List<List<Color>> iconAnimation = [
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.single(Colors.white, Colors.blue, 7),
    IconAnimationUtils.single(Colors.white, Colors.blue, 5),
    IconAnimationUtils.single(Colors.white, Colors.blue, 4),
    IconAnimationUtils.single(Colors.white, Colors.blue, 2),
    IconAnimationUtils.single(Colors.white, Colors.blue, 1),
    IconAnimationUtils.single(Colors.white, Colors.blue, 0),
    IconAnimationUtils.single(Colors.white, Colors.blue, 2),
    IconAnimationUtils.single(Colors.white, Colors.blue, 3),
    IconAnimationUtils.single(Colors.white, Colors.blue, 5),
    IconAnimationUtils.single(Colors.white, Colors.blue, 6),
  ];
  static const String numberOfRoundsSettingKey = "ZIGZAG_NUMBER_OF_ROUNDS";

  int maxGameTime = 60 * 1000;
  List<int> targets = [7, 6, 5, 3, 4, 2, 3, 1, 6, 0];
  int currentTargetIndex = 0;

  @override
  int getIndex() {
    return index;
  }

  @override
  String getFinalScore() {
    return TimerFormatter.format(getElapsedTime());
  }

  @override
  void onBeginTimerTick(bool onoff) {
    DeviceConnection.setLedColor(
        onoff ? LedColors.red : LedColors.off, targets[currentTargetIndex]);
  }

  @override
  void onGameTimerUpdate(int timeElapsed) {
    if (timeElapsed >= maxGameTime) {
      finish(false);
    }
    onGameScoreUpdate(TimerFormatter.format(maxGameTime - timeElapsed));
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
    var settings = await getGameSettings();
    int numberOfRounds = hasSetting(settings, numberOfRoundsSettingKey)
        ? int.parse(settings[numberOfRoundsSettingKey]!)
        : 1;

    targets =
        List.generate(numberOfRounds, (index) => [7, 6, 5, 3, 4, 2, 3, 1, 6, 0])
            .flattened
            .toList();
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
    await DeviceConnection.setSingleLedActive(LedColors.blue, index);
  }

  @override
  List<String> getGameSettingKeys() {
    return [numberOfRoundsSettingKey];
  }
}
