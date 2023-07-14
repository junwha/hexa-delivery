import 'package:flutter/material.dart';

final ThemeData kThemeData = ThemeData(
  fontFamily: "Spoqa",
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: "Spoqa",
      color: Color(0xFFFF6332),
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
  primaryColor: const Color(0xFFFF6332),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2,
        color: Color(0xFFFF6332),
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
        color: Color(0xFFFF6332),
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

final TextStyle kTitleTextStyle = const TextStyle(
  fontFamily: "Spoqa",
  color: Color(0xFFFF6332),
  fontSize: 18,
  fontWeight: FontWeight.w600,
);