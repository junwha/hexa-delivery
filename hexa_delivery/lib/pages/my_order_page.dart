import 'package:flutter/material.dart';
import 'package:hexa_delivery/model/category.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/pages/detail_page.dart';
import 'package:hexa_delivery/theme/theme_data.dart';
import 'package:hexa_delivery/widgets/order_desc_card.dart';

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
        Expanded(child: OrderDescCard(order)),
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
}