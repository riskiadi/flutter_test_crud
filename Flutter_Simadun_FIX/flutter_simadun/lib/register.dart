import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_simadun/login.dart';
import 'package:flutter_simadun/repository.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                "Pendaftaran Akun Pengguna",
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
                    child: Text("Daftar"),
                    onPressed: () {
                      if (_verify()) {
                        repository.createUser(_usernameController.text, _passwordController.text).then((value){
                          GFToast.showToast(
                            "Pendaftaran Berhasil",
                            context,
                            toastPosition: GFToastPosition.TOP,
                          );
                        });
                      } else {
                        GFToast.showToast(
                          "Username dan Kata sandi masih kosong",
                          context,
                          toastPosition: GFToastPosition.BOTTOM,
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offAll(LoginPage());
                    },
                    child: Text("Kembali Login"),
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
}
