import "dart:async";

import "package:dribla_app_v2/assets.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/led_colors.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:sizer/sizer.dart";

import "../games/game.dart";
import "game_finished_screen.dart";

class PlayGameScreen extends StatefulWidget {
  final Game selectedGame;

  const PlayGameScreen({super.key, required this.selectedGame});

  @override
  State<StatefulWidget> createState() => _PlayGameScreen();
}

class _PlayGameScreen extends State<PlayGameScreen> {
  int _timeToStart = 10; // Starting value for the timer
  String _score = "0";
  String _gameStatusText = "";
  bool _disconnected = false;
  StreamSubscription<ConnectionStatus>? _connectionStatusStreamSubscription;

  @override
  void initState() {
    super.initState();
    _initializeGame(super.context);
  }

  String getLocalizedGameStatusText(
      AppLocalizations localizations, String status) {
    if (status == "startGame") {
      return localizations.startGameText;
    }

    if (status == "timeRunning") {
      return localizations.timeRunning;
    }

    return "";
  }

  _initializeGame(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    DeviceConnection.stopIdleAnimation();
    await Future.delayed(const Duration(milliseconds: 200));
    await DeviceConnection.setAllLedColors(LedColors.off);
    await DeviceConnection.resetLeds();
    _connectionStatusStreamSubscription = DeviceConnection
        .connectionStatusController.stream
        .listen((connectionStatus) {
      if (connectionStatus == ConnectionStatus.bleDisconnected) {
        widget.selectedGame.pauseGame();
        setState(() {
          _disconnected = true;
        });
      } else if (connectionStatus == ConnectionStatus.bleConnected) {
        setState(() {
          _disconnected = false;
        });
        Timer(const Duration(milliseconds: 1000),
            () => widget.selectedGame.resumeGame());
      }
    });
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
    widget.selectedGame.onStatusUpdate = (status) {
      setState(() {
        _gameStatusText = getLocalizedGameStatusText(localizations, status);
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
    widget.selectedGame.sensorCount = DeviceConnection.connectedSensorsCount;
    widget.selectedGame.run();
  }

  @override
  void dispose() {
    widget.selectedGame.dispose();
    _connectionStatusStreamSubscription?.cancel();
    super.dispose();
  }

  void _navigateBack() {
    widget.selectedGame.dispose();
    DeviceConnection.startIdleAnimation();
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
                    _disconnected
                        ? locale.retryingConnection
                        : _timeToStart > 0
                            ? _timeToStart.toString()
                            : _score,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontSize: _disconnected
                          ? 20.0
                          : _timeToStart > 0
                              ? 160.0
                              : 84.0,
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
                fixedSize: MaterialStatePropertyAll(Size(80.w, 7.h)),
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
