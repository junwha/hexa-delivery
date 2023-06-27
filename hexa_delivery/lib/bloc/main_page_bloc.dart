import 'dart:async';

import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/resources/mainpage_provider.dart';

class MainPageBloc {
  final StreamController<List<OrderTopDTO>> _orderTopDTOStream =
      StreamController();
  Stream<List<OrderTopDTO>> get orderTopDTOStream => _orderTopDTOStream.stream;

  void requestNewOrderTopDTO() async {
    List<OrderTopDTO> orderTopDTOList = await MainPageProvider.mainList();
    _orderTopDTOStream.sink.add(orderTopDTOList);
  }

  void destroy() {
    _orderTopDTOStream.close();
  }
}