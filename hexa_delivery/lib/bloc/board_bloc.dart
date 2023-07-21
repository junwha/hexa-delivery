import 'dart:async';

import 'package:hexa_delivery/model/category.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/resources/board_order_provider.dart';

class BoardBloc {
  final StreamController<List<OrderDescDTO>> _orderStream = StreamController();
  int _page = 0;

  Stream<List<OrderDescDTO>> get getOrderStream => _orderStream.stream;

  void requestNextPage({Category? category, int? uid}) async {
    List<OrderDescDTO> orderList = await BoardResource.getOrders(category: category, uid: uid, pageIndex: _page);
    _orderStream.sink.add(orderList);
    _page += 1;
  } 
}