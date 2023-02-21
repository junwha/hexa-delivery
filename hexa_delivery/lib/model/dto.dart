class StoreDTO {
  int sid;
  String name;
  String category;

  StoreDTO (this.sid, this.name, this.category);
}

class OrderTopDTO {
  int oid;
  DateTime expTime;
  OrderTopDTO (this.oid, this.expTime);
}

class OrderDescDTO extends OrderTopDTO {
  String name;
  String category;
  int fee;

  OrderDescDTO (super.oid, this.name, this.category, super.expTime, this.fee);
}

// Contains full data of each order
class OrderDTO extends OrderDescDTO {
  int numOfMembers;
  String meetingLocation;
  String menuLink;
  String groupLink;
  

  OrderDTO (super.oid, super.name, super.category, super.expTime, super.fee, this.numOfMembers, this.meetingLocation, this.menuLink, this.groupLink);
}


