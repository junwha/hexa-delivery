import 'package:flutter/material.dart';
import 'package:hexa_delivery/pages/verification_page.dart';
import 'package:hexa_delivery/theme/theme_data.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HeXA Delivery',
      theme: themeData,
      home: VerificationPage(),
    );
  }
}
