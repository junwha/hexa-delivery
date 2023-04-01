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
    OrderTopDTO(
        "o000",
        "피자나라 치킨공주",
        DateTime(now.year, now.month, now.day, (now.hour + 1) % 24, now.minute,
            now.second)),
    OrderTopDTO(
        "o001",
        "BHC 구영점",
        DateTime(now.year, now.month, now.day, now.hour, (now.minute + 5) % 60,
            now.second)),
    OrderTopDTO(
        "o002",
        "처갓집치킨 천상점",
        DateTime(now.year, now.month, now.day, now.hour, (now.minute + 10) % 60,
            now.second)),
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
        centerTitle: false,
        toolbarHeight: 60,
        title: buildAppBarTitle('HeXA DELIVERY'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.account_circle),
              color: const Color.fromARGB(255, 255, 91, 91),
              iconSize: 30,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                child: buildSearchBar(),
              ),
              buildSubTitle('임박한 모임'),
              SizedBox(
                height: 130,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: top3Orders
                        .asMap()
                        .entries
                        .map((order) => buildTop3Order(order.key, order.value))
                        .toList()),
              ),
              buildSubTitle('카테고리'),
              buildCategoryGrid(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          "만들기",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        icon: const Icon(Icons.add),
        onPressed: () {},
        tooltip: 'Increment',
        backgroundColor: const Color.fromARGB(255, 255, 91, 91),
      ),
    );
  }
}

Widget buildSearchBar() {
  return const TextField(
    textAlign: TextAlign.center,
    decoration: InputDecoration(
      fillColor: Color.fromARGB(255, 230, 230, 230),
      filled: true,
      contentPadding: EdgeInsets.all(12),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0, color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(
            20,
          ))),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 0, color: Colors.transparent),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      hintText: "가게 이름을 입력해주세요.",
    ),
    style: TextStyle(
      fontSize: 15,
      color: Color(0xFFFF6332),
      fontWeight: FontWeight.w700,
    ),
    autocorrect: false,
    autofocus: false,
    maxLines: 1,
  );
}

Widget buildTop3Order(int index, OrderTopDTO order) {
  return Padding(
    padding: const EdgeInsets.only(left: 37, right: 37, bottom: 7),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildGroupListText('${index + 1}. ${order.name}'),
        TimerWidget(order.expTime.difference(DateTime.now())),
      ],
    ),
  );
}

Widget buildCategoryGrid() {
  return SizedBox(
    height: 380,
    child: GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: buildCategoryButton(),
    ),
  );
}

List<Widget> buildCategoryButton() {
  return kCategoryList.map((item) {
    return ElevatedButton(
      onPressed: () {},
      style: const ButtonStyle(
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
          backgroundColor:
              MaterialStatePropertyAll(Color.fromARGB(255, 245, 245, 245)),
          shadowColor: MaterialStatePropertyAll(Colors.transparent)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              item['Icon'],
              style: const TextStyle(fontFamily: "Tossface", fontSize: 40),
            ),
          ),
          Text(item['Name'],
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black)),
        ],
      ),
    );
  }).toList();
}

Widget buildAppBarTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(left: 10),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 23,
      ),
    ),
  );
}

Widget buildSubTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(left: 30, top: 20, bottom: 15),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Color.fromARGB(255, 170, 170, 170),
      ),
    ),
  );
}

Widget buildGroupListText(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 21,
    ),
  );
}
