import 'dart:convert';

import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/resources/store_provider.dart';
import 'package:hexa_delivery/utils/user_info_cache.dart';
import 'package:http/http.dart' as http;
import 'package:hexa_delivery/model/category.dart';

class OrderResource {
  // Fields for OrderToBeCreatedDTO
  StoreDTO? storeDTO;
  DateTime expTime = DateTime.now(); // will be updated
  int? fee;
  String? location;
  String? groupLink;

  Future<bool> createOrder() async {
    int rid = -1;
    if (storeDTO == null || fee == null || location == null || groupLink == null) return false;
    
    if (storeDTO is StoreCreateDTO) {
      StoreCreateDTO storeCreateDTO = storeDTO! as StoreCreateDTO;
      if (storeCreateDTO.category == null) return false;
      rid = await StoreListQueryProvider.createStoreAndGetRID(storeCreateDTO); 
    }
    else { 
      rid = storeDTO!.getRID; 
    }
    print(rid);
    if (rid == -1) return false; // TODO: deal with unexpected error 

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://delivery.hexa.pro/order/create'));

    var headers = {
      "Access-Token": userInfoInMemory.token!,
    };

    var body = {
      "rid": rid.toString(),
      "uid": userInfoInMemory.uid!,
      "exp_time": expTime.toIso8601String(),
      "fee": fee.toString(),
      "location": location!,
      "group_link": groupLink!,
    };

    request.fields.addAll(body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = await response.stream.bytesToString();

    print(res);
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(res)["data"]!;
      
      return true;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  static Future<List<OrderTopDTO>> getTopOrders() async {
    var url = Uri.parse(
      'http://delivery.hexa.pro/order/top_list',
    );
    var response = await http.get(url);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = jsonDecode(response.body);
      List dataS = data['data'];
      print('OK');
      print(dataS);
      //List mainList = jsonDecode(data['data']);
      //print(mainList);
      //var MainPageList = MainDTO.nfromJson(data);

      List<OrderTopDTO> mainTop3 = List.from(data['data'])
          .map((json) => OrderTopDTO.fromJson(json))
          .toList();
      return mainTop3;
    } else {
      // If that call was not successful, throw an error.
      return [];
    }
  }

  static Future<List<OrderDescDTO>> getOrders(
      {int? uid, Category? category, int? pageIndex}) async {
    if (uid == null && category == null) return [];
    
    String? options;
    if (uid != null) {
      options = "uid=$uid";
    }
    if (category != null) {
      options = options == null ? "" : "$options&";
      options += "category=${kCategory2String[category]}";
    }
    if (pageIndex != null) {
      options = options == null ? "" : "$options&";
      options += "page=$pageIndex";
    }
    
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