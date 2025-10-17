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
import "package:dribla_app_v2/screens/character_ready_screen.dart";
import "package:dribla_app_v2/screens/shoes_selection_screen.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:dribla_app_v2/game_utils.dart";
import "package:dribla_app_v2/screens/choose_game_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_swiper_plus/flutter_swiper_plus.dart";
import "package:sizer/sizer.dart";
import "package:url_launcher/url_launcher_string.dart";

class OutfitSelectionScreen extends StatefulWidget {
  const OutfitSelectionScreen({super.key, required this.chosenCharacter});

  final int chosenCharacter;

  @override
  State<StatefulWidget> createState() => _OutfitSelectionScreenState();
}

class _OutfitSelectionScreenState extends State<OutfitSelectionScreen> {
  int chosenOutfit = 0;
  @override
  void initState() {
    super.initState();
  }

  static String getOutfitAsset(int index, int character) {
    return switch (index) {
      0 =>
        "assets/avatars/avatar_0${character + 1}/avatar_0${character + 1}_clothes_01_shoes_01.png",
      1 =>
        "assets/avatars/avatar_0${character + 1}/avatar_0${character + 1}_clothes_02_shoes_01.png",
      2 =>
        "assets/avatars/avatar_0${character + 1}/avatar_0${character + 1}_clothes_03_shoes_01.png",
      3 =>
        "assets/avatars/avatar_0${character + 1}/avatar_0${character + 1}_clothes_04_shoes_01.png",
      4 =>
        "assets/avatars/avatar_0${character + 1}/avatar_0${character + 1}_clothes_05_shoes_01.png",
      5 =>
        "assets/avatars/avatar_0${character + 1}/avatar_0${character + 1}_clothes_06_shoes_01.png",
      _ =>
        "assets/avatars/avatar_0${character + 1}/avatar_0${character + 1}_clothes_01_shoes_01.png",
    };
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
                Text('Outfit', style: theme.textTheme.headlineMedium),
                Text(
                  'Next choose your outfit',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: Swiper(
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 8.h)),
                            Image.asset(
                              getOutfitAsset(index, widget.chosenCharacter),
                              width: 60.w,
                              height: 60.w,
                            ),
                          ],
                        );
                      },
                      itemCount: 6,
                      loop: false,
                      onIndexChanged: (index) => {
                        setState(() {
                          chosenOutfit = index;
                        })
                      },
                      control: const SwiperControl(color: DriblaColors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 80.0),
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
                                builder: (context) =>
                                    const CharacterCreationScreen(),
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
                      Text(
                        '${chosenOutfit + 1} / 6',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                                  builder: (context) => ShoesSelectionScreen(
                                      chosenCharacter: widget.chosenCharacter,
                                      chosenOutfit: chosenOutfit)),
                            );
                          },
                          child: const Row(
                            children: [
                              SizedBox(width: 5),
                              Text(
                                'Next',
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
