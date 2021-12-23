import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_simadun/login.dart';
import 'package:flutter_simadun/model/report_model.dart';
import 'package:flutter_simadun/repository.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helper.dart';

class HomePage extends StatefulWidget {

  final String username;
  const HomePage({Key? key, required this.username}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String? editedId;
  var repository = Repository();
  TextEditingController _reportController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    _reportController.addListener(() {
      if(_reportController.text.isEmpty){
        setState(() {
          editedId=null;
        });
      }
    });

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 0.05.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Selamat Datang, ",
                          style: TextStyle(fontSize: 17.sp),
                        ),
                        Text(
                          widget.username,
                          style:
                          TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        _setSharedPref("username","role");
                        Get.off(const LoginPage());
                      },
                      child: Text(
                        "Keluar",
                        style: TextStyle(
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.h,
                ),
                TextField(
                  controller: _reportController,
                  decoration:
                      InputDecoration(hintText: "Silahkan masukan keluhan anda"),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GFButton(
                    child: Text(editedId==null?"Kirim" : "Edit"),
                    onPressed: () {
                      if(editedId==null){
                        repository.createReport(widget.username, _reportController.text);
                        _reportController.text = "";
                      }else{
                        repository.editReport(editedId.toString(), _reportController.text);
                        editedId = null;
                        _reportController.text = "";
                      }
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(height: 20,),
                Text("Daftar aduan kamu", style: TextStyle(fontSize: 17.sp),),
                SizedBox(height: 10,),
                FutureBuilder(
                  future: repository.getReport(username: widget.username),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<ReportModel> data = snapshot.data as List<ReportModel>;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: GestureDetector(
                              onTap: () {
                                editedId = data[index].id;
                                _reportController.text = data[index].report.toString();
                                setState(() {});
                              },
                              child: ListTile(
                                isThreeLine: true,
                                tileColor: Colors.black.withOpacity(0.07),
                                title: Text("Pelapor: ${data[index].username.toString()}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data[index].report.toString()),
                                    Text("Status: ${_statusConverter(data[index].status.toString())}", style: TextStyle(fontWeight: FontWeight.w800, color: data[index].status == "0" ? Colors.orange : Colors.green),),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    repository.deleteReport(data[index].id.toString()).then((value){
                                      GFToast.showToast("Hapus Berhasil", context, toastPosition: GFToastPosition.TOP);
                                      setState(() {});
                                    });
                                  },
                                )
                              ),
                            ),
                          );
                          return Text(data[index].report.toString());
                        },
                      );
                    } else {
                      if(snapshot.data == null){
                        return Text("Data Laporan Kosong");
                      }else{
                        return CircularProgressIndicator();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _statusConverter(String status){
    switch(status){
      case "0":
        return "Proses";
      default:
        return "Selesai";
    }
  }

  _setSharedPref(String username, String role) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(username);
    prefs.remove(role);
  }

}
