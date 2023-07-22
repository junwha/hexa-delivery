import 'package:flutter/material.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/pages/detail_page.dart';
import 'package:hexa_delivery/theme/theme_data.dart';

class OrderDescCard extends StatelessWidget {
  final OrderDescDTO order;

  const OrderDescCard(
      this.order,
      {super.key});

  @override
  Widget build(BuildContext context) {
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
                      order.name,
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
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Text(
                    //   '현재 ${order.numOfMembers}명 참가중',
                    //   style: const TextStyle(
                    //     fontSize: 14.0,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                    const SizedBox(height: 3),
                    Text(
                      '배달료 ${order.fee}원',
                      style: const TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
