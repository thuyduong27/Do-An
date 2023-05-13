// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:convert';

import 'package:fe_web/confing.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/gvhd.dart';
import '../../../common/date-pick-time.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/text-file.dart';
import '../../../common/title_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../common/toast.dart';

class ThemMoiGVHD extends StatefulWidget {
  Function callbackChange;
  ThemMoiGVHD({Key? key, required this.callbackChange}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<ThemMoiGVHD> {
  Map<int, String> listHocVi = {
    -1: '<<<---Chọn--->>>',
    0: 'Không',
    1: 'Thạc sĩ',
    2: 'Tiến sĩ',
    3: 'Phó gíao sư',
    4: 'Giáo sư',
  };
  int selectedHocVi = -1;
  Map<int, String> listTrangthai = {
    -1: '<<<---Chọn--->>>',
    1: 'Hoạt động',
    0: 'Khoá',
  };
  int selectedTrangThai = -1;

  Map<int, String> listGender = {
    -1: '<<<---Chọn--->>>',
    0: 'Nữ',
    1: 'Nam',
  };
  int selectedGender = -1;

  bool showMenuFind = true;
  TextEditingController ten = TextEditingController();
  TextEditingController donVi = TextEditingController();
  TextEditingController sdt = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  var ngaySinh;
  String avatar = "";

  late GVHD data;

  @override
  void initState() {
    super.initState();
    data = GVHD();
  }

  void dispose() {
    ten.dispose();
    donVi.dispose();
    sdt.dispose();
    email.dispose();
    address.dispose();
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
                  {'url': "/quan-ly-doanh-nghiep", 'title': 'Giáo viên hướng dẫn'},
                ],
                content: 'Thêm mới',
              ),
              Container(
                height: MediaQuery.of(context).size.height - 200,
                padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              SizedBox(
                                child: SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: (avatar == "") ? Image.asset("/images/noavatar.png") : Image.network("$baseUrl/api/files/$avatar"),
                                ),
                              ),
                              SizedBox(height: 10),
                              OutlinedButton(
                                child: Text("Tải ảnh"),
                                onPressed: () async {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['png', 'JPEG', 'JPG', 'TIFF', 'GIF'],
                                    withReadStream: true,
                                    allowMultiple: false,
                                  );
                                  if (result != null) {
                                    var avatarImage = await uploadFile(result, context: context);
                                    setState(() {
                                      avatar = avatarImage;
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
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextFieldValidatedForm(
                                      type: 'Text',
                                      height: 40,
                                      controller: ten,
                                      label: 'Tên:',
                                      flexLable: 2,
                                      requiredValue: 1,
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
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Text('Giới tính:', style: titleContainerBox),
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
                                              )),
                                          Expanded(
                                            flex: 5,
                                            child: Container(
                                              color: Colors.white,
                                              width: MediaQuery.of(context).size.width * 0.20,
                                              height: 40,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2(
                                                  dropdownMaxHeight: 250,
                                                  items: listGender.entries.map((item) => DropdownMenuItem<int>(value: item.key, child: Text(item.value))).toList(),
                                                  value: selectedGender,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedGender = value as int;
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
                                    child: TextFieldValidatedForm(
                                      type: 'Email',
                                      height: 40,
                                      controller: email,
                                      label: 'Email:',
                                      flexLable: 2,
                                      requiredValue: 1,
                                    ),
                                  ),
                                  SizedBox(width: 100),
                                  Expanded(
                                    flex: 3,
                                    child: TextFieldValidatedForm(
                                      type: 'Phone',
                                      height: 40,
                                      controller: sdt,
                                      label: 'SĐT:',
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
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 30),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Text('Học vị:', style: titleContainerBox),
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
                                              )),
                                          Expanded(
                                            flex: 5,
                                            child: Container(
                                              color: Colors.white,
                                              width: MediaQuery.of(context).size.width * 0.20,
                                              height: 40,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2(
                                                  dropdownMaxHeight: 250,
                                                  items: listHocVi.entries.map((item) => DropdownMenuItem<int>(value: item.key, child: Text(item.value))).toList(),
                                                  value: selectedHocVi,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedHocVi = value as int;
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
                                  SizedBox(width: 100),
                                  Expanded(
                                    flex: 3,
                                    child: TextFieldValidatedForm(
                                      type: 'None',
                                      height: 40,
                                      controller: donVi,
                                      label: 'Đơn vị:',
                                      flexLable: 2,
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
                                                  child: Text('Ngày sinh:', style: titleContainerBox),
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
                                            dateDisplay: ngaySinh,
                                            selectedDateFunction: (day) {
                                              ngaySinh = day;
                                              setState(() {});
                                            }),
                                        SizedBox(height: 30)
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 100),
                                  Expanded(
                                    flex: 3,
                                    child: TextFieldValidatedForm(
                                      type: 'None',
                                      height: 40,
                                      controller: address,
                                      label: 'Địa chỉ:',
                                      flexLable: 2,
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
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Text('Trạng thái:', style: titleContainerBox),
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
                                              )),
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
                                        if (ten.text == "" || email.text == "" || sdt.text == "" || selectedTrangThai == -1 || selectedHocVi == -1 || ngaySinh == null || selectedGender == -1) {
                                          showToast(
                                            context: context,
                                            msg: "Cần điền đầy đủ thông tin",
                                            color: Color.fromRGBO(245, 117, 29, 1),
                                            icon: const Icon(Icons.info),
                                          );
                                          Navigator.pop(context);
                                        } else {
                                          data.fullName = ten.text;
                                          data.address = address.text;
                                          data.sdt = sdt.text;
                                          data.email = email.text;
                                          data.donVi = donVi.text;
                                          data.hocVi = selectedHocVi;
                                          data.status = selectedTrangThai;
                                          data.ngaySinh = convertTimeStamp(ngaySinh, "12:00:00");
                                          data.gioiTinh = (selectedGender == 0) ? true : false;
                                          data.role = 1;
                                          if (avatar != "") data.avatar = avatar;
                                          var abc = await httpPost("/api/nguoi-dung/create", data.toJson(), context);
                                          var result = jsonDecode(abc["body"]);
                                          var dataGV = {"idNguoiDung": result['result'], "idKhtt": user.khttNow.id, "status": 1};
                                          httpPost("/api/giao-vien/post", dataGV, context);
                                          showToast(
                                            context: context,
                                            msg: "Thêm mới thành công",
                                            color: mainColor,
                                            icon: const Icon(Icons.done),
                                          );
                                          widget.callbackChange(true);
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
                                        widget.callbackChange(false);
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
