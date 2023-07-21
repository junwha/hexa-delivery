import 'package:flutter/material.dart';
import 'package:hexa_delivery/model/category.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/pages/detail_page.dart';
import 'package:hexa_delivery/theme/theme_data.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});
  // final List<OrderDTO> orders;

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  final order = OrderDTO(12312, '치킨', Category.chicken, DateTime.timestamp(),
      10000, 2, 'meetingLocation', 'menuLink', 'groupLink');

  final store = StoreCreateDTO('BHC 구영점');
  // int number = 10;
  // String startTime = '10';
  // int cost = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("내 주문"),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          }, // 뒤로가기
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 25),
              child: Text(
                '현재 모임',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            buildCancelContainer(context, order),
            buildCancelContainer(context, order),
            buildCancelContainer(context, order),
          ],
        ),
      ),
    );
  }

  Widget buildCancelContainer(BuildContext context, OrderDTO order) {
    return Row(
      children: [
        Expanded(child: buildContainer(context, order)),
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color.fromRGBO(255, 224, 224, 1),
          ),
          margin: const EdgeInsets.only(right: 18),
          width: 80,
          height: 80,
          alignment: Alignment.center,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete,
                color: Color.fromARGB(255, 255, 31, 31),
              ),
              SizedBox(height: 5),
              Text(
                "나가기",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 31, 31),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  GestureDetector buildContainer(BuildContext context, OrderDTO order) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailPage(order.oid)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 240, 240, 240),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        color: Color(kThemeColorHEX),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Text(
                          '주문시간 ',
                          style: TextStyle(
                              color: Color.fromARGB(255, 99, 118, 119),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${order.expTime.hour}시 ${order.expTime.minute}분',
                          style: const TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(right: 18),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       Text(
              //         '현재 ${order.numOfMembers}명 참가중',
              //         style: const TextStyle(
              //           fontSize: 14.0,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //       const SizedBox(height: 3),
              //       Text(
              //         '배달료 ${order.fee}원',
              //         style: const TextStyle(
              //             fontSize: 14.0, fontWeight: FontWeight.w400),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
