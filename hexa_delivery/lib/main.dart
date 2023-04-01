import 'package:flutter/material.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'HeXA Delivery',
      theme: themeData,
      home: const MainPage(),
      // DetailPage(OrderDTO("0000", "푸라닭 구영점", Category.chicken, DateTime.now(), 4000, 4, "기숙사 광장", "https://baemin.me/fZACSxoyb", "https://open.kakao.com"))
      // MainPage()
    );
  }
}
