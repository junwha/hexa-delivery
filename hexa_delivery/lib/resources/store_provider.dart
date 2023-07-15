import 'dart:async';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/utils/user_info_cache.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StoreListQueryProvider {
  static Future<int> createStoreAndGetRID(StoreDTO store) async {
    // var headers = {
    //   "Access-Token": userInfoInMemory.token!,
    // };
    // var request = http.MultipartRequest(
    //     'POST', Uri.parse('http://delivery.hexa.pro/order/create'));

    // var body = {
    //   "uid": userInfoInMemory.uid!,
    //   "category": store.category,
    //   "fee": order.getFee().toString(),
    //   "location": order.getLocation(),
    //   "group_link": order.getGroupLink(),
    //   // "member_num": 1000.toString(), // 뭐지
    // };

    // request.fields.addAll(body);

    // request.headers.addAll(headers);

    // http.StreamedResponse response = await request.send();

    // var res = await response.stream.bytesToString();

    // print(res);
    // if (response.statusCode == 201) {
    //   // If the call to the server was successful, parse the JSON
    //   Map<String, dynamic> data = json.decode(res)["data"]!;
    //   print(data);
    //   // implement return response object
    // } else {
    //   // If that call was not successful, throw an error.
    //   throw Exception('Failed to load post');
    // }
    return -1;
  }

  static Future<List<StoreDTO>> searchStoresAndGetList(String query) async {
    final url = Uri.parse("http://delivery.hexa.pro/store/search?query=$query");
    final response = await http.get(url);
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<dynamic> data = json.decode(response.body)["data"]!;
      print(data);
      List<StoreDTO> storeList =
          data.map((json) => StoreDTO.fromJson(json)).toList();
      
      if (storeList.isEmpty) storeList.add(StoreDTO(query));

      return storeList;
      
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }  
}
