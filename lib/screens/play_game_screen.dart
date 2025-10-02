import "dart:async";

import "package:dribla_app_v2/assets.dart";
import "package:dribla_app_v2/components/styled_elevated_button.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/dribla_colors.dart";
import "package:dribla_app_v2/led_colors.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:sizer/sizer.dart";

import "../games/game.dart";
import "game_finished_screen.dart";

class PlayGameScreen extends StatefulWidget {
  final Game selectedGame;

  const PlayGameScreen({super.key, required this.selectedGame});

  @override
  State<StatefulWidget> createState() => _PlayGameScreen();
}

class _PlayGameScreen extends State<PlayGameScreen>
    with SingleTickerProviderStateMixin {
  int _timeToStart = 0;
  String _score = "";
  String _gameStatusText = "";
  bool _disconnected = false;
  StreamSubscription<ConnectionStatus>? _connectionStatusStreamSubscription;
  late AnimationController _disconnectedAnimationController;

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _disconnectedAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 47),
    )..addListener(() {
        setState(() {});
      });
  }

  String getLocalizedGameStatusText(
      AppLocalizations localizations, String status) {
    if (status == "startGame") {
      return localizations.startGameText;
    }

    if (status == "timeRunning") {
      return localizations.timeRunning;
    }

    if (status == "points") {
      return localizations.points;
    }

    if (status == "gameRunning") {
      return localizations.gameRunning;
    }

    return "";
  }

  _initializeGame() async {
    await Future.delayed(const Duration(milliseconds: 200));
    await DeviceConnection.setAllLedColors(LedColors.red);
    await DeviceConnection.resetLeds();
    _connectionStatusStreamSubscription = DeviceConnection
        .connectionStatusController.stream
        .listen((connectionStatus) {
      if (connectionStatus == ConnectionStatus.bleDisconnected) {
        widget.selectedGame.pauseGame();
        _disconnectedAnimationController.reset();
        _disconnectedAnimationController.forward();
        setState(() {
          _disconnected = true;
        });
      } else if (connectionStatus == ConnectionStatus.bleConnected) {
        _disconnectedAnimationController.stop();
        setState(() {
          _disconnected = false;
        });
        Timer(const Duration(milliseconds: 1000),
            () => widget.selectedGame.resumeGame());
      }
    });
    widget.selectedGame.onCountDownUpdate = (timeToStart) {
      if (mounted) {
        setState(() {
          _timeToStart = timeToStart;
        });
      }
    };
    widget.selectedGame.onGameScoreUpdate = (score) {
      if (mounted) {
        setState(() {
          _score = score;
        });
      }
    };

    widget.selectedGame.onFinish = (win) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameFinishedScreen(
            finalScore: widget.selectedGame.getFinalScore(context),
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
    widget.selectedGame.onStatusUpdate = (status) {
      setState(() {
        _gameStatusText = getLocalizedGameStatusText(locale, status);
      });
    };
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0),
              ),
              child: Image(
                image: const AssetImage(Assets.logoAsset),
                width: 50.w,
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
                    fontFamily: "Urbanist",
                    fontWeight: FontWeight.w900,
                    fontSize: _disconnected
                        ? 20.0
                        : _timeToStart > 0
                            ? 160.0
                            : 84.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (_disconnected) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LinearProgressIndicator(
                    value: _disconnectedAnimationController.value,
                    minHeight: 16.0,
                    color: DriblaColors.orange,
                    semanticsLabel: "Reconnect indicator",
                  ),
                )
              ]
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 45.0),
          child: StyledElevatedButton(
            onPressed: _navigateBack,
            style: theme.elevatedButtonTheme.style!.copyWith(
              fixedSize: WidgetStatePropertyAll(Size(80.w, 7.h)),
            ),
            child: Text(
              locale.backButtonText,
              style: theme.textTheme.headlineMedium,
            ),
          ),
        ),
      ],
    );
  }
}
