import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hexa_delivery/pages/main_page.dart';
import 'package:hexa_delivery/theme/theme_data.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('ko', ''),
        Locale('en', ''),
      ],
      debugShowCheckedModeBanner: false,
      title: 'HeXA Delivery',
      theme: themeData,
      home: const MainPage(),
    );
  }
}
