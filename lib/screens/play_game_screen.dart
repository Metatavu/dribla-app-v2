import "dart:developer" as developer;
import "dart:math";
import "package:collection/collection.dart";

import "package:dribla_app_v2/assets.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/screens/game_finished_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_svg/flutter_svg.dart";
import "dart:async";

class PlayGameScreen extends StatefulWidget {
  const PlayGameScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PlayGameScreenState();
}

class _PlayGameScreenState extends State<PlayGameScreen> {
  StreamSubscription<List<int>>? _subscription;

  int _beginningTimerValue = 10; // Starting value for the timer
  Timer? _gameTimer;
  int _gameTimerValue = 0;

  int? currentTarget;
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
    _subscription?.cancel();
    super.dispose();
  }

  void _startBeginningTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_beginningTimerValue > 0) {
          _beginningTimerValue--;
        } else {
          timer.cancel(); // Stop the timer when it reaches 0
          _listenToSensorCharacteristic();
          _startGameTimer();
          _progressGame();
        }
      });
    });
  }

  Future<void> _listenToSensorCharacteristic() async {
    _subscription = DeviceConnection.sensorValueStream.listen((data) {
      developer.log("SENSOR DATA: ${data.toString()}");
      final activeSensors = DeviceConnection.parseSensorData(data.first);

      if (activeSensors.contains(currentTarget)) {
        _progressGame();
      }
    });
  }

  void _progressGame() {
    points++;
    int nextTarget;

    do {
      nextTarget = Random().nextInt(8) + 1;
    } while (nextTarget == currentTarget);

    if (points >= maxPoints) {
      _navigateNextScreen();
    } else {
      currentTarget = nextTarget;
      _updateTargetLed(nextTarget);
    }
  }

  Future<void> _updateTargetLed(int currentTarget) async {
    DeviceConnection.ledCharacteristics.forEachIndexed((index, characteristic) {
      characteristic.write(index + 1 == currentTarget ? [0xFF] : [0x00]);
    });
  }

  void _startGameTimer() {
    const oneSec = Duration(seconds: 1);
    _gameTimer = Timer.periodic(
      oneSec,
      (timer) => setState(() => _gameTimerValue++),
    );
  }

  void _navigateNextScreen() {
    _gameTimer?.cancel();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameFinishedScreen(
          gameTime: _gameTimerValue,
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
                        : _gameTimerValue.toString(),
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Container(
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
