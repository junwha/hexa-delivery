import 'dart:async';
import 'package:hexa_delivery/model/dto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StoreListQueryProvider {
  Map<String, StoreDTO>? _storeNameDTOMap;

  Future<List<StoreDTO>> searchStoresAndGetList(String query) async {
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

      Iterable<MapEntry<String, StoreDTO>> entries = storeList.map((store) => MapEntry(store.getName, store));
      _storeNameDTOMap = Map.fromEntries(entries); // cache store map

      return storeList;
      
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  bool isCreated(String query) {
    if (_storeNameDTOMap == null) return true;
    // The query is guaranteed to there (search before suggest & select)
    if (_storeNameDTOMap![query]!.isFromAPI()) return false;
    return true;
  }
}
