import "package:dribla_app_v2/assets.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/components/game_icon.dart";
import "package:dribla_app_v2/components/game_settings_dialog.dart";
import "package:dribla_app_v2/components/styled_elevated_button.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/game_utils.dart";
import "package:dribla_app_v2/games/letter_game.dart";
import "package:dribla_app_v2/games/memory_game.dart";
import "package:dribla_app_v2/games/minefield_game.dart";
import "package:dribla_app_v2/games/minesweeper_game.dart";
import "package:dribla_app_v2/games/star_game.dart";
import "package:dribla_app_v2/games/ten_game.dart";
import "package:dribla_app_v2/games/ten_game_two_players.dart";
import "package:dribla_app_v2/games/ten_turns_game.dart";
import "package:dribla_app_v2/games/worm_game.dart";
import "package:dribla_app_v2/games/zigzag_game.dart";
import "package:dribla_app_v2/screens/play_game_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_swiper_plus/flutter_swiper_plus.dart";
import "package:sizer/sizer.dart";
import "package:url_launcher/url_launcher_string.dart";

class ChooseGameScreen extends StatefulWidget {
  const ChooseGameScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChooseGameScreenState();
}

class _ChooseGameScreenState extends State<ChooseGameScreen> {
  int chosenGame = 0;

  @override
  void initState() {
    super.initState();
    DeviceConnection.startIdleAnimation();
  }

  String getLocalizedTitle(int index, AppLocalizations localizations) {
    return switch (index) {
      TenGame.index => localizations.tengame,
      ZigZagGame.index => localizations.zigzag,
      MineFieldGame.index => localizations.minefield,
      MineSweeperGame.index => localizations.pickBerries,
      LetterGame.index => localizations.envelope,
      WormGame.index => localizations.snake,
      TenGameTwoPlayers.index => localizations.tengameMultiplayer,
      TenTurnsGame.index => localizations.tenturns,
      MemoryGame.index => localizations.memoryGame,
      StarGame.index => localizations.startGameText,
      _ => ""
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const ConnectionStatusAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage(Assets.chooseGameBackgroundImageAsset),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 3.0.h),
                      child: Text(
                        loc.chooseGame,
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                //  width: 200,
                //height: 400,
                child: SizedBox(
                  child: Swiper(
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GameIcon(
                              animationSpeedMs:
                                  GameUtils.getIconAnimationSpeed(index),
                              colorSequency: GameUtils.getIconAnimation(index)),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              getLocalizedTitle(index, loc),
                              style: theme.textTheme.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: 10,
                    loop: false,
                    onIndexChanged: (index) => {
                      setState(() {
                        chosenGame = index;
                      })
                    },
                    pagination: SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      margin: const EdgeInsets.only(bottom: 22.0),
                      builder: DotSwiperPaginationBuilder(
                          activeColor: Colors.red,
                          size: 15.0.sp,
                          activeSize: 15.0.sp,
                          space: 7.sp),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15.0),
                child: StyledElevatedButton(
                  onPressed: () async {
                    launchUrlString(GameUtils.getInstructionsUrl(chosenGame));
                  },
                  style: theme.elevatedButtonTheme.style?.copyWith(
                    fixedSize: MaterialStatePropertyAll(
                      Size(80.w, 7.h),
                    ),
                    backgroundColor: const MaterialStatePropertyAll(
                      Colors.blueAccent,
                    ),
                  ),
                  child: Text(
                    loc.instructionsButtonText,
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
              ),
              if (GameUtils.hasGameSettings(chosenGame))
                Container(
                  margin: const EdgeInsets.only(bottom: 15.0),
                  child: StyledElevatedButton(
                    onPressed: () async {
                      var data = await showDialog<Map<String, String?>>(
                        context: context,
                        builder: (context) =>
                            GameSettingsDialog(gameIndex: chosenGame),
                      );
                      if (data != null) {
                        GameUtils.setGameSettings(chosenGame, data);
                      }
                    },
                    style: theme.elevatedButtonTheme.style?.copyWith(
                      fixedSize: MaterialStatePropertyAll(
                        Size(80.w, 7.h),
                      ),
                      backgroundColor: const MaterialStatePropertyAll(
                        Colors.blueAccent,
                      ),
                    ),
                    child: Text(
                      loc.settingsButtonText,
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(bottom: 15.0),
                child: StyledElevatedButton(
                  onPressed: () {
                    if (DeviceConnection.connectionStatus ==
                            ConnectionStatus.bleConnected &&
                        GameUtils.isAllowed(chosenGame,
                            DeviceConnection.connectedSensorsCount)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayGameScreen(
                            selectedGame: GameUtils.selectGame(chosenGame),
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            GameUtils.isAllowed(chosenGame,
                                    DeviceConnection.connectedSensorsCount)
                                ? loc.noConnection
                                : loc.gameNotAvailable,
                          ),
                        ),
                      );
                    }
                  },
                  style: theme.elevatedButtonTheme.style?.copyWith(
                    fixedSize: MaterialStatePropertyAll(Size(80.w, 10.0.h)),
                  ),
                  child: Text(
                    loc.playButtonText,
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
