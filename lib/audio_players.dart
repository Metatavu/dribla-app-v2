import "package:audioplayers/audioplayers.dart";

class AudioPlayers {
  static final explosionPlayer = AudioPlayer();
  static final countDownPlayer = AudioPlayer();
  static final successPlayer = AudioPlayer();
  static final victoryPlayer = AudioPlayer();
  static final failurePlayer = AudioPlayer();
  static final beepPlayer = AudioPlayer();
  static final bonusPlayer = AudioPlayer();

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

    await beepPlayer.setSource(AssetSource("audio/beep.wav"));
    await beepPlayer.setReleaseMode(ReleaseMode.stop);
    await beepPlayer.setPlayerMode(PlayerMode.lowLatency);

    await bonusPlayer.setSource(AssetSource("audio/bonus.wav"));
    await bonusPlayer.setReleaseMode(ReleaseMode.stop);
    await bonusPlayer.setPlayerMode(PlayerMode.lowLatency);
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

  static void playBeep() async {
    await beepPlayer.stop();
    await beepPlayer.resume();
  }

  static void playBonus() async {
    await bonusPlayer.stop();
    await bonusPlayer.resume();
  }

  static Future<void> deinit() async {
    await successPlayer.release();
    await countDownPlayer.release();
    await victoryPlayer.release();
    await failurePlayer.release();
    await explosionPlayer.release();
    await beepPlayer.release();
    await bonusPlayer.release();
  }
}
