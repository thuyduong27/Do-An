// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, unused_local_variable, curly_braces_in_flow_control_structures, sort_child_properties_last, use_build_context_synchronously

import 'dart:convert';
import 'dart:html';

import 'package:fe_web/views/common/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/company.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/phan-trang.dart';
import '../../../common/text-file.dart';
import '../../../common/title_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Border;
import '../../../common/toast.dart';
import 'sua-doanh-nghiep.dart';
import 'them-moi-doanh-nghiep.dart';
import 'xem-doanh-nghiep.dart';

class QuanLyDNScreen extends StatefulWidget {
  QuanLyDNScreen({Key? key}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<QuanLyDNScreen> {
  var page = 1;
  var rowPerPage = 10;
  var totalElements = 0;
  var firstRow = 1, lastRow = 0;
  var rowCount = 0;
  var currentPage = 1;
  var tableIndex = 1;
  List<Company> listCompany = [];
  late Future<List<Company>> getListDoangNghiep;
  String findDoanhNghiep = "";

  Future<List<Company>> getDoanhNghiep(int page, String findDoanhNghiep) async {
    if (page * rowPerPage > totalElements) {
      page = (1.0 * totalElements / rowPerPage - 1).ceil();
    }
    if (page < 1) {
      page = 0;
    }
    var response5;
    if (findDoanhNghiep == "") {
      response5 = await httpGet("/api/doanh-nghiep/get/page?size=$rowPerPage&page=$page&filter=status>0", context);
    } else {
      response5 = await httpGet("/api/doanh-nghiep/get/page?size=$rowPerPage&page=$page&filter=status>0 and $findDoanhNghiep", context);
    }
    var content = [];
    if (response5.containsKey("body")) {
      setState(() {
        var resultLPV = jsonDecode(response5["body"]);
        listCompany = [];
        currentPage = page + 1;
        content = resultLPV['result']['content'];
        listCompany = content.map((e) {
          return Company.fromJson(e);
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
      return listCompany;
    } else {
      throw Exception('Không có data');
    }
  }

  Map<int, String> listHopDong = {
    0: 'Tất cả',
    1: 'Có',
    2: 'Không',
  };
  int selectedHopDong = 0;
  Map<int, String> listTrangthai = {
    0: 'Tất cả',
    1: 'Không khoá',
    2: 'Khoá',
  };
  int selectedTrangThai = 0;

  //tìm kiếm
  bool showMenuFind = true;
  TextEditingController ten = TextEditingController();
  TextEditingController mst = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController manager = TextEditingController();
  TextEditingController managerSdt = TextEditingController();
  TextEditingController managerEmail = TextEditingController();

  Future<void> createExcel(List<Company> listData) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    int stt = listData.length;
    sheet.getRangeByIndex(1, 1, 1 + stt, 8).cellStyle.fontSize = 12;
    sheet.getRangeByIndex(1, 1, 2 + stt, 8).cellStyle.fontName = "Times New Roman";
    sheet.getRangeByIndex(1, 1, 2 + stt, 8).cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByIndex(1, 1, 2 + stt, 8).cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByIndex(2, 1, 2 + stt, 8).cellStyle.borders.all.lineStyle = LineStyle.thin;
    sheet.getRangeByIndex(2, 1, 2, 8).cellStyle.backColor = '#008c87';
    sheet.getRangeByIndex(2, 1, 2, 8).cellStyle.fontSize = 13;
    sheet.getRangeByIndex(2, 1, 2, 8).cellStyle.bold = true;
    sheet.getRangeByIndex(2, 1).rowHeight = 40;
    sheet.getRangeByIndex(3, 1, 2 + stt, 1).rowHeight = 25;
    sheet.getRangeByIndex(1, 1, 1, 8).merge();
    sheet.getRangeByIndex(1, 1).rowHeight = 45;
    sheet.getRangeByIndex(1, 1).setText("Danh sách doanh nghiệp");
    sheet.getRangeByIndex(1, 1).cellStyle.fontSize = 25;
    sheet.getRangeByIndex(1, 1).cellStyle.bold = true;
    sheet.getRangeByName('A1').columnWidth = 6.4;
    sheet.getRangeByName('B1').columnWidth = 80;
    sheet.getRangeByName('C1').columnWidth = 40;
    sheet.getRangeByName('D1').columnWidth = 25;
    sheet.getRangeByName('E1').columnWidth = 25;
    sheet.getRangeByName('F1').columnWidth = 10;
    sheet.getRangeByName('G1').columnWidth = 80;
    sheet.getRangeByName('H1').columnWidth = 20;
    sheet.getRangeByName('A2').setText("STT");
    sheet.getRangeByName('B2').setText("Tên doanh nghiệp");
    sheet.getRangeByName('C2').setText("Người quản lý");
    sheet.getRangeByName('D2').setText("Số điện thoại");
    sheet.getRangeByName('E2').setText("Email");
    sheet.getRangeByName('F2').setText("Mã số thuế");
    sheet.getRangeByName('G2').setText("Địa chỉ");
    sheet.getRangeByName('H2').setText("Hợp đồng");
    sheet.autoFilters.filterRange = sheet.getRangeByName('A2:H${1 + stt}');
    for (var i = 0; i < listData.length; i++) {
      sheet.getRangeByName('A${i + 3}').setNumber(i + 1);
      sheet.getRangeByName('B${i + 3}').setText(listData[i].name);
      sheet.getRangeByName('C${i + 3}').setText(listData[i].manager);
      sheet.getRangeByName('D${i + 3}').setText(listData[i].managerSdt);
      sheet.getRangeByName('E${i + 3}').setText(listData[i].managerEmail);
      sheet.getRangeByName('F${i + 3}').setText(listData[i].mst ?? "");
      sheet.getRangeByName('G${i + 3}').setText(listData[i].address);
      sheet.getRangeByName('H${i + 3}').setText(listData[i].hopDong == true ? "Đã ký" : "Chưa ký");
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    if (kIsWeb) {
      AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'Danh_sach_doanh_nghiep.xlsx')
        ..click();
    }
  }

  @override
  void initState() {
    super.initState();
    getListDoangNghiep = getDoanhNghiep(0, findDoanhNghiep);
  }

  void dispose() {
    ten.dispose();
    mst.dispose();
    address.dispose();
    manager.dispose();
    managerSdt.dispose();
    managerEmail.dispose();
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
                ],
                content: 'Quản lý doanh nghiệp',
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
                                          child: TextFieldValidatedForm(
                                            type: 'None',
                                            height: 40,
                                            controller: mst,
                                            label: 'Mã số thuế:',
                                            flexLable: 2,
                                          ),
                                        ),
                                        SizedBox(width: 100),
                                        Expanded(
                                          flex: 3,
                                          child: TextFieldValidatedForm(
                                            type: 'None',
                                            height: 40,
                                            controller: manager,
                                            label: 'Người quản lý:',
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
                                            controller: managerEmail,
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
                                            controller: managerSdt,
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
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 30),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text('Hợp đồng:', style: titleContainerBox),
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
                                                        items: listHopDong.entries.map((item) => DropdownMenuItem<int>(value: item.key, child: Text(item.value))).toList(),
                                                        value: selectedHopDong,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedHopDong = value as int;
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
                                                findDoanhNghiep = "";
                                                var findTen = "";
                                                var findMst = "";
                                                var findAddress = "";
                                                var findManager = "";
                                                var findManagerSdt = "";
                                                var findManagerEmail = "";
                                                var findHopDong = "";
                                                var findTrangThai = "";
                                                if (ten.text != "") {
                                                  findTen = "and name~'*${ten.text}*' ";
                                                } else
                                                  findTen = "";
                                                if (address.text != "") {
                                                  findAddress = "and address~'*${address.text}*' ";
                                                } else
                                                  findAddress = "";
                                                if (mst.text != "") {
                                                  findMst = "and mst~'*${mst.text}*' ";
                                                } else
                                                  findMst = "";
                                                if (manager.text != "") {
                                                  findManager = "and manager~'*${manager.text}*' ";
                                                } else
                                                  findManager = "";
                                                if (managerSdt.text != "") {
                                                  findManagerSdt = "and managerSdt~'*${managerSdt.text}*' ";
                                                } else
                                                  findManagerSdt = "";
                                                if (managerEmail.text != "") {
                                                  findManagerEmail = "and managerEmail~'*${managerEmail.text}*' ";
                                                } else
                                                  findManagerEmail = "";
                                                if (selectedHopDong != 0) {
                                                  if (selectedHopDong == 1)
                                                    findHopDong = "and hopDong:true ";
                                                  else
                                                    findHopDong = "and hopDong:false ";
                                                } else
                                                  findHopDong = "";
                                                if (selectedTrangThai != 0) {
                                                  findTrangThai = "and status:$selectedTrangThai ";
                                                } else
                                                  findTrangThai = "";
                                                findDoanhNghiep = findTen + findMst + findAddress + findManager + findManagerSdt + findManagerEmail + findHopDong + findTrangThai;
                                                if (findDoanhNghiep != "") if (findDoanhNghiep.substring(0, 3) == "and") findDoanhNghiep = findDoanhNghiep.substring(4);
                                                getDoanhNghiep(0, findDoanhNghiep);
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
                                                foregroundColor: Theme.of(context).iconTheme.color,
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 15.0,
                                                  horizontal: 10.0,
                                                ),
                                                backgroundColor: mainColor,
                                                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                              ),
                                              onPressed: () async {
                                                setState(() {
                                                  ten.text = "";
                                                  mst.text = "";
                                                  address.text = "";
                                                  manager.text = "";
                                                  managerSdt.text = "";
                                                  managerEmail.text = "";
                                                  selectedHopDong = 0;
                                                  selectedTrangThai = 0;
                                                  findDoanhNghiep = "";
                                                });
                                                getDoanhNghiep(0, findDoanhNghiep);
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
                                                    builder: (BuildContext context) => ThemMoiDoanhNghiep(
                                                      callbackChange: (value) {
                                                        statusChange = value;
                                                      },
                                                    ),
                                                  ),
                                                );
                                                if (statusChange) {
                                                  getDoanhNghiep(0, "");
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
                                                List<Company> listExport = [];
                                                try {
                                                  var response;
                                                  if (findDoanhNghiep == "") {
                                                    response = await httpGet("/api/doanh-nghiep/get/page?size=10000000&filter=status>0", context);
                                                  } else {
                                                    response = await httpGet("/api/doanh-nghiep/get/page?size=10000000&filter=status>0 and $findDoanhNghiep", context);
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
                                                          return Company.fromJson(e);
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
                                future: getListDoangNghiep,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(showCheckboxColumn: false, columnSpacing: 30, border: TableBorder.all(color: colorPage), columns: [
                                        DataColumn(label: Text('STT', style: textDataColumn)),
                                        DataColumn(label: Text('Tên doanh nghiệp', style: textDataColumn)),
                                        DataColumn(label: Text('Người quản lý', style: textDataColumn)),
                                        DataColumn(label: Text('SĐT', style: textDataColumn)),
                                        DataColumn(label: Text('Email', style: textDataColumn)),
                                        DataColumn(label: Text('Địa chỉ', style: textDataColumn)),
                                        DataColumn(label: Text('Mã số thuế', style: textDataColumn)),
                                        DataColumn(label: Text('Hợp đồng', style: textDataColumn)),
                                        DataColumn(label: Text('Hành động', style: textDataColumn)),
                                      ], rows: <DataRow>[
                                        for (var i = 0; i < listCompany.length; i++)
                                          DataRow(
                                            cells: [
                                              DataCell(Text("${tableIndex + i}", style: textDataRow)),
                                              DataCell(Text("${listCompany[i].name}", style: textDataRow)),
                                              DataCell(Text("${(listCompany[i].manager != null) ? listCompany[i].manager : ""}", style: textDataRow)),
                                              DataCell(Text("${(listCompany[i].managerSdt != null) ? listCompany[i].managerSdt : ""}", style: textDataRow)),
                                              DataCell(Text("${(listCompany[i].managerEmail != null) ? listCompany[i].managerEmail : ""}", style: textDataRow)),
                                              DataCell(SizedBox(width: 300, child: Text("${listCompany[i].address}", style: textDataRow))),
                                              DataCell(Text("${(listCompany[i].mst != null) ? listCompany[i].mst : ""}", style: textDataRow)),
                                              DataCell(Text((listCompany[i].hopDong == true) ? "Có" : "Không ", style: textDataRow)),
                                              DataCell(Row(
                                                children: [
                                                  Container(
                                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: InkWell(
                                                          onTap: () {
                                                            Navigator.push<void>(
                                                              context,
                                                              MaterialPageRoute<void>(
                                                                builder: (BuildContext context) => XemDoanhNghiep(
                                                                  company: listCompany[i],
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
                                                              builder: (BuildContext context) => SuaDoanhNghiep(
                                                                company: listCompany[i],
                                                                callbackChange: (value) {
                                                                  setState(() {
                                                                    listCompany[i] = value;
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
                                                                              'Xác nhận xóa doanh nghiệp',
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
                                                                          Text("Xoá ${listCompany[i].name}"),
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
                                                                          var response = await httpDelete("/api/doanh-nghiep/del/${listCompany[i].id}", context);
                                                                          Navigator.pop(context);
                                                                          showToast(
                                                                            context: context,
                                                                            msg: "Đã xoá doanh nghiệp",
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
                                                          getDoanhNghiep(0, findDoanhNghiep);
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
                                      getDoanhNghiep(page - 1, findDoanhNghiep);
                                      currentPage = page - 1;
                                    });
                                  },
                                  rowPerPageChangeHandler: (rowPerPage) {
                                    setState(() {
                                      this.rowPerPage = rowPerPage!;
                                      firstRow = page * currentPage;
                                      getDoanhNghiep(0, findDoanhNghiep);
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
