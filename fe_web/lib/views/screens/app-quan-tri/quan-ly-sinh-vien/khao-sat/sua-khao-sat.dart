// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously, deprecated_member_use
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe_web/confing.dart';
import 'package:fe_web/models/khao-sat.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../controllers/api.dart';
import '../../../../../controllers/provider.dart';
import '../../../../common/date-pick-time.dart';
import '../../../../common/footer.dart';
import '../../../../common/header-admin.dart';
import '../../../../common/text-file.dart';
import '../../../../common/title_page.dart';
import '../../../../common/toast.dart';

class SuaKhaoSat extends StatefulWidget {
  KhaoSat data;
  Function callbackChange;
  SuaKhaoSat({Key? key, required this.callbackChange, required this.data}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<SuaKhaoSat> {
  KhaoSat data = KhaoSat();
  var thoiHan;
  bool showMenuFind = true;
  TextEditingController tieuDe = TextEditingController();
  TextEditingController link = TextEditingController();
  Map<int, String> listTrangthai = {
    0: 'Đang khảo sát',
    1: 'Đã khảo sát',
    2: 'Huỷ',
  };
  int selectedTrangThai = -1;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    tieuDe.text = data.tilte ?? "";
    link.text = data.link ?? "";
    selectedTrangThai = data.status ?? 0;
    thoiHan = DateFormat('dd-MM-yyyy').format(DateTime.parse(data.deadline!).toLocal());
  }

  @override
  void dispose() {
    tieuDe.dispose();
    link.dispose();
    super.dispose();
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

    return Header(
        widgetBody: Consumer<SecurityModel>(
      builder: (context, user, child) => Scaffold(
        body: Container(
          decoration: BoxDecoration(color: colorPage),
          child: ListView(
            controller: ScrollController(),
            children: [
              TitlePage(
                listPreTitle: [
                  {'url': "/nhan-su", 'title': 'Trang chủ'},
                  {'url': "/khao-sat", 'title': 'Khảo sát'},
                ],
                content: 'Cập nhật',
              ),
              Container(
                height: MediaQuery.of(context).size.height - 200,
                padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: ListView(
                  controller: ScrollController(),
                  children: [
                    // Nhap thong tin
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: borderRadiusContainer,
                        boxShadow: [boxShadowContainer],
                        border: borderAllContainerBox,
                      ),
                      padding: paddingBoxContainer,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Nhập thông tin',
                                style: textNormal,
                              ),
                              Icon(
                                Icons.more_horiz,
                                color: Color(0xff9aa5ce),
                                size: 14,
                              ),
                            ],
                          ),
                          //Đường line
                          Divider(
                            thickness: 1,
                            color: colorPage,
                          ),
                          Column(
                            children: [
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextFieldValidatedForm(
                                      type: 'Text',
                                      height: 40,
                                      controller: tieuDe,
                                      label: 'Tiêu đề:',
                                      flexLable: 2,
                                      requiredValue: 1,
                                    ),
                                  ),
                                  SizedBox(width: 100),
                                  Expanded(
                                    flex: 3,
                                    child: TextFieldValidatedForm(
                                      type: 'Text',
                                      height: 40,
                                      controller: link,
                                      label: 'Link:',
                                      flexLable: 2,
                                      requiredValue: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        DatePickerBox1(
                                            isTime: false,
                                            label: Row(
                                              children: [
                                                Flexible(
                                                  child: Text('Thời hạn:', style: titleContainerBox),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(left: 5),
                                                  child: Text("*",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 16,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            dateDisplay: thoiHan,
                                            selectedDateFunction: (day) {
                                              thoiHan = day;
                                              setState(() {});
                                            }),
                                        SizedBox(height: 30)
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 100),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 30),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text('Trạng thái:', style: titleContainerBox),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Container(
                                              color: Colors.white,
                                              width: MediaQuery.of(context).size.width * 0.20,
                                              height: 40,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2(
                                                  dropdownMaxHeight: 250,
                                                  items: listTrangthai.entries.map((item) => DropdownMenuItem<int>(value: item.key, child: Text(item.value))).toList(),
                                                  value: selectedTrangThai,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedTrangThai = value as int;
                                                    });
                                                  },
                                                  buttonHeight: 40,
                                                  itemHeight: 40,
                                                  dropdownDecoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(216, 218, 229, 1))),
                                                  buttonDecoration: BoxDecoration(border: Border.all(width: 0.5, style: BorderStyle.solid)),
                                                  buttonElevation: 0,
                                                  buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                                                  itemPadding: const EdgeInsets.only(left: 14, right: 14),
                                                  dropdownElevation: 5,
                                                  focusColor: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 30),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text('File kết quả:', style: titleContainerBox),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: TextButton(
                                              child: Text('${(data.file != null) ? data.file : "Tải"}'),
                                              onPressed: () async {
                                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: [],
                                              withReadStream: true,
                                              allowMultiple: false,
                                            );
                                            if (result != null) {
                                              var fileHopDong = await uploadFile(result, context: context);
                                              setState(() {
                                                data.file = fileHopDong;
                                              });
                                            } else {
                                              return showToast(
                                                context: context,
                                                msg: "Chọn lại file",
                                                color: Color.fromRGBO(245, 117, 29, 1),
                                                icon: const Icon(Icons.info),
                                              );
                                            }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 100),
                                  Expanded(
                                    flex: 3,
                                    child: Container(),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //tìm kiếm
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Theme.of(context).iconTheme.color,
                                        textStyle: Theme.of(context).textTheme.caption?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20.0,
                                          horizontal: 40.0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        backgroundColor: mainColor,
                                      ),
                                      onPressed: () async {
                                        processing();
                                        if (tieuDe.text == "" || link.text == "" || thoiHan == null) {
                                          showToast(
                                            context: context,
                                            msg: "Cần điền đầy đủ thông tin",
                                            color: Color.fromRGBO(245, 117, 29, 1),
                                            icon: const Icon(Icons.info),
                                          );
                                          Navigator.pop(context);
                                        } else {
                                          data.idKhtt = user.khttNow.id;
                                          data.tilte = tieuDe.text;
                                          data.link = link.text;
                                          data.deadline = convertTimeStamp(thoiHan, "12:00:00");
                                          data.status = selectedTrangThai;
                                          var abc = await httpPut("/api/khao-sat/put/${data.id}", data.toJson(), context);
                                          print(abc);
                                          showToast(
                                            context: context,
                                            msg: "Cập nhật thành công",
                                            color: mainColor,
                                            icon: const Icon(Icons.done),
                                          );
                                          widget.callbackChange(data);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Text('Lưu', style: textBtnWhite),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Theme.of(context).iconTheme.color,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20.0,
                                          horizontal: 40.0,
                                        ),
                                        backgroundColor: orange,
                                        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                      ),
                                      onPressed: () {
                                        widget.callbackChange(widget.data);
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        children: [
                                          Text('Huỷ', style: textBtnWhite),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Footer()
            ],
          ),
        ),
      ),
    ));
  }
}
