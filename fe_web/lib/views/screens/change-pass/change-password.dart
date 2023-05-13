// ignore_for_file: prefer_const_constructors, sort_child_properties_last, deprecated_member_use, use_full_hex_values_for_flutter_colors, use_build_context_synchronously, annotate_overrides, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../../../controllers/api.dart';
import '../../common/style.dart';
import '../../common/toast.dart';
class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);
  @override
  State<ChangePassword> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<ChangePassword> {
  TextEditingController password = TextEditingController();
  TextEditingController passwordCheck = TextEditingController();
  late bool _passwordVisible;
  LocalStorage storage = LocalStorage("storage");
  var id;
  void initState() {
    super.initState();
    id = storage.getItem("id");
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> processing() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    return AlertDialog(
      content: SizedBox(
        width: 460,
        height: 230,
        child: ListView(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Đổi mật khẩu', style: textTitleAlertDialog),
              IconButton(onPressed: () => {Navigator.pop(context)}, icon: Icon(Icons.close)),
            ]),
            const Divider(thickness: 1, color: Colors.black),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Mật khẩu mới ',
                        style: textDropdownTitle,
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 300,
                          height: 40,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  autofillHints: const [AutofillHints.password],
                                  obscureText: _passwordVisible,
                                  controller: password,
                                  minLines: 1,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    // labelText: widget.lableText,
                                    border: const OutlineInputBorder(borderSide: BorderSide(width: 0.2, color: Colors.black45)),
                                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0.2, color: Colors.black45)),
                                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                        color: Theme.of(context).primaryColorDark,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Xác nhận ',
                        style: textDropdownTitle,
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 300,
                          height: 40,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  autofillHints: const [AutofillHints.password],
                                  obscureText: _passwordVisible,
                                  controller: passwordCheck,
                                  minLines: 1,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    // labelText: widget.lableText,
                                    border: const OutlineInputBorder(borderSide: BorderSide(width: 0.2, color: Colors.black45)),
                                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0.2, color: Colors.black45)),
                                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                        color: Theme.of(context).primaryColorDark,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 1, color: Colors.black),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    processing();
                    if (password.text == "" || passwordCheck.text == "") {
                      Future.delayed(const Duration(seconds: 1), () {
                        showToast(
                          context: context,
                          msg: "Cần nhập đủ thông tin",
                          color: Colors.orange,
                          icon: const Icon(Icons.warning),
                        );
                        Navigator.pop(context);
                      });
                    } else {
                      if (password.text != passwordCheck.text) {
                        Future.delayed(const Duration(seconds: 1), () {
                          showToast(
                            context: context,
                            msg: "Mật khẩu không khớp",
                            color: Colors.orange,
                            icon: const Icon(Icons.warning),
                          );
                          Navigator.pop(context);
                        });
                      } else {
                        var userLogin = {"userName": "", "password": password.text};
                        var abc = await httpPost("/api/nguoi-dung/change-pass/$id", userLogin, context);
                        print(abc);
                        Future.delayed(const Duration(seconds: 1), () {
                          showToast(
                            context: context,
                            msg: "Thay đổi mật khẩu thành công",
                            color: Color.fromARGB(136, 72, 238, 67),
                            icon: const Icon(Icons.done),
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      }
                    }
                  },
                  child: Text(
                    'Xác nhận',
                    style: textBtnWhite,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff6C92D0),
                    onPrimary: Colors.white,
                    elevation: 3,
                    minimumSize: Size(100, 40),
                  ),
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Hủy', style: textBtnWhite),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 255, 132, 124),
                    onPrimary: Colors.white,
                    elevation: 3,
                    minimumSize: Size(100, 40),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
