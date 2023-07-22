import 'package:flutter/material.dart';

const int kThemeColorHEX = 0xFFFF6332;

final ThemeData kThemeData = ThemeData(
  fontFamily: "Spoqa",
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: "Spoqa",
      color: Color(kThemeColorHEX),
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  textTheme: const TextTheme(
    displayMedium: TextStyle(
      fontFamily: "Spoqa",
      fontSize: 24,
      color: Colors.grey,
      fontWeight: FontWeight.w600,
    ),
  ),
  primaryColor: const Color(kThemeColorHEX),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2,
        color: Color(kThemeColorHEX),
      ),
      borderRadius: BorderRadius.circular(13),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2,
        color: Colors.grey,
      ),
      borderRadius: BorderRadius.circular(13),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2,
        color: Color(kThemeColorHEX),
      ),
      borderRadius: BorderRadius.circular(13),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 1.5,
        color: Colors.red,
      ),
      borderRadius: BorderRadius.circular(13),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 1.5,
        color: Colors.red,
      ),
      borderRadius: BorderRadius.circular(13),
    ),
    errorStyle: const TextStyle(
      fontSize: 14,
    ),
    floatingLabelStyle: const TextStyle(
      color: Colors.black,
    ),
  ),

  // colorScheme: const ColorScheme(
  //     background: Color.fromARGB(255, 255, 255, 255), brightness: 1),
);

const TextStyle kHighlightTextStyle = TextStyle(
  fontFamily: "Spoqa",
  color: Color(kThemeColorHEX),
  fontSize: 30,
  fontWeight: FontWeight.w600,
);
