import 'dart:convert';

import 'package:hexa_delivery/model/dto.dart';
import 'package:http/http.dart' as http;

class OrderResource {
  void createOrder(OrderToBeCreatedDTO order, User user) async {
    var headers = {
      "Access-Token": user.getToken(),
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://delivery.hexa.pro/order/create'));

    var body = {
      "rid": order.getRID().toString(),
      "uid": user.getUID().toString(),
      "exp_time": order.getExpTime().toIso8601String(),
      "fee": order.getFee().toString(),
      "location": order.getLocation(),
      "group_link": order.getGroupLink(),
      // "member_num": 1000.toString(), // 뭐지
    };

    request.fields.addAll(body);

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = await response.stream.bytesToString();

    print(res);
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(res)["data"]!;
      print(data);
      // implement return response object
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
