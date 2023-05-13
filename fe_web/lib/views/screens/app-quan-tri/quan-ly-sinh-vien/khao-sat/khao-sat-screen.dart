// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, unused_local_variable, curly_braces_in_flow_control_structures, sort_child_properties_last, use_build_context_synchronously, unnecessary_import, deprecated_member_use, unnecessary_new

import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe_web/models/khao-sat.dart';
import 'package:fe_web/views/common/loadApi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:fe_web/models/ke-hoach-thuc-tap.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:http/http.dart' as http;

import '../../../../../confing.dart';
import '../../../../../controllers/api.dart';
import '../../../../../controllers/provider.dart';
import '../../../../common/footer.dart';
import '../../../../common/header-admin.dart';
import '../../../../common/phan-trang.dart';
import '../../../../common/text-file.dart';
import '../../../../common/title_page.dart';
import '../../../../common/toast.dart';
import 'sua-khao-sat.dart';
import 'them-moi-khao-sat.dart';
import 'xem-khao-sat.dart';

class KhaoSatScreen extends StatefulWidget {
  KhaoSatScreen({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<KhaoSatScreen> {
  var page = 1;
  var rowPerPage = 10;
  var totalElements = 0;
  var firstRow = 1, lastRow = 0;
  var rowCount = 0;
  var currentPage = 1;
  var tableIndex = 1;
  List<KhaoSat> listData = [];
  String findGVHD = "";

  Future<List<KhaoSat>> getData(int page, String findGVHD) async {
    if (page * rowPerPage > totalElements) {
      page = (1.0 * totalElements / rowPerPage - 1).ceil();
    }
    if (page < 1) {
      page = 0;
    }
    var response5;
    if (findGVHD == "") {
      response5 = await httpGet("/api/khao-sat/get/page?filter=idKhtt:${selectedKHTT.id ?? 0}&size=$rowPerPage&page=$page&sort=status", context);
    } else {
      response5 = await httpGet("/api/khao-sat/get/page?filter=idKhtt:${selectedKHTT.id ?? 0} and $findGVHD&size=$rowPerPage&page=$page&sort=status", context);
    }
    if (response5.containsKey("body")) {
      setState(() {
        var resultLPV = jsonDecode(response5["body"]);
        var content = [];
        listData = [];
        currentPage = page + 1;
        content = resultLPV['result']['content'];
        listData = content.map((e) {
          return KhaoSat.fromJson(e);
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

  Map<int, String> listTrangthai = {
    -1: 'Tất cả',
    0: 'Đang khảo sát',
    1: 'Đã khảo sát',
    2: 'Huỷ',
  };
  int selectedTrangThai = -1;

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
                        content: 'Khảo sát  ',
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
                                        selectedTrangThai = -1;
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
                                                  label: 'Tiêu đề:',
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
                                                        selectedTrangThai = -1;
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
                                                          builder: (BuildContext context) => ThemMoiKhaoSat(
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
                                        DataColumn(label: Text('Tiêu đề', style: textDataColumn)),
                                        DataColumn(label: Text('Thời hạn', style: textDataColumn)),
                                        DataColumn(label: Text('Tiến độ', style: textDataColumn)),
                                        DataColumn(label: Text('Trạng thái', style: textDataColumn)),
                                        DataColumn(label: Text('Hành động', style: textDataColumn)),
                                      ], rows: <DataRow>[
                                        for (var i = 0; i < listData.length; i++)
                                          DataRow(
                                            cells: [
                                              DataCell(Text("${tableIndex + i}", style: textDataRow)),
                                              DataCell(Text("${listData[i].tilte}", style: textDataRow)),
                                              DataCell(Text((listData[i].deadline != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(listData[i].deadline!)) : "", style: textDataRow)),
                                              DataCell(Text("${listData[i].soluongKS}/${listData[i].soluongSV}", style: textDataRow)),
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
                                                                builder: (BuildContext context) => XemKhaoSat(
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
                                                              builder: (BuildContext context) => SuaKhaoSat(
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
                                                                              'Xác nhận xóa khảo sát',
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
                                                                          Text("Xoá ${listData[i].tilte}"),
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
                                                                        onPressed: () async {
                                                                          await httpDelete("/api/khao-sat/del/${listData[i].id}", context);
                                                                          Navigator.pop(context);
                                                                          showToast(
                                                                            context: context,
                                                                            msg: "Đã xoá khảo sát",
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
