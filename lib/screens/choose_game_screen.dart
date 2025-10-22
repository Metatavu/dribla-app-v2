import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_footer.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/components/game_icon.dart";
import "package:dribla_app_v2/components/game_settings_dialog.dart";
import "package:dribla_app_v2/components/styled_dialog.dart";
import "package:dribla_app_v2/components/styled_elevated_button.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/screens/main_page_screen.dart";
import "package:dribla_app_v2/theme/theme.dart";
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
import "package:dribla_app_v2/screens/character_creation_screen.dart";
import "package:dribla_app_v2/screens/play_game_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_swiper_plus/flutter_swiper_plus.dart";
import "package:new_version_plus/new_version_plus.dart";
import "package:sizer/sizer.dart";
import "package:url_launcher/url_launcher_string.dart";

class ChooseGameScreen extends StatefulWidget {
  const ChooseGameScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChooseGameScreenState();
}

class _ChooseGameScreenState extends State<ChooseGameScreen> {
  int chosenGame = 0;

  final newVersion = NewVersionPlus();

  @override
  void initState() {
    super.initState();
    DeviceConnection.startIdleAnimation();
    checkVersion(newVersion, context);
  }

  checkVersion(NewVersionPlus newVersion, BuildContext context) async {
    final status = await newVersion.getVersionStatus();
    if (context.mounted && status != null && status.canUpdate == true) {
      customShowUpdateDialog(context, newVersion, status);
    }
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
      StarGame.index => localizations.starGameText,
      _ => ""
    };
  }

  String getLocalizedInstructionUrl(int index, AppLocalizations localizations) {
    return switch (index) {
      TenGame.index => localizations.tengameUrl,
      ZigZagGame.index => localizations.zigzagUrl,
      MineFieldGame.index => localizations.minefieldUrl,
      MineSweeperGame.index => localizations.pickBerriesUrl,
      LetterGame.index => localizations.envelopeUrl,
      WormGame.index => localizations.snakeUrl,
      TenGameTwoPlayers.index => localizations.tengameMultiplayerUrl,
      TenTurnsGame.index => localizations.tenturnsUrl,
      MemoryGame.index => localizations.memoryGameUrl,
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
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/dribla_new_background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    child: Swiper(
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 5.h)),
                            GameIcon(
                                animationSpeedMs:
                                    GameUtils.getIconAnimationSpeed(index),
                                colorSequency:
                                    GameUtils.getIconAnimation(index)),
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
                      itemCount: 9,
                      loop: false,
                      onIndexChanged: (index) => {
                        setState(() {
                          chosenGame = index;
                        })
                      },
                      control: const SwiperControl(color: DriblaColors.white),
                      pagination: SwiperPagination(
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.only(bottom: 22.0),
                        builder: DotSwiperPaginationBuilder(
                            activeColor: DriblaColors.orange,
                            color: DriblaColors.white,
                            size: 15.0.sp,
                            activeSize: 15.0.sp,
                            space: 7.sp),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 15.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      launchUrlString(
                          getLocalizedInstructionUrl(chosenGame, loc));
                    },
                    child: Text(
                      loc.instructionsButtonText,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 15.0),
                  child: ElevatedButton(
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
                    child: Text(
                      loc.settingsButtonText,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 15.0),
                  child: ElevatedButton(
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          loc.startGameButton,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const AppFooter(),
              ],
            )),
      ),
    );
  }
}

void customShowUpdateDialog(BuildContext context, NewVersionPlus newVersion,
    VersionStatus versionCheck) {
  final theme = Theme.of(context);
  final loc = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StyledDialog(
        title: loc.updateAvailable,
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                "${loc.updateToVersion} ${versionCheck.storeVersion}?",
                style: theme.textTheme.headlineSmall,
              )
            ],
          ),
        ),
        actions: [
          StyledElevatedButton(
            style: theme.elevatedButtonTheme.style,
            onPressed: () async {
              await newVersion.launchAppStore(versionCheck.appStoreLink);
            },
            child: Text(
              loc.updateButtonText,
              style: theme.textTheme.headlineSmall,
            ),
          ),
          OutlinedButton(
            style: theme.outlinedButtonTheme.style?.copyWith(
              backgroundColor: const WidgetStatePropertyAll(DriblaColors.black),
            ),
            child: Text(
              loc.closeButtonText,
              style: theme.textTheme.headlineSmall,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
