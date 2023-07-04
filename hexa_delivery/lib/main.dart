import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hexa_delivery/pages/main_page.dart';
import 'package:hexa_delivery/theme/theme_data.dart';

void main() {
  /*
  print('ok');
  Future<List<OrderTopDTO>> d = MainPageProvider().mainList();
  d.then((val) {
    print('val: ${val[0].name}');
  });*/
  //print('check= ',d[0].name);[]
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'HeXA Delivery',
      theme: themeData,
      home: const MainPage(),
    );
  }
}
