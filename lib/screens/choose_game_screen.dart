import "package:dribla_app_v2/assets.dart";
import "package:dribla_app_v2/screens/play_minefield_game_screen.dart";
import "package:dribla_app_v2/screens/play_ten_game_screen.dart";
import "package:dribla_app_v2/screens/play_zigzag_game_screen.dart";
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

  static final List<String> _gameDescriptions = [
    """• Harjoittele sisä-ja ulkosyrjäkäännöksiä
      • Pidä hyvä peliasento
      • Pyri nostamaan katsetta pois pallosta, jotta voit havannoida paremmin""",
    """• Harjoittele kuljettamista molemmilla jaloilla ja käytä erilaisia tapoja muuttaa suuntaa.
      • Pidä hyvä peliasento koko ajan
      • Pyri nostamaan katsetta pois pallosta, jotta voit havannoida paremmin""",
    """Interdum accumsan pharetra sociosqu, vehicula class fames, suspendisse
      eleifend dui nulla mollis semper feugiat risus. Congue auctor fusce
      cubilia, pretium sagittis non feugiat hendrerit."""
  ];
  static final List<String> _gameTitles = [
    "Zig-Zag",
    "10 - Peli",
    "Miinakenttä"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

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
                      SvgPicture.asset(Assets.gameIconAsset),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          _gameTitles[index],
                          style: theme.textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          _gameDescriptions[index],
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  );
                },
                itemCount: 3,
                loop: false,
                onIndexChanged: (index) => chosenGame = index,
                pagination: const SwiperPagination(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 400.0),
                  builder: DotSwiperPaginationBuilder(activeColor: Colors.red),
                ),
              ),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => switch (chosenGame) {
                            0 => const PlayZigZagGameScreen(),
                            1 => const PlayTenGameScreen(),
                            2 => const PlayMinefieldGameScreen(),
                            _ => const PlayTenGameScreen()
                          }),
                );
              },
              style: theme.elevatedButtonTheme.style?.copyWith(
                  fixedSize: const MaterialStatePropertyAll(Size(290.0, 65.0))),
              child: Text(
                loc.playButtonText,
                style: theme.textTheme.headlineMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
