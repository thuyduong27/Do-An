// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, unused_local_variable, curly_braces_in_flow_control_structures, sort_child_properties_last, use_build_context_synchronously, unnecessary_import, deprecated_member_use, unnecessary_new

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe_web/views/common/loadApi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:fe_web/models/ke-hoach-thuc-tap.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:http/http.dart' as http;
import '../../../../confing.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/company.dart';
import '../../../../models/gvhd.dart';
import '../../../../models/sinh-vien.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/phan-trang.dart';
import '../../../common/text-file.dart';
import '../../../common/title_page.dart';
import '../../../common/toast.dart';
import 'sua-sinh-vien.dart';
import 'them-moi-sinh-vien.dart';
import 'thong-tin-sinh-vien.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Border;

class QuanLySinhVienScreen extends StatefulWidget {
  QuanLySinhVienScreen({Key? key}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<QuanLySinhVienScreen> {
  var page = 1;
  var rowPerPage = 10;
  var totalElements = 0;
  var firstRow = 1, lastRow = 0;
  var rowCount = 0;
  var currentPage = 1;
  var tableIndex = 1;
  List<SinhVien> listData = [];
  String findGVHD = "";

  Future<List<SinhVien>> getData(int page, String findGVHD) async {
    if (page * rowPerPage > totalElements) {
      page = (1.0 * totalElements / rowPerPage - 1).ceil();
    }
    if (page < 1) {
      page = 0;
    }
    var response5;
    if (findGVHD == "") {
      response5 = await httpGet("/api/sinh-vien-thuc-tap/get/page?size=$rowPerPage&page=$page&filter=idKhtt:${selectedKHTT.id ?? 0}&sort=status", context);
    } else {
      response5 = await httpGet("/api/sinh-vien-thuc-tap/get/page?size=$rowPerPage&page=$page&filter=idKhtt:${selectedKHTT.id ?? 0} and $findGVHD&sort=status", context);
    }
    if (response5.containsKey("body")) {
      setState(() {
        var resultLPV = jsonDecode(response5["body"]);
        var content = [];
        listData = [];
        currentPage = page + 1;
        content = resultLPV['result']['content'];
        listData = content.map((e) {
          return SinhVien.fromJson(e);
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

  int selectedNganh = -1;
  Map<int, String> listNganh = {
    -1: 'Tất cả',
    0: 'Công nghệ thông tin',
    1: 'Kỹ thuật phần mềm',
    2: 'Hệ thống thông tin',
    3: 'Khoa học máy tính',
    4: 'Công nghệ đa phương tiện',
  };
  Map<int, String> listTrangthai = {
    -1: 'Tất cả',
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

  //tìm kiếm
  bool showMenuFind = true;
  TextEditingController ten = TextEditingController();
  TextEditingController maSV = TextEditingController();

  KeHoachThucTap selectedKHTT = KeHoachThucTap(id: 0, tilte: "");
  Future<List<KeHoachThucTap>> getKeHoacThucTap() async {
    List<KeHoachThucTap> resultKhtt = [];
    var response1 = await httpGet("/api/ke-hoach-thuc-tap/get/page?filter=status!2&sort=status", context);
    resultKhtt = [];
    if (response1.containsKey("body")) {
      setState(() {
        var body = jsonDecode(response1['body']);
        var content = [];
        content = body['result']['content'];
        resultKhtt = content.map((e) {
          return KeHoachThucTap.fromJson(e);
        }).toList();
      });
    }
    return resultKhtt;
  }

  GVHD selectedGVHD = GVHD(id: null, fullName: "--Chọn giảng viên--");
  Future<List<GVHD>> getGVHD() async {
    List<GVHD> resultGVHD = [];
    var response1 = await httpGet("/api/giao-vien/get/page?filter=status:1 and idKhtt:${selectedKHTT.id}", context);
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
      GVHD all = GVHD(id: null, fullName: "--Chọn giảng viên--");
      setState(() {
        resultGVHD.insert(0, all);
      });
    }
    return resultGVHD;
  }

  Company selectedCSTT = Company(id: null, name: "--Chọn--");
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
      Company all = Company(id: null, name: "--Chọn--");
      setState(() {
        resultCSTT.insert(0, all);
      });
    }
    return resultCSTT;
  }

  getKeHoacThucTapNow() async {
    List<KeHoachThucTap> resultNow = [];
    var response2 = await httpGet("/api/ke-hoach-thuc-tap/get/page?filter=status:0", context);
    if (response2.containsKey("body")) {
      setState(() {
        var body = jsonDecode(response2['body']);
        var content = [];
        content = body['result']['content'];
        selectedKHTT = KeHoachThucTap.fromJson(content.first);
      });
    }
  }

  bool statusData = false;
  callApi() async {
    setState(() {
      statusData = false;
    });
    getData(0, findGVHD);
    setState(() {
      statusData = true;
    });
  }

  Future<void> createExcel(List<SinhVien> listData) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    int stt = listData.length;
    sheet.getRangeByIndex(1, 1, 1 + stt, 18).cellStyle.fontSize = 12;
    sheet.getRangeByIndex(1, 1, 2 + stt, 18).cellStyle.fontName = "Times New Roman";
    sheet.getRangeByIndex(1, 1, 2 + stt, 18).cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByIndex(1, 1, 2 + stt, 18).cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByIndex(2, 1, 2 + stt, 18).cellStyle.borders.all.lineStyle = LineStyle.thin;
    sheet.getRangeByIndex(2, 1, 2, 18).cellStyle.backColor = '#009c87';
    sheet.getRangeByIndex(2, 1, 2, 18).cellStyle.fontSize = 13;
    sheet.getRangeByIndex(2, 1, 2, 18).cellStyle.bold = true;
    sheet.getRangeByIndex(2, 1).rowHeight = 40;
    sheet.getRangeByIndex(3, 1, 2 + stt, 1).rowHeight = 25;
    sheet.getRangeByIndex(1, 1, 1, 18).merge();
    sheet.getRangeByIndex(1, 1).rowHeight = 45;
    sheet.getRangeByIndex(1, 1).setText("DANH SÁCH SINH VIÊN ĐH ${(listData.isNotEmpty) ? listData.first.nguoiDung!.khoa : ""} ĐĂNG KÝ THỰC TẬP TỐT NGHIỆP");
    sheet.getRangeByIndex(1, 1).cellStyle.fontSize = 23;
    sheet.getRangeByIndex(1, 1).cellStyle.bold = true;
    sheet.getRangeByName('A1').columnWidth = 6;
    sheet.getRangeByName('B1').columnWidth = 14;
    sheet.getRangeByName('C1').columnWidth = 30;
    sheet.getRangeByName('D1').columnWidth = 12;
    sheet.getRangeByName('E1').columnWidth = 18;
    sheet.getRangeByName('F1').columnWidth = 5;
    sheet.getRangeByName('G1').columnWidth = 20;
    sheet.getRangeByName('H1').columnWidth = 31;
    sheet.getRangeByName('I1').columnWidth = 26;
    sheet.getRangeByName('J1').columnWidth = 12;
    sheet.getRangeByName('K1').columnWidth = 33;
    sheet.getRangeByName('L1').columnWidth = 56;
    sheet.getRangeByName('M1').columnWidth = 59;
    sheet.getRangeByName('N1').columnWidth = 40;
    sheet.getRangeByName('O1').columnWidth = 20;
    sheet.getRangeByName('P1').columnWidth = 33;
    sheet.getRangeByName('Q1').columnWidth = 17;
    sheet.getRangeByName('R1').columnWidth = 17;

    sheet.getRangeByName('A2').setText("STT");
    sheet.getRangeByName('B2').setText("Mã sv");
    sheet.getRangeByName('C2').setText("Họ tên");
    sheet.getRangeByName('D2').setText("Ngày sinh");
    sheet.getRangeByName('E2').setText("Lớp");
    sheet.getRangeByName('F2').setText("Khoá");
    sheet.getRangeByName('G2').setText("Số điện thoại");
    sheet.getRangeByName('H2').setText("Email");
    sheet.getRangeByName('I2').setText("GV Hướng dẫn");
    sheet.getRangeByName('J2').setText("Điện thoại");
    sheet.getRangeByName('K2').setText("Email");
    sheet.getRangeByName('L2').setText("Tên doanh nghiệp");
    sheet.getRangeByName('M2').setText("Địa chỉ công ty đi thực tập");
    sheet.getRangeByName('N2').setText("Người quản lý sinh viên");
    sheet.getRangeByName('O2').setText("Điện thoại người quản lý");
    sheet.getRangeByName('P2').setText("Email người quản lý");
    sheet.getRangeByName('Q2').setText("Điểm");
    sheet.getRangeByName('R2').setText("Điểm bằng chữ");
    sheet.autoFilters.filterRange = sheet.getRangeByName('A2:R${1 + stt}');
    for (var i = 0; i < listData.length; i++) {
      sheet.getRangeByName('A${i + 3}').setNumber(i + 1);
      sheet.getRangeByName('B${i + 3}').setText(listData[i].nguoiDung!.maSv);
      sheet.getRangeByName('C${i + 3}').setText(listData[i].nguoiDung!.fullName);
      sheet.getRangeByName('D${i + 3}').setText(DateFormat('dd-MM-yyyy').format(DateTime.parse(listData[i].nguoiDung!.ngaySinh!)));
      sheet.getRangeByName('E${i + 3}').setText(listData[i].nguoiDung!.lop);
      sheet.getRangeByName('F${i + 3}').setText(listData[i].nguoiDung!.khoa);
      sheet.getRangeByName('G${i + 3}').setText(listData[i].nguoiDung!.sdt);
      sheet.getRangeByName('H${i + 3}').setText(listData[i].nguoiDung!.email);
      if (listData[i].giaoVien != null) {
        (listData[i].giaoVien!.hocVi == 1)
            ? sheet.getRangeByName('I${i + 3}').setText("ThS. ${listData[i].giaoVien!.fullName!}")
            : (listData[i].giaoVien!.hocVi == 2)
                ? sheet.getRangeByName('I${i + 3}').setText("TS. ${listData[i].giaoVien!.fullName!}")
                : sheet.getRangeByName('I${i + 3}').setText(listData[i].giaoVien!.fullName!);
        sheet.getRangeByName('J${i + 3}').setText(listData[i].giaoVien!.sdt);
        sheet.getRangeByName('K${i + 3}').setText(listData[i].giaoVien!.email);
      }
      if (listData[i].doanhNghiep != null) {
        sheet.getRangeByName('L${i + 3}').setText(listData[i].doanhNghiep!.name);
        sheet.getRangeByName('M${i + 3}').setText(listData[i].doanhNghiep!.address ?? "");
        sheet.getRangeByName('N${i + 3}').setText(listData[i].doanhNghiep!.manager);
        sheet.getRangeByName('O${i + 3}').setText(listData[i].doanhNghiep!.managerSdt);
        sheet.getRangeByName('P${i + 3}').setText(listData[i].doanhNghiep!.managerEmail);
      }
      if (listData[i].diem != null && listData[i].diem != "") sheet.getRangeByName('Q${i + 3}').setNumber(double.parse(listData[i].diem!));
      if (listData[i].diem != null && listData[i].diem != "")
        sheet.getRangeByName('R${i + 3}').setText((double.parse(listData[i].diem!) > 8.5)
            ? "A"
            : (double.parse(listData[i].diem!) > 7.7)
                ? "B+"
                : (double.parse(listData[i].diem!) > 7)
                    ? "B"
                    : (double.parse(listData[i].diem!) > 6.2)
                        ? "C+"
                        : (double.parse(listData[i].diem!) > 5.5)
                            ? "C"
                            : (double.parse(listData[i].diem!) > 4.7)
                                ? "D+"
                                : (double.parse(listData[i].diem!) > 4)
                                    ? "D"
                                    : "F");
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    if (kIsWeb) {
      AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'Danh_sach_sinh_vien.xlsx')
        ..click();
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      var securityModel = Provider.of<SecurityModel>(context, listen: false);
      selectedKHTT = securityModel.khttNow;
      callApi();
    });
  }

  @override
  void dispose() {
    ten.dispose();
    maSV.dispose();
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
          child: (statusData == true)
              ? ListView(
                  controller: ScrollController(),
                  children: [
                    TitlePage(
                        listPreTitle: [
                          {'url': "/trang-chu", 'title': 'Trang chủ'},
                        ],
                        content: 'Quản lý sinh viên thực tập',
                        widgetBoxRight: Container(
                          width: 500,
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text('Kế hoạch:', style: titleContainerBox),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width * 0.20,
                                  height: 40,
                                  child: DropdownSearch<KeHoachThucTap>(
                                    popupProps: PopupPropsMultiSelection.menu(
                                      showSearchBox: true,
                                    ),
                                    dropdownDecoratorProps: DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        constraints: const BoxConstraints.tightFor(
                                          width: 300,
                                          height: 40,
                                        ),
                                        contentPadding: const EdgeInsets.only(left: 14, bottom: 14),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(0),
                                          ),
                                          borderSide: BorderSide(color: Colors.black, width: 0.5),
                                        ),
                                        hintText: "--Chọn kế hoạch thực tập--",
                                        hintMaxLines: 2,
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(0),
                                          ),
                                          borderSide: BorderSide(color: Colors.black, width: 0.5),
                                        ),
                                      ),
                                    ),
                                    asyncItems: (String? filter) => getKeHoacThucTap(),
                                    itemAsString: (KeHoachThucTap u) => u.tilte!,
                                    selectedItem: selectedKHTT,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedKHTT = value!;
                                        ten.text = "";
                                        maSV.text = "";
                                        selectedGVHD = GVHD(id: null, fullName: "--Chọn giảng viên--");
                                        selectedCSTT = Company(id: null, name: "--Chọn--");
                                        selectedTrangThai = -1;
                                        selectedNganh = -1;
                                        findGVHD = "";
                                      });
                                      callApi();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
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
                                                  controller: maSV,
                                                  label: 'Mã sinh viên:',
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
                                                        child: Text('Ngành: ', style: titleContainerBox),
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
                                                      var findMaSV = "";
                                                      var findGV = "";
                                                      var findCSTT = "";
                                                      var findNganh = "";
                                                      var findTrangThai = "";
                                                      if (ten.text != "") {
                                                        findTen = "and nguoiDung.fullName~'*${ten.text}*' ";
                                                      } else
                                                        findTen = "";
                                                      if (maSV.text != "") {
                                                        findMaSV = "and nguoiDung.maSv~'*${ten.text}*' ";
                                                      } else
                                                        findMaSV = "";
                                                      if (selectedGVHD.id != null) {
                                                        findGV = "and idGvhd:${selectedGVHD.id} ";
                                                      } else {
                                                        findGV = "";
                                                      }
                                                      if (selectedCSTT.id != null) {
                                                        findCSTT = "and idDoanhNghiep:${selectedCSTT.id} ";
                                                      } else {
                                                        findCSTT = "";
                                                      }
                                                      if (selectedNganh != -1) {
                                                        findNganh = "and nguoiDung.nganh:$selectedNganh ";
                                                      } else
                                                        findNganh = "";
                                                      if (selectedTrangThai != -1) {
                                                        findTrangThai = "and status:$selectedTrangThai ";
                                                      } else
                                                        findTrangThai = "";
                                                      findGVHD = findTen + findMaSV + findGV + findCSTT + findNganh + findTrangThai;
                                                      if (findGVHD != "") if (findGVHD.substring(0, 3) == "and") findGVHD = findGVHD.substring(4);
                                                      callApi();
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
                                                      backgroundColor: mainColor,
                                                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                                    ),
                                                    onPressed: () async {
                                                      setState(() {
                                                        ten.text = "";
                                                        maSV.text = "";
                                                        selectedGVHD = GVHD(id: null, fullName: "--Chọn giảng viên--");
                                                        selectedCSTT = Company(id: null, name: "--Chọn--");
                                                        selectedTrangThai = -1;
                                                        selectedNganh = -1;
                                                        findGVHD = "";
                                                      });
                                                      callApi();
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
                                                          builder: (BuildContext context) => ThemMoiSinhVien(
                                                            idKhtt: selectedKHTT.id!,
                                                            callbackChange: (value) {
                                                              statusChange = value;
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                      if (statusChange) {
                                                        callApi();
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
                                                (selectedKHTT.id == user.khttNow.id)
                                                    ? Container(
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
                                                            processing();
                                                            bool statusChange = false;
                                                            await showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) => XacNhanThem(
                                                                      idKHTT: selectedKHTT.id!,
                                                                      callBack: (value) {
                                                                        statusChange = value;
                                                                      },
                                                                    ));
                                                            if (statusChange) {
                                                              callApi();
                                                            }
                                                            Navigator.pop(context);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Icon(Icons.upload_file, color: white),
                                                              SizedBox(width: 5),
                                                              Text('Tải file danh sách', style: textBtnWhite),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
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
                                                      List<SinhVien> listExport = [];
                                                      try {
                                                        var response;
                                                        if (findGVHD == "") {
                                                          response = await httpGet("/api/sinh-vien-thuc-tap/get/page?filter=idKhtt:${selectedKHTT.id ?? 0}&sort=status&size=100000000", context);
                                                        } else {
                                                          response = await httpGet("/api/sinh-vien-thuc-tap/get/page?filter=idKhtt:${selectedKHTT.id ?? 0} and $findGVHD&sort=status&size=100000000", context);
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
                                                                return SinhVien.fromJson(e);
                                                              }).toList();
                                                            });
                                                          }
                                                        }
                                                      } catch (e) {
                                                        print(e);
                                                      }
                                                      createExcel(listExport);
                                                      // print(listExport.length);
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
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(showCheckboxColumn: false, columnSpacing: 30, border: TableBorder.all(color: colorPage), columns: [
                                        DataColumn(label: Text('STT', style: textDataColumn)),
                                        DataColumn(label: Text('Mã sinh viên', style: textDataColumn)),
                                        DataColumn(label: Text('Tên', style: textDataColumn)),
                                        DataColumn(label: Text('Lớp', style: textDataColumn)),
                                        DataColumn(label: Text('Ngành', style: textDataColumn)),
                                        DataColumn(label: Text('Giảng viên hướng dẫn', style: textDataColumn)),
                                        DataColumn(label: Text('Cơ sở thực tập', style: textDataColumn)),
                                        DataColumn(label: Text('Trạng thái', style: textDataColumn)),
                                        DataColumn(label: Text('Hành động', style: textDataColumn)),
                                      ], rows: <DataRow>[
                                        for (var i = 0; i < listData.length; i++)
                                          DataRow(
                                            cells: [
                                              DataCell(Text("${tableIndex + i}", style: textDataRow)),
                                              DataCell(Text("${listData[i].nguoiDung!.maSv}", style: textDataRow)),
                                              DataCell(Text("${listData[i].nguoiDung!.fullName}", style: textDataRow)),
                                              DataCell(Text("${listData[i].nguoiDung!.lop}", style: textDataRow)),
                                              DataCell(Text("${(listData[i].nguoiDung!.nganh != null) ? listNganh[listData[i].nguoiDung!.nganh] : ""}", style: textDataRow)),
                                              DataCell(Text(
                                                  (listData[i].giaoVien != null)
                                                      ? "${(listData[i].giaoVien!.hocVi == 1) ? "Ths" : (listData[i].giaoVien!.hocVi == 2) ? "Tiến sĩ" : ""} ${listData[i].giaoVien!.fullName ?? ""}"
                                                      : "",
                                                  style: textDataRow)),
                                              DataCell(SizedBox(width: 300, child: Text((listData[i].doanhNghiep != null) ? listData[i].doanhNghiep!.name ?? "" : "", style: textDataRow))),
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
                                                                builder: (BuildContext context) => ThongTinSinhVien(
                                                                  data: listData[i],
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
                                                              builder: (BuildContext context) => SuaSinhVien(
                                                                idKhtt: selectedKHTT.id!,
                                                                data: listData[i],
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
                                                                              'Xác nhận xóa sinh viên',
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
                                                                          Text("Xoá ${listData[i].nguoiDung!.fullName}"),
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
                                                                          await httpDelete("/api/nguoi-dung/del/${listData[i].nguoiDung!.id}", context);
                                                                          await httpDelete("/api/sinh-vien-thuc-tap/del/${listData[i].id}", context);
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
                )
              : CommonApp().loadingCallAPi(),
        ),
      ),
    ));
  }
}

