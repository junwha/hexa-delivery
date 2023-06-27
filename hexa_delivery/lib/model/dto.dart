import 'package:hexa_delivery/model/category.dart';

class StoreDTO {
  String sid;
  String name;
  Category category;

  StoreDTO(this.sid, this.name, this.category);
}

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
}

class OrderDescDTO extends OrderTopDTO {
  Category category;
  int fee;

  OrderDescDTO(super.oid, super.name, this.category, super.expTime, this.fee);
}

// Contains full data of each order
class OrderDTO extends OrderDescDTO {
  int numOfMembers;
  String meetingLocation;
  String menuLink;
  String groupLink;

  OrderDTO(super.oid, super.name, super.category, super.expTime, super.fee,
      this.numOfMembers, this.meetingLocation, this.menuLink, this.groupLink);
}
