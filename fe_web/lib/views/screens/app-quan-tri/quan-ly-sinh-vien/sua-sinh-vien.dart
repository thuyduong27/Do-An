// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:convert';
import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe_web/confing.dart';
import 'package:fe_web/models/sinh-vien.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/company.dart';
import '../../../../models/gvhd.dart';
import '../../../common/date-pick-time.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/text-file.dart';
import '../../../common/title_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../common/toast.dart';

class SuaSinhVien extends StatefulWidget {
  SinhVien data;
  int idKhtt;
  Function callbackChange;
  SuaSinhVien({Key? key, required this.data, required this.idKhtt, required this.callbackChange}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<SuaSinhVien> {
  SinhVien data = SinhVien();
  int selectedNganh = -1;
  Map<int, String> listNganh = {
    -1: '--Chọn---',
    0: 'Công nghệ thông tin',
    1: 'Kỹ thuật phần mềm',
    2: 'Hệ thống thông tin',
    3: 'Khoa học máy tính',
    4: 'Công nghệ đa phương tiện',
  };
  Map<int, String> listTrangthai = {
    -1: '--Chọn---',
    0: 'Chưa đăng ký đề tài',
    1: 'Đã đăng ký đề tài, chờ xác nhận',
    2: 'Xác nhận đề tài',
    3: 'Đang thực tập',
    4: 'Đã thực tập xong',
    5: 'Đã nộp báo cáo',
    6: 'Đã chấm điểm',
    7: 'Đạt',
    8: 'Không đạt',
  };
  int selectedTrangThai = -1;

  Map<int, String> listGender = {
    -1: 'Tất cả',
    0: 'Nữ',
    1: 'Nam',
  };
  int selectedGender = -1;

  bool showMenuFind = true;
  TextEditingController ten = TextEditingController();
  TextEditingController masv = TextEditingController();
  TextEditingController lop = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController sdt = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController khoa = TextEditingController();
  TextEditingController deTai = TextEditingController();

  var ngaySinh;
  String avatar = "";

  GVHD selectedGVHD = GVHD(id: null, fullName: "Không");
  Future<List<GVHD>> getGVHD() async {
    List<GVHD> resultGVHD = [];
    var response1 = await httpGet("/api/giao-vien/get/page?filter=status:1 and idKhtt:${widget.idKhtt}", context);
    resultGVHD = [];
    if (response1.containsKey("body")) {
      setState(() {
        var body = jsonDecode(response1['body']);
        var content = [];
        content = body['result']['content'];
        resultGVHD = content.map((e) {
          return GVHD.fromJson(e['nguoiDung']);
        }).toList();
        if (content.isNotEmpty) {
          for (var i = 0; i < content.length; i++) {
            resultGVHD[i].id = content[i]['id'];
          }
        }
      });
      GVHD all = GVHD(id: null, fullName: "Không");
      setState(() {
        resultGVHD.insert(0, all);
      });
    }
    return resultGVHD;
  }

  Company selectedCSTT = Company(id: null, name: "Không");
  Future<List<Company>> getCSTT() async {
    List<Company> resultCSTT = [];
    var response1 = await httpGet("/api/doanh-nghiep/get/page?filter=status:1&sort=type", context);
    resultCSTT = [];
    if (response1.containsKey("body")) {
      setState(() {
        var body = jsonDecode(response1['body']);
        var content = [];
        content = body['result']['content'];
        resultCSTT = content.map((e) {
          return Company.fromJson(e);
        }).toList();
      });
      Company all = Company(id: null, name: "Không");
      setState(() {
        resultCSTT.insert(0, all);
      });
    }
    return resultCSTT;
  }

  @override
  void initState() {
    super.initState();
    data = widget.data;
    ten.text = data.nguoiDung!.fullName ?? "";
    masv.text = data.nguoiDung!.maSv ?? "";
    email.text = data.nguoiDung!.email ?? "";
    sdt.text = data.nguoiDung!.sdt ?? "";
    khoa.text = data.nguoiDung!.khoa ?? "";
    lop.text = data.nguoiDung!.lop ?? "";
    deTai.text = data.deTai ?? "";
    selectedTrangThai = data.status!;
    selectedNganh = data.nguoiDung!.nganh!;
    if (data.idDoanhNghiep != null) {
      selectedCSTT = data.doanhNghiep!;
    }
    if (data.idGvhd != null) {
      selectedGVHD = data.giaoVien!;
      selectedGVHD.id = data.idGvhd;
    }
    if (data.nguoiDung!.ngaySinh != null && data.nguoiDung!.ngaySinh != "") ngaySinh = DateFormat('dd-MM-yyyy').format(DateTime.parse(data.nguoiDung!.ngaySinh!));
  }

  @override
  void dispose() {
    ten.dispose();
    masv.dispose();
    sdt.dispose();
    email.dispose();
    address.dispose();
    lop.dispose();
    khoa.dispose();
    deTai.dispose();
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
                  {'url': "/quan-ly-sinh-vien", 'title': 'Quản lý sinh viên thực tập'},
                ],
                content: 'Cập nhật',
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
                                    child: TextFieldValidatedForm(
                                      type: 'Text',
                                      height: 40,
                                      controller: masv,
                                      label: 'Mã sv:',
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
                                      controller: khoa,
                                      label: 'Khoá:',
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
                                    child: TextFieldValidatedForm(
                                      type: 'None',
                                      height: 40,
                                      controller: lop,
                                      label: 'Lớp:',
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
                                                    child: Text('Ngành: ', style: titleContainerBox),
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
                                                  items: listNganh.entries.map((item) => DropdownMenuItem<int>(value: item.key, child: Text(item.value))).toList(),
                                                  value: selectedNganh,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedNganh = value as int;
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
                              (selectedTrangThai > 1)
                                  ? Row(
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
                                                    child: Text('Giảng viên HD:', style: titleContainerBox),
                                                  ),
                                                  Expanded(
                                                    flex: 5,
                                                    child: Container(
                                                      color: Colors.white,
                                                      height: 40,
                                                      child: DropdownSearch<GVHD>(
                                                        popupProps: PopupPropsMultiSelection.menu(
                                                          showSearchBox: true,
                                                        ),
                                                        dropdownDecoratorProps: DropDownDecoratorProps(
                                                          dropdownSearchDecoration: InputDecoration(
                                                            constraints: const BoxConstraints.tightFor(
                                                              width: 300,
                                                              height: 40,
                                                            ),
                                                            contentPadding: const EdgeInsets.only(left: 14, bottom: 10),
                                                            focusedBorder: const OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(0),
                                                              ),
                                                              borderSide: BorderSide(color: Colors.black, width: 0.5),
                                                            ),
                                                            hintText: "--Chọn giảng viên--",
                                                            hintMaxLines: 1,
                                                            enabledBorder: const OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(0),
                                                              ),
                                                              borderSide: BorderSide(color: Colors.black, width: 0.5),
                                                            ),
                                                          ),
                                                        ),
                                                        asyncItems: (String? filter) => getGVHD(),
                                                        itemAsString: (GVHD u) => "${(u.hocVi == 1) ? "Ths" : (u.hocVi == 2) ? "Tiến sĩ" : ""} ${u.fullName ?? ""}",
                                                        selectedItem: selectedGVHD,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedGVHD = value!;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
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
                                                    child: Text('Cơ sở thực tập:', style: titleContainerBox),
                                                  ),
                                                  Expanded(
                                                    flex: 5,
                                                    child: Container(
                                                      color: Colors.white,
                                                      height: 40,
                                                      child: DropdownSearch<Company>(
                                                        popupProps: PopupPropsMultiSelection.menu(
                                                          showSearchBox: true,
                                                        ),
                                                        dropdownDecoratorProps: DropDownDecoratorProps(
                                                          dropdownSearchDecoration: InputDecoration(
                                                            constraints: const BoxConstraints.tightFor(
                                                              width: 300,
                                                              height: 40,
                                                            ),
                                                            contentPadding: const EdgeInsets.only(left: 14, bottom: 10),
                                                            focusedBorder: const OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(0),
                                                              ),
                                                              borderSide: BorderSide(color: Colors.black, width: 0.5),
                                                            ),
                                                            hintText: "--Chọn--",
                                                            hintMaxLines: 1,
                                                            enabledBorder: const OutlineInputBorder(
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(0),
                                                              ),
                                                              borderSide: BorderSide(color: Colors.black, width: 0.5),
                                                            ),
                                                          ),
                                                        ),
                                                        asyncItems: (String? filter) => getCSTT(),
                                                        itemAsString: (Company u) => "${u.name}",
                                                        selectedItem: selectedCSTT,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedCSTT = value!;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    )
                                  : Row(),
                              (selectedTrangThai > 1)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: TextFieldValidatedForm(
                                            type: 'None',
                                            height: 40,
                                            controller: deTai,
                                            label: 'Đề tài:',
                                            flexLable: 2,
                                          ),
                                        ),
                                        SizedBox(width: 100),
                                        Expanded(
                                          flex: 3,
                                          child: Container(),
                                        ),
                                      ],
                                    )
                                  : Row(),
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
                                        if (ten.text == "" || email.text == "" || sdt.text == "" || selectedTrangThai == -1 || selectedNganh == -1 || ngaySinh == null || lop.text == "" || khoa.text == "" || masv.text == "") {
                                          showToast(
                                            context: context,
                                            msg: "Cần điền đầy đủ thông tin",
                                            color: Color.fromRGBO(245, 117, 29, 1),
                                            icon: const Icon(Icons.info),
                                          );
                                          Navigator.pop(context);
                                        } else {
                                          data.nguoiDung = GVHD();
                                          data.nguoiDung!.role = 2;
                                          data.nguoiDung!.status = 1;
                                          data.nguoiDung!.fullName = ten.text;
                                          data.nguoiDung!.maSv = masv.text;
                                          data.nguoiDung!.email = email.text;
                                          data.nguoiDung!.sdt = sdt.text;
                                          data.nguoiDung!.khoa = khoa.text;
                                          data.nguoiDung!.lop = lop.text;
                                          data.deTai = deTai.text;
                                          data.nguoiDung!.nganh = selectedNganh;
                                          data.nguoiDung!.ngaySinh = convertTimeStamp(ngaySinh, "12:00:00");
                                          data.idKhtt = widget.idKhtt;
                                          data.idGvhd = selectedGVHD.id;
                                          data.idDoanhNghiep = selectedCSTT.id;
                                          data.status = selectedTrangThai;
                                          // print(data.nguoiDung!.toJson());
                                          // var abc = await httpPut("/api/nguoi-dung/put/${data.nguoiDung!.id}", data.nguoiDung!.toJson(), context);
                                          // var abcRf = jsonDecode(abc["body"]);
                                          // var idNguoidung = abcRf['result'];
                                          // data.idNguoiDung = int.tryParse(idNguoidung.toString());
                                          print(data.toJson());
                                          var abc = await httpPut("/api/sinh-vien-thuc-tap/put/${data.id}", data.toJson(), context);
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
