class TimerFormatter {
  static String format(int millis) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    var duration = Duration(milliseconds: millis);
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inMinutes)}:$twoDigitSeconds";
  }
}
