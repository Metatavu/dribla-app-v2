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
              Text(loc.outfit, style: theme.textTheme.headlineMedium),
              Text(
                loc.editCharOutfit,
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
                            getOutfitAsset(index, chosenCharacter),
                            width: 60.w,
                            height: 60.w,
                          ),
                        ],
                      );
                    },
                    itemCount: 6,
                    loop: false,
                    onIndexChanged: (index) => chosenOutfit.value = index,
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
                      height: 12.w,
                      width: 32.w,
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
                        child: Row(
                          children: [
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              loc.backButton,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      '${chosenOutfit.value + 1} / 6',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Container(
                      height: 12.w,
                      width: 33.w,
                      child: ElevatedButton(
                        style: theme.elevatedButtonTheme.style,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShoesSelectionScreen(
                                    chosenCharacter: chosenCharacter,
                                    chosenOutfit: chosenOutfit.value)),
                          );
                        },
                        child: Row(
                          children: [
                            const SizedBox(width: 5),
                            Text(
                              loc.nextButton,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
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
      ),
    );
  }
}
