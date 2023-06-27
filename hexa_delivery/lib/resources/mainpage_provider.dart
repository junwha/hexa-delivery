import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:hexa_delivery/model/dto.dart';
/*
class OrderTopDTO {
  late DateTime expTime;
  late String name;
  late String oid;

  OrderTopDTO(this.oid, this.name, this.expTime);

  OrderTopDTO.fromJson(Map<String, dynamic> json) {
    expTime = DateTime.parse(json['exp_time']);
    name = json['name'];
    oid = json['oid'].toString();
  }
}*/

class MainPageProvider {
  static Future<List<OrderTopDTO>> mainList() async {
    var url = Uri.parse(
      'http://delivery.hexa.pro/order/top_list',
    );
    var response = await http.get(url);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = jsonDecode(response.body);
      List dataS = data['data'];
      print('OK');
      print(dataS[0]['exp_time']);
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
}