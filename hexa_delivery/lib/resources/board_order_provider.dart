import 'package:hexa_delivery/model/category.dart';
import 'package:hexa_delivery/model/dto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BoardResource {
  static Future<List<OrderDescDTO>> getOrders(
      {int? uid, Category? category, int? pageIndex}) async {
    if (uid == null && category == null) return [];
    
    String options = "";
    if (uid != null) options += "uid=$uid&";
    if (category != null) options += "category=${kCategory2String[category]}&";
    if (pageIndex != null) options += "page=$pageIndex&";
    
    var url = Uri.parse(
      'http://delivery.hexa.pro/order/list?$options',
    );

    var response = await http.get(url);
    print(url);
    print(response.body);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<dynamic> data = jsonDecode(response.body)['data'];
      print(data);
      
      List<OrderDescDTO> orderList = data.map(
        (json)=>OrderDescDTO.fromJson(json)).toList();

      return orderList;
    } else {
      // If that call was not successful, throw an error.
      return [];
    }
  }
}
