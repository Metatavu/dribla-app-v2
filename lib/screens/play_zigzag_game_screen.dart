import "package:dribla_app_v2/assets.dart";
import "package:dribla_app_v2/audio_players.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/led_colors.dart";
import "package:dribla_app_v2/screens/game_finished_screen.dart";
import "package:dribla_app_v2/timer_formatters.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_svg/flutter_svg.dart";
import "dart:async";

class PlayZigZagGameScreen extends StatefulWidget {
  const PlayZigZagGameScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PlayZigZagGameScreen();
}

class _PlayZigZagGameScreen extends State<PlayZigZagGameScreen> {
  int _beginningTimerValue = 10; // Starting value for the timer
  String _gameStatusText = "ALOITETAAN!"; // TODO: localize
  Timer? _gameTimer;
  Timer? _beginningTimer;
  int maxGameTime = 60 * 1000;
  int _gameTimerValue = 60 * 1000;
  List<int> targets = [0, 4, 1, 6, 2, 7, 6, 3, 4, 5];
  int currentTargetIdex = 0;

  @override
  void initState() {
    super.initState();
    _startBeginningTimer();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _beginningTimer?.cancel();
    DeviceConnection.clearListeners();
    super.dispose();
  }

  void _startBeginningTimer() {
    const oneSec = Duration(seconds: 1);
    var onoff = false;
    var countDownStarted = false;
    setState(() {
      _gameStatusText = "ALOITETAAN!";
    });
    _beginningTimer = Timer.periodic(oneSec, (timer) {
      setState(() {
        _beginningTimerValue--;
      });

      if (_beginningTimerValue < 4 && !countDownStarted) {
        countDownStarted = true;
        AudioPlayers.playCountDown();
      }

      if (_beginningTimerValue > 0) {
        DeviceConnection.setLedColor(
            onoff ? LedColors.RED : LedColors.OFF, targets[currentTargetIdex]);
        onoff = !onoff;
      } else {
        setState(() {
          _gameStatusText = "AIKAA JÄLJELLÄ:";
        });
        _beginningTimer?.cancel(); // Stop the timer when it reaches 0
        _listenToSensorCharacteristic();
        _startGameTimer();
        _startGame();
      }
    });
  }

  Future<void> _listenToSensorCharacteristic() async {
    DeviceConnection.addSensorValueListerner((data) {
      if (data.contains(targets[currentTargetIdex] + 1)) {
        _progressGame();
      }
    });
  }

  void _startGame() {
    _updateTargetLed(targets[currentTargetIdex]);
  }

  void _progressGame() {
    AudioPlayers.playSuccess();
    currentTargetIdex++;
    if (currentTargetIdex >= targets.length) {
      _navigateNextScreen(true);
    } else {
      _updateTargetLed(targets[currentTargetIdex]);
    }
  }

  Future<void> _updateTargetLed(int index) async {
    await DeviceConnection.setSingleLedActive(LedColors.BLUE, index);
  }

  void _startGameTimer() {
    const millis100 = Duration(milliseconds: 100);
    _gameTimer = Timer.periodic(
      millis100,
      (timer) => {
        setState(() => _gameTimerValue -= 100),
        if (_gameTimerValue <= 0) {_navigateNextScreen(false)}
      },
    );
  }

  void _navigateNextScreen(bool win) {
    _gameTimer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameFinishedScreen(
          gameTime: maxGameTime - _gameTimerValue,
          win: win,
          gameIndex: 0,
        ),
      ),
    );
  }

  void _navigateBack() {
    _gameTimer?.cancel();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          image: AssetImage(Assets.chooseGameBackgroundImageAsset),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0),
                ),
                child: SvgPicture.asset(
                  Assets.logoAsset,
                  width: 138,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Text(
                  _gameStatusText,
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                )),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    _beginningTimerValue > 0
                        ? _beginningTimerValue.toString()
                        : TimerFormatter.format(_gameTimerValue),
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontSize: _beginningTimerValue > 0 ? 160.0 : 84.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 25.0),
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(5, 5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _navigateBack,
              style: theme.elevatedButtonTheme.style!.copyWith(
                fixedSize: const MaterialStatePropertyAll(Size(290.0, 65.0)),
                backgroundColor: const MaterialStatePropertyAll(Colors.blue),
              ),
              child: Text(
                locale.backButtonText,
                style: theme.textTheme.headlineMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
