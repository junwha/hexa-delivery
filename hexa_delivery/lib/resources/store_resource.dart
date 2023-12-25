import 'dart:async';
import 'package:hexa_delivery/model/dto.dart';
import 'package:hexa_delivery/utils/user_info_cache.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hexa_delivery/settings.dart';

class StoreResource {
  static Future<Iterable<StoreDTO>> getStoreList(String query) async {
    List<StoreDTO> storeList =
        await StoreResource.searchStoresAndGetList(query);

    return storeList;
  }

  static Future<int> createStoreAndGetRID(StoreCreateDTO store) async {
    print('createStoreAndGetRID');
    print(store.getName);
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://$kDeliveryURI/store/create'));

    var body = {
      "name": store.getName,
      "creator": userInfoInMemory.uid!,
      "category": '치킨',
    };

    var headers = {
      "Access-Token": userInfoInMemory.token!,
    };

    request.fields.addAll(body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = await response.stream.bytesToString();

    print(res);
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(res)["data"]!;

      print('returning ${data["rid"]!}');
      return data["rid"]!;
    } else {
      // If that call was not successful, throw an error.
      print('returning -1');
      return -1;
    }
  }

  static Future<List<StoreDTO>> searchStoresAndGetList(String query) async {
    final url = Uri.parse("http://$kDeliveryURI/store/search?query=$query");
    final response = await http.get(url);
    print('searchStoresAndGetList');
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<dynamic> data = json.decode(response.body)["data"]!;
      List<StoreDTO> storeList =
          data.map((json) => StoreDTO.fromJson(json)).toList();

      print('returning $storeList');
      return storeList;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
