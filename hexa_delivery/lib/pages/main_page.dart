import 'package:flutter/material.dart';
import 'package:hexa_delivery/bloc/main_page_bloc.dart';
import 'package:hexa_delivery/model/category.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/pages/board.dart';
import 'package:hexa_delivery/pages/create_group_page.dart';
import 'package:hexa_delivery/pages/login_page.dart';
import 'package:hexa_delivery/theme/theme_data.dart';
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
  late MainPageBloc mainPageBloc;

  @override
  void initState() {
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
        centerTitle: false,
        toolbarHeight: 60,
        title: buildAppBarTitle('HeXA DELIVERY'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              icon: const Icon(Icons.account_circle),
              color: const Color.fromARGB(255, 255, 91, 91),
              iconSize: 30,
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async {
          mainPageBloc.requestNewOrderTopDTO();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildSubTitle('임박한 모임'),
              const SizedBox(height: 10),
              StreamBuilder(
                  stream: mainPageBloc.orderTopDTOStream,
                  builder:
                      (context, AsyncSnapshot<List<OrderTopDTO>> snapshot) {
                    return snapshot.hasData && snapshot.data!.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: snapshot.data!
                                .map((order) => buildTop3Order(order))
                                .toList())
                        : const Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                      fontSize: 23,
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  "아래 카테고리에서 음식점을 찾아보세요.",
                                  style: TextStyle(
                                    color: Color.fromARGB(137, 117, 117, 117),
                                  ),
                                )
                              ],
                            ),
                          );
                  }),
              buildSubTitle('카테고리'),
              const SizedBox(height: 5),
              buildCategoryGrid(context),
            ],
          ),
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateGroupPage()),
          );
        },
        tooltip: 'Increment',
        backgroundColor: const Color(kThemeColorHEX),
        elevation: 0,
        label: const Text(
          "만들기",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        icon: const Icon(Icons.add),
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
      color: Color(kThemeColorHEX),
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
    padding: const EdgeInsets.only(left: 37, right: 37, bottom: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildGroupListText(order.name),
        TimerWidget(order.expTime.difference(DateTime.now())),
      ],
    ),
  );
}

Widget buildCategoryGrid(context) {
  return SizedBox(
    height: 400,
    child: GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      crossAxisCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: buildCategoryButton(context),
    ),
  );
}

List<Widget> buildCategoryButton(context) {
  return kCategoryList.map((item) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BoardPage(item['Name'])),
        );
      },
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
                  fontSize: 16,
                  color: Colors.black87)),
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
        color: Color(0xFF637677),
      ),
    ),
  );
}

Widget buildGroupListText(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.black87,
      fontSize: 21,
    ),
  );
}
