import "dart:async";
import "dart:math";

import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";

class MemoryGame extends Game {
  static const index = 8;
  static const title = "Muistipeli";
  static const description =
      """• Harjoittele kuljettamista molemmilla jaloilla ja käytä erilaisia tapoja muuttaa suuntaa.
      • Pidä hyvä peliasento koko ajan
      • Pyri nostamaan katsetta pois pallosta, jotta voit havannoida paremmin""";
  static const int iconAnimationSpeed = 200;
  static List<List<Color>> iconAnimation = [
    IconAnimationUtils.all(Colors.white),
    ...List.generate(
        10,
        (index) => IconAnimationUtils.single(
            Colors.white, Colors.blue, Random().nextInt(8)))
  ];

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

  List<int> currentTargets = [];
  List<int> foundTargets = [];
  int difficulty = 3;
  int points = 0;
  bool _readingActive = false;

  @override
  int getIndex() {
    return MemoryGame.index;
  }

  @override
  String getFinalScore() {
    return points.toString();
  }

  @override
  void onBeginTimerTick(bool onoff) {}

  @override
  void onSensorValueUpdate(List<int> activeSensors) {
    var next = currentTargets.firstWhere((i) => !foundTargets.contains(i));
    for (var activeSensor in activeSensors) {
      var index = activeSensor - 1;
      if (_readingActive && index != next && !foundTargets.contains(index)) {
        _fail(index, next);
      } else if (_readingActive && index == next) {
        foundTargets.add(index);
        _progressGame(index);
      }
    }
  }

  @override
  void setupGame() async {}

  @override
  Future<void> startGame() async {
    currentTargets = turns[0];
    await DeviceConnection.resetLeds();
    _showTargets(currentTargets);
  }

  @override
  bool skipEndingFanfare() {
    return true;
  }

  List<int> _getRandomTargets(int count) {
    List<int> randomTargets = [];
    var allTargets = List.generate(8, (index) => index);
    for (var _ in List.generate(count, (index) => index)) {
      allTargets.shuffle();
      var next = allTargets.first;
      allTargets.remove(next);
      randomTargets.add(next);
    }
    return randomTargets;
  }

  void _progressGame(int? lastActive) {
    AudioPlayers.playSuccess();
    points++;
    onGameScoreUpdate(points.toString());
    if (foundTargets.length == currentTargets.length) {
      foundTargets = [];
      if (points < 6) {
        int nextTarget;
        do {
          nextTarget = Random().nextInt(turns.length);
        } while (lastActive != null && turns[nextTarget].contains(lastActive));
        currentTargets = turns[nextTarget];
      } else {
        difficulty++;
        if (difficulty > 8) {
          difficulty = 8;
        }
        currentTargets = _getRandomTargets(difficulty);
      }
      _showTargets(currentTargets);
    } else {
      _updateTargetLed(foundTargets);
    }
  }

  Future<void> _fail(int wrongTarget, int correctTarget) async {
    _readingActive = false;
    AudioPlayers.playFailure();
    for (var _ in List.generate(4, (index) => index)) {
      await DeviceConnection.setAllLedColors(LedColors.OFF);
      await DeviceConnection.setLedsActive(
          [LedColors.RED, LedColors.BLUE], [wrongTarget, correctTarget]);
      await Future.delayed(const Duration(milliseconds: 50));
    }
    await DeviceConnection.setAllLedColors(LedColors.OFF);
    finish(false);
  }

  Future<void> _showTargets(List<int> ledTargets) async {
    _readingActive = false;
    for (var _ in List.generate(3, (index) => index)) {
      await DeviceConnection.setAllLedColors(LedColors.OFF);
      for (var target in ledTargets) {
        await DeviceConnection.setLedColor(LedColors.BLUE, target);
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    await DeviceConnection.setAllLedColors(LedColors.OFF);
    await DeviceConnection.resetLeds();
    _readingActive = true;
  }

  Future<void> _updateTargetLed(List<int> found) async {
    var colors = found.map((_) => LedColors.GREEN).toList();
    await DeviceConnection.setLedsActive(colors, found);
    await DeviceConnection.resetLeds();
  }

  @override
  void onGameTimerUpdate(int timeElapsed) {}

  @override
  List<String> getGameSettingKeys() {
    return [];
  }
}
