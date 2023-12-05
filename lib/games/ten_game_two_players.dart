import "dart:math";

import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";
import "../timer_formatters.dart";

class TenGameTwoPlayers extends Game {
  static const index = 6;
  static const title = "10 - Peli (2 Pelaajaa)";
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
      "TEN_GAME_2PLAYER_NUMBER_OF_TARGETS";

  int maxPoints = 10;
  int currentTargetPlayer1 = 8;
  int currentTargetPlayer2 = 3;
  int pointsPlayer1 = 0;
  int pointsPlayer2 = 0;

  @override
  int getIndex() {
    return TenGameTwoPlayers.index;
  }

  @override
  String getFinalScore() {
    var winner = pointsPlayer1 >= maxPoints ? "Sininen" : "Punainen";
    var loser = winner == "Sininen" ? "Punainen" : "Sininen";
    var winnerPoints =
        pointsPlayer1 > pointsPlayer2 ? pointsPlayer1 : pointsPlayer2;
    var loserPoints =
        pointsPlayer1 > pointsPlayer2 ? pointsPlayer2 : pointsPlayer1;
    return "$winner: $winnerPoints \n $loser: $loserPoints  \n ${TimerFormatter.format(getElapsedTime())}";
  }

  @override
  void onBeginTimerTick(bool onoff) {
    DeviceConnection.setLedColor(
        onoff ? LedColors.blue : LedColors.off, currentTargetPlayer1 - 1);
    DeviceConnection.setLedColor(
        onoff ? LedColors.red : LedColors.off, currentTargetPlayer2 - 1);
  }

  @override
  void onSensorValueUpdate(List<int> activeSensors) {
    if (activeSensors.contains(currentTargetPlayer1)) {
      _progressGamePlayer1();
    }
    if (activeSensors.contains(currentTargetPlayer2)) {
      _progressGamePlayer2();
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
    await _updateTargetLeds(currentTargetPlayer1, currentTargetPlayer2);
    await DeviceConnection.resetLeds();
  }

  void _progressGamePlayer1() {
    pointsPlayer1++;
    AudioPlayers.playSuccess();

    int nextTarget =
        _getNextTarget([currentTargetPlayer1, currentTargetPlayer2]);

    if (pointsPlayer1 >= maxPoints) {
      finish(true);
    } else {
      currentTargetPlayer1 = nextTarget;
      _updateTargetLeds(nextTarget, currentTargetPlayer2);
    }
  }

  void _progressGamePlayer2() {
    pointsPlayer2++;
    AudioPlayers.playSuccess();

    int nextTarget =
        _getNextTarget([currentTargetPlayer1, currentTargetPlayer2]);

    if (pointsPlayer2 >= maxPoints) {
      finish(true);
    } else {
      currentTargetPlayer2 = nextTarget;
      _updateTargetLeds(currentTargetPlayer1, nextTarget);
    }
  }

  int _getNextTarget(List<int> exclude) {
    int nextTarget;
    do {
      nextTarget = Random().nextInt(8) + 1;
    } while (exclude.contains(nextTarget));
    return nextTarget;
  }

  Future<void> _updateTargetLeds(int currentTarget, int currentTarget2) async {
    await DeviceConnection.setLedsActive([LedColors.blue, LedColors.red],
        [currentTarget - 1, currentTarget2 - 1]);
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
