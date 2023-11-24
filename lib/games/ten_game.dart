import "dart:math";

import "package:dribla_app_v2/games/game.dart";
import "package:flutter/material.dart";

import "../audio_players.dart";
import "../device_connection.dart";
import "../icon_animation_utils.dart";
import "../led_colors.dart";
import "../timer_formatters.dart";

class TenGame extends Game {
  static const index = 0;
  static const title = "10 - Peli";
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

  static const String numberOfTargetsSettingKey = "TEN_GAME_NUMBER_OF_TARGETS";

  int maxPoints = 10;
  int currentTarget = 8;
  int points = 0;

  @override
  int getIndex() {
    return TenGame.index;
  }

  @override
  String getFinalScore() {
    return TimerFormatter.format(getElapsedTime());
  }

  @override
  void onBeginTimerTick(bool onoff) {
    DeviceConnection.setLedColor(
        onoff ? LedColors.RED : LedColors.OFF, currentTarget - 1);
  }

  @override
  void onSensorValueUpdate(List<int> activeSensors) {
    if (activeSensors.contains(currentTarget)) {
      _progressGame();
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
  void startGame() {
    _updateTargetLed(currentTarget);
  }

  void _progressGame() {
    points++;
    AudioPlayers.playSuccess();

    int nextTarget;
    do {
      nextTarget = Random().nextInt(8) + 1;
    } while (nextTarget == currentTarget);

    if (points >= maxPoints) {
      finish(true);
    } else {
      currentTarget = nextTarget;
      _updateTargetLed(nextTarget);
    }
  }

  Future<void> _updateTargetLed(int currentTarget) async {
    await DeviceConnection.setSingleLedActive(
        LedColors.BLUE, currentTarget - 1);
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
