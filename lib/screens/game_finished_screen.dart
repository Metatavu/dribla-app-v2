import "package:dribla_app_v2/assets.dart";
import "package:dribla_app_v2/audio_players.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/game_utils.dart";
import "package:dribla_app_v2/led_colors.dart";
import "package:dribla_app_v2/screens/play_game_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_svg/flutter_svg.dart";

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
    DeviceConnection.setAllLedColors(LedColors.off);
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
                              widget.win
                                  ? "Tulokset:"
                                  : "Parempi onni ensi kerralla :(",
                              style: theme.textTheme.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.finalScore ?? "",
                              style: theme.textTheme.headlineLarge,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ))),
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
                fixedSize: const MaterialStatePropertyAll(Size(290.0, 65.0)),
                backgroundColor: const MaterialStatePropertyAll(Colors.blue),
              ),
              child: Text(
                loc.replay,
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
                onPressed: () {
                  Navigator.pop(context);
                },
                style: theme.elevatedButtonTheme.style?.copyWith(
                  fixedSize: const MaterialStatePropertyAll(Size(290.0, 65.0)),
                  backgroundColor: const MaterialStatePropertyAll(Colors.blue),
                ),
                child: Text(
                  loc.backButtonText,
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
