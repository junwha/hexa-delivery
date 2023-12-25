import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hexa_delivery/model/baemin_parser.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/pages/create_group_page.dart';
import 'package:hexa_delivery/pages/search_stores_page.dart';
import 'package:hexa_delivery/resources/order_resource.dart';
import 'package:hexa_delivery/resources/store_resource.dart';
import 'package:hexa_delivery/theme/theme_data.dart';

class MainPageBloc {
  final StreamController<List<OrderTopDTO>> _orderTopDTOStream =
      StreamController();
  Stream<List<OrderTopDTO>> get orderTopDTOStream => _orderTopDTOStream.stream;
  late BuildContext _context;

  void onSharingFromBaemin(String? text) async {
    Map<String, dynamic> parsed = parseBaeminSharing(text ?? '');
    if (parsed['is_successful']) {
      String restaurant = parsed['restaurant'];
      String url = parsed['url'];

      final context = _context;

      showDialog(
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  color: kThemeData.primaryColor,
                ),
              ),
            ],
          );
        },
      );

      StoreDTO store;

      final storeList = await StoreResource.getStoreList(restaurant);

      if (storeList.isNotEmpty) {
        store = storeList.first;
        print('store name: ${store.getName}');
        if (!context.mounted) return;
        Navigator.pop(context);
      } else {
        var storeId = await StoreResource.createStoreAndGetRID(
            StoreCreateDTO(restaurant));
        store = StoreDTO(rid: storeId, name: restaurant);
        print('store name: ${store.getName}');
        if (!context.mounted) return;
        Navigator.pop(context);
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return CreateGroupPage(
              store: store,
              url: url,
            );
          },
        ),
      ).then((value) {
        requestNewOrderTopDTO();
      });
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
                    return const SearchStoresPage();
                  })).then((val) {
                    requestNewOrderTopDTO();
                  });
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
