// ignore_for_file: file_names, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_typing_uninitialized_variables, prefer_const_constructors, dead_code, sort_child_properties_last, unused_local_variable, use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:fe_web/views/common/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/ke-hoach-thuc-tap.dart';
import '../../../common/date-pick-time.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/phan-trang.dart';
import '../../../common/text-file.dart';
import '../../../common/title_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../common/toast.dart';
import 'sua-khtt.dart';
import 'them-khtt.dart';

class KeHoachThucTapScreen extends StatefulWidget {
  KeHoachThucTapScreen({Key? key}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<KeHoachThucTapScreen> {
  var page = 1;
  var rowPerPage = 10;
  var totalElements = 0;
  var firstRow = 1, lastRow = 0;
  var rowCount = 0;
  var currentPage = 1;
  var tableIndex = 1;
  List<KeHoachThucTap> listKeHoachThucTap = [];
  late Future<List<KeHoachThucTap>> getListKeHoachThucTap;
  String findKeHoachThucTap = "";

  Future<List<KeHoachThucTap>> getKeHoachThucTap(int page, String findKeHoachThucTap) async {
    if (page * rowPerPage > totalElements) {
      page = (1.0 * totalElements / rowPerPage - 1).ceil();
    }
    if (page < 1) {
      page = 0;
    }
    var response5;
    if (findKeHoachThucTap == "") {
      response5 = await httpGet("/api/ke-hoach-thuc-tap/get/page?sort=status&size=$rowPerPage&page=$page", context);
    } else {
      response5 = await httpGet("/api/ke-hoach-thuc-tap/get/page?filter=$findKeHoachThucTap&sort=status&size=$rowPerPage&page=$page", context);
    }
    var content = [];
    if (response5.containsKey("body")) {
      setState(() {
        var resultLPV = jsonDecode(response5["body"]);
        listKeHoachThucTap = [];
        currentPage = page + 1;
        content = resultLPV['result']['content'];
        listKeHoachThucTap = content.map((e) {
          return KeHoachThucTap.fromJson(e);
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
      return listKeHoachThucTap;
    } else {
      throw Exception('Không có data');
    }
  }

  int selectedHopDong = 0;
  Map<int, String> listTrangthai = {
    -1: 'Tất cả',
    0: 'Đang thực hiện',
    1: 'Hoàn thành',
    2: 'Huỷ',
  };
  int selectedTrangThai = -1;
  var time1;
  var time2;

  //tìm kiếm
  bool showMenuFind = true;
  TextEditingController tieuDe = TextEditingController();

  @override
  void initState() {
    super.initState();
    getListKeHoachThucTap = getKeHoachThucTap(0, findKeHoachThucTap);
  }

  void dispose() {
    tieuDe.dispose();
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
                content: 'Kế hoạch thực tập',
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
                                            controller: tieuDe,
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: DatePickerBox1(
                                              requestDayBefore: time2,
                                              isTime: false,
                                              label: Text(
                                                'Từ ngày:',
                                                style: titleContainerBox,
                                              ),
                                              dateDisplay: time1,
                                              selectedDateFunction: (day) {
                                                time1 = day;
                                                setState(() {});
                                              }),
                                        ),
                                        SizedBox(width: 100),
                                        Expanded(
                                          flex: 3,
                                          child: DatePickerBox1(
                                              requestDayAfter: time1,
                                              isTime: false,
                                              label: Text(
                                                'Đến ngày:',
                                                style: titleContainerBox,
                                              ),
                                              dateDisplay: time1,
                                              selectedDateFunction: (day) {
                                                time2 = day;
                                                print(day);
                                                setState(() {});
                                              }),
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
                                                findKeHoachThucTap = "";
                                                var findTieuDe = "";
                                                if (tieuDe.text != "") {
                                                  findTieuDe = "and tilte~'*${tieuDe.text}*' ";
                                                } else
                                                  findTieuDe = "";
                                                // if (address.text != "") {
                                                //   findAddress = "and address~'*${address.text}*' ";
                                                // } else
                                                //   findAddress = "";
                                                // if (mst.text != "") {
                                                //   findMst = "and mst~'*${mst.text}*' ";
                                                // } else
                                                //   findMst = "";
                                                // if (manager.text != "") {
                                                //   findManager = "and manager~'*${manager.text}*' ";
                                                // } else
                                                //   findManager = "";
                                                findKeHoachThucTap = findTieuDe;
                                                if (findKeHoachThucTap != "") if (findKeHoachThucTap.substring(0, 3) == "and") findKeHoachThucTap = findKeHoachThucTap.substring(4);
                                                // print(findKeHoachThucTap);
                                                getKeHoachThucTap(0, findKeHoachThucTap);
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
                                                  tieuDe.text = "";
                                                  selectedTrangThai = -1;
                                                  findKeHoachThucTap = "";
                                                  time1 = null;
                                                  time2 = null;
                                                });
                                                getKeHoachThucTap(0, findKeHoachThucTap);
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
                                                    builder: (BuildContext context) => ThemMoiKHTT(
                                                      callbackChange: (value) {
                                                        statusChange = value;
                                                      },
                                                    ),
                                                  ),
                                                );
                                                if (statusChange) {
                                                  getKeHoachThucTap(0, "");
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
                              FutureBuilder<dynamic>(
                                future: getListKeHoachThucTap,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(showCheckboxColumn: false, columnSpacing: 30, border: TableBorder.all(color: colorPage), columns: [
                                        DataColumn(label: Text('STT', style: textDataColumn)),
                                        DataColumn(label: Text('Tên doanh nghiệp', style: textDataColumn)),
                                        DataColumn(label: Text('Ngày bắt đầu', style: textDataColumn)),
                                        DataColumn(label: Text('Ngày kết thúc', style: textDataColumn)),
                                        DataColumn(label: Text('Trạng thái', style: textDataColumn)),
                                        // DataColumn(label: Text('Địa chỉ', style: textDataColumn)),
                                        // DataColumn(label: Text('Mã số thuế', style: textDataColumn)),
                                        // DataColumn(label: Text('Hợp đồng', style: textDataColumn)),
                                        DataColumn(label: Text('Hành động', style: textDataColumn)),
                                      ], rows: <DataRow>[
                                        for (var i = 0; i < listKeHoachThucTap.length; i++)
                                          DataRow(
                                            cells: [
                                              DataCell(Text("${tableIndex + i}", style: textDataRow)),
                                              DataCell(SizedBox(width: 500,child: Text("${listKeHoachThucTap[i].tilte}", style: textDataRow))),
                                              DataCell(Text((listKeHoachThucTap[i].startDate != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(listKeHoachThucTap[i].startDate!)) : "", style: textDataRow)),
                                              DataCell(Text((listKeHoachThucTap[i].endDate != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(listKeHoachThucTap[i].endDate!)) : "", style: textDataRow)),
                                              DataCell(Text(
                                                  (listKeHoachThucTap[i].status == 1)
                                                      ? "Hoàn Thành"
                                                      : (listKeHoachThucTap[i].status == 2)
                                                          ? "Huỷ"
                                                          : (listKeHoachThucTap[i].status == 0)
                                                              ? "Đang thực hiện"
                                                              : "",
                                                  style: textDataRow)),
                                              // DataCell(SizedBox(width: 300, child: Text("${listKeHoachThucTap[i].address}", style: textDataRow))),
                                              // DataCell(Text("${(listKeHoachThucTap[i].mst != null) ? listKeHoachThucTap[i].mst : ""}", style: textDataRow)),
                                              // DataCell(Text((listKeHoachThucTap[i].hopDong ==true) ? "Có" : "Không ", style: textDataRow)),
                                              DataCell(Row(
                                                children: [
                                                  Container(
                                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: InkWell(
                                                          onTap: () {
                                                            // Navigator.push<void>(
                                                            //   context,
                                                            //   MaterialPageRoute<void>(
                                                            //     builder: (BuildContext context) => XemKeHoachThucTap(
                                                            //       KeHoachThucTap: listKeHoachThucTap[i],
                                                            //     ),
                                                            //   ),
                                                            // );
                                                          },
                                                          child: Icon(Icons.visibility))),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                    child: InkWell(
                                                        onTap: () {
                                                          Navigator.push<void>(
                                                            context,
                                                            MaterialPageRoute<void>(
                                                              builder: (BuildContext context) => SuaKHTT(
                                                                keHoachThucTap: listKeHoachThucTap[i],
                                                                callbackChange: (value) {
                                                                  setState(() {
                                                                    listKeHoachThucTap[i] = value;
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
                                                                              'Xác nhận xóa kế hoạch thực tập',
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
                                                                    content: SizedBox(
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
                                                                          Text("Xoá ${listKeHoachThucTap[i].tilte}"),
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
                                                                          var response = await httpDelete("/api/ke-hoach-thuc-tap/del/${listKeHoachThucTap[i].id}", context);
                                                                          print(response);
                                                                          Navigator.pop(context);
                                                                          showToast(
                                                                            context: context,
                                                                            msg: "Đã xoá kế hoạch thực tập",
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
                                                          getKeHoachThucTap(0, findKeHoachThucTap);
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
                                      getKeHoachThucTap(page - 1, findKeHoachThucTap);
                                      currentPage = page - 1;
                                    });
                                  },
                                  rowPerPageChangeHandler: (rowPerPage) {
                                    setState(() {
                                      this.rowPerPage = rowPerPage!;
                                      firstRow = page * currentPage;
                                      getKeHoachThucTap(0, findKeHoachThucTap);
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
