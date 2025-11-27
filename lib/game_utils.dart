import "package:dribla_app_v2/games/bluefrog_game.dart";
import "package:dribla_app_v2/games/follow_the_rabbit_game.dart";
import "package:dribla_app_v2/games/letter_game.dart";
import "package:dribla_app_v2/games/memory_game.dart";
import "package:dribla_app_v2/games/minefield_game.dart";
import "package:dribla_app_v2/games/minesweeper_game.dart";
import "package:dribla_app_v2/games/star_game.dart";
import "package:dribla_app_v2/games/ten_game.dart";
import "package:dribla_app_v2/games/ten_game_two_players.dart";
import "package:dribla_app_v2/games/ten_turns_game.dart";
import "package:dribla_app_v2/games/worm_game.dart";
import "package:dribla_app_v2/games/zigzag_game.dart";
import "package:dribla_app_v2/icon_animation_utils.dart";
import "package:flutter/material.dart";
import "games/game.dart";

class GameUtils {
  static bool isAllowed(int index, int connectedSensors) {
    return switch (index) {
      TenGame.index =>
        TenGame().getAllowedNumberOfSensors().contains(connectedSensors),
      ZigZagGame.index =>
        ZigZagGame().getAllowedNumberOfSensors().contains(connectedSensors),
      MineFieldGame.index =>
        MineFieldGame().getAllowedNumberOfSensors().contains(connectedSensors),
      MineSweeperGame.index => MineSweeperGame()
          .getAllowedNumberOfSensors()
          .contains(connectedSensors),
      LetterGame.index =>
        LetterGame().getAllowedNumberOfSensors().contains(connectedSensors),
      WormGame.index =>
        WormGame().getAllowedNumberOfSensors().contains(connectedSensors),
      TenGameTwoPlayers.index => TenGameTwoPlayers()
          .getAllowedNumberOfSensors()
          .contains(connectedSensors),
      TenTurnsGame.index =>
        TenTurnsGame().getAllowedNumberOfSensors().contains(connectedSensors),
      MemoryGame.index =>
        MemoryGame().getAllowedNumberOfSensors().contains(connectedSensors),
      StarGame.index =>
        StarGame().getAllowedNumberOfSensors().contains(connectedSensors),
      BluefrogGame.index =>
        BluefrogGame().getAllowedNumberOfSensors().contains(connectedSensors),
      FollowTheRabbitGame.index => FollowTheRabbitGame()
          .getAllowedNumberOfSensors()
          .contains(connectedSensors),
      _ => false
    };
  }

  static Game selectGame(int index) {
    return switch (index) {
      TenGame.index => TenGame(),
      ZigZagGame.index => ZigZagGame(),
      MineFieldGame.index => MineFieldGame(),
      MineSweeperGame.index => MineSweeperGame(),
      LetterGame.index => LetterGame(),
      WormGame.index => WormGame(),
      TenGameTwoPlayers.index => TenGameTwoPlayers(),
      TenTurnsGame.index => TenTurnsGame(),
      MemoryGame.index => MemoryGame(),
      StarGame.index => StarGame(),
      BluefrogGame.index => BluefrogGame(),
      FollowTheRabbitGame.index => FollowTheRabbitGame(),
      _ => TenGame()
    };
  }

  static String getDescription(int index) {
    return switch (index) {
      TenGame.index => TenGame.description,
      ZigZagGame.index => ZigZagGame.description,
      MineFieldGame.index => MineFieldGame.description,
      MineSweeperGame.index => MineSweeperGame.description,
      LetterGame.index => LetterGame.description,
      WormGame.index => WormGame.description,
      TenGameTwoPlayers.index => TenGameTwoPlayers.description,
      TenTurnsGame.index => TenTurnsGame.description,
      MemoryGame.index => MemoryGame.description,
      _ => ""
    };
  }

  static List<List<Color>> getIconAnimation(int index) {
    return switch (index) {
      TenGame.index => TenGame.iconAnimation,
      ZigZagGame.index => ZigZagGame.iconAnimation,
      MineFieldGame.index => MineFieldGame.iconAnimation,
      MineSweeperGame.index => MineSweeperGame.iconAnimation,
      LetterGame.index => LetterGame.iconAnimation,
      WormGame.index => WormGame.iconAnimation,
      TenGameTwoPlayers.index => TenGameTwoPlayers.iconAnimation,
      TenTurnsGame.index => TenTurnsGame.iconAnimation,
      MemoryGame.index => MemoryGame.iconAnimation,
      StarGame.index => StarGame.iconAnimation,
      BluefrogGame.index => BluefrogGame.iconAnimation,
      FollowTheRabbitGame.index => FollowTheRabbitGame.iconAnimation,
      _ => [IconAnimationUtils.all(Colors.white)]
    };
  }

