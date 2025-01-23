import "dart:math";

import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";
import "../timer_formatters.dart";

class TenTurnsGame extends Game {
  static const index = 6;
  static const description = "";
  static const int iconAnimationSpeed = 200;
  static List<List<Color>> iconAnimation = [
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.multipleColors(
        Colors.red, {7: Colors.cyan, 5: Colors.cyan, 1: Colors.cyan}),
    IconAnimationUtils.multipleColors(Colors.red,
        {7: Colors.lightGreenAccent, 5: Colors.cyan, 1: Colors.cyan}),
    IconAnimationUtils.multipleColors(Colors.red, {
      7: Colors.lightGreenAccent,
      5: Colors.lightGreenAccent,
      1: Colors.cyan
    }),
    IconAnimationUtils.multipleColors(Colors.red, {
      7: Colors.lightGreenAccent,
      5: Colors.lightGreenAccent,
      1: Colors.lightGreenAccent
    }),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.multipleColors(
        Colors.red, {0: Colors.cyan, 1: Colors.cyan, 5: Colors.cyan}),
    IconAnimationUtils.multipleColors(Colors.red,
        {0: Colors.lightGreenAccent, 1: Colors.cyan, 5: Colors.cyan}),
    IconAnimationUtils.multipleColors(Colors.red, {
      0: Colors.lightGreenAccent,
      1: Colors.lightGreenAccent,
      5: Colors.cyan
    }),
    IconAnimationUtils.multipleColors(Colors.red, {
      0: Colors.lightGreenAccent,
      1: Colors.lightGreenAccent,
      5: Colors.lightGreenAccent
    }),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.multipleColors(
        Colors.red, {1: Colors.cyan, 6: Colors.cyan, 5: Colors.cyan}),
    IconAnimationUtils.multipleColors(Colors.red,
        {1: Colors.lightGreenAccent, 6: Colors.cyan, 5: Colors.cyan}),
    IconAnimationUtils.multipleColors(Colors.red, {
      1: Colors.lightGreenAccent,
      6: Colors.lightGreenAccent,
      5: Colors.cyan
    }),
    IconAnimationUtils.multipleColors(Colors.red, {
      1: Colors.lightGreenAccent,
      6: Colors.lightGreenAccent,
      5: Colors.lightGreenAccent
    }),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.multipleColors(
        Colors.red, {1: Colors.cyan, 2: Colors.cyan, 4: Colors.cyan}),
    IconAnimationUtils.multipleColors(Colors.red,
        {1: Colors.lightGreenAccent, 2: Colors.cyan, 4: Colors.cyan}),
    IconAnimationUtils.multipleColors(Colors.red, {
      1: Colors.lightGreenAccent,
      2: Colors.lightGreenAccent,
      4: Colors.cyan
    }),
    IconAnimationUtils.multipleColors(Colors.red, {
      1: Colors.lightGreenAccent,
      2: Colors.lightGreenAccent,
      4: Colors.lightGreenAccent
    }),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.multipleColors(
        Colors.red, {6: Colors.cyan, 5: Colors.cyan, 3: Colors.cyan}),
    IconAnimationUtils.multipleColors(Colors.red,
        {6: Colors.lightGreenAccent, 5: Colors.cyan, 3: Colors.cyan}),
    IconAnimationUtils.multipleColors(Colors.red, {
      6: Colors.lightGreenAccent,
      5: Colors.lightGreenAccent,
      3: Colors.cyan
    }),
    IconAnimationUtils.multipleColors(Colors.red, {
      6: Colors.lightGreenAccent,
      5: Colors.lightGreenAccent,
      3: Colors.lightGreenAccent
    }),
  ];

  static const String numberOfTargetsSettingKey =
      "TEN_TURNS_GAME_NUMBER_OF_TARGETS";

  List<List<int>> turns = [
    [7, 5, 1],
    [0, 1, 5],
    [2, 1, 5],
    [4, 5, 1],
    [0, 6, 1],
    [0, 6, 7],
    [7, 6, 5],
    [1, 6, 5],
    [1, 3, 2],
    [5, 3, 4],
    [1, 3, 5],
    [1, 2, 4],
    [2, 4, 5],
    [5, 7, 0],
    [1, 0, 7],
    [6, 1, 3],
    [6, 5, 3]
  ];

  int maxPoints = 10;
  List<int> currentTargets = [];
  List<int> foundTargets = [];
  int points = 0;
  bool _resetDone = false;

  @override
  int getIndex() {
    return TenTurnsGame.index;
  }

  @override
  String getFinalScore() {
    return TimerFormatter.format(getElapsedTime());
  }

  @override
  void onBeginTimerTick(bool onoff) {
    DeviceConnection.setLedColor(onoff ? LedColors.green : LedColors.red, 7);
  }

  @override
  void onSensorValueUpdate(List<int> activeSensors) {
    for (var activeSensor in activeSensors) {
      var index = activeSensor - 1;
      if (_resetDone &&
          !foundTargets.contains(index) &&
          currentTargets.contains(index)) {
        foundTargets.add(index);
        _progressGame(index);
      }
    }
  }

  @override
  void setupGame() async {
    await DeviceConnection.setAllLedColors(LedColors.red);
    var settings = await getGameSettings();
    maxPoints = hasSetting(settings, numberOfTargetsSettingKey)
        ? int.parse(settings[numberOfTargetsSettingKey]!)
        : 10;
  }

  @override
  Future<void> startGame() async {
    currentTargets = turns[0];
    await _updateTargetLed(currentTargets, foundTargets);
    _resetDone = true;
  }

  void _progressGame(int? lastActive) {
    AudioPlayers.playSuccess();

    if (foundTargets.length == currentTargets.length) {
      points++;
      int nextTarget;
      do {
        nextTarget = Random().nextInt(turns.length);
      } while (lastActive != null && turns[nextTarget].contains(lastActive));
      foundTargets = [];
      currentTargets = turns[nextTarget];
    }
    if (points >= maxPoints) {
      finish(true);
    } else {
      _updateTargetLed(currentTargets, foundTargets);
    }
  }

  Future<void> _updateTargetLed(List<int> ledTargets, List<int> found) async {
    var colors = found.map((_) => LedColors.green).toList();
    var left = ledTargets.where((t) => !found.contains(t)).toList();
    colors.addAll(left.map((_) => LedColors.blue));
    await DeviceConnection.setLedsActive(colors, found + left, LedColors.red);
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
    return [8];
  }
}
