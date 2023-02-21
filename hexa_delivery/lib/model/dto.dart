import 'package:flutter/foundation.dart';

class StoreDTO {
  String sid;
  String name;
  Category category;

  StoreDTO (this.sid, this.name, this.category);
}

class OrderTopDTO {
  String oid;
  String name;
  DateTime expTime;
  OrderTopDTO (this.oid, this.name, this.expTime);
}

class OrderDescDTO extends OrderTopDTO {
  Category category;
  int fee;

  OrderDescDTO (super.oid, super.name, this.category, super.expTime, this.fee);
}

// Contains full data of each order
class OrderDTO extends OrderDescDTO {
  int numOfMembers;
  String meetingLocation;
  String menuLink;
  String groupLink;
  

  OrderDTO (super.oid, super.name, super.category, super.expTime, super.fee, this.numOfMembers, 
      this.meetingLocation, this.menuLink, this.groupLink);
}


