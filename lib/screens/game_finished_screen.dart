import 'package:dribla_app_v2/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:flutter_svg/flutter_svg.dart';

import 'choose_game_screen.dart';

class GameFinisihedScreen extends StatefulWidget {
  final BluetoothCharacteristic? sensorCharacteristic;
  final BluetoothCharacteristic? ledCharacteristic;
  final int? gameTime;

  const GameFinisihedScreen({
    Key? key,
    this.sensorCharacteristic,
    this.ledCharacteristic,
    this.gameTime,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GameFinisihedScreenState();
}

class _GameFinisihedScreenState extends State<GameFinisihedScreen> {
  String _gameTitle = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    setState(() {
      _gameTitle = loc.gameEnded;
    });

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
                    _gameTitle,
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                // New "Time passed" text added here
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Time passed: ",
                    style: theme.textTheme.headlineMedium?.copyWith(fontSize: (1.5 * num.parse(theme.textTheme.headlineMedium?.fontSize.toString() ?? "20")).toDouble()), // Adjust the font size if needed
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.gameTime?.toString() ?? "",
                      style: theme.textTheme.headlineMedium?.copyWith(fontSize: (2 * num.parse(theme.textTheme.headlineMedium?.fontSize.toString() ?? "20")).toDouble()), // Double the font size
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChooseGameScreen(
                      sensorCharacteristic: widget.sensorCharacteristic,
                      ledCharacteristic: widget.ledCharacteristic,
                    ),
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
                style: theme.elevatedButtonTheme.style?.copyWith(
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