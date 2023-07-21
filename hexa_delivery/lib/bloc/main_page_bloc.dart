import 'dart:async';

import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/resources/order_resource.dart';

class MainPageBloc {
  final StreamController<List<OrderTopDTO>> _orderTopDTOStream =
      StreamController();
  Stream<List<OrderTopDTO>> get orderTopDTOStream => _orderTopDTOStream.stream;

  void requestNewOrderTopDTO() async {
    List<OrderTopDTO> orderTopDTOList = await OrderResource.getTopOrders();
    _orderTopDTOStream.sink.add(orderTopDTOList);
  }

  void destroy() {
    _orderTopDTOStream.close();
  }
}