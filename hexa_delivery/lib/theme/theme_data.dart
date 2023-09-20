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
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateColor.resolveWith(
          (states) => const Color(kThemeColorHEX)),
      overlayColor: MaterialStateColor.resolveWith(
          (states) => const Color(kThemeColorHEX).withOpacity(0.2)),
    ),
  ),
  timePickerTheme: TimePickerThemeData(
    dialHandColor: const Color(kThemeColorHEX),
    dayPeriodColor: MaterialStateColor.resolveWith(
      (states) => states.contains(MaterialState.selected)
          ? const Color.fromARGB(255, 255, 227, 219)
          : Colors.grey.shade200,
    ),
    dayPeriodTextColor: const Color(kThemeColorHEX),
    hourMinuteTextColor: MaterialStateColor.resolveWith(
      (states) => states.contains(MaterialState.selected)
          ? const Color(kThemeColorHEX)
          : Colors.black,
    ),
    hourMinuteColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? const Color.fromARGB(255, 255, 227, 219)
            : Colors.grey.shade200),
  ),
  datePickerTheme: DatePickerThemeData(
    todayBackgroundColor: MaterialStateColor.resolveWith(
      (states) => states.contains(MaterialState.selected)
          ? const Color(kThemeColorHEX)
          : Colors.transparent,
    ),
    todayForegroundColor: MaterialStateColor.resolveWith(
      (states) => states.contains(MaterialState.selected)
          ? Colors.white
          : const Color(kThemeColorHEX),
    ),
    headerBackgroundColor: const Color(kThemeColorHEX),
    dayBackgroundColor: MaterialStateColor.resolveWith(
      (states) => states.contains(MaterialState.selected)
          ? const Color(kThemeColorHEX)
          : Colors.transparent,
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

const boxDecorationTheme = BoxDecoration(
  border: Border.fromBorderSide(
    BorderSide(
      width: 2,
      color: Color(kThemeColorHEX),
    ),
  ),
  borderRadius: BorderRadius.all(Radius.circular(13)),
);

final textButtonDefaultTheme = TextButton.styleFrom(
  foregroundColor: const Color(kThemeColorHEX),
  textStyle: const TextStyle(
    fontFamily: "Spoqa",
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
);
