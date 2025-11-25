import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_footer.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/screens/shoes_selection_screen.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:dribla_app_v2/screens/choose_game_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:sizer/sizer.dart";

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dribla_app_v2/providers/auth_providers.dart';

class CharacterReadyScreen extends HookConsumerWidget {
  const CharacterReadyScreen(
      {super.key,
      required this.chosenCharacter,
      required this.chosenOutfit,
      required this.chosenShoes});

  final int chosenCharacter;
  final int chosenOutfit;
  final int chosenShoes;

  static String getFinalAsset(int character, int outfit, int shoes) {
    if (character > 8) {
      return "assets/avatars/avatar_${character + 1}/avatar_${character + 1}_clothes_0${outfit + 1}_shoes_0${shoes + 1}.png";
    }
    return "assets/avatars/avatar_0${character + 1}/avatar_0${character + 1}_clothes_0${outfit + 1}_shoes_0${shoes + 1}.png";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final isAuthExpired = ref.watch(isAuthExpiredProvider);
    final auth = ref.watch(authNotifierProvider);
    String? userProfileId = auth.value?.accessToken.sub;
    String? username = auth.value?.accessToken.preferred_username ?? "";

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
                    child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text('${loc.hello} $username!',
                            style: theme.textTheme.headlineMedium)),
                    SizedBox(height: 1.h),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          loc.lookingGood,
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
                      width: double.infinity,
                      height: 40.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black.withOpacity(0.6),
                      ),
                      child: Image.asset(
                        getFinalAsset(
                            chosenCharacter, chosenOutfit, chosenShoes),
                        height: 5.h,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Container(
                          height: 30.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 12.w,
                                width: 32.w,
                                margin: EdgeInsets.only(bottom: 10.h),
                                child: ElevatedButton(
                                  style: theme.elevatedButtonTheme.style,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ShoesSelectionScreen(
                                          chosenCharacter: chosenCharacter,
                                          chosenOutfit: chosenOutfit,
                                        ),
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
                                        loc.backButton,
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
                              SizedBox(width: 5.w),
                              Container(
                                height: 12.w,
                                width: 32.w,
                                margin: EdgeInsets.only(bottom: 10.h),
                                child: ElevatedButton(
                                  style: theme.elevatedButtonTheme.style,
                                  onPressed: () {
                                    // Update user profile with saved character
                                    ref
                                        .read(authNotifierProvider.notifier)
                                        .updateUserProfileCharacters(
                                          userProfileId!,
                                          characterType: chosenCharacter,
                                          characterOutfitType: chosenOutfit,
                                          characterShoesType: chosenShoes,
                                        );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ChooseGameScreen()),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(width: 4.w),
                                      Text(
                                        loc.save,
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
                    ),
                  ],
                ))),
          ),
          const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
        ],
      ),
    );
  }
}
