import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hexa_delivery/pages/loading_page.dart';
import 'package:hexa_delivery/utils/firebase_options.dart';
import 'package:hexa_delivery/theme/theme_data.dart';

void main() async {
  /*
  print('ok');
  Future<List<OrderTopDTO>> d = MainPageProvider().mainList();
  d.then((val) {
    print('val: ${val[0].name}');
  });*/
  //print('check= ',d[0].name);[]
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.white),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      theme: kThemeData,
      home: LoadingPage(),
    );
  }
}
