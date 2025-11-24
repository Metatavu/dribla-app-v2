import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_footer.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/screens/character_creation_screen.dart";
import "package:dribla_app_v2/screens/shoes_selection_screen.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_swiper_plus/flutter_swiper_plus.dart";
import "package:sizer/sizer.dart";

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dribla_app_v2/providers/auth_providers.dart';

class OutfitSelectionScreen extends HookConsumerWidget {
  const OutfitSelectionScreen({super.key, required this.chosenCharacter});

  final int chosenCharacter;

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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final isAuthExpired = ref.watch(isAuthExpiredProvider);
    final chosenOutfit = useState<int>(0);

    useEffect(() {
      if (isAuthExpired) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/login');
        });
      }
      return null;
    }, [isAuthExpired]);

    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: const ConnectionStatusAppBar(),
        drawer: const AppDrawer(),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/dribla_new_background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                  padding: EdgeInsets.all(35.00),
                  child: SingleChildScrollView(
                      child: Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(loc.outfit,
                                    style: theme.textTheme.headlineMedium),
                              ),
                              SizedBox(height: 1.h),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    loc.editCharOutfit,
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                      fontFamily: "Urbanist",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0.sp,
                                    ),
                                  )),
                              SizedBox(height: 1.h),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                width: double.infinity,
                                height: 45.h,
                                child: Swiper(
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(top: 8.h)),
                                        Image.asset(
                                          getOutfitAsset(
                                              index, chosenCharacter),
                                          width: 60.w,
                                          height: 60.w,
                                        ),
                                      ],
                                    );
                                  },
                                  itemCount: 6,
                                  loop: false,
                                  onIndexChanged: (index) =>
                                      chosenOutfit.value = index,
                                  control: const SwiperControl(
                                      color: DriblaColors.orange),
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                                child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(bottom: 20.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 12.w,
                                          width: 32.w,
                                          child: ElevatedButton(
                                            style:
                                                theme.elevatedButtonTheme.style,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CharacterCreationScreen(),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 2.w),
                                                Text(
                                                  loc.backButtonText,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.sp),
                                                ),
                                                const SizedBox(width: 5),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Container(
                                            child: Expanded(
                                                child: Text(
                                          '${chosenOutfit.value + 1} / 6',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ))),
                                        SizedBox(width: 5.w),
                                        Container(
                                          height: 12.w,
                                          width: 30.w,
                                          child: ElevatedButton(
                                            style:
                                                theme.elevatedButtonTheme.style,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShoesSelectionScreen(
                                                          chosenCharacter:
                                                              chosenCharacter,
                                                          chosenOutfit:
                                                              chosenOutfit
                                                                  .value,
                                                        )),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                SizedBox(width: 4.w),
                                                Text(
                                                  loc.nextButton,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.sp),
                                                ),
                                                SizedBox(width: 2.w),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          )))),
            ),
            const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
          ],
        ));
  }
}
