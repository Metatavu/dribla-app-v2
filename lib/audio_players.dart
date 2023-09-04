import "package:audioplayers/audioplayers.dart";

class AudioPlayers {
  static final explosionPlayer = AudioPlayer();
  static final countDownPlayer = AudioPlayer();
  static final successPlayer = AudioPlayer();
  static final victoryPlayer = AudioPlayer();
  static final failurePlayer = AudioPlayer();

  static Future<void> init() async {
    await successPlayer.setSource(AssetSource("audio/success.wav"));
    await successPlayer.setReleaseMode(ReleaseMode.stop);
    await successPlayer.setPlayerMode(PlayerMode.lowLatency);

    await countDownPlayer.setSource(AssetSource("audio/countdown.wav"));
    await countDownPlayer.setReleaseMode(ReleaseMode.stop);
    await countDownPlayer.setPlayerMode(PlayerMode.lowLatency);

    await victoryPlayer.setSource(AssetSource("audio/victory.mp3"));
    await victoryPlayer.setReleaseMode(ReleaseMode.stop);

    await failurePlayer.setSource(AssetSource("audio/failure.wav"));
    await failurePlayer.setReleaseMode(ReleaseMode.stop);

    await explosionPlayer.setSource(AssetSource("audio/explosion.wav"));
    await explosionPlayer.setReleaseMode(ReleaseMode.stop);
    await explosionPlayer.setPlayerMode(PlayerMode.lowLatency);
  }

  static void playSuccess() async {
    await successPlayer.stop();
    await successPlayer.resume();
  }

  static void playCountDown() async {
    await countDownPlayer.stop();
    await countDownPlayer.resume();
  }

  static void playExplosion() async {
    await explosionPlayer.stop();
    await explosionPlayer.resume();
  }

  static void playVictory() async {
    await victoryPlayer.stop();
    await victoryPlayer.resume();
  }

  static void playFailure() async {
    await failurePlayer.stop();
    await failurePlayer.resume();
  }

  static Future<void> deinit() async {
    await successPlayer.release();
    await countDownPlayer.release();
    await victoryPlayer.release();
    await failurePlayer.release();
    await explosionPlayer.release();
  }
}
