// ignore_for_file: prefer_const_constructors, unnecessary_null_in_if_null_operators, curly_braces_in_flow_control_structures, unnecessary_new, prefer_is_empty, must_be_immutable

import 'package:fe_web/views/common/style.dart';
import 'package:flutter/material.dart';

class TextFieldValidatedForm extends StatefulWidget {
  String type;
  TextEditingController? controller; //Cần truyền controller vào để lấy giá trị ra TextEditingController
  int? minLines = 1;
  int? maxLines = 1;
  int? flexLable;
  int? flexTextField;
  final Widget? widgetBox;
  final Widget? widgetIcon;
  String? hint;
  String? label;
  final double height;
  final Function? callbackValue;
  Function? onChange;
  Function? enter;
  int? requiredValue;
  bool? require;
  bool? enabled;
  int? marginBot;
  TextFieldValidatedForm({Key? key, required this.type, this.controller, this.minLines, this.maxLines, this.hint, this.label, this.flexLable, this.flexTextField, this.widgetBox, this.callbackValue, this.enter, this.requiredValue, this.widgetIcon, required this.height, this.require, this.onChange, this.marginBot, this.enabled}) : super(key: key);

  @override
  State<TextFieldValidatedForm> createState() => _TextFieldValidatedFormState();
}

class _TextFieldValidatedFormState extends State<TextFieldValidatedForm> {
  String? er;
  late double height = widget.height;
  bool isEmail(String string) {
    // Null or empty string is invalid
    if (string.isEmpty) {
      return false;
    }

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }

  bool _isPhoneNumber(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  bool _isPassword(String value) {
    if (value.length < 8) {
      return false;
    } else
      return true;
  }

  bool _isFullName(String value) {
    if (value.length < 3 || value.length > 50) {
      return false;
    } else
      return true;
  }

  bool _isNumeric(String str) {
    bool status = false;
    try {
      int.parse(str);
      status = true;
      return status;
    } catch (e) {
      status = false;
      return status;
    }
  }

  bool _isNumericGreater(String str) {
    bool status = false;
    try {
      int number = int.parse(str);
      if (number >= 0) status = true;
      return status;
    } catch (e) {
      status = false;
      return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.marginBot != null ? null : EdgeInsets.only(bottom: 30),
      height: height,
      child: Row(
        children: [
          widget.label != null
              ? Expanded(
                  flex: widget.flexLable ?? 3,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.label!,
                          style: titleContainerBox,
                        ),
                      ),
                      (widget.requiredValue == 1)
                          ? Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text("*",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  )),
                            )
                          : Text(""),
                    ],
                  ))
              : Container(),
          Expanded(
            flex: widget.flexTextField ?? 5,
            child: TextField(
              obscureText: widget.type == 'Password' ? true : false,
              // minLines: widget.minLines,
              enabled: widget.enabled ?? null,
              controller: widget.controller ?? null,
              decoration: InputDecoration(
                hintText: widget.hint,
                errorText: er,
                contentPadding: const EdgeInsets.fromLTRB(10, 7, 5, 0),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              onSubmitted: (value) {
                // print(value);
                if (widget.enter!() != null) widget.enter!();
              },
              onChanged: (value) {
                if (widget.type == 'fullName') {
                  if (value.isEmpty) {
                    setState(() {
                      er = "Trường này không được bỏ trống";
                      height = 63;
                    });
                  } else {
                    if (_isFullName(value) == false) {
                      setState(() {
                        er = "Họ tên(Từ 3 - 50 ký tự";
                        height = 63;
                      });
                    } else {
                      setState(() {
                        er = null;
                        height = 40;
                      });
                    }
                  }
                } else if (widget.type == 'Text') {
                  if (value.isEmpty) {
                    setState(() {
                      er = "Trường này không được bỏ trống";
                      height = 63;
                    });
                  } else {
                    setState(() {
                      er = null;
                      height = 40;
                    });
                  }
                } else if (widget.type == 'Email') {
                  if (isEmail(widget.controller!.text)) {
                    setState(() {
                      er = null;
                      height = 40;
                    });
                  } else {
                    setState(() {
                      er = "Đây phải là một Email";
                      height = 63;
                    });
                  }
                } else if (widget.type == 'Phone') {
                  if (_isPhoneNumber(widget.controller!.text)) {
                    setState(() {
                      er = null;
                      height = 40;
                    });
                  } else {
                    setState(() {
                      er = "Đây phải là một số điện thoại";
                      height = 63;
                    });
                  }
                } else if (widget.type == 'N') {
                  if (_isNumericGreater(widget.controller!.text)) {
                    setState(() {
                      er = null;
                      height = 40;
                    });
                  } else {
                    setState(() {
                      er = "Số lần phải là số tự nhiên";
                      height = 63;
                    });
                  }
                } else if (widget.type == 'Password') {
                  if (!_isPassword(widget.controller!.text)) {
                    er = "Mật khẩu phải dài hơn 8 ký tự";
                    height = 63;
                  } else {
                    er = null;
                    height = 40;
                  }
                  setState(() {});
                } else if (widget.type == 'Number') {
                  if (!_isNumeric(widget.controller!.text)) {
                    er = "Yêu cầu đây phải là một số";
                    height = 63;
                  } else {
                    er = null;
                    height = 40;
                  }
                  setState(() {});
                } else if (widget.type == 'None') {
                  setState(() {});
                }
                if (widget.require != null) if (widget.require == true) {
                  if (value != '') {
                  } else {
                    er = null;
                    height = 40;
                    setState(() {});
                  }
                }
                if (widget.callbackValue != null) widget.callbackValue!(height);
                if (widget.onChange != null) widget.onChange!(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
