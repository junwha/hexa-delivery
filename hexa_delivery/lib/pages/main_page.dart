import 'package:flutter/material.dart';
import 'package:hexa_delivery/model/category.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/widgets/timer.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();

  const MainPage({super.key});
}

List<int> groupTotalTime = [221, 317, 500];

List<Duration> countdownDurations = [
  Duration(minutes: groupTotalTime[0] ~/ 60, seconds: groupTotalTime[0] % 60),
  Duration(minutes: groupTotalTime[1] ~/ 60, seconds: groupTotalTime[1] % 60),
  Duration(minutes: groupTotalTime[2] ~/ 60, seconds: groupTotalTime[2] % 60)
];


List<OrderTopDTO> getTop3OrdersMock() {
  DateTime now = DateTime.now();
  return [
    OrderTopDTO("o000", "피자나라 치킨공주", DateTime(now.year, now.month, now.day, (now.hour+1)%24, now.minute, now.second)),
    OrderTopDTO("o001", "BHC 구영점", DateTime(now.year, now.month, now.day, now.hour, (now.minute+5)%60, now.second)),
    OrderTopDTO("o002", "처갓집치킨 천상점", DateTime(now.year, now.month, now.day, now.hour, (now.minute+10)%60, now.second)),
  ];
}


class _MainPageState extends State<MainPage> {  
  List<OrderTopDTO> top3Orders = [];

  @override
  void initState() {
    top3Orders = getTop3OrdersMock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Column(
          children: [
            buildAppBarTitle('HeXA'),
            buildAppBarTitle('DELIVERY'),
          ],
        )),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle),
            color: Colors.black,
            iconSize: 30,
          ),
        ],
        backgroundColor: const Color(0xff81ccd1),
      ),
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildSubTitle('임박한 모임'),
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: top3Orders.map((order)=>buildTop3Order(order)).toList()
            ),
            buildSubTitle('카테고리'),
            const SizedBox(height: 5),
            buildCategoryGrid(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        backgroundColor: const Color(0xFF81CCD1),
        child: const Icon(Icons.add),
      ),
    );
  }
}
Widget buildTop3Order(OrderTopDTO order) {
  return Padding(
    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 5),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildGroupListText(order.name),
          TimerWidget(order.expTime.difference(DateTime.now())),
        ],
      ),
  );
}

Widget buildCategoryGrid() {
  return SizedBox(
    height: 500,
    child: GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      children: buildCategoryButton(),
    ),
  );
}

List<Widget> buildCategoryButton() {
  return kCategoryList.map((item) {
      return ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                const Color(0xFFC6EDEF),
              ),
              foregroundColor: MaterialStateProperty.all(Colors.black),
              side: MaterialStateProperty.all(
                const BorderSide(
                  width: 2.0,
                  color: Colors.black,
                ),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
              ),
          ),
          child: Text(item,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )
          ),
        );
    }).toList();
}


Widget buildAppBarTitle(String text) {
  return Text(
    text,
    style: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget buildSubTitle(String text) {
  return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xff637677),
        ),
      ),
  );
}

Widget buildGroupListText(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  );
}