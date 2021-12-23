class UserModel {
  UserModel({
      String? password, 
      String? role, 
      String? username,}){
    _password = password;
    _role = role;
    _username = username;
}

  UserModel.fromJson(dynamic json) {
    _password = json['password'];
    _role = json['role'];
    _username = json['username'];
  }
  String? _password;
  String? _role;
  String? _username;

  String? get password => _password;
  String? get role => _role;
  String? get username => _username;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['password'] = _password;
    map['role'] = _role;
    map['username'] = _username;
    return map;
  }

}