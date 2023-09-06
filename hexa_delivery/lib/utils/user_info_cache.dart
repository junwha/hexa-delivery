final UserInfoCache userInfoInMemory = UserInfoCache();

class UserInfoCache {
  String? _uid;
  String? _token;

  String? get uid => _uid;
  String? get token => _token;
  bool get valid => _uid != null && _token != null;

  void setUserInfo(String uid, String token) {
    _uid = uid;
    _token = token;
  }

  void clear() {
    _uid = null;
    _token = null;
  }
}
