import "package:dribla_app_v2/assets.dart";
import "package:dribla_app_v2/audio_players.dart";
import "package:dribla_app_v2/screens/play_minefield_game_screen.dart";
import "package:dribla_app_v2/screens/play_ten_game_screen.dart";
import "package:dribla_app_v2/screens/play_zigzag_game_screen.dart";
import "package:dribla_app_v2/timer_formatters.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_svg/flutter_svg.dart";

import "choose_game_screen.dart";

class GameFinishedScreen extends StatefulWidget {
  final int? gameTime;
  final int gameIndex;
  final bool win;

  const GameFinishedScreen(
      {Key? key, this.gameTime, required this.gameIndex, required this.win})
      : super(key: key);

  @override
  State<GameFinishedScreen> createState() => _GameFinishedScreen();
}

class _GameFinishedScreen extends State<GameFinishedScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.win) {
      AudioPlayers.playVictory();
    } else {
      AudioPlayers.playFailure();
    }
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
                                  ? loc.gameTime
                                  : "Parempi onni ensi kerralla :(",
                              style: theme.textTheme.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.win
                                  ? TimerFormatter.format(widget.gameTime ?? 0)
                                  : "",
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
                    builder: (context) => switch (widget.gameIndex) {
                      0 => const PlayZigZagGameScreen(),
                      1 => const PlayTenGameScreen(),
                      2 => const PlayMinefieldGameScreen(),
                      _ => const PlayTenGameScreen()
                    },
                  ),
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChooseGameScreen(),
                    ),
                  );
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
