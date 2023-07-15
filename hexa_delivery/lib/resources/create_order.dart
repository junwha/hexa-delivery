import 'dart:convert';

import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/resources/store_provider.dart';
import 'package:hexa_delivery/utils/user_info_cache.dart';
import 'package:http/http.dart' as http;

class OrderResource {
  // Fields for OrderToBeCreatedDTO
  StoreDTO? storeDTO;
  DateTime? orderHM;
  DateTime? orderDate;
  int? fee;
  String? location;
  String? groupLink;

  Future<Iterable<StoreDTO>> getStoreList(String query) async {
    List<StoreDTO> storeList = await StoreListQueryProvider.searchStoresAndGetList(query);

    return storeList;
  }

  Future<bool> createOrder() async {
    // int rid = -1;
    // if (_storeNameDTOMap!.containsKey(storeName)) {
    //   StoreDTO store =_storeNameDTOMap![storeName]!;
    //   if (!store.isFromAPI()) { 
    //     rid = await StoreListQueryProvider.createStoreAndGetRID(store); 
    //     if (rid == -1) return false; // TODO: deal with unexpected error 
    //   }
    //   else { 
    //     rid = store.getRID; 
    //   };

    //   return true;
    // }


    // var headers = {
    //   "Access-Token": userInfoInMemory.token!,
    // };
    // var request = http.MultipartRequest(
    //     'POST', Uri.parse('http://delivery.hexa.pro/order/create'));

    // var body = {
    //   "rid": order.getRID().toString(),
    //   "uid": userInfoInMemory.uid!,
    //   "exp_time": order.getExpTime().toIso8601String(),
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
    return true;
  }
}