class XacNhanThem extends StatefulWidget {
  int idKHTT;
  Function callBack;
  XacNhanThem({Key? key, required this.idKHTT, required this.callBack}) : super(key: key);
  @override
  State<XacNhanThem> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<XacNhanThem> {
  exportFileExcel(file, int idKhtt, {context}) async {
    if (file != null) {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/api/sinh-vien-thuc-tap/up-file-danh-sach/$idKhtt"),
      );
      request.files.add(new http.MultipartFile(
        "file",
        file!.files.first.readStream!,
        file.files.first.size,
        filename: file.files.first.name,
      ));
      //-------Send request
      var resp = await request.send();
      var result = await resp.stream.bytesToString();
      return result;
    } else {
      return "null";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 460,
        height: 230,
        child: ListView(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Xác nhận tải danh sách', style: textTitleAlertDialog),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.callBack(false);
                  },
                  icon: Icon(Icons.close)),
            ]),
            const Divider(thickness: 1, color: Color.fromARGB(255, 150, 150, 150)),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Text("Xác nhận tải file danh sách, danh sách cũ sẽ bị xoá. Có chắc chắn tải lên?"),
            ),
            const Divider(thickness: 1, color: Color.fromARGB(255, 148, 148, 148)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //tìm kiếm
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).iconTheme.color,
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
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['xlsx'],
                        withReadStream: true,
                      );
                      if (result != null) {
                        await exportFileExcel(result, widget.idKHTT, context: context);
                      }
                      widget.callBack(true);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Text('Tải file', style: textBtnWhite),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).iconTheme.color,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 40.0,
                      ),
                      backgroundColor: orange,
                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                    ),
                    onPressed: () {
                      widget.callBack(false);
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
      ),
    );
  }

  Future<void> processing() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Center(child: const CircularProgressIndicator());
      },
    );
  }
}
