import 'dart:async';

import 'package:hexa_delivery/model/category.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/resources/board_order_provider.dart';

class BoardBloc {
  final StreamController<List<OrderDescDTO>> _orderStream = StreamController();
  int _page = 1;
  final List<OrderDescDTO> _orderList = [];

  Stream<List<OrderDescDTO>> get getOrderStream => _orderStream.stream;

  void fetchNextPage({Category? category, int? uid}) async {
    List<OrderDescDTO> fetchList = await BoardResource.getOrders(category: category, uid: uid, pageIndex: _page);
    _orderList.addAll(fetchList);
    _orderStream.sink.add(_orderList);
    _page += 1;
  } 
}