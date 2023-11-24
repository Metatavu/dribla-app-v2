import "package:dribla_app_v2/assets.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/led_colors.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../games/game.dart";
import "game_finished_screen.dart";

class PlayGameScreen extends StatefulWidget {
  final Game selectedGame;

  const PlayGameScreen({Key? key, required this.selectedGame})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayGameScreen();
}

class _PlayGameScreen extends State<PlayGameScreen> {
  int _timeToStart = 10; // Starting value for the timer
  String _score = "0";
  String _gameStatusText = "ALOITETAAN!"; // TODO: localize

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  _initializeGame() async {
    await DeviceConnection.setAllLedColors(LedColors.OFF);
    await DeviceConnection.resetLeds();
    widget.selectedGame.onCountDownUpdate = (timeToStart) {
      setState(() {
        _timeToStart = timeToStart;
      });
    };
    widget.selectedGame.onGameScoreUpdate = (score) {
      setState(() {
        _score = score;
      });
    };
    widget.selectedGame.onStatusTextUpdate = (status) {
      setState(() {
        _gameStatusText = status;
      });
    };
    widget.selectedGame.onFinish = (win) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameFinishedScreen(
            finalScore: widget.selectedGame.getFinalScore(),
            win: win,
            skipEndingFanfare: widget.selectedGame.skipEndingFanfare(),
            gameIndex: widget.selectedGame.getIndex(),
          ),
        ),
      );
    };
    widget.selectedGame.run();
  }

  @override
  void dispose() {
    widget.selectedGame.dispose();
    super.dispose();
  }

  void _navigateBack() {
    widget.selectedGame.dispose();
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
                    _timeToStart > 0 ? _timeToStart.toString() : _score,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontSize: _timeToStart > 0 ? 160.0 : 84.0,
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
