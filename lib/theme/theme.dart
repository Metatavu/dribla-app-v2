import "package:flutter/material.dart";
import "package:sizer/sizer.dart";

class DriblaColors {
  static const orange = Color.fromARGB(255, 255, 85, 0);
  static const black = Color.fromARGB(255, 0, 0, 0);
  static const white = Color.fromARGB(255, 255, 255, 255);
  static const greenAccent = Color.fromARGB(255, 113, 168, 131);
  static const greenbg = Color.fromARGB(255, 60, 117, 83);
  static const newBtnColor = Color(0xFFFF5500);
}

ThemeData getTheme(final BuildContext context) {
  final baseTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        color: Colors.white,
        decoration: TextDecoration.none,
        fontFamily: "Urbanist",
        fontWeight: FontWeight.w900,
        fontSize: 15.0.sp,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        decoration: TextDecoration.none,
        fontFamily: "Urbanist",
        fontWeight: FontWeight.w900,
        fontSize: 23.0.sp,
      ),
      headlineLarge: TextStyle(
        color: Colors.white,
        decoration: TextDecoration.none,
        fontFamily: "Urbanist",
        fontWeight: FontWeight.w900,
        fontSize: 51.0.sp,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
        decoration: TextDecoration.none,
        fontFamily: "Urbanist",
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        fontSize: 11.0.sp,
      ),
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(108, 54)),
        shape: WidgetStatePropertyAll(ContinuousRectangleBorder()),
        elevation: WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(DriblaColors.orange),
        foregroundColor: WidgetStatePropertyAll(DriblaColors.white),
        textStyle: WidgetStatePropertyAll(TextStyle(
          decoration: TextDecoration.none,
          fontFamily: "Urbanist",
          fontWeight: FontWeight.w900,
          fontSize: 28.0,
        )),
      ),
    ),
    outlinedButtonTheme: const OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(108, 54)),
        side: WidgetStatePropertyAll(
            BorderSide(color: DriblaColors.white, width: 3)),
        shape: WidgetStatePropertyAll(ContinuousRectangleBorder()),
        foregroundColor: WidgetStatePropertyAll(DriblaColors.white),
        textStyle: WidgetStatePropertyAll(TextStyle(
          decoration: TextDecoration.none,
          fontFamily: "Urbanist",
          fontWeight: FontWeight.w900,
          fontSize: 28.0,
        )),
      ),
    ),
    dialogTheme: const DialogTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      shape: ContinuousRectangleBorder(),
      titleTextStyle: TextStyle(
        color: Colors.white,
        decoration: TextDecoration.none,
        fontFamily: "Urbanist",
        fontWeight: FontWeight.w900,
        fontSize: 28.0,
      ),
      contentTextStyle: TextStyle(
        color: Colors.white,
        decoration: TextDecoration.none,
        fontFamily: "Urbanist",
        fontWeight: FontWeight.w400,
        fontSize: 16.0,
      ),
    ),
    sliderTheme: const SliderThemeData(
      thumbColor: DriblaColors.orange,
      activeTrackColor: DriblaColors.orange,
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        constraints: BoxConstraints.expand(height: 54.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        suffixIconColor: Colors.white,
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        elevation: WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          ContinuousRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
      textStyle: TextStyle(
        color: Colors.white,
        decoration: TextDecoration.none,
        fontFamily: "Urbanist",
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        fontSize: 16.0,
      ),
    ),
  );

  return baseTheme;
  // todo fonts
  // final themeWithFonts = baseTheme.copyWith();

  // return themeWithFonts.copyWith(
  //   colorScheme: ColorScheme.fromSeed(
  //     seedColor: const Color(0xFF268C5D),
  //     brightness: Brightness.light,
  //     primary: ColorTheme.primary,
  //     background: const Color(0xFFF7F7F7),
  //   ),
  //   appBarTheme: AppBarTheme(
  //     //backgroundColor: Colors.white,
  //     // backgroundColor: baseTheme.primaryColor,
  //     // foregroundColor: Colors.white,
  //     // leadingWidth: 60,
  //   ),
  // );
}
