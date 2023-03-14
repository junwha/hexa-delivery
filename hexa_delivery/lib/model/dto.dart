import 'package:hexa_delivery/model/category.dart';

class StoreDTO {
  late int rid;
  late String name;

  StoreDTO(this.rid, this.name);

  StoreDTO.fromJson(Map<String, dynamic> parsedJson) {
    rid = parsedJson['rid'];
    name = parsedJson['name'];
  }

  int getRID() => rid;

  String getName() => name;
}

class OrderTopDTO {
  String oid;
  String name;
  DateTime expTime;
  OrderTopDTO(this.oid, this.name, this.expTime);
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

class OrderToBeCreatedDTO {
  int rID;
  DateTime expTime;
  int fee;
  String location;
  String groupLink;

  OrderToBeCreatedDTO(
    this.rID,
    this.expTime,
    this.fee,
    this.location,
    this.groupLink,
  );

  int getRID() => rID;

  DateTime getExpTime() => expTime;

  int getFee() => fee;

  String getLocation() => location;

  String getGroupLink() => groupLink;
}

class UserOnlyUID {
  int uID;

  UserOnlyUID(this.uID);

  int getUID() => uID;
}

class User extends UserOnlyUID {
  String token;

  User(super.uID, this.token);

  String getToken() => token;
}

class UserValified {
  User? user;
  bool isValified;
  bool isCodeWrong;
  bool isCodeExpired;

  UserValified({
    this.user,
    required this.isValified,
    required this.isCodeWrong,
    required this.isCodeExpired,
  });

  bool getIsValified() => isValified;

  bool getIsCodeExpired() => isCodeExpired;

  bool getIsCodeWrong() => isCodeWrong;

  User getUser() {
    if (isValified && user != null) {
      return user!;
    } else {
      throw Exception('user not valified');
    }
  }
}
