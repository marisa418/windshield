import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static const MaterialColor kToDark = MaterialColor(
    0xff5236ff,
    <int, Color>{
      50: Color(0xffefe8ff),
      100: Color(0xffd3c6fe),
      200: Color(0xffb59fff),
      300: Color(0xff9376ff),
      400: Color(0xff5136ff),
      500: Color(0xff5236ff),
      600: Color(0xff4032f8),
      700: Color(0xff1c2af0),
      800: Color(0xff0024ea),
      900: Color(0xff0016e4),
    },
  );
  static TextTheme textTheme = TextTheme(
    headline1: GoogleFonts.kanit(fontSize: 36, fontWeight: FontWeight.w500),
    headline2: GoogleFonts.kanit(fontSize: 28, fontWeight: FontWeight.w500),
    headline3: GoogleFonts.kanit(fontSize: 21, fontWeight: FontWeight.w500),
    headline4: GoogleFonts.kanit(fontSize: 16, fontWeight: FontWeight.w500),
    bodyText1: GoogleFonts.kanit(fontSize: 14, fontWeight: FontWeight.w500),
    bodyText2: GoogleFonts.kanit(fontSize: 12, fontWeight: FontWeight.w500),
  );
  static TextTheme whiteTextTheme = TextTheme(
    headline1: GoogleFonts.kanit(
        fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white),
    headline2: GoogleFonts.kanit(
        fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white),
    headline3: GoogleFonts.kanit(
        fontSize: 21, fontWeight: FontWeight.w500, color: Colors.white),
    headline4: GoogleFonts.kanit(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
    bodyText1: GoogleFonts.kanit(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
    bodyText2: GoogleFonts.kanit(
        fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
  );
  static ThemeData myTheme() {
    return ThemeData(
      primarySwatch: kToDark,
      textTheme: textTheme,
      brightness: Brightness.light,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 82, 84, 255),
      ),
    );
  }
}
