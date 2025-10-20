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
import "package:dribla_app_v2/screens/profile_screen.dart";
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
  int _selectedIndex = 0;
  int chosenOutfit = 0;
  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: const AppHeaderAppBar(),
        drawer: const AppDrawer(),
        // TODO if there is too much content, make body scrollable
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/dribla_new_background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 5.w),
                        Text('Username', style: theme.textTheme.headlineMedium),
                      ],
                    ),
                    Row(children: [
                      SizedBox(width: 5.w),
                      Text('Some ID here $_selectedIndex',
                          style: theme.textTheme.bodyMedium),
                    ]),
                    Container(
                      padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                      child: Center(
                        child: Image.asset('assets/char_pic_temp.png',
                            width: 60.w, height: 60.w),
                      ),
                      // TODO switching between users?
                      // child: Swiper(
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         GameIcon(
                      //           animationSpeedMs:
                      //               GameUtils.getIconAnimationSpeed(index),
                      //           colorSequency:
                      //               GameUtils.getIconAnimation(index),
                      //         ),
                      //         SizedBox(height: 2.h),
                      //         Text(
                      //           'Outfit $index',
                      //           style: theme.textTheme.bodyMedium,
                      //         ),
                      //       ],
                      //     );
                      //   },
                      //   itemCount: 5,
                      //   viewportFraction: 0.8,
                      //   scale: 0.9,
                      //   onIndexChanged: (int index) {
                      //     setState(() {
                      //       chosenOutfit = index;
                      //     });
                      //   },
                      // ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 5.w),
                        Expanded(
                            flex: 1,
                            child: Text(
                              loc.rank,
                              style: theme.textTheme.bodyMedium,
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              '10',
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 5.w),
                        Expanded(
                            flex: 1,
                            child: Text(
                              loc.totalHours,
                              style: theme.textTheme.bodyMedium,
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              '35.6h',
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 5.w),
                        Expanded(
                            flex: 1,
                            child: Text(
                              'Games played',
                              style: theme.textTheme.bodyMedium,
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              '124',
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfileScreen()),
                          );
                        },
                        child: Text(
                          'View more',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
          //const AppFooter(),
        ]));
  }
}
