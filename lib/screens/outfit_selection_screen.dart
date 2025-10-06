import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/components/game_icon.dart";
import "package:dribla_app_v2/components/game_settings_dialog.dart";
import "package:dribla_app_v2/components/styled_dialog.dart";
import "package:dribla_app_v2/components/styled_elevated_button.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/screens/character_creation_screen.dart";
import "package:dribla_app_v2/screens/character_ready_screen.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:dribla_app_v2/game_utils.dart";
import "package:dribla_app_v2/screens/choose_game_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_swiper_plus/flutter_swiper_plus.dart";
import "package:sizer/sizer.dart";
import "package:url_launcher/url_launcher_string.dart";

class OutfitSelectionScreen extends StatefulWidget {
  const OutfitSelectionScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OutfitSelectionScreenState();
}

class _OutfitSelectionScreenState extends State<OutfitSelectionScreen> {
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
        appBar: const ConnectionStatusAppBar(),
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
                  'Choose your outfit',
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
                            Padding(padding: EdgeInsets.only(top: 2.h)),
                            GameIcon(
                                animationSpeedMs:
                                    GameUtils.getIconAnimationSpeed(index),
                                colorSequency:
                                    GameUtils.getIconAnimation(index)),
                          ],
                        );
                      },
                      itemCount: 9,
                      loop: false,
                      onIndexChanged: (index) => {
                        setState(() {
                          chosenOutfit = index;
                          print('Chosen outfit: $chosenOutfit');
                        })
                      },
                      control: const SwiperControl(color: DriblaColors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                          style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  DriblaColors.newBtnColor)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CharacterCreationScreen(),
                              ),
                            );
                          },
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          label: const Text(
                            "Back",
                            style: TextStyle(color: Colors.white),
                          )),
                      SizedBox(width: 15.w),
                      Text(
                        '${chosenOutfit + 1}/9',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      TextButton.icon(
                          style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  DriblaColors.newBtnColor)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CharacterReadyScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward,
                              color: Colors.white),
                          label: const Text(
                            "Next",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
