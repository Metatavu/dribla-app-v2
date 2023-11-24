import "dart:math";

import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";
import "../timer_formatters.dart";

class TenTurnsGame extends Game {
  static const index = 7;
  static const title = "10 - Käännöstä";
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
    DeviceConnection.setLedColor(onoff ? LedColors.RED : LedColors.OFF, 7);
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
    var settings = await getGameSettings();
    maxPoints = hasSetting(settings, numberOfTargetsSettingKey)
        ? int.parse(settings[numberOfTargetsSettingKey]!)
        : 10;
  }

  @override
  Future<void> startGame() async {
    currentTargets = turns[0];
    await _updateTargetLed(currentTargets, foundTargets);
    await DeviceConnection.resetLeds();
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
    var colors = found.map((_) => LedColors.GREEN).toList();
    var left = ledTargets.where((t) => !found.contains(t)).toList();
    colors.addAll(left.map((_) => LedColors.BLUE));
    await DeviceConnection.setLedsActive(colors, found + left);
  }

  @override
  void onGameTimerUpdate(int timeElapsed) {
    onGameScoreUpdate(TimerFormatter.format(timeElapsed));
  }

  @override
  List<String> getGameSettingKeys() {
    return [numberOfTargetsSettingKey];
  }
}
