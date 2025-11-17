import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_footer.dart";
import "package:dribla_app_v2/components/connection_status_appbar.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/screens/outfit_selection_screen.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:dribla_app_v2/screens/choose_game_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_swiper_plus/flutter_swiper_plus.dart";
import "package:sizer/sizer.dart";

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dribla_app_v2/providers/auth_providers.dart';

class CharacterCreationScreen extends HookConsumerWidget {
  const CharacterCreationScreen({super.key});

  static String getCharacterAsset(int index) {
    return switch (index) {
      0 => "assets/avatars/avatar_01/avatar_01_base.png",
      1 => "assets/avatars/avatar_02/avatar_02_base.png",
      _ => "assets/avatars/avatar_01/avatar_01_base.png",
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final isAuthExpired = ref.watch(isAuthExpiredProvider);
    final chosenCharacter = useState<int>(0);

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
                              child: Text(loc.editAvatar,
                                  style: theme.textTheme.headlineMedium),
                            ),
                            SizedBox(height: 1.h),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  loc.editCharType,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
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
                                        getCharacterAsset(index),
                                        width: 60.w,
                                        height: 60.w,
                                      ),
                                    ],
                                  );
                                },
                                itemCount: 2,
                                loop: false,
                                onIndexChanged: (index) =>
                                    chosenCharacter.value = index,
                                control: const SwiperControl(
                                    color: DriblaColors.white),
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                              child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(bottom: 20.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                    const ChooseGameScreen(),
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
                                                loc.cancelButton,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
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
                                        '${chosenCharacter.value + 1} / 2',
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
                                                      OutfitSelectionScreen(
                                                          chosenCharacter:
                                                              chosenCharacter
                                                                  .value)),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 5),
                                              Text(
                                                loc.nextButton,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
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
                                  )),
                            )
                          ],
                        )))),
          ),
          const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
        ],
      ),
    );
  }
}
