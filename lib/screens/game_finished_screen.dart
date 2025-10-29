import "package:sizer/sizer.dart";
import "package:dribla_app_v2/assets.dart";
import "package:dribla_app_v2/audio_players.dart";
import "package:dribla_app_v2/components/styled_elevated_button.dart";
import "package:dribla_app_v2/device_connection.dart";
import "package:dribla_app_v2/theme/theme.dart";
import "package:dribla_app_v2/game_utils.dart";
import "package:dribla_app_v2/led_colors.dart";
import "package:dribla_app_v2/screens/play_game_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dribla_app_v2/providers/auth_providers.dart';

class GameFinishedScreen extends HookConsumerWidget {
  final String? finalScore;
  final int gameIndex;
  final bool win;
  final bool skipEndingFanfare;
  final int elapsedTime;

  const GameFinishedScreen({
    super.key,
    this.finalScore,
    required this.elapsedTime,
    required this.gameIndex,
    required this.win,
    required this.skipEndingFanfare,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final isAuthExpired = ref.watch(isAuthExpiredProvider);
    final auth = ref.watch(authNotifierProvider);
    String? userProfileId = auth.value?.accessToken.sub;

    useEffect(() {
      if (!skipEndingFanfare) {
        if (win) {
          AudioPlayers.playVictory();
        } else {
          AudioPlayers.playFailure();
        }
      }
      DeviceConnection.setAllLedColors(LedColors.red);
      print('Final score is');
      print(finalScore);
      int? convertedScore = int.tryParse(finalScore ?? "0");
      // duration in ms, rounded to seconds
      int? duration = elapsedTime ~/ 1000;
      String game = "Unknown game";
      switch (gameIndex) {
        case 1:
          game = loc.envelope;
          break;
        case 2:
          game = loc.zigzag;
          break;
        case 3:
          game = loc.pickBerries;
          break;
        case 4:
          game = loc.tengame;
          break;
        case 5:
          game = loc.tengameMultiplayer;
          break;
        case 6:
          game = loc.tenturns;
          break;
        case 7:
          game = loc.snake;
          break;
        case 8:
          game = loc.starGameText;
          break;
        case 9:
          game = loc.memoryGame;
          break;
        default:
          game = "Unknown Game";
      }
      ref
          .read(authNotifierProvider.notifier)
          .createNewGameSession(userProfileId!, convertedScore, duration, game);
      return null;
    }, []);

    useEffect(() {
      if (isAuthExpired) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/login');
        });
      }
      return null;
    }, [isAuthExpired]);

    String gameTitle = loc.gameEnded;
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0),
              ),
              child: Image(
                image: const AssetImage(Assets.logoAsset),
                width: 50.w,
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
                  gameTitle,
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        win ? loc.results : loc.betterLuckNextTime,
                        style: theme.textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        finalScore ?? "",
                        style: theme.textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        StyledElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PlayGameScreen(
                  selectedGame: GameUtils.selectGame(gameIndex),
                ),
              ),
            );
          },
          style: theme.elevatedButtonTheme.style?.copyWith(
            fixedSize: WidgetStatePropertyAll(Size(80.w, 10.0.h)),
          ),
          child: Icon(
            Icons.play_circle_outline,
            color: DriblaColors.white,
            size: 15.w.toDouble(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 45.0),
          child: OutlinedButton(
            onPressed: () {
              DeviceConnection.startIdleAnimation();
              Navigator.pop(context);
            },
            style: theme.outlinedButtonTheme.style?.copyWith(
              fixedSize: WidgetStatePropertyAll(Size(80.w, 7.h)),
              backgroundColor: const WidgetStatePropertyAll(DriblaColors.black),
            ),
            child: Text(
              loc.backButtonText,
              style: theme.textTheme.headlineMedium,
            ),
          ),
        ),
      ],
    );
  }
}