  static int getIconAnimationSpeed(int index) {
    return switch (index) {
      TenGame.index => TenGame.iconAnimationSpeed,
      ZigZagGame.index => ZigZagGame.iconAnimationSpeed,
      MineFieldGame.index => MineFieldGame.iconAnimationSpeed,
      MineSweeperGame.index => MineSweeperGame.iconAnimationSpeed,
      LetterGame.index => LetterGame.iconAnimationSpeed,
      WormGame.index => WormGame.iconAnimationSpeed,
      TenGameTwoPlayers.index => TenGameTwoPlayers.iconAnimationSpeed,
      TenTurnsGame.index => TenTurnsGame.iconAnimationSpeed,
      MemoryGame.index => MemoryGame.iconAnimationSpeed,
      StarGame.index => StarGame.iconAnimationSpeed,
      BluefrogGame.index => BluefrogGame.iconAnimationSpeed,
      FollowTheRabbitGame.index => FollowTheRabbitGame.iconAnimationSpeed,
      _ => 200
    };
  }

  static bool hasGameSettings(int index) {
    return switch (index) {
      TenGame.index => TenGame().getGameSettingKeys().isNotEmpty,
      ZigZagGame.index => ZigZagGame().getGameSettingKeys().isNotEmpty,
      MineFieldGame.index => MineFieldGame().getGameSettingKeys().isNotEmpty,
      MineSweeperGame.index =>
        MineSweeperGame().getGameSettingKeys().isNotEmpty,
      LetterGame.index => LetterGame().getGameSettingKeys().isNotEmpty,
      WormGame.index => WormGame().getGameSettingKeys().isNotEmpty,
      TenGameTwoPlayers.index =>
        TenGameTwoPlayers().getGameSettingKeys().isNotEmpty,
      TenTurnsGame.index => TenTurnsGame().getGameSettingKeys().isNotEmpty,
      MemoryGame.index => MemoryGame().getGameSettingKeys().isNotEmpty,
      StarGame.index => StarGame().getGameSettingKeys().isNotEmpty,
      BluefrogGame.index => BluefrogGame().getGameSettingKeys().isNotEmpty,
      FollowTheRabbitGame.index =>
        FollowTheRabbitGame().getGameSettingKeys().isNotEmpty,
      _ => false
    };
  }

  static Future<Map<String, String?>> getGameSettings(int index) async {
    return switch (index) {
      TenGame.index => await TenGame().getGameSettings(),
      ZigZagGame.index => await ZigZagGame().getGameSettings(),
      MineFieldGame.index => await MineFieldGame().getGameSettings(),
      MineSweeperGame.index => await MineSweeperGame().getGameSettings(),
      LetterGame.index => await LetterGame().getGameSettings(),
      WormGame.index => await WormGame().getGameSettings(),
      TenGameTwoPlayers.index => await TenGameTwoPlayers().getGameSettings(),
      TenTurnsGame.index => await TenTurnsGame().getGameSettings(),
      MemoryGame.index => await MemoryGame().getGameSettings(),
      StarGame.index => await StarGame().getGameSettings(),
      BluefrogGame.index => await BluefrogGame().getGameSettings(),
      FollowTheRabbitGame.index =>
        await FollowTheRabbitGame().getGameSettings(),
      _ => <String, String?>{}
    };
  }

  static void setGameSettings(int index, Map<String, String?> settings) async {
    await TenGame().setStartDelay(settings);
    // ignore: void_checks
    return switch (index) {
      TenGame.index => await TenGame().setGameSettings(settings),
      ZigZagGame.index => await ZigZagGame().setGameSettings(settings),
      MineFieldGame.index => await MineFieldGame().setGameSettings(settings),
      MineSweeperGame.index =>
        await MineSweeperGame().setGameSettings(settings),
      LetterGame.index => await LetterGame().setGameSettings(settings),
      WormGame.index => await WormGame().setGameSettings(settings),
      TenGameTwoPlayers.index =>
        await TenGameTwoPlayers().setGameSettings(settings),
      TenTurnsGame.index => await TenTurnsGame().setGameSettings(settings),
      MemoryGame.index => await MemoryGame().setGameSettings(settings),
      StarGame.index => await StarGame().setGameSettings(settings),
      BluefrogGame.index => await BluefrogGame().setGameSettings(settings),
      FollowTheRabbitGame.index =>
        await FollowTheRabbitGame().setGameSettings(settings),
      _ => <String, String?>{}
    };
  }
}
