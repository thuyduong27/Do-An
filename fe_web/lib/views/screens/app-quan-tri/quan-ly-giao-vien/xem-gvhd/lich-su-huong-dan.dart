// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:convert';

import 'package:fe_web/models/ke-hoach-thuc-tap.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../controllers/api.dart';
import '../../../../../models/gvhd.dart';

class LichSuHuongDan extends StatefulWidget {
  GVHD gvhd;
  LichSuHuongDan({Key? key, required this.gvhd}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<LichSuHuongDan> {
  late GVHD data;
  List<KeHoachThucTap> listKeHoachThucTap = [];
  Future<List<KeHoachThucTap>> getData() async {
    var response5 = await httpGet("/api/giao-vien/get/page?&filter=status:1 and idNguoiDung:${data.id}&sort=idKhtt,desc", context);

    var content = [];
    if (response5.containsKey("body")) {
      setState(() {
        var resultLPV = jsonDecode(response5["body"]);
        listKeHoachThucTap = [];
        content = resultLPV['result']['content'];
        listKeHoachThucTap = content.map((e) {
          return KeHoachThucTap.fromJson(e['keHoachThucTap']);
        }).toList();
      });
      return listKeHoachThucTap;
    } else {
      throw Exception('Không có data');
    }
  }

  Map<int, String> listTrangthai = {
    0: 'Hoạt động',
    1: 'Hoàn thành',
    2: 'Dừng hoạt động',
  };

  @override
  void initState() {
    super.initState();
    data = widget.gvhd;
    getData();
  }

  @override
  void dispose() {
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

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      width: MediaQuery.of(context).size.width * 1,
      decoration: BoxDecoration(
        color: white,
        borderRadius: borderRadiusContainer,
        boxShadow: [boxShadowContainer],
        border: borderAllContainerBox,
      ),
      padding: paddingBoxContainer,
      child: ListView(
        controller: ScrollController(),
        children: [
          for (var element in listKeHoachThucTap)
            TextButton(
              onPressed: () {},
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10),
                height: 100,
                decoration: BoxDecoration(
                  color: colorPage,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [boxShadowContainer],
                ),
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Text(
                      "${element.tilte}",
                      style: textBtnTopic,
                      overflow: TextOverflow.clip,
                    )),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(child: Text("Trạng thái: ${listTrangthai[element.status]}", style: textDataRow)),
                        Expanded(child: Text("Số lượng hướng dẫn: 0", style: textDataRow)),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Expanded(child: Text((element.startDate != null) ? "Ngày bắt đầu: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(element.startDate!))}" : "", style: textDataRow)), Expanded(child: Text((element.endDate != null) ? "Ngày kết thúc: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(element.endDate!))}" : "", style: textDataRow))],
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
