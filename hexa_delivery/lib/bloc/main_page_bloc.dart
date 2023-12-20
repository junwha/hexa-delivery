import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexa_delivery/model/baemin_parser.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/pages/create_group_page.dart';
import 'package:hexa_delivery/pages/create_group_page_manual.dart';
import 'package:hexa_delivery/resources/order_resource.dart';

class MainPageBloc {
  final StreamController<List<OrderTopDTO>> _orderTopDTOStream =
      StreamController();
  Stream<List<OrderTopDTO>> get orderTopDTOStream => _orderTopDTOStream.stream;
  late BuildContext _context;

  void onSharingFromBaemin(String? text) {
    Map<String, dynamic> parsed = parseBaeminSharing(text ?? '');
    if (parsed['is_successful']) {
      String restaurant = parsed['restaurant'];
      String url = parsed['url'];
      Navigator.push(_context, MaterialPageRoute(builder: (context) {
        return CreateGroupPage(
          restaurant: restaurant,
          url: url,
        );
      }));
    } else {
      showDialog(
        context: _context,
        builder: (context) {
          return AlertDialog(
            title: const Text('오류가 발생했습니다.'),
            content: const Text('직접 주문을 생성하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(_context,
                      MaterialPageRoute(builder: (context) {
                    return const CreateGroupPageManual(); // Navigate to CreateGroupPageManual
                  }));
                },
                child: const Text('예'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('아니오'),
              ),
            ],
          );
        },
      );
    }
  }

  void tossContext(BuildContext context) {
    _context = context;
  }

  void requestNewOrderTopDTO() async {
    List<OrderTopDTO> orderTopDTOList = await OrderResource.getTopOrders();
    _orderTopDTOStream.sink.add(orderTopDTOList);
  }

  void destroy() {
    _orderTopDTOStream.close();
  }
}
