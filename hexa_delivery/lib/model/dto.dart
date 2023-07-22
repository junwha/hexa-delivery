import 'package:hexa_delivery/model/category.dart';

class StoreDTO {
  late int rid;
  late String name;

  StoreDTO() {}

  StoreDTO.fromJson(Map<String, dynamic> parsedJson) {
    rid = parsedJson['rid'];
    name = parsedJson['name'];
  }

  int get getRID => rid;
  String get getName => name;
}

class StoreCreateDTO extends StoreDTO {
  String? category; // lazily initialized 

  StoreCreateDTO(String name) {
    super.rid = -1;
    super.name = name;
  }
}

class OrderTopDTO {
  late DateTime expTime;
  late String name;
  late int oid;

  OrderTopDTO(this.oid, this.name, this.expTime);

  OrderTopDTO.fromJson(Map<String, dynamic> json) {
    expTime = DateTime.parse(json['exp_time']);
    name = json['name'];
    oid = json['oid'];
  }
}

class OrderDescDTO extends OrderTopDTO {
  late Category category;
  late int fee;

  OrderDescDTO(super.oid, super.name, this.category, super.expTime, this.fee);
  
  OrderDescDTO.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    category = kString2Category[json['category']]!;
    fee = json['fee'];
  }
}

// Contains full data of each order
class OrderDTO extends OrderDescDTO {
  // late int numOfMembers;
  late String meetingLocation;
  late String groupLink;

  OrderDTO(super.oid, super.name, super.category, super.expTime, super.fee,
          this.meetingLocation, this.groupLink);

  OrderDTO.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    meetingLocation = json['location'];
    groupLink = json['group_link'];
  }
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