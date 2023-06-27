import 'package:flutter/material.dart';
import 'package:hexa_delivery/bloc/main_page_bloc.dart';
import 'package:hexa_delivery/main.dart';
import 'package:hexa_delivery/model/category.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/resources/mainpage_provider.dart';
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
/*
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
  print('point1: ' + te.toString());
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
}*/

/*
List<OrderTopDTO> getTop3OrdersMock() {
  Future<List<OrderTopDTO>> d = MainPageProvider().mainList();
  late List<OrderTopDTO> getTop3;
  d.then((val) {
    getTop3 = val;
    print('val: ${val[0].name}');
  }).catchError((error) {
    getTop3 = error;
  });
  return getTop3;
}*/

class _MainPageState extends State<MainPage> {
  // List<OrderTopDTO> top3Orders = [];

// class _MainPageState extends State<MainPage> {
  //List<OrderTopDTO> top3Orders = [];
  //List<OrderTopDTO> tee = getTop3OrdersMock();
  //print('Point2: '+tee.toString());
  late MainPageBloc mainPageBloc;
  @override
  void initState() {
    //top3Orders = getTop3OrdersMock();
    //asyncFunction();
    mainPageBloc = MainPageBloc();
    mainPageBloc.requestNewOrderTopDTO();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //asyncFunction();
    //print('point5' + top3Orders.toString());
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
          child: RefreshIndicator(
        onRefresh: () async {
          mainPageBloc.requestNewOrderTopDTO();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildSubTitle('임박한 모임'),
              // const SizedBox(height: 10),
              // StreamBuilder(
              //     stream: mainPageBloc.orderTopDTOStream,
              //     builder:
              //         (context, AsyncSnapshot<List<OrderTopDTO>> snapshot) {
              //       return snapshot.hasData
              //           ? Column(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               children: snapshot.data!
              //                   .map((order) => buildTop3Order(2, order))
              //                   .toList())
              //           : CircularProgressIndicator() as Widget;
              //     }),
              SizedBox(
                height: 130,
                child: top3Orders.isNotEmpty
                    ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: top3Orders
                        .asMap()
                        .entries
                        .map((order) =>
                        buildTop3Order(order))
                        .toList())
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "🍴",
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: "Tossface",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "아직 모임이 없어요",
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "아래 카테고리에서 음식점을 찾아보세요.",
                        style: TextStyle(
                          color: Color.fromARGB(137, 117, 117, 117),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              buildSubTitle('카테고리'),
              const SizedBox(height: 5),
              buildCategoryGrid(),
            ],
          ),
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        backgroundColor: const Color(0xFF81CCD1),
        child: const Icon(Icons.add),
      ),
    );

    // @override
    // void dispose() {
    //   mainPageBloc.destroy();
    //   super.dispose();
    // }

    // return Center(
    //   child: CircularProgressIndicator(),
    // );

    /*
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
                child: top3Orders.isNotEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: top3Orders
                            .asMap()
                            .entries
                            .map((order) =>
                                buildTop3Order(order.key, order.value))
                            .toList())
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "🍴",
                              style: TextStyle(
                                fontSize: 40,
                                fontFamily: "Tossface",
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "아직 모임이 없어요",
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              "아래 카테고리에서 음식점을 찾아보세요.",
                              style: TextStyle(
                                color: Color.fromARGB(137, 117, 117, 117),
                              ),
                            )
                          ],
                        ),
                      ),
              ),
              buildSubTitle('카테고리'),
              buildCategoryGrid(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        label: const Text(
          "만들기",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        icon: const Icon(Icons.add),
        onPressed: () {},
        tooltip: 'Increment',
        backgroundColor: const Color.fromARGB(255, 255, 91, 91),
      ),
    );*/
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

Widget buildTop3Order(OrderTopDTO order) {
  //print('build test: ' + order.name);
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
      scrollDirection: Axis.vertical,
      crossAxisCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      crossAxisSpacing: 20,
      shrinkWrap: true,
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
          )),
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