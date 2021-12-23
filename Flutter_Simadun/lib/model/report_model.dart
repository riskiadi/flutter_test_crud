class ReportModel {
  ReportModel({
      String? id,
      String? report,
      String? username,
      String? status,}){
    _id = id;
    _report = report;
    _username = username;
    _status = status;
}

  ReportModel.fromJson(dynamic json) {
    _id = json['id'];
    _report = json['report'];
    _username = json['username'];
    _status = json['status'];
  }
  String? _id;
  String? _report;
  String? _username;
  String? _status;

  String? get id => _id;
  String? get report => _report;
  String? get username => _username;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['report'] = _report;
    map['username'] = _username;
    map['status'] = _status;
    return map;
  }

}