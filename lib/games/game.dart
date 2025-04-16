import "dart:async";

import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../audio_players.dart";
import "../device_connection.dart";

abstract class Game {
  Timer? _gameTick;
  Timer? _beginningTimer;
  Stopwatch _gameTime = Stopwatch();
  int _beginningTimerValue = 10;
  bool _started = false;
  int sensorCount = 8;

  Function(String) onStatusUpdate = (String status) {};
  Function(int) onCountDownUpdate = (int countdown) {};
  Function(String) onGameScoreUpdate = (String score) {};
  Function(bool) onFinish = (bool win) {};

  int getIndex();
  String getFinalScore(BuildContext context);
  void onBeginTimerTick(bool onoff);
  void onSensorValueUpdate(List<int> activeSensors);
  void onGameTimerUpdate(int timeElapsed);
  void setupGame();
  void startGame();
  List<String> getGameSettingKeys();
  List<int> getAllowedNumberOfSensors();

  String getPointsUnit() {
    return "timeRunning";
  }

  void finish(bool win) {
    _stopGame();
    onFinish(win);
  }

  int getElapsedTime() {
    return _gameTime.elapsedMilliseconds;
  }

  int getGameTimerProgressMs() {
    return 100;
  }

  void run() async {
    final delay = await getStartDelay();
    _beginningTimerValue = delay ?? 10;
    setupGame();
    const oneSec = Duration(seconds: 1);
    var countDownStarted = false;
    bool onoff = false;
    onStatusUpdate("startGame");
    onCountDownUpdate(_beginningTimerValue);
    _beginningTimer = Timer.periodic(oneSec, (timer) {
      _beginningTimerValue--;
      onCountDownUpdate(_beginningTimerValue);
      if (_beginningTimerValue < 4 && !countDownStarted) {
        countDownStarted = true;
        AudioPlayers.playCountDown();
      }
      if (_beginningTimerValue > 0) {
        onoff = !onoff;
        onBeginTimerTick(onoff);
      } else {
        onStatusUpdate(getPointsUnit());
        _beginningTimer?.cancel(); // Stop the timer when it reaches 0
        _listenToSensorCharacteristic();
        _startGameTimer();
        _startGame();
      }
    });
  }

  Future<Map<String, String?>> getGameSettings() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String?> settings = {};
    var keys = getGameSettingKeys();
    keys.add("start_delay");
    for (var settingKey in keys) {
      settings[settingKey] = prefs.getString(settingKey);
    }
    return settings;
  }

  Future<int?> getStartDelay() async {
    final prefs = await SharedPreferences.getInstance();
    final startDelay = prefs.getString("start_delay") ?? "10";
    return int.tryParse(startDelay);
  }

  setStartDelay(Map<String, String?> settings) async {
    final prefs = await SharedPreferences.getInstance();
    if (settings.containsKey("start_delay") &&
        settings["start_delay"] != null) {
      prefs.setString("start_delay", settings["start_delay"]!);
    } else {
      prefs.remove("start_delay");
    }
  }

  setGameSettings(Map<String, String?> settings) async {
    final prefs = await SharedPreferences.getInstance();
    var keys = getGameSettingKeys();
    for (var settingKey in keys) {
      if (settings.containsKey(settingKey) && settings[settingKey] != null) {
        prefs.setString(settingKey, settings[settingKey]!);
      } else {
        prefs.remove(settingKey);
      }
      //settings[settingKey] = prefs.getString(settingKey);
    }
  }

  void _startGameTimer() {
    var progress = getGameTimerProgressMs();
    var millis100 = Duration(milliseconds: progress);
    _gameTime.reset();
    _gameTime.start();
    _gameTick = Timer.periodic(
      millis100,
      (timer) => onGameTimerUpdate(_gameTime.elapsedMilliseconds),
    );
  }

  Future<void> _listenToSensorCharacteristic() async {
    DeviceConnection.addSensorValueListener((data) {
      if (_started) {
        onSensorValueUpdate(data);
      }
    });
  }

  bool hasSetting(Map<String, String?> settings, String key) {
    return settings.containsKey(key) && settings[key] != null;
  }

  bool skipEndingFanfare() {
    return false;
  }

  void pauseGame() {
    _started = false;
    _gameTime.stop();
  }

  void resumeGame() {
    _started = true;
    _gameTime.start();
  }

  void _startGame() {
    _started = true;
    startGame();
  }

  void _stopGame() {
    _started = false;
    _gameTick?.cancel();
    _gameTime.stop();
    _beginningTimer?.cancel();
  }

  void dispose() {
    _stopGame();
    DeviceConnection.clearListeners();
  }
}
