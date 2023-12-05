import "package:dribla_app_v2/assets.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/components/game_icon.dart";
import "package:dribla_app_v2/components/game_settings_dialog.dart";
import "package:dribla_app_v2/components/styled_elevated_button.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/game_utils.dart";
import "package:dribla_app_v2/screens/play_game_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter_swiper_plus/flutter_swiper_plus.dart";

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
                padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                child: Text(
                  loc.chooseGame,
                  style: theme.textTheme.headlineMedium,
                ),
              ),
            ),
            Expanded(
              //  width: 200,
              //height: 400,
              child: SizedBox(
                width: 300,
                child: Swiper(
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GameIcon(
                            animationSpeedMs:
                                GameUtils.getIconAnimationSpeed(index),
                            colorSequency: GameUtils.getIconAnimation(index)),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            GameUtils.getTitle(index),
                            style: theme.textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            GameUtils.getDescription(index),
                            style: theme.textTheme.bodySmall,
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
                  pagination: const SwiperPagination(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(top: 415.0),
                    builder:
                        DotSwiperPaginationBuilder(activeColor: Colors.red),
                  ),
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
                    fixedSize: const MaterialStatePropertyAll(
                      Size(290.0, 65.0),
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
              margin: const EdgeInsets.only(bottom: 25.0),
              child: StyledElevatedButton(
                onPressed: () {
                  if (DeviceConnection.connectionStatus ==
                      ConnectionStatus.bleConnected) {
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
                      const SnackBar(
                        content: Text(
                          "Ei yhteyttä mattoon, varmista että bluetooth sekä laite on kytketty päälle.",
                        ),
                      ),
                    );
                  }
                },
                style: theme.elevatedButtonTheme.style?.copyWith(
                  fixedSize: const MaterialStatePropertyAll(Size(290.0, 65.0)),
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
    );
  }
}
