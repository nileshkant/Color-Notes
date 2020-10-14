import 'package:flutter/material.dart';

// final appTheme = ThemeData(
//   brightness: Brightness.dark,
//   primaryColor: Colors.cyan,
//   primarySwatch: Colors.yellow,
//   textTheme: TextTheme(
//     headline1: TextStyle(
//       fontFamily: 'Corben',
//       fontWeight: FontWeight.w700,
//       fontSize: 24,
//     ),
//     headline2: TextStyle(
//       fontFamily: 'Corben',
//       fontWeight: FontWeight.w500,
//       fontSize: 12,
//     ),
//   ),
// );

final darkTheme = ThemeData(
  primaryColor: Colors.cyan,
  primarySwatch: Colors.yellow,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  accentColor: Colors.white,
  textSelectionColor: Colors.white10,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.black12,
  textTheme: TextTheme(
    headline1: TextStyle(
      fontFamily: 'Corben',
      fontWeight: FontWeight.w700,
      fontSize: 24,
    ),
    headline2: TextStyle(
      fontFamily: 'Corben',
      fontWeight: FontWeight.w500,
      fontSize: 12,
    ),
  ),
);

final lightTheme = ThemeData(
  primarySwatch: Colors.lightBlue,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  textSelectionColor: Colors.black12,
  accentColor: Colors.black,
  accentIconTheme: IconThemeData(color: Colors.white),
  dividerColor: Colors.white54,
  textTheme: TextTheme(
    headline1: TextStyle(
      fontFamily: 'Corben',
      fontWeight: FontWeight.w700,
      fontSize: 24,
    ),
    headline2: TextStyle(
      fontFamily: 'Corben',
      fontWeight: FontWeight.w500,
      fontSize: 12,
    ),
  ),
);
