import "dart:async";

import "package:shared_preferences/shared_preferences.dart";

import "../audio_players.dart";
import "../device_connection.dart";

abstract class Game {
  Timer? _gameTimer;
  Timer? _beginningTimer;
  int _beginningTimerValue = 10;
  int _gameTimerValue = 0;
  bool _started = false;

  Function(String) onStatusTextUpdate = (String status) {};
  Function(int) onCountDownUpdate = (int countdown) {};
  Function(String) onGameScoreUpdate = (String score) {};
  Function(bool) onFinish = (bool win) {};

  int getIndex();
  String getFinalScore();
  void onBeginTimerTick(bool onoff);
  void onSensorValueUpdate(List<int> activeSensors);
  void onGameTimerUpdate(int timeElapsed);
  void setupGame();
  void startGame();
  List<String> getGameSettingKeys();

  void finish(bool win) {
    _stopGame();
    onFinish(win);
  }

  int getElapsedTime() {
    return _gameTimerValue;
  }

  void run() {
    setupGame();
    const oneSec = Duration(seconds: 1);
    var countDownStarted = false;
    bool onoff = false;
    onStatusTextUpdate("ALOITETAAN!");
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
        onStatusTextUpdate("AIKAA KULUNUT:");
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
    for (var settingKey in keys) {
      settings[settingKey] = prefs.getString(settingKey);
    }
    return settings;
  }

  setGameSettings(Map<String, String?> settings) async {
    final prefs = await SharedPreferences.getInstance();
    var keys = getGameSettingKeys();
    for (var settingKey in keys) {
      if (settings.containsKey(settingKey)) {
        prefs.setString(settingKey, settings[settingKey]!);
      } else {
        prefs.remove(settingKey);
      }
      //settings[settingKey] = prefs.getString(settingKey);
    }
  }

  void _startGameTimer() {
    const millis100 = Duration(milliseconds: 100);
    _gameTimer = Timer.periodic(
      millis100,
      (timer) => {_gameTimerValue += 100, onGameTimerUpdate(_gameTimerValue)},
    );
  }

  Future<void> _listenToSensorCharacteristic() async {
    DeviceConnection.addSensorValueListerner((data) {
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

  void _startGame() {
    _started = true;
    startGame();
  }

  void _stopGame() {
    _started = false;
    _gameTimer?.cancel();
    _beginningTimer?.cancel();
  }

  void dispose() {
    _stopGame();
    DeviceConnection.clearListeners();
  }
}
