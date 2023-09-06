import 'dart:async';

import 'package:hexa_delivery/model/category.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/resources/order_resource.dart';

class BoardBloc {
  final StreamController<List<OrderDescDTO>> _orderStream = StreamController();
  int _page = 1;
  final List<OrderDescDTO> _orderList = [];

  Stream<List<OrderDescDTO>> get getOrderStream => _orderStream.stream;

  void fetchNextPage({Category? category, int? uid}) async {
    List<OrderDescDTO> fetchList = await OrderResource.getOrders(
        category: category, uid: uid, pageIndex: _page);
    _orderList.addAll(fetchList);
    _orderStream.sink.add(_orderList);
    if (fetchList.isNotEmpty) _page += 1;
  }

  void deleteOrder(int oid) async {
    bool success = await OrderResource.closeOrder(oid);
    if (success) _orderList.removeWhere((order) => order.oid == oid);
    _orderStream.sink.add(_orderList);
  }
}
