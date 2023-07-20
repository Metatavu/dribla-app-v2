import 'package:flutter/material.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';

class ChooseGameScreen extends StatefulWidget {
  const ChooseGameScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChooseGameScreenState();
}

class _ChooseGameScreenState extends State<ChooseGameScreen> {
  static const String _gameDescription =
      """Interdum accumsan pharetra sociosqu, vehicula class fames, suspendisse
      eleifend dui nulla mollis semper feugiat risus. Congue auctor fusce 
      cubilia, pretium sagittis non feugiat hendrerit.""";
  static const String _gameTitle = "Pujottelu";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          image: AssetImage("assets/dribla_choose_game_background.jpg"),
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
                  "assets/dribla_logo.svg",
                  width: 138,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
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
                      SvgPicture.asset("assets/game_icon.svg"),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          _gameTitle,
                          style: theme.textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          _gameDescription,
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  );
                },
                itemCount: 3,
                loop: false,
                pagination: const SwiperPagination(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 400.0),
                  builder: DotSwiperPaginationBuilder(activeColor: Colors.red),
                ),
              ),
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
              onPressed: () {},
              style: theme.elevatedButtonTheme.style!.copyWith(
                  fixedSize: const MaterialStatePropertyAll(Size(290.0, 65.0))),
              child: Text(
                loc.playButtonText,
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
                onPressed: () {},
                style: theme.elevatedButtonTheme.style!.copyWith(
                  fixedSize: const MaterialStatePropertyAll(Size(290.0, 65.0)),
                  backgroundColor: const MaterialStatePropertyAll(Colors.blue),
                ),
                child: Text(
                  loc.settingsButtonText,
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
