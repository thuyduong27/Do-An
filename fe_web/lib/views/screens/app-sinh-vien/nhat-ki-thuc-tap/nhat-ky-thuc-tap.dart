// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'package:fe_web/views/common/loadApi.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/nhat-ky-thuc-tap.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/title_page.dart';
import 'sua-nhat-ky-tt.dart';
import 'them-nhat-ky-tt.dart';

class NhatKyTTScreen extends StatefulWidget {
  // final SinhVien myProvider;
  NhatKyTTScreen({Key? key}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<NhatKyTTScreen> {
  bool statusData = false;
  SecurityModel? myProvider;
  List<NhatKyTT> listNhatKyTT = [];
  Future<List<NhatKyTT>> getNhatKyTT() async {
    myProvider = Provider.of<SecurityModel>(context, listen: false);
    var idSV = myProvider!.sinhVien.id;
    var responseThongBao = await httpGet("/api/nhat-ky-thuc-tap/get/page?filter=idSv:$idSV and status:1&sort=id", context);
    listNhatKyTT = [];
    if (responseThongBao.containsKey("body")) {
      setState(() {
        var body = jsonDecode(responseThongBao['body']);
        var content = [];
        content = body['result']['content'];
        listNhatKyTT = content.map((e) {
          return NhatKyTT.fromJson(e);
        }).toList();
      });
    }
    return listNhatKyTT;
  }

  callApi() async {
    setState(() {
      statusData = false;
    });
    await getNhatKyTT();
    setState(() {
      statusData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      callApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Header(widgetBody: Consumer<SecurityModel>(builder: (context, user, child) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(color: colorPage),
          child: (statusData)
              ? ListView(
                  controller: ScrollController(),
                  children: [
                    TitlePage(
                      listPreTitle: [],
                      content: 'Nhật ký thực tập',
                      widgetBoxRight: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: TextButton(
                          onPressed: () async {
                            bool statusChange = false;
                            await Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => ThemMoiNKTT(
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
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).iconTheme.color,
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 40.0,
                            ),
                            backgroundColor: mainColor,
                            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                          ),
                          child: Row(
                            children: [
                              Text('Thêm mới', style: textBtnWhite),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.8,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: borderRadiusContainer,
                          boxShadow: [boxShadowContainer],
                          border: borderAllContainerBox,
                        ),
                        padding: paddingBoxContainer,
                        child: ListView(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: 1500,
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(flex: 1, child: Text('Tuần', style: textDataColumn)),
                                        SizedBox(width: 15),
                                        Expanded(flex: 2, child: Text('Từ ngày', style: textDataColumn)),
                                        SizedBox(width: 15),
                                        Expanded(flex: 2, child: Text('Đến ngày', style: textDataColumn)),
                                        SizedBox(width: 15),
                                        Expanded(flex: 4, child: Text('Nội dung thực tập', style: textDataColumn)),
                                        SizedBox(width: 15),
                                        Expanded(flex: 4, child: Text('Kết quả đạt được', style: textDataColumn)),
                                        SizedBox(width: 15),
                                        Expanded(flex: 2, child: Text('Ghi chú', style: textDataColumn)),
                                        SizedBox(width: 15),
                                        Expanded(flex: 1, child: Text('Hành động', style: textDataColumn)),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 1,
                                      color: colorPage,
                                    ),
                                    if (listNhatKyTT.isNotEmpty)
                                      for (var i = 0; i < listNhatKyTT.length; i++)
                                        Container(
                                          margin: EdgeInsets.only(top: 15, bottom: 15),
                                          padding: EdgeInsets.only(bottom: 15),
                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color.fromARGB(255, 234, 234, 234)))),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Expanded(flex: 1, child: Text(listNhatKyTT[i].name ?? "", style: textDataRow)),
                                                  SizedBox(width: 15),
                                                  Expanded(flex: 2, child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(listNhatKyTT[i].startDate!)), style: textDataRow)),
                                                  SizedBox(width: 15),
                                                  Expanded(flex: 2, child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(listNhatKyTT[i].endDate!)), style: textDataRow)),
                                                  SizedBox(width: 15),
                                                  Expanded(flex: 4, child: Text(listNhatKyTT[i].content ?? "", style: textDataRow)),
                                                  SizedBox(width: 15),
                                                  Expanded(flex: 4, child: Text(listNhatKyTT[i].ketQua ?? "", style: textDataRow)),
                                                  SizedBox(width: 15),
                                                  Expanded(flex: 2, child: Text(listNhatKyTT[i].ghiChu ?? "", style: textDataRow)),
                                                  SizedBox(width: 15),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                      child: InkWell(
                                                          onTap: () {
                                                            Navigator.push<void>(
                                                              context,
                                                              MaterialPageRoute<void>(
                                                                builder: (BuildContext context) => SuaNKTT(
                                                                  data: listNhatKyTT[i],
                                                                  callbackChange: (value) {
                                                                    setState(() {
                                                                      listNhatKyTT[i] = value;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Icon(Icons.edit_calendar, color: mainColor)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "Lần sửa đổi gần nhất: ${(listNhatKyTT[i].modifiedDate != null) ? DateFormat('HH:ss a dd-MM-yyyy').format(DateTime.parse(listNhatKyTT[i].modifiedDate!).toLocal()) : ""}",
                                                    style: textCardContentBlue,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    Footer()
                  ],
                )
              : CommonApp().loadingCallAPi(),
        ),
      );
    }));
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
