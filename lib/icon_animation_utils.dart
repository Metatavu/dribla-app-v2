import "dart:ui";

class IconAnimationUtils {
  static List<Color> all(Color color) {
    return List.generate(8, (_) => color);
  }

  static List<Color> single(Color bg, Color color, int index) {
    return List.generate(8, (i) => i == index ? color : bg);
  }

  static List<Color> multiple(Color bg, Color color, List<int> indices) {
    return List.generate(8, (i) => indices.contains(i) ? color : bg);
  }
}
