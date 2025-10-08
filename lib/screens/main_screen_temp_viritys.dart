import "package:dribla_app_v2/components/app_footer.dart";
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

class MainPageScreen extends StatefulWidget {
  const MainPageScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
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
        // redo body using Stack, Padding, SingleChildScrollView, and footer in Positioned
        body: Stack(children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/dribla_new_background.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text('Username',
                              style: theme.textTheme.headlineMedium),
                          Text(
                            'id text here',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text('todo test blabla',
                              style: theme.textTheme.bodyMedium),
                          Container(
                            height: 50.h,
                            padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                            child: Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GameIcon(
                                      animationSpeedMs:
                                          GameUtils.getIconAnimationSpeed(
                                              index),
                                      colorSequency:
                                          GameUtils.getIconAnimation(index),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'Outfit $index',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                );
                              },
                              itemCount: 5,
                              viewportFraction: 0.8,
                              scale: 0.9,
                              onIndexChanged: (int index) {
                                setState(() {
                                  chosenOutfit = index;
                                });
                              },
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(width: 5.w),
                              Expanded(
                                  child: Text(
                                    'Rank',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  flex: 1),
                              Expanded(
                                  child: Text(
                                    '10',
                                    style: theme.textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  flex: 1),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(width: 5.w),
                              Expanded(
                                  child: Text(
                                    'Total hours',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  flex: 1),
                              Expanded(
                                  child: Text(
                                    '35.6h',
                                    style: theme.textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  flex: 1),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(width: 5.w),
                              Expanded(
                                  child: Text(
                                    'Games played',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  flex: 1),
                              Expanded(
                                  child: Text(
                                    '124',
                                    style: theme.textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  flex: 1),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(width: 5.w),
                              Expanded(
                                  child: Text(
                                    'Games played',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  flex: 1),
                              Expanded(
                                  child: Text(
                                    '124',
                                    style: theme.textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  flex: 1),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
          const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
        ]));
  }
}


/*
                    Row(
                      children: [
                        SizedBox(width: 5.w),
                        Expanded(
                            child: Text(
                              'Games played',
                              style: theme.textTheme.bodyMedium,
                            ),
                            flex: 1),
                        Expanded(
                            child: Text(
                              '124',
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            flex: 1),
                      ],
                    ),
                    //SizedBox(height: 5.h),
                    const AppFooter(),
*/