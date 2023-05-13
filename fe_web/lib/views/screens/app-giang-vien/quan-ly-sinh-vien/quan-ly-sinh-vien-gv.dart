// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, unused_local_variable, curly_braces_in_flow_control_structures, sort_child_properties_last, use_build_context_synchronously, unnecessary_import, deprecated_member_use, unnecessary_new

import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe_web/views/common/loadApi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'thong-tin-sv-gv.dart';

class QuanLySinhVienGVScreen extends StatefulWidget {
  QuanLySinhVienGVScreen({Key? key}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<QuanLySinhVienGVScreen> {
  var page = 1;
  var rowPerPage = 10;
  var totalElements = 0;
  var firstRow = 1, lastRow = 0;
  var rowCount = 0;
  var currentPage = 1;
  var tableIndex = 1;
  List<SinhVien> listData = [];
  String findGVHD = "";

  Future<List<SinhVien>> getData(int page, String findGVHD, int idgv) async {
    if (page * rowPerPage > totalElements) {
      page = (1.0 * totalElements / rowPerPage - 1).ceil();
    }
    if (page < 1) {
      page = 0;
    }
    var response5;
    if (findGVHD == "") {
      response5 = await httpGet("/api/sinh-vien-thuc-tap/get/page?size=$rowPerPage&page=$page&filter=idKhtt:${selectedKHTT.id ?? 0} and giaoVien.idNguoiDung:$idgv&sort=status", context);
    } else {
      response5 = await httpGet("/api/sinh-vien-thuc-tap/get/page?size=$rowPerPage&page=$page&filter=idKhtt:${selectedKHTT.id ?? 0} and giaoVien.idNguoiDung:$idgv and $findGVHD&sort=status", context);
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
  TextEditingController lop = TextEditingController();

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
  callApi(int idgv) async {
    setState(() {
      statusData = false;
    });
    getData(0, findGVHD, idgv);
    setState(() {
      statusData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      var securityModel = Provider.of<SecurityModel>(context, listen: false);
      selectedKHTT = securityModel.khttNow;
      callApi(securityModel.user.id!);
    });
  }

  @override
  void dispose() {
    ten.dispose();
    maSV.dispose();
    lop.dispose();
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
                                        hintMaxLines: 1,
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
                                        lop.text = "";
                                        selectedCSTT = Company(id: null, name: "--Chọn--");
                                        selectedTrangThai = -1;
                                        selectedNganh = -1;
                                        findGVHD = "";
                                      });
                                      callApi(user.user.id!);
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
                                                child: TextFieldValidatedForm(
                                                  type: 'None',
                                                  height: 40,
                                                  controller: lop,
                                                  label: 'Lớp:',
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
                                                  margin: EdgeInsets.only(left: 20, right: 10),
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
                                                      callApi(user.user.id!);
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
                                                        selectedCSTT = Company(id: null, name: "--Chọn--");
                                                        selectedTrangThai = -1;
                                                        selectedNganh = -1;
                                                        findGVHD = "";
                                                      });
                                                      callApi(user.user.id!);
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
                                                    onPressed: () async {},
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
                                        DataColumn(label: Text('Cơ sở thực tập', style: textDataColumn)),
                                        DataColumn(label: Text('Trạng thái', style: textDataColumn)),
                                        DataColumn(label: Text('Nhật ký TT', style: textDataColumn)),
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
                                              DataCell(SizedBox(width: 300, child: Text((listData[i].doanhNghiep != null) ? listData[i].doanhNghiep!.name ?? "" : "", style: textDataRow))),
                                              DataCell(Text("${(listData[i].status != null) ? listTrangthai[listData[i].status] : ""}", style: textDataRow)),
                                              DataCell(Text("${listData[i].countNTT} bản ghi", style: textDataRow)),
                                              DataCell(Row(
                                                children: [
                                                  Container(
                                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: InkWell(
                                                          onTap: () {
                                                            Navigator.push<void>(
                                                              context,
                                                              MaterialPageRoute<void>(
                                                                builder: (BuildContext context) => ThongTinSinhVienGV(
                                                                  data: listData[i],
                                                                  callback: (value) {
                                                                    setState(() {
                                                                      listData[i] = value;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Icon(Icons.visibility))),
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
                                            getData(page - 1, findGVHD, user.user.id!);
                                            currentPage = page - 1;
                                          });
                                        },
                                        rowPerPageChangeHandler: (rowPerPage) {
                                          setState(() {
                                            this.rowPerPage = rowPerPage!;
                                            firstRow = page * currentPage;
                                            getData(0, findGVHD, user.user.id!);
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
