
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexa_delivery/settings.dart';
import 'package:hexa_delivery/utils/user_info_cache.dart';

class SecureStorageInternal {
  static Future<bool> readUserInfoIntoMemory() async {
    const storage = FlutterSecureStorage();      
    String? uidTokenProp = await storage.read(key: kUIDSecureStorageKey);
    String? jwtTokenProp = await storage.read(key: kJWTTokenSecureStorageKey);

    if (uidTokenProp != null && jwtTokenProp != null) {
      userInfoInMemory.setUserInfo(uidTokenProp, jwtTokenProp);
      return true;
    }

    return false;
  }

  static Future<void> writeUserInfoIntoMemoryAndStorage(String uid, String token) async {
    const storage = FlutterSecureStorage();

    userInfoInMemory.setUserInfo(uid, token);
    storage.write(key: kUIDSecureStorageKey, value: uid);
    storage.write(key: kJWTTokenSecureStorageKey, value: token);
  }
}