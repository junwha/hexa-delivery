import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  fontFamily: "Spoqa",
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 250, 250, 250),
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Color(0xFFFF6332),
      fontSize: 19,
      fontWeight: FontWeight.w600,
    ),
  ),
  textTheme: const TextTheme(
    displayMedium: TextStyle(
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
      borderRadius: BorderRadius.circular(20),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2,
        color: Color(0xFFFF6332),
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 1.5,
        color: Colors.red,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 1.5,
        color: Colors.red,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    errorStyle: const TextStyle(
      fontSize: 14,
    ),
    floatingLabelStyle: const TextStyle(
      color: Colors.black,
    ),
  ),
);
