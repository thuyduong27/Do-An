// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:fe_web/views/common/loadApi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../controllers/api.dart';
import '../../../../../models/nhat-ky-thuc-tap.dart';
import '../../../../../models/sinh-vien.dart';
import '../../../../common/style.dart';

class NhatKyThucTap extends StatefulWidget {
  SinhVien data;
  NhatKyThucTap({Key? key, required this.data}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<NhatKyThucTap> {
  bool satatusData = false;
  
  List<NhatKyTT> listNhatKyTT = [];
  Future<List<NhatKyTT>> getNhatKyTT() async {
    var responseThongBao = await httpGet("/api/nhat-ky-thuc-tap/get/page?filter=idSv:${widget.data.id} and status:1&sort=id", context);
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
    getNhatKyTT();
    setState(() {
      satatusData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> processing() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    return (satatusData)
        ? Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
              color: white,
              borderRadius: borderRadiusContainer,
              boxShadow: [boxShadowContainer],
              border: borderAllContainerBox,
            ),
            child: ListView(
              controller: ScrollController(),
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 1400,
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
                            Expanded(flex: 2, child: Text('File đính kèm', style: textDataColumn)),
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
                                          flex: 2,
                                          child: (listNhatKyTT[i].file != null && listNhatKyTT[i].file != "")
                                              ? Tooltip(
                                                  message: "Tải file đính kèm",
                                                  child: IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        Icons.download,
                                                        color: mainColor,
                                                        size: 25,
                                                      )))
                                              : Container()),
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
            ),
          )
        : CommonApp().loadingCallAPi();
  }
}
