import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color greenClr = Color(0xFF8eb4ab);
const Color orangeClr = Color(0xFFFF7056);
const Color yellowClr = Color(0xFFFCCE60);
const Color white = Colors.white;
const primaryClr = greenClr;
const Color darkGreyClr = Color(0xFF121212);

class Themes {
  static final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    indicatorColor: primaryClr,
    textTheme: TextTheme(
        bodyText2:
            TextStyle(color: Get.isDarkMode ? Colors.white : darkGreyClr)),
    backgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(primary: greenClr),
    buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
  );
  static final dark = ThemeData(
    brightness: Brightness.dark,
    indicatorColor: primaryClr,
    primaryColor: darkGreyClr,
    backgroundColor: darkGreyClr,
  );

  TextStyle get taskTileHeadingTextStyle => GoogleFonts.lato(
      textStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white));
}
