import "package:flutter/material.dart";

class LedColors {
  static const int off = 0;
  static const int green = 0x00FF0000;
  static const int red = 0x0000FF00;
  static const int blue = 0xFF000000;

  static int fromColor(Color color) {
    return Color.fromARGB(color.blue, color.green, color.red, 0).value;
  }
}
