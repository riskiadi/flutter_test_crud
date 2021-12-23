import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_simadun/login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helper.dart';
import 'home.dart';
import 'home_admin.dart';

class InitiatorPage extends StatefulWidget {
  const InitiatorPage({Key? key}) : super(key: key);

  @override
  _InitiatorPageState createState() => _InitiatorPageState();
}

class _InitiatorPageState extends State<InitiatorPage> {

  @override
  void initState() {
    super.initState();
    _getSharedPref().then((value){
      print(value.getString("username"));
      if(value.getString("username")!=null){
        if(value.getString("role")=="admin"){
          Get.off(HomeAdminPage(username: value.getString("username").toString(),));
        }else{
          Get.off(HomePage(username: value.getString("username").toString(),));
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 30,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "SISTEM ADUAN\nRUMAH SAKIT TUGUREJO",
                  style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(height: 15,),
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/logo.svg',
                  height: 250,
                ),
              ),
              SizedBox(height: 35,),
              GFButton(
                child: Text("Masuk"),
                color: Colors.orange,
                onPressed: (){
                  Get.off(() => const LoginPage());
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<SharedPreferences> _getSharedPref() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

}
