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
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 82, 84, 255),
      ),
    );
  }

  static Color primaryMajor = const Color(0xff5236ff);
  static Color primaryMinor = const Color(0x1a5236ff);
  static List<Color> majorBackground = [primaryMajor, const Color(0xff75a1e3)];
  static Color secondaryMajor = const Color(0x99000000);
  static Color secondaryMinor = const Color(0xffececec);
  static Color positiveMajor = const Color(0xff16d9ab);
  static Color positiveMinor = const Color(0x1a16d9ab);
  static Color negativeMajor = const Color(0xffe3006d);
  static Color negativeMinor = const Color(0x1ae3006d);
  static List<Color> incomeBackground = const [
    Color(0xff14b6da),
    Color(0xff2ae194),
  ];
  static List<Color> expenseBackground = const [
    Color(0xffdf4833),
    Color(0xffee3884),
  ];
  static List<Color> assetBackground = const [
    Color(0xff47d7e0),
    Color(0xff4d72f3),
  ];
  static List<Color> debtBackground = const [
    Color(0xffee3884),
    Color(0xffd26cf6),
  ];
  static List<Color> incomeWorking = const [
    Color(0xff16d9ab),
    Color(0x8016d9ab),
  ];
  static List<Color> incomeAsset = const [
    Color(0xff4cc6ed),
    Color(0x804cc6ed),
  ];
  static List<Color> incomeOther = const [
    Color(0xff4f75ff),
    Color(0x804f75ff),
  ];
  static List<Color> expenseInconsist = const [
    Color(0xffdf4833),
    Color(0x80df4833),
  ];
  static List<Color> expenseConsist = const [
    Color(0xffe98510),
    Color(0x80e98510),
  ];
  static List<Color> savingAndInvest = const [
    Color(0xff5236ff),
    Color(0x805236ff),
  ];
  static List<Color> assetLiquid = const [
    Color(0xff4cc6ed),
    Color(0x804cc6ed),
  ];
  static List<Color> assetInvest = const [
    Color(0xff1bd6e2),
    Color(0x801bd6e2),
  ];
  static List<Color> assetPersonal = const [
    Color(0xff5ba0f0),
    Color(0x805ba0f0),
  ];
  static List<Color> debtShort = const [
    Color(0xffe3006d),
    Color(0x80e3006d),
  ];
  static List<Color> debtLong = const [
    Color(0xfff263db),
    Color(0x80f263db),
  ];
  static Color inactiveBudget = const Color(0xffececec);
  // outerGlow
  static Color dropShadow = const Color(0x40000000);
  static Color notificateToEdit = const Color(0xffec033b);
}
