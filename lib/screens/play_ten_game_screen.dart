import "dart:developer" as developer;
import "dart:math";
import "package:audioplayers/audioplayers.dart";

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

class PlayTenGameScreen extends StatefulWidget {
  const PlayTenGameScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PlayTenGameScreen();
}

class _PlayTenGameScreen extends State<PlayTenGameScreen> {
  int _beginningTimerValue = 10; // Starting value for the timer
  String _gameStatusText = "ALOITETAAN!"; // TODO: localize
  Timer? _gameTimer;
  Timer? _beginningTimer;
  int _gameTimerValue = 0;

  int currentTarget = 1;
  int points = 0;
  int maxPoints = 10;

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
            onoff ? LedColors.RED : LedColors.OFF, currentTarget - 1);
        onoff = !onoff;
      } else {
        setState(() {
          _gameStatusText = "AIKAA KULUNUT:";
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
      if (data.contains(currentTarget)) {
        _progressGame();
      }
    });
  }

  void _startGame() {
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
      developer.log("Game finished!");
      _navigateNextScreen();
    } else {
      currentTarget = nextTarget;
      developer.log("Next target: $nextTarget");
      _updateTargetLed(nextTarget);
    }
  }

  Future<void> _updateTargetLed(int currentTarget) async {
    await DeviceConnection.setSingleLedActive(
        LedColors.BLUE, currentTarget - 1);
  }

  void _startGameTimer() {
    const millis100 = Duration(milliseconds: 100);
    _gameTimer = Timer.periodic(
      millis100,
      (timer) => setState(() => _gameTimerValue += 100),
    );
  }

  void _navigateNextScreen() {
    _gameTimer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameFinishedScreen(
          gameTime: _gameTimerValue,
          win: true,
          gameIndex: 1,
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
