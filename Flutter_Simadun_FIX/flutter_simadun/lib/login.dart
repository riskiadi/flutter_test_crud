import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_simadun/home.dart';
import 'package:flutter_simadun/home_admin.dart';
import 'package:flutter_simadun/register.dart';
import 'package:flutter_simadun/repository.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var repository = Repository();

    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.symmetric(horizontal: 0.10.sw, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Login Pengguna",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(hintText: "Masukan Username"),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Masukan kata sandi",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  GFButton(
                    child: Text("Masuk"),
                    onPressed: () {
                      if (_verify()) {
                        repository.login(_usernameController.text, _passwordController.text).then((value){
                          if(value!=null){
                            GFToast.showToast(
                              "Login Berhasil",
                              context,
                              toastPosition: GFToastPosition.TOP,
                            );
                            _setSharedPref(_usernameController.text, value.role.toString());
                            if(value.role=="admin"){
                              Get.off(HomeAdminPage(username: _usernameController.text,));
                            }else{
                              Get.off(HomePage(username: _usernameController.text,));
                            }
                          }else{
                            GFToast.showToast(
                              "Login Gagal",
                              context,
                              toastPosition: GFToastPosition.TOP,
                            );
                          }

                        });
                      } else {
                        GFToast.showToast(
                          "Username dan Kata sandi masih kosong",
                          context,
                          toastPosition: GFToastPosition.TOP,
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(RegisterPage());
                    },
                    child: Text("Daftar Akun"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _verify() {
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  _setSharedPref(String username, String role) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", username);
    prefs.setString("role", role);
  }

}
