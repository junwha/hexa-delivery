import 'package:flutter/material.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/pages/create_group_test.dart';
import 'package:hexa_delivery/pages/detail_page.dart';
import 'package:hexa_delivery/pages/main_page.dart';
import 'package:hexa_delivery/resources/mainpage_get_API.dart';
import 'package:hexa_delivery/resources/mainpage_provider.dart';
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
        debugShowCheckedModeBanner: false,
        title: 'HeXA Delivery',
        theme: themeData,
        home: MainPage()
        //DetailPage(OrderDTO("0000", "푸라닭 구영점", Category.chicken, DateTime.now(), 4000, 4, "기숙사 광장", "https://baemin.me/fZACSxoyb", "https://open.kakao.com"))
        //const CreateGroupPageTest(),

        // DetailPage(OrderDTO("0000", "푸라닭 구영점", Category.chicken, DateTime.now(), 4000, 4, "기숙사 광장", "https://baemin.me/fZACSxoyb", "https://open.kakao.com"))
        // MainPage()
        );
  }
}
