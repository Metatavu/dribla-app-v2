import "package:dribla_app_v2/assets.dart";
import "package:flutter/material.dart";
import "package:flutter_blue/flutter_blue.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_svg/flutter_svg.dart";
import "dart:async";

import "choose_game_screen.dart";

class PlayGameScreen extends StatefulWidget {
  final BluetoothCharacteristic? sensorCharacteristic;
  final BluetoothCharacteristic? ledCharacteristic;

  const PlayGameScreen({
    super.key,
    this.sensorCharacteristic,
    this.ledCharacteristic,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayGameScreenState();
}

class _PlayGameScreenState extends State<PlayGameScreen> {
  String _gameTitle = "";
  int _tapCount = 10; // Total taps allowed
  int _timerValue = 5; // Starting value for the timer

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_timerValue > 0) {
          _timerValue--;
        } else {
          timer.cancel(); // Stop the timer when it reaches 0
          _listenToSensorCharacteristic();
        }
      });
    });
  }

  Future<void> _listenToSensorCharacteristic() async {
    await widget.sensorCharacteristic?.setNotifyValue(true);
    widget.sensorCharacteristic?.value.listen((value) async {
      if (value.firstOrNull == 1 && _tapCount > 0) {
        // If the first value is 1 in the characteristic value and tap count is greater than 0
        await _writeLedCharacteristic([0, 0, 0, 0]);
        _decreaseTapCount(); // Decrease the tap count
      } else if (value.firstOrNull == 0) {
        // If the first value is 0 in the characteristic value
        await _writeLedCharacteristic([0, 255, 0, 255]);
      }
    });
  }

  Future<void> _writeLedCharacteristic(List<int> value) async {
    await widget.ledCharacteristic?.write(value);
  }

  void _navigateBack() {
    if (_tapCount == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChooseGameScreen(
            sensorCharacteristic: widget.sensorCharacteristic,
            ledCharacteristic: widget.ledCharacteristic,
          ),
        ),
      );
    }
  }

  void _decreaseTapCount() {
    if (_timerValue == 0) {
      setState(() {
        _tapCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    setState(() {
      if (_timerValue > 0) {
        _gameTitle = loc.startGameText;
      } else {
        _gameTitle = loc.tapsLeft;
      }
    });

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
                    _gameTitle,
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _decreaseTapCount,
                    child: Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: _navigateBack,
                        child: Text(
                          _timerValue > 0
                              ? _timerValue.toString()
                              : _tapCount == 0
                                  ? "Hihhihhii. Voitit pelin!!1"
                                  : _tapCount.toString(),
                          style: theme.textTheme.headlineMedium!.copyWith(
                            fontSize: (2 *
                                    num.parse(
                                      theme.textTheme.headlineMedium?.fontSize
                                              .toString() ??
                                          "20",
                                    ))
                                .toDouble(),
                          ), // Double the font size
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChooseGameScreen(
                      sensorCharacteristic: widget.sensorCharacteristic,
                      ledCharacteristic: widget.ledCharacteristic,
                    ),
                  ),
                );
              },
              style: theme.elevatedButtonTheme.style!.copyWith(
                fixedSize: const MaterialStatePropertyAll(Size(290.0, 65.0)),
                backgroundColor: const MaterialStatePropertyAll(Colors.blue),
              ),
              child: Text(
                loc.backButtonText,
                style: theme.textTheme.headlineMedium,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: theme.elevatedButtonTheme.style?.copyWith(
                  fixedSize: const MaterialStatePropertyAll(Size(290.0, 65.0)),
                  backgroundColor: const MaterialStatePropertyAll(Colors.blue),
                ),
                child: Text(
                  loc.settingsButtonText,
                  style: theme.textTheme.headlineMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
