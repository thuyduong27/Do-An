// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, unused_local_variable, curly_braces_in_flow_control_structures, sort_child_properties_last, use_build_context_synchronously

import 'dart:convert';
import 'dart:html';

import 'package:fe_web/views/common/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/gvhd.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/phan-trang.dart';
import '../../../common/text-file.dart';
import '../../../common/title_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Border;
import '../../../common/toast.dart';
import 'sua-gvhd.dart';
import 'them-gvhd.dart';
import 'xem-gvhd/xem-gvhd.dart';

class QuanLyGVHDScreen extends StatefulWidget {
  QuanLyGVHDScreen({Key? key}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<QuanLyGVHDScreen> {
  var page = 1;
  var rowPerPage = 10;
  var totalElements = 0;
  var firstRow = 1, lastRow = 0;
  var rowCount = 0;
  var currentPage = 1;
  var tableIndex = 1;
  List<GVHD> listData = [];
  late Future<List<GVHD>> getListData;
  String findGVHD = "";

  Future<List<GVHD>> getData(int page, String findGVHD) async {
    if (page * rowPerPage > totalElements) {
      page = (1.0 * totalElements / rowPerPage - 1).ceil();
    }
    if (page < 1) {
      page = 0;
    }
    var response5;
    if (findGVHD == "") {
      response5 = await httpGet("/api/nguoi-dung/get/page?size=$rowPerPage&page=$page&filter=role:1&sort=status,desc&sort=id,desc", context);
    } else {
      response5 = await httpGet("/api/nguoi-dung/get/page?size=$rowPerPage&page=$page&filter=role:1 and $findGVHD&sort=status,desc&sort=id,desc", context);
    }
    var content = [];
    if (response5.containsKey("body")) {
      setState(() {
        var resultLPV = jsonDecode(response5["body"]);
        listData = [];
        currentPage = page + 1;
        content = resultLPV['result']['content'];
        listData = content.map((e) {
          return GVHD.fromJson(e);
        }).toList();
        rowCount = resultLPV['result']["totalElements"];
        totalElements = resultLPV['result']["totalElements"];
        lastRow = totalElements;
        rowCount = resultLPV['result']['totalElements'];
        if (content.isNotEmpty) {
          firstRow = (currentPage) * rowPerPage + 1;
          lastRow = (currentPage + 1) * rowPerPage;
          if (lastRow > totalElements) {
            lastRow = totalElements;
          }
          tableIndex = (currentPage - 1) * rowPerPage + 1;
        }
      });
      return listData;
    } else {
      throw Exception('Không có data');
    }
  }

  Map<int, String> listHocVi = {
    -1: 'Tất cả',
    0: 'Không',
    1: 'Thạc sĩ',
    2: 'Tiến sĩ',
    3: 'Phó gíao sư',
    4: 'Giáo sư',
  };
  int selectedHocVi = -1;
  Map<int, String> listTrangthai = {
    -1: 'Tất cả',
    1: 'Hoạt động',
    0: 'Khoá',
  };
  int selectedTrangThai = -1;

  Map<int, String> listGender = {
    -1: 'Tất cả',
    0: 'Nữ',
    1: 'Nam',
  };
  int selectedGender = -1;

  //tìm kiếm
  bool showMenuFind = true;
  TextEditingController ten = TextEditingController();
  TextEditingController donVi = TextEditingController();
  TextEditingController sdt = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();

  Future<void> createExcel(List<GVHD> listData) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    int stt = listData.length;
    sheet.getRangeByIndex(1, 1, 1 + stt, 9).cellStyle.fontSize = 12;
    sheet.getRangeByIndex(1, 1, 2 + stt, 9).cellStyle.fontName = "Times New Roman";
    sheet.getRangeByIndex(1, 1, 2 + stt, 9).cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByIndex(1, 1, 2 + stt, 9).cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByIndex(2, 1, 2 + stt, 9).cellStyle.borders.all.lineStyle = LineStyle.thin;
    sheet.getRangeByIndex(2, 1, 2, 9).cellStyle.backColor = '#008c87';
    sheet.getRangeByIndex(2, 1, 2, 9).cellStyle.fontSize = 13;
    sheet.getRangeByIndex(2, 1, 2, 9).cellStyle.bold = true;
    sheet.getRangeByIndex(2, 1).rowHeight = 40;
    sheet.getRangeByIndex(3, 1, 2 + stt, 1).rowHeight = 25;
    sheet.getRangeByIndex(1, 1, 1, 9).merge();
    sheet.getRangeByIndex(1, 1).rowHeight = 45;
    sheet.getRangeByIndex(1, 1).setText("Danh sách giáo viên");
    sheet.getRangeByIndex(1, 1).cellStyle.fontSize = 25;
    sheet.getRangeByIndex(1, 1).cellStyle.bold = true;
    sheet.getRangeByName('A1').columnWidth = 6.4;
    sheet.getRangeByName('B1').columnWidth = 35;
    sheet.getRangeByName('C1').columnWidth = 11;
    sheet.getRangeByName('D1').columnWidth = 14;
    sheet.getRangeByName('E1').columnWidth = 30;
    sheet.getRangeByName('F1').columnWidth = 20;
    sheet.getRangeByName('G1').columnWidth = 15;
    sheet.getRangeByName('H1').columnWidth = 20;
    sheet.getRangeByName('I1').columnWidth = 80;
    sheet.getRangeByName('A2').setText("STT");
    sheet.getRangeByName('B2').setText("Họ tên");
    sheet.getRangeByName('C2').setText("Giới tính");
    sheet.getRangeByName('D2').setText("Ngày sinh");
    sheet.getRangeByName('E2').setText("Email");
    sheet.getRangeByName('F2').setText("Số điện thoại");
    sheet.getRangeByName('G2').setText("Học vị");
    sheet.getRangeByName('H2').setText("Đơn vị");
    sheet.getRangeByName('I2').setText("Địa chỉ");
    sheet.autoFilters.filterRange = sheet.getRangeByName('A2:I${1 + stt}');
    for (var i = 0; i < listData.length; i++) {
      sheet.getRangeByName('A${i + 3}').setNumber(i + 1);
      sheet.getRangeByName('B${i + 3}').setText(listData[i].fullName);
      sheet.getRangeByName('C${i + 3}').setText(listData[i].gioiTinh == true ? "Nữ" : "Nam");
      sheet.getRangeByName('D${i + 3}').setText(DateFormat('dd/MM/yyyy').format(DateTime.parse(listData[i].ngaySinh!).toLocal()));
      sheet.getRangeByName('E${i + 3}').setText(listData[i].email);
      sheet.getRangeByName('F${i + 3}').setText(listData[i].sdt);
      sheet.getRangeByName('G${i + 3}').setText(listData[i].hocVi == 1
          ? "Thạc sĩ"
          : listData[i].hocVi == 2
              ? "Tiến sĩ"
              : "");
      sheet.getRangeByName('H${i + 3}').setText(listData[i].donVi);
      sheet.getRangeByName('I${i + 3}').setText(listData[i].address);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    if (kIsWeb) {
      AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'Danh_sach_giao_vien.xlsx')
        ..click();
    }
  }

  @override
  void initState() {
    super.initState();
    getListData = getData(0, findGVHD);
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
                  {'url': "/trang-chu", 'title': 'Trang chủ'},
                ],
                content: 'Giáo viên hướng dẫn',
              ),
              Container(
                // margin: EdgeInsets.only(top: 25),
                // padding: EdgeInsets.symmetric(vertical: verticalPaddingPage, horizontal: horizontalPaddingPage),
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
                      padding: EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 5),
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
                          (!showMenuFind)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showMenuFind = !showMenuFind;
                                          });
                                        },
                                        icon: Icon(Icons.expand_more, size: 28)),
                                  ],
                                )
                              : Column(
                                  children: [
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: TextFieldValidatedForm(
                                            type: 'None',
                                            height: 40,
                                            controller: ten,
                                            label: 'Tên:',
                                            flexLable: 2,
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
                                          child: TextFieldValidatedForm(
                                            type: 'None',
                                            height: 40,
                                            controller: email,
                                            label: 'Email:',
                                            flexLable: 2,
                                          ),
                                        ),
                                        SizedBox(width: 100),
                                        Expanded(
                                          flex: 3,
                                          child: TextFieldValidatedForm(
                                            type: 'None',
                                            height: 40,
                                            controller: sdt,
                                            label: 'SĐT:',
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
                                          child: TextFieldValidatedForm(
                                            type: 'None',
                                            height: 40,
                                            controller: address,
                                            label: 'Địa chỉ:',
                                            flexLable: 2,
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
                                                  child: Text('Giới tính:', style: titleContainerBox),
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
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 30),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text('Học vị:', style: titleContainerBox),
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
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          //tìm kiếm
                                          Container(
                                            margin: EdgeInsets.only(left: 20),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                primary: Theme.of(context).iconTheme.color,
                                                textStyle: Theme.of(context).textTheme.caption?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 15.0,
                                                  horizontal: 10.0,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                                backgroundColor: orange,
                                              ),
                                              onPressed: () {
                                                findGVHD = "";
                                                var findTen = "";
                                                var findDonVi = "";
                                                var findSdt = "";
                                                var findEmail = "";
                                                var findAdress = "";
                                                var findHocVi = "";
                                                var findGioiTinh = "";
                                                var findTrangThai = "";
                                                if (ten.text != "") {
                                                  findTen = "and fullName~'*${ten.text}*' ";
                                                } else
                                                  findTen = "";
                                                if (donVi.text != "") {
                                                  findDonVi = "and donVi~'*${donVi.text}*' ";
                                                } else
                                                  findDonVi = "";
                                                if (sdt.text != "") {
                                                  findSdt = "and sdt~'*${sdt.text}*' ";
                                                } else
                                                  findSdt = "";
                                                if (email.text != "") {
                                                  findEmail = "and email~'*${email.text}*' ";
                                                } else
                                                  findEmail = "";
                                                if (address.text != "") {
                                                  findAdress = "and address~'*${address.text}*' ";
                                                } else
                                                  findAdress = "";
                                                if (selectedHocVi != -1) {
                                                  findHocVi = "and hocVi:$selectedHocVi ";
                                                } else
                                                  findHocVi = "";
                                                if (selectedGender != -1) {
                                                  if (selectedGender == 0)
                                                    findGioiTinh = "and gioiTinh:true ";
                                                  else
                                                    findGioiTinh = "and gioiTinh:false ";
                                                } else
                                                  findGioiTinh = "";
                                                if (selectedTrangThai != -1) {
                                                  findTrangThai = "and status:$selectedTrangThai ";
                                                } else
                                                  findTrangThai = "";
                                                findGVHD = findTen + findDonVi + findSdt + findEmail + findAdress + findHocVi + findGioiTinh + findTrangThai;
                                                if (findGVHD != "") if (findGVHD.substring(0, 3) == "and") findGVHD = findGVHD.substring(4);
                                                getData(0, findGVHD);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.search, color: white),
                                                  SizedBox(width: 5),
                                                  Text('Tìm kiếm', style: textBtnWhite),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 20, right: 10),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                primary: Theme.of(context).iconTheme.color,
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 15.0,
                                                  horizontal: 10.0,
                                                ),
                                                backgroundColor: grey,
                                                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                              ),
                                              onPressed: () async {
                                                setState(() {
                                                  ten.text = "";
                                                  donVi.text = "";
                                                  sdt.text = "";
                                                  email.text = "";
                                                  address.text = "";
                                                  selectedHocVi = -1;
                                                  selectedTrangThai = -1;
                                                  selectedGender = -1;
                                                  findGVHD = "";
                                                });
                                                getData(0, findGVHD);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.refresh, color: white),
                                                  SizedBox(width: 5),
                                                  Text('Đặt lại', style: textBtnWhite),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                primary: Theme.of(context).iconTheme.color,
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 15.0,
                                                  horizontal: 10.0,
                                                ),
                                                backgroundColor: mainColor,
                                                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                              ),
                                              onPressed: () async {
                                                bool statusChange = false;
                                                await Navigator.push<void>(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                    builder: (BuildContext context) => ThemMoiGVHD(
                                                      callbackChange: (value) {
                                                        statusChange = value;
                                                      },
                                                    ),
                                                  ),
                                                );
                                                if (statusChange) {
                                                  getData(0, "");
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.add, color: white),
                                                  SizedBox(width: 5),
                                                  Text('Thêm mới', style: textBtnWhite),
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
                                                  vertical: 15.0,
                                                  horizontal: 10.0,
                                                ),
                                                backgroundColor: mainColor,
                                                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                              ),
                                              onPressed: () async {
                                                List<GVHD> listExport = [];
                                                try {
                                                  var response;
                                                  if (findGVHD == "") {
                                                    response = await httpGet("/api/nguoi-dung/get/page?size=100000&filter=role:1&sort=status,desc&sort=id,desc", context);
                                                  } else {
                                                    response = await httpGet("/api/nguoi-dung/get/page?size=100000&filter=role:1 and $findGVHD&sort=status,desc&sort=id,desc", context);
                                                  }
                                                  if (response.containsKey("body")) {
                                                    var body = jsonDecode(response["body"]);
                                                    var content = [];
                                                    if (body["success"] == true) {
                                                      setState(() {
                                                        totalElements = body["result"]["totalElements"];
                                                        content = body["result"]["content"];
                                                        page = body['result']['totalPages'];
                                                        listExport = content.map((e) {
                                                          return GVHD.fromJson(e);
                                                        }).toList();
                                                      });
                                                    }
                                                  }
                                                } catch (e) {
                                                  print(e);
                                                }
                                                createExcel(listExport);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.download, color: white),
                                                  SizedBox(width: 5),
                                                  Text('Xuất file', style: textBtnWhite),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                showMenuFind = !showMenuFind;
                                              });
                                            },
                                            icon: Icon(Icons.expand_less, size: 28)),
                                      ],
                                    )
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Container(
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
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Kết quả tìm kiếm : $lastRow',
                                    style: textNormal,
                                  ),
                                  Icon(
                                    Icons.more_horiz,
                                    color: Color(0xff9aa5ce),
                                    size: 14,
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child: Divider(
                                  thickness: 1,
                                  color: colorPage,
                                ),
                              ),
                              FutureBuilder<dynamic>(
                                future: getListData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(showCheckboxColumn: false, columnSpacing: 30, border: TableBorder.all(color: colorPage), columns: [
                                        DataColumn(label: Text('STT', style: textDataColumn)),
                                        DataColumn(label: Text('Tên', style: textDataColumn)),
                                        DataColumn(label: Text('Giới tính', style: textDataColumn)),
                                        DataColumn(label: Text('SĐT', style: textDataColumn)),
                                        DataColumn(label: Text('Email', style: textDataColumn)),
                                        DataColumn(label: Text('Địa chỉ', style: textDataColumn)),
                                        DataColumn(label: Text('Học vị', style: textDataColumn)),
                                        DataColumn(label: Text('Đơn vị', style: textDataColumn)),
                                        DataColumn(label: Text('Trạng thái', style: textDataColumn)),
                                        DataColumn(label: Text('Hành động', style: textDataColumn)),
                                      ], rows: <DataRow>[
                                        for (var i = 0; i < listData.length; i++)
                                          DataRow(
                                            cells: [
                                              DataCell(Text("${tableIndex + i}", style: textDataRow)),
                                              DataCell(Text("${listData[i].fullName}", style: textDataRow)),
                                              DataCell(Text((listData[i].gioiTinh == true) ? "Nữ" : "Nam", style: textDataRow)),
                                              DataCell(Text("${(listData[i].sdt != null) ? listData[i].sdt : ""}", style: textDataRow)),
                                              DataCell(Text("${(listData[i].email != null) ? listData[i].email : ""}", style: textDataRow)),
                                              DataCell(SizedBox(width: 300, child: Text("${listData[i].address}", style: textDataRow))),
                                              DataCell(Text("${(listData[i].hocVi != null) ? listHocVi[listData[i].hocVi] : ""}", style: textDataRow)),
                                              DataCell(Text("${(listData[i].donVi != null) ? listData[i].donVi : ""}", style: textDataRow)),
                                              DataCell(Text("${(listData[i].status != null) ? listTrangthai[listData[i].status] : ""}", style: textDataRow)),
                                              DataCell(Row(
                                                children: [
                                                  Container(
                                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: InkWell(
                                                          onTap: () {
                                                            Navigator.push<void>(
                                                              context,
                                                              MaterialPageRoute<void>(
                                                                builder: (BuildContext context) => XemGVHD(
                                                                  gvhd: listData[i],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Icon(Icons.visibility))),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                    child: InkWell(
                                                        onTap: () {
                                                          Navigator.push<void>(
                                                            context,
                                                            MaterialPageRoute<void>(
                                                              builder: (BuildContext context) => SuaGVHD(
                                                                gvhd: listData[i],
                                                                callbackChange: (value) {
                                                                  setState(() {
                                                                    listData[i] = value;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Icon(Icons.edit_calendar, color: mainColor)),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                    child: InkWell(
                                                        onTap: () async {
                                                          await showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) => AlertDialog(
                                                                    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                      SizedBox(
                                                                        child: Row(
                                                                          children: [
                                                                            Text(
                                                                              'Xác nhận xóa giáo viên hướng dẫn',
                                                                              style: textNormal,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      IconButton(
                                                                        onPressed: () => {Navigator.pop(context)},
                                                                        icon: Icon(
                                                                          Icons.close,
                                                                        ),
                                                                      ),
                                                                    ]),
                                                                    //content
                                                                    content: Container(
                                                                      width: 400,
                                                                      height: 150,
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Divider(
                                                                            thickness: 1,
                                                                            color: colorPage,
                                                                          ),
                                                                          Text("Xoá ${listData[i].fullName}"),
                                                                          Divider(
                                                                            thickness: 1,
                                                                            color: colorPage,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    //actions
                                                                    actions: [
                                                                      ElevatedButton(
                                                                        onPressed: () => Navigator.pop(context),
                                                                        child: Text('Hủy'),
                                                                        style: ElevatedButton.styleFrom(
                                                                          primary: orange,
                                                                          onPrimary: white,
                                                                          elevation: 3,
                                                                          minimumSize: Size(100, 40),
                                                                        ),
                                                                      ),
                                                                      ElevatedButton(
                                                                        onPressed: () async {
                                                                          var response = await httpDelete("/api/nguoi-dung/del/${listData[i].id}", context);
                                                                          Navigator.pop(context);
                                                                          showToast(
                                                                            context: context,
                                                                            msg: "Đã xoá người dùng",
                                                                            color: Color.fromARGB(136, 72, 238, 67),
                                                                            icon: const Icon(Icons.done),
                                                                          );
                                                                        },
                                                                        child: Text(
                                                                          'Xác nhận',
                                                                          style: TextStyle(),
                                                                        ),
                                                                        style: ElevatedButton.styleFrom(
                                                                          primary: mainColor,
                                                                          onPrimary: white,
                                                                          elevation: 3,
                                                                          minimumSize: Size(100, 40),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ));
                                                          getData(0, findGVHD);
                                                        },
                                                        child: Icon(Icons.delete, color: red)),
                                                  ),
                                                ],
                                              )),
                                            ],
                                          )
                                      ]),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}');
                                  }
                                  // By default, show a loading spinner.
                                  return const CircularProgressIndicator();
                                },
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 50),
                                child: DynamicTablePagging(
                                  rowCount,
                                  currentPage,
                                  rowPerPage,
                                  pageChangeHandler: (page) {
                                    setState(() {
                                      getData(page - 1, findGVHD);
                                      currentPage = page - 1;
                                    });
                                  },
                                  rowPerPageChangeHandler: (rowPerPage) {
                                    setState(() {
                                      this.rowPerPage = rowPerPage!;
                                      firstRow = page * currentPage;
                                      getData(0, findGVHD);
                                    });
                                  },
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ],
                  ),
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
