import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_footer.dart";
import "package:dribla_app_v2/components/app_header_appbar.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/components/game_icon.dart";
import "package:dribla_app_v2/components/game_settings_dialog.dart";
import "package:dribla_app_v2/components/styled_dialog.dart";
import "package:dribla_app_v2/components/styled_elevated_button.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/screens/character_creation_screen.dart";
import "package:dribla_app_v2/screens/outfit_selection_screen.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:dribla_app_v2/game_utils.dart";
import "package:dribla_app_v2/screens/choose_game_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_swiper_plus/flutter_swiper_plus.dart";
import "package:sizer/sizer.dart";
import "package:url_launcher/url_launcher_string.dart";

class CharacterReadyScreen extends StatefulWidget {
  const CharacterReadyScreen(
      {super.key, required this.chosenCharacter, required this.chosenOutfit});

  final int chosenCharacter;
  final int chosenOutfit;

  @override
  State<StatefulWidget> createState() => _CharacterReadyScreenState();
}

class _CharacterReadyScreenState extends State<CharacterReadyScreen> {
  int chosenOutfit = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: const AppHeaderAppBar(),
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
                Text('Hello username!', style: theme.textTheme.headlineMedium),
                Text(
                  'Looking good! Ready to play? You selected Char ${widget.chosenCharacter} with Outfit ${widget.chosenOutfit}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                      child: Container(
                    child: Text('TODO'),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 9.w,
                        width: 25.w,
                        child: ElevatedButton(
                          style: theme.elevatedButtonTheme.style,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OutfitSelectionScreen(
                                    chosenCharacter: widget.chosenCharacter),
                              ),
                            );
                          },
                          child: const Row(
                            children: [
                              SizedBox(width: 5),
                              Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Back',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(width: 5),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      SizedBox(width: 15.w),
                      Container(
                        height: 9.w,
                        width: 25.w,
                        child: ElevatedButton(
                          style: theme.elevatedButtonTheme.style,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ChooseGameScreen()),
                            );
                          },
                          child: const Row(
                            children: [
                              SizedBox(width: 5),
                              Text(
                                'Start',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const AppFooter(),
              ],
            ),
          ),
        ));
  }
}
