import 'package:flutter/material.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/pages/board.dart';
import 'package:hexa_delivery/pages/detail_page.dart';
import 'package:hexa_delivery/pages/login_page.dart';
import 'package:hexa_delivery/pages/main_page.dart';

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
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff81ccd1),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: MainPage()
      // DetailPage(OrderDTO("0000", "푸라닭 구영점", Category.chicken, DateTime.now(), 4000, 4, "기숙사 광장", "https://baemin.me/fZACSxoyb", "https://open.kakao.com")) 
      // MainPage()
    );
  }
}
