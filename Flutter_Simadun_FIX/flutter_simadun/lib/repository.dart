
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:flutter_simadun/model/report_model.dart';
import 'package:flutter_simadun/model/user_model.dart';

class Repository{

  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  Future createUser(String username, String password) async{
    await databaseReference.child('users').push().set({
      "username": username,
      "password": password,
      "role": username=="admin" ? "admin" : "normal"
    });
  }

  Future createReport(String username, String report) async{
    await databaseReference.child('report').push().set({
      "username": username,
      "report": report,
      "status": "0",
    });
  }

  Future editReport(String id, String report) async{
    await databaseReference.child('report/$id').update({
      "report": report,
    });
  }

  Future<List<ReportModel>?> getReport({String? username}) async{
    print("getReport() executed");
    var snapshot = await databaseReference.child("report").get();
    List<ReportModel>? model = <ReportModel>[];
    Map<String, dynamic> report = jsonDecode(json.encode(snapshot.value));
    report.forEach((key, value) {

      if(username==null){
        model.add(ReportModel(id: key, username: value["username"], report: value["report"], status: value["status"]));
      }else{
        if(value["username"]==username){
          model.add(ReportModel(id: key, username: value["username"], report: value["report"], status: value["status"]));
        }
      }

    });
    model.forEach((element) {
      print(element.status);
    });
    return model;
  }

  Future<bool> deleteReport(String id) async{
    print("deleteReport() executed");
    await databaseReference.child("report/$id").remove();
    return true;
  }

  Future<bool> checkReport(String id, bool status) async{
    print("checkReport() executed");
    await databaseReference.child("report/$id").update({
      "status" : status ? "1" : "0"
    });
    return true;
  }

  Future<UserModel?> login(String username, String password) async{
    print("login() executed");
    var snapshot = await databaseReference.child("users").get();
    UserModel? userModel;
    Map<String, dynamic> map = jsonDecode(json.encode(snapshot.value));
    map.forEach((key, value) {
      if(value["username"] == username && value["password"] == password){
        userModel = UserModel.fromJson(value);
      }
    });
    return userModel;
  }

}