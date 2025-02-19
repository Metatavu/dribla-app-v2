import "dart:async";

import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";

enum GameMode { easy, normal, hard }

class MemoryGame extends Game {
  static const index = 9;
  static const description =
      """Helppo: Kirjaimet. Muista kirjain ja kosketa kaikkia valoja omassa järjestyksessä.
      Normaali: Kuviot. Kosketa kuvion valoja omassa järjestyksessä
      Vaikea: Kuviot. Kosketa kuvion valoja syttymisjärjestyksessä""";
  static const int iconAnimationSpeed = 200;
  static List<List<Color>> iconAnimation = [
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.multiple(Colors.red, Colors.cyan, [2]),
    IconAnimationUtils.multiple(Colors.red, Colors.cyan, [2, 1]),
    IconAnimationUtils.multiple(Colors.red, Colors.cyan, [2, 1, 0]),
    IconAnimationUtils.multiple(Colors.red, Colors.cyan, [2, 1, 0, 7]),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.multiple(Colors.red, Colors.lightGreenAccent, [2]),
    IconAnimationUtils.multiple(Colors.red, Colors.lightGreenAccent, [2, 1]),
    IconAnimationUtils.multiple(Colors.red, Colors.lightGreenAccent, [2, 1, 0]),
    IconAnimationUtils.multiple(
        Colors.red, Colors.lightGreenAccent, [2, 1, 0, 7]),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.multiple(Colors.red, Colors.cyan, [0]),
    IconAnimationUtils.multiple(Colors.red, Colors.cyan, [0, 1]),
    IconAnimationUtils.multiple(Colors.red, Colors.cyan, [0, 1, 2]),
    IconAnimationUtils.multiple(Colors.red, Colors.cyan, [0, 1, 2, 4]),
    IconAnimationUtils.multiple(Colors.red, Colors.cyan, [0, 1, 2, 4, 5]),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.multiple(Colors.red, Colors.lightGreenAccent, [0]),
    IconAnimationUtils.multiple(Colors.red, Colors.lightGreenAccent, [0, 1]),
    IconAnimationUtils.multiple(Colors.red, Colors.lightGreenAccent, [0, 1, 2]),
    IconAnimationUtils.multiple(
        Colors.red, Colors.lightGreenAccent, [0, 1, 2, 4]),
    IconAnimationUtils.single(Colors.white, Colors.red, 6),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.red),
    IconAnimationUtils.all(Colors.white),
    IconAnimationUtils.all(Colors.white),
  ];
  static const String difficultySettingKey = "MEMORY_GAME_DIFFICULTY";

  List<List<int>> letters = [
    [2, 1, 0, 7],
    [2, 1, 0, 7],
    [0, 1, 2, 3, 4, 5, 7],
    [2, 1, 0],
    [2, 1, 0, 7, 5, 4],
    [4, 5, 7, 0, 1],
    [0, 1, 2, 4, 5],
    [4, 2, 1, 5, 7, 0],
    [0, 1, 2, 4, 5, 6, 7]
  ];

  List<int> currentTargets = [];
  List<int> foundTargets = [];
  int points = 0;
  int currentLetterIndex = 0;
  bool _readingActive = false;
  GameMode mode = GameMode.normal;
  int round = 0;
  List<int> targetCount = [
    2,
    2,
    2,
    3,
    3,
    3,
    4,
    4,
    4,
    5,
    5,
    5,
    6,
    6,
    6,
    7,
    7,
    7
  ];

  @override
  int getIndex() {
    return MemoryGame.index;
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
  void onBeginTimerTick(bool onoff) {}

  @override
  void onSensorValueUpdate(List<int> activeSensors) {
    if (mode == GameMode.hard) {
      var next = currentTargets.firstWhere((i) => !foundTargets.contains(i));
      for (var activeSensor in activeSensors) {
        var index = activeSensor - 1;
        if (_readingActive && index != next && !foundTargets.contains(index)) {
          _fail(index, [next]);
        } else if (_readingActive && index == next) {
          foundTargets.add(index);
          _progressGame(index);
        }
      }
    } else {
      for (var activeSensor in activeSensors) {
        var index = activeSensor - 1;
        var availableTargets =
            currentTargets.where((i) => !foundTargets.contains(i));
        if (_readingActive &&
            !availableTargets.contains(index) &&
            !foundTargets.contains(index)) {
          _fail(index, availableTargets.toList());
        } else if (_readingActive && availableTargets.contains(index)) {
          foundTargets.add(index);
          _progressGame(index);
        }
      }
    }
  }

  @override
  void setupGame() async {
    var settings = await getGameSettings();
    var difficulty = hasSetting(settings, difficultySettingKey)
        ? settings[difficultySettingKey]
        : "NORMAL";

    mode = switch (difficulty) {
      "HARD" => GameMode.hard,
      "NORMAL" => GameMode.normal,
      "EASY" => GameMode.easy,
      _ => GameMode.normal
    };
    round = 0;
    if (mode == GameMode.hard) {
      round = 3;
    }
  }

  @override
  Future<void> startGame() async {
    currentTargets = switch (mode) {
      GameMode.hard => _getRandomTargets(targetCount[round]),
      GameMode.normal => _getRandomTargets(targetCount[round]),
      GameMode.easy => _getRandomLetter()
    };
    await DeviceConnection.resetLeds();
    _showTargets(currentTargets);
  }

  @override
  bool skipEndingFanfare() {
    return true;
  }

  List<int> _getRandomLetter() {
    return (letters..shuffle()).first;
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

  Future<void> _progressGame(int? lastActive) async {
    AudioPlayers.playSuccess();
    points++;
    onGameScoreUpdate(points.toString());
    await _updateTargetLed(foundTargets);
    if (foundTargets.length == currentTargets.length) {
      await Future.delayed(const Duration(milliseconds: 1000));
      foundTargets = [];
      if (mode == GameMode.easy) {
        currentTargets = _getRandomLetter();
      } else {
        round++;
        int count = round >= targetCount.length ? 8 : targetCount[round];
        currentTargets = _getRandomTargets(count);
      }
      _showTargets(currentTargets);
    }
  }

  Future<void> _fail(int wrongTarget, List<int> correctTargets) async {
    _readingActive = false;

    AudioPlayers.playFailure();
    /*for (var _ in List.generate(4, (index) => index)) {
      await DeviceConnection.setAllLedColors(LedColors.off);
      await DeviceConnection.setLedsActive(
          [LedColors.red, ...correctTargets.map((_) => LedColors.green)],
          [wrongTarget, ...correctTargets]);
      await Future.delayed(const Duration(milliseconds: 50));
    }*/
    await DeviceConnection.setAllLedColors(LedColors.red);
    finish(false);
  }

  Future<void> _showTargets(List<int> ledTargets) async {
    _readingActive = false;
    if (mode == GameMode.hard) {
      for (var _ in List.generate(3, (index) => index)) {
        await DeviceConnection.setAllLedColors(LedColors.red);
        await Future.delayed(const Duration(milliseconds: 5000));
        for (var target in ledTargets) {
          await DeviceConnection.setLedColor(LedColors.blue, target);
          await Future.delayed(const Duration(milliseconds: 700));
        }
      }
    } else {
      await DeviceConnection.setLedsActive(
          ledTargets.map((_) => LedColors.blue).toList(),
          ledTargets,
          LedColors.red);
      await Future.delayed(const Duration(milliseconds: 3000));
    }

    await DeviceConnection.setAllLedColors(LedColors.red);
    await DeviceConnection.resetLeds();
    await Future.delayed(const Duration(milliseconds: 1000));
    _readingActive = true;
  }

  Future<void> _updateTargetLed(List<int> found) async {
    var colors = found.map((_) => LedColors.green).toList();
    await DeviceConnection.setLedsActive(colors, found, LedColors.red);
    await DeviceConnection.resetLeds();
  }

  @override
  void onGameTimerUpdate(int timeElapsed) {}

  @override
  List<String> getGameSettingKeys() {
    return [difficultySettingKey];
  }

  @override
  List<int> getAllowedNumberOfSensors() {
    return [8];
  }
}
