// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:fe_web/controllers/api.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import '../../../controllers/provider.dart';
import '../../common/toast.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LocalStorage storage = LocalStorage("storage");
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // hien pass
  bool isHiddenPassword = true;
  void _passwordView() {
    if (isHiddenPassword == true) {
      isHiddenPassword = false;
    } else {
      isHiddenPassword = true;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool checkSubmitButton() {
    if (_usernameController.text.isNotEmpty && _usernameController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> processing() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Center(child: const CircularProgressIndicator());
        },
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
        child: Row(
          children: [
            Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("/images/2.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'HỆ THỐNG QUẢN LÝ THỰC TẬP TỐT NGHIỆP',
                            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 30.0),
                          ),
                        ),
                        // Công Ty Cổ Phần Phát Triển Cung Ứng Nhân Lực Quốc Tế Aam
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.only(top: 30),
                            child: Text(
                              'KHOA CÔNG NGHỆ THÔNG TIN',
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 50.0),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'ĐẠI HỌC CÔNG NGHIỆP HÀ NỘI',
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w900, fontSize: 50.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(color: Color.fromARGB(255, 238, 238, 238)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 60),
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              margin: EdgeInsets.only(bottom: 30),
                              child: Image.asset("/images/logo.png"),
                            ),
                            SizedBox(
                                width: 400,
                                child: Text(
                                  'HỆ THỐNG QUẢN LÝ THỰC TẬP TỐT NGHIỆP',
                                  style: TextStyle(
                                    fontSize: 15,
                                    letterSpacing: -0.8,
                                    fontWeight: FontWeight.w800,
                                    color: Color.fromARGB(255, 6, 6, 6),
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                            Form(
                              child: AutofillGroup(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                        child: SizedBox(
                                          width: 400,
                                          height: 50,
                                          child: TextFormField(
                                            textInputAction: TextInputAction.next,
                                            autofillHints: const [AutofillHints.email],
                                            controller: _usernameController,
                                            onChanged: (value) {},
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
                                              border: OutlineInputBorder(),
                                              labelText: 'Tài khoản',
                                              hintText: 'Nhập tên đăng nhập',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                        child: SizedBox(
                                          width: 400,
                                          height: 50,
                                          child: TextFormField(
                                            autofillHints: const [AutofillHints.password],
                                            controller: _passwordController,
                                            obscureText: isHiddenPassword,
                                            onFieldSubmitted: (value) {},
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(color: Colors.grey),
                                              border: OutlineInputBorder(),
                                              labelText: 'Mật khẩu',
                                              hintText: 'Nhập mật khẩu',
                                              suffixIcon: InkWell(
                                                onTap: _passwordView,
                                                child: isHiddenPassword ? Icon(Icons.visibility_off_outlined) : Icon(Icons.visibility),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: ElevatedButton(
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: const Text('Đăng nhập'),
                                              ),
                                              onPressed: () async {
                                                processing();
                                                if (_usernameController.text == "" || _passwordController.text == "") {
                                                  showToast(
                                                    context: context,
                                                    msg: "Cần điền đầy đủ thông tin",
                                                    color: Color.fromRGBO(245, 117, 29, 1),
                                                    icon: const Icon(Icons.warning),
                                                  );
                                                  Navigator.pop(context);
                                                } else {
                                                  var loginData = {"username": _usernameController.text, "password": _passwordController.text};
                                                  var responseLogin = await httpPost("/api/nguoi-dung/login", loginData, context);
                                                  var body = jsonDecode(responseLogin['body']);
                                                  if (body['success'] == false) {
                                                    showToast(
                                                      context: context,
                                                      msg: "${body['result']}",
                                                      color: Color.fromRGBO(245, 117, 29, 1),
                                                      icon: const Icon(Icons.warning),
                                                    );
                                                    Navigator.pop(context);
                                                  } else {
                                                    if (body["result"]['status'] == 1) {
                                                      storage.setItem('id', body["result"]['id'].toString());
                                                      storage.setItem('role', body["result"]['role'].toString());
                                                      var securityModel = Provider.of<SecurityModel>(context, listen: false);
                                                      if (body["result"]['role'] == 0) {
                                                        Navigator.pushNamed(context, '/trang-chu');
                                                        securityModel.changeSttMenu(1);
                                                      } else if (body["result"]['role'] == 1) {
                                                        Navigator.pushNamed(context, '/trang-chu-gv');
                                                        securityModel.changeSttMenu(20);
                                                      } else {
                                                        Navigator.pushNamed(context, '/ke-hoach-thuc-tap-sv');
                                                        securityModel.changeSttMenu(10);
                                                      }
                                                    } else {
                                                      showToast(
                                                        context: context,
                                                        msg: "Tài khoản không hoạt động",
                                                        color: Colors.orange,
                                                        icon: const Icon(Icons.warning),
                                                      );
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
