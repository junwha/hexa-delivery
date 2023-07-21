import 'dart:math';

import 'package:hexa_delivery/model/category.dart';
import 'package:hexa_delivery/model/dto.dart';

class BoardResource {
  //for test without backend (should be removed afterwards)
  Map<String, dynamic> generateRandomOrder(Category category) {
    final String? kcategory = kCategory2String[category];
    final String storeName = '$kcategory집 ${Random().nextInt(100)}호점';
    final StoreDTO store = StoreDTO.fromJson(
        {"rid": Random().nextInt(100000000000), "name": storeName});
    final OrderDTO order = OrderDTO(
        Random().nextInt(100000000000),
        storeName,
        category,
        DateTime.now(),
        Random().nextInt(100000),
        Random().nextInt(10),
        'meetingLocation',
        'menuLink',
        'groupLink');
    return {"store": store, "order": order};
  }

  //for test without backend (should be removed afterwards)
  Future<List<Map<String, dynamic>>> getOrders(
      Category category, int pageIndex) async {
    List<Map<String, dynamic>> orders = [];
    for (int i = 0; i < 20; i++) {
      orders.add(generateRandomOrder(category));
    }

    return Future.delayed(
      Duration(milliseconds: Random().nextInt(1000)),
      () {
        return orders;
      },
    );
  }
}
