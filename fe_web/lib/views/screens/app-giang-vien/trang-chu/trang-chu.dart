// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'package:fe_web/controllers/api.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/ke-hoach-thuc-tap.dart';
import '../../../../models/sinh-vien.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/text-file.dart';
import '../../../common/title_page.dart';
import '../../../common/toast.dart';

class TrangChuGVScreen extends StatefulWidget {
  TrangChuGVScreen({Key? key}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<TrangChuGVScreen> {
  bool statusData = false;
  int soLg = 0;
  KeHoachThucTap selectedKHTT = KeHoachThucTap(id: 0, tilte: "");
  getData(int idgv) async {
    var response5 = await httpGet("/api/sinh-vien-thuc-tap/get/page?filter=idKhtt:${selectedKHTT.id ?? 0} and giaoVien.idNguoiDung:$idgv", context);
    if (response5.containsKey("body")) {
      setState(() {
        var resultLPV = jsonDecode(response5["body"]);
        soLg = resultLPV['result']['totalElements'];
      });
    } else {
      throw Exception('Không có data');
    }
  }

  callApi(int idgv) async {
    setState(() {
      statusData = false;
    });
    getData(idgv);
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
  Widget build(BuildContext context) {
    return Header(
        widgetBody: Consumer<SecurityModel>(
      builder: (context, user, child) => Scaffold(
        body: Container(
          decoration: BoxDecoration(color: colorPage),
          child: ListView(
            controller: ScrollController(),
            children: [
              TitlePage(
                  listPreTitle: [],
                  content: 'Trang chủ',
                  widgetBoxRight: Container(
                    margin: EdgeInsets.only(top: 15),
                    // decoration: BoxDecoration(color: Colors.amber),
                    child: Row(),
                  )),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1.2,
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
                      keHoachThucTapWidget(),
                    ],
                  )),
              Footer()
            ],
          ),
        ),
      ),
    ));
  }

  keHoachThucTapWidget() {
    return Consumer<SecurityModel>(
      builder: (context, user, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [Text("Kế hoạch thực tập hiện tại", style: titleContainerBox)],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Tooltip(
                  verticalOffset: 0,
                  message: user.khttNow.tilte,
                  child: TextFieldValidatedForm(
                    type: 'None',
                    height: 40,
                    controller: TextEditingController(text: user.khttNow.tilte),
                    label: "Tiêu đề: ",
                    flexLable: 2,
                    enabled: false,
                  ),
                ),
              ),
              SizedBox(width: 100),
              Expanded(
                flex: 3,
                child: TextFieldValidatedForm(
                  controller: TextEditingController(text: "$soLg sinh viên"),
                  type: 'None',
                  height: 40,
                  label: "Quản lý: ",
                  flexLable: 2,
                  enabled: false,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Tooltip(
                  verticalOffset: 0,
                  message: DateFormat('dd-MM-yyyy').format(DateTime.parse(user.khttNow.startDate!)),
                  child: TextFieldValidatedForm(
                    type: 'None',
                    height: 40,
                    controller: TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.parse(user.khttNow.startDate!))),
                    label: "Ngày bắt đầu: ",
                    flexLable: 2,
                    enabled: false,
                  ),
                ),
              ),
              SizedBox(width: 100),
              Expanded(
                flex: 3,
                child: Tooltip(
                  verticalOffset: 0,
                  message: DateFormat('dd-MM-yyyy').format(DateTime.parse(user.khttNow.endDate!)),
                  child: TextFieldValidatedForm(
                    type: 'None',
                    height: 40,
                    controller: TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.parse(user.khttNow.endDate!))),
                    label: "Ngày kết thúc: ",
                    flexLable: 2,
                    enabled: false,
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
                child: Tooltip(
                  verticalOffset: 0,
                  message: (user.khttNow.hanDangKy != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.khttNow.hanDangKy!)) : "",
                  child: TextFieldValidatedForm(
                    type: 'None',
                    height: 40,
                    controller: TextEditingController(text: (user.khttNow.hanDangKy != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.khttNow.hanDangKy!)) : ""),
                    label: "Hạn đăng ký: ",
                    flexLable: 2,
                    enabled: false,
                  ),
                ),
              ),
              SizedBox(width: 100),
              Expanded(
                flex: 3,
                child: Tooltip(
                  verticalOffset: 0,
                  message: (user.khttNow.hanNopBaoCao != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.khttNow.hanNopBaoCao!)) : "",
                  child: TextFieldValidatedForm(
                    type: 'None',
                    height: 40,
                    controller: TextEditingController(text: (user.khttNow.hanNopBaoCao != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.khttNow.hanNopBaoCao!)) : ""),
                    label: "Hạn nộp báo cáo: ",
                    flexLable: 2,
                    enabled: false,
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
                child: Tooltip(
                  verticalOffset: 0,
                  message: (user.khttNow.ngayDiThuctap != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.khttNow.ngayDiThuctap!)) : "",
                  child: TextFieldValidatedForm(
                    type: 'None',
                    height: 40,
                    controller: TextEditingController(text: (user.khttNow.ngayDiThuctap != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.khttNow.ngayDiThuctap!)) : ""),
                    label: "Ngày đi thực tập: ",
                    flexLable: 2,
                    enabled: false,
                  ),
                ),
              ),
              SizedBox(width: 100),
              Expanded(
                flex: 3,
                child: Tooltip(
                  verticalOffset: 0,
                  message: (user.khttNow.ngayHetThuctap != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.khttNow.ngayHetThuctap!)) : "",
                  child: TextFieldValidatedForm(
                    type: 'None',
                    height: 40,
                    controller: TextEditingController(text: (user.khttNow.ngayHetThuctap != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.khttNow.ngayHetThuctap!)) : ""),
                    label: "Ngày hết thực tập: ",
                    flexLable: 2,
                    enabled: false,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(flex: 3, child: Container()),
              SizedBox(width: 100),
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "File đính kèm",
                          style: titleContainerBox,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: OutlinedButton(
                          child: Text("Tải"),
                          onPressed: () async {
                            if (user.khttNow.fileDanhSach != null && user.khttNow.fileDanhSach != "") {
                              downloadFile("fileName");
                            } else {
                              showToast(
                                context: context,
                                msg: "Không có file đính kèm",
                                color: Color.fromRGBO(245, 117, 29, 1),
                                icon: const Icon(Icons.info),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Text("Nội dung kế hoạch thực tập: ", style: titleContainerBox),
          SizedBox(height: 10),
          TextField(
            maxLines: 20,
            minLines: 3,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            controller: TextEditingController(text: user.khttNow.content ?? ""),
            enabled: false,
          ),
        ],
      ),
    );
  }
}
