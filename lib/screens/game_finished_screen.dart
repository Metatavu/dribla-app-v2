import "package:dribla_app_v2/assets.dart";
import "package:dribla_app_v2/audio_players.dart";
import "package:dribla_app_v2/components/styled_elevated_button.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:dribla_app_v2/game_utils.dart";
import "package:dribla_app_v2/led_colors.dart";
import "package:dribla_app_v2/screens/play_game_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:sizer/sizer.dart";

class GameFinishedScreen extends StatefulWidget {
  final String? finalScore;
  final int gameIndex;
  final bool win;
  final bool skipEndingFanfare;

  const GameFinishedScreen({
    super.key,
    this.finalScore,
    required this.gameIndex,
    required this.win,
    required this.skipEndingFanfare,
  });

  @override
  State<GameFinishedScreen> createState() => _GameFinishedScreen();
}

class _GameFinishedScreen extends State<GameFinishedScreen> {
  @override
  void initState() {
    super.initState();
    if (!widget.skipEndingFanfare) {
      if (widget.win) {
        AudioPlayers.playVictory();
      } else {
        AudioPlayers.playFailure();
      }
    }
    DeviceConnection.setAllLedColors(LedColors.red);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String gameTitle = "";
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    gameTitle = loc.gameEnded;
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
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  gameTitle,
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.win ? loc.results : loc.betterLuckNextTime,
                            style: theme.textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            widget.finalScore ?? "",
                            style: theme.textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ))),
            ],
          ),
        ),
        StyledElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => PlayGameScreen(
                          selectedGame: GameUtils.selectGame(
                        widget.gameIndex,
                      ))),
            );
          },
          style: theme.elevatedButtonTheme.style?.copyWith(
            fixedSize: WidgetStatePropertyAll(Size(80.w, 10.0.h)),
          ),
          child: Icon(
            Icons.play_circle_outline,
            color: DriblaColors.white,
            size: 15.w.toDouble(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 45.0),
          child: OutlinedButton(
            onPressed: () {
              DeviceConnection.startIdleAnimation();
              Navigator.pop(context);
            },
            style: theme.outlinedButtonTheme.style?.copyWith(
              fixedSize: WidgetStatePropertyAll(Size(80.w, 7.h)),
              backgroundColor: const WidgetStatePropertyAll(DriblaColors.black),
            ),
            child: Text(
              loc.backButtonText,
              style: theme.textTheme.headlineMedium,
            ),
          ),
        ),
      ],
    );
  }
}
