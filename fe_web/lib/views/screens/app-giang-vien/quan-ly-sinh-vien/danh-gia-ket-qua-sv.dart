// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, unused_local_variable, use_build_context_synchronously

import 'dart:convert';

import 'package:fe_web/views/common/loadApi.dart';
import 'package:flutter/material.dart';
import '../../../../../controllers/api.dart';
import '../../../../../models/sinh-vien.dart';
import '../../../../models/danh-gia-ket-qua.dart';
import '../../../common/style.dart';
import '../../../common/text-file.dart';
import '../../../common/toast.dart';

class DanhGiaVaKetQua extends StatefulWidget {
  SinhVien data;
  Function? callback;
  DanhGiaVaKetQua({Key? key, required this.data, this.callback}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<DanhGiaVaKetQua> {
  TextEditingController nguoiDanhGiaOne = TextEditingController();
  TextEditingController donViOne = TextEditingController();
  TextEditingController hocViOne = TextEditingController();
  TextEditingController nguoiDanhGiaTwo = TextEditingController();
  TextEditingController donViTwo = TextEditingController();
  TextEditingController hocViTwo = TextEditingController();
  TextEditingController diemOneOne = TextEditingController();
  TextEditingController diemTwoOne = TextEditingController();
  TextEditingController diemOneTwo = TextEditingController();
  TextEditingController diemTwoTwo = TextEditingController();
  TextEditingController diemOneThree = TextEditingController();
  TextEditingController diemTwoThree = TextEditingController();

  bool satatusData = false;
  List<DanhGiaKetQua> listDanhGiaKetQua = [];
  DanhGiaKetQua danhGiaKetQua = DanhGiaKetQua();
  Future<DanhGiaKetQua> getDanhGiaKetQua() async {
    var responseThongBao = await httpGet("/api/danh-gia-ket-qua/get/page?filter=idSinhVien:${widget.data.id} &sort=id", context);
    if (responseThongBao.containsKey("body")) {
      setState(() {
        var body = jsonDecode(responseThongBao['body']);
        var content = [];
        content = body['result']['content'];
        listDanhGiaKetQua = content.map((e) {
          return DanhGiaKetQua.fromJson(e);
        }).toList();
        if (listDanhGiaKetQua.isNotEmpty) {
          print(listDanhGiaKetQua.first.toJson());
          danhGiaKetQua = listDanhGiaKetQua.first;
        }
      });
    }
    return danhGiaKetQua;
  }

  bool edit = false;

  callApi() async {
    await getDanhGiaKetQua();
    if (danhGiaKetQua.id != null) {
      nguoiDanhGiaOne.text = danhGiaKetQua.nguoiDanhGiaOne ?? "";
      donViOne.text = danhGiaKetQua.donViOne ?? "";
      hocViOne.text = danhGiaKetQua.hocViOne ?? "";
      nguoiDanhGiaTwo.text = danhGiaKetQua.nguoiDanhGiaTwo ?? "";
      donViTwo.text = danhGiaKetQua.donViTwo ?? "";
      hocViTwo.text = danhGiaKetQua.hocViTwo ?? "";
      diemOneOne.text = (danhGiaKetQua.diemOneOne != null) ? danhGiaKetQua.diemOneOne.toString() : "";
      diemTwoOne.text = (danhGiaKetQua.diemTwoOne != null) ? danhGiaKetQua.diemTwoOne.toString() : "";
      diemOneTwo.text = (danhGiaKetQua.diemOneTwo != null) ? danhGiaKetQua.diemOneTwo.toString() : "";
      diemTwoTwo.text = (danhGiaKetQua.diemTwoTwo != null) ? danhGiaKetQua.diemTwoTwo.toString() : "";
    }
    setState(() {
      satatusData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.data.status == 5) edit = false;
    callApi();
  }

  @override
  void dispose() {
    nguoiDanhGiaOne.dispose();
    donViOne.dispose();
    hocViOne.dispose();
    nguoiDanhGiaTwo.dispose();
    donViTwo.dispose();
    hocViTwo.dispose();
    // nguoiDanhGiaThree.dispose();
    // donViThree.dispose();
    // hocViThree.dispose();
    diemOneOne.dispose();
    diemTwoOne.dispose();
    diemOneTwo.dispose();
    diemTwoTwo.dispose();
    // diemOneThree.dispose();
    // diemTwoThree.dispose();
    super.dispose();
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
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            child: ListView(
              controller: ScrollController(),
              children: [
                (widget.data.status! < 5)
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("Sinh viên chưa nộp báo cáo", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: red))],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width * 1,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: borderRadiusContainer,
                          boxShadow: [boxShadowContainer],
                          border: borderAllContainerBox,
                        ),
                        child: (edit == false)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Theme.of(context).iconTheme.color,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                        horizontal: 40.0,
                                      ),
                                      backgroundColor: mainColor,
                                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        edit = true;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Text('Cập nhật', style: textBtnWhite),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Theme.of(context).iconTheme.color,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                        horizontal: 40.0,
                                      ),
                                      backgroundColor: mainColor,
                                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        if (danhGiaKetQua.diemOne == null || danhGiaKetQua.diemTwo == null) {
                                          widget.data.status = 5;
                                          widget.data.diem = "";
                                        } else if ((danhGiaKetQua.diemOne! * 0.4 + danhGiaKetQua.diemTwo! * 0.6) > 4) {
                                          widget.data.status = 7;
                                          widget.data.diem = "${danhGiaKetQua.diemOne! * 0.4 + danhGiaKetQua.diemTwo! * 0.6}";
                                        } else {
                                          widget.data.status = 8;
                                          widget.data.diem = "${danhGiaKetQua.diemOne! * 0.4 + danhGiaKetQua.diemTwo! * 0.6}";
                                        }
                                      });
                                      await httpPut('/api/sinh-vien-thuc-tap/put/${widget.data.id}', widget.data.toJson(), context);
                                      showToast(
                                        context: context,
                                        msg: "Đã đánh giá sinh viên",
                                        color: Color.fromARGB(136, 72, 238, 67),
                                        icon: const Icon(Icons.done),
                                      );
                                      danhGiaKetQua.idSinhVien = widget.data.id;
                                      danhGiaKetQua.nguoiDanhGiaOne = nguoiDanhGiaOne.text;
                                      danhGiaKetQua.nguoiDanhGiaTwo = nguoiDanhGiaTwo.text;
                                      danhGiaKetQua.hocViOne = hocViOne.text;
                                      danhGiaKetQua.hocViTwo = hocViTwo.text;
                                      danhGiaKetQua.donViOne = donViOne.text;
                                      danhGiaKetQua.donViTwo = donViTwo.text;
                                      danhGiaKetQua.diemOneOne = int.tryParse(diemOneOne.text);
                                      danhGiaKetQua.diemTwoOne = int.tryParse(diemTwoOne.text);
                                      danhGiaKetQua.diemOneTwo = int.tryParse(diemOneTwo.text);
                                      danhGiaKetQua.diemTwoTwo = int.tryParse(diemTwoTwo.text);

                                      if (danhGiaKetQua.id == null) {
                                        var responseDG = await httpPost("/api/danh-gia-ket-qua/post", danhGiaKetQua.toJson(), context);
                                        print(responseDG);
                                        var bodyDG = jsonDecode(responseDG['body']);
                                        danhGiaKetQua.id = int.tryParse(bodyDG['result'].toString());
                                      } else {
                                        var responseDG = await httpPut("/api/danh-gia-ket-qua/put/${danhGiaKetQua.id}", danhGiaKetQua.toJson(), context);
                                        print("Cap nhat: ${danhGiaKetQua.id}");
                                      }

                                      setState(() {
                                        edit = false;
                                      });
                                      widget.callback!(widget.data);
                                    },
                                    child: Row(
                                      children: [
                                        Text('Lưu', style: textBtnWhite),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 30),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Theme.of(context).iconTheme.color,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                        horizontal: 40.0,
                                      ),
                                      backgroundColor: orange,
                                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        edit = false;
                                        widget.callback!(widget.data);
                                        if (danhGiaKetQua.id != null) {
                                          nguoiDanhGiaOne.text = danhGiaKetQua.nguoiDanhGiaOne ?? "";
                                          donViOne.text = danhGiaKetQua.donViOne ?? "";
                                          hocViOne.text = danhGiaKetQua.hocViOne ?? "";
                                          nguoiDanhGiaTwo.text = danhGiaKetQua.nguoiDanhGiaTwo ?? "";
                                          donViTwo.text = danhGiaKetQua.donViTwo ?? "";
                                          hocViTwo.text = danhGiaKetQua.hocViTwo ?? "";
                                          // nguoiDanhGiaThree.text = danhGiaKetQua.nguoiDanhGiaThree ?? "";
                                          // donViThree.text = danhGiaKetQua.donViThree ?? "";
                                          diemOneOne.text = danhGiaKetQua.diemOneOne.toString();
                                          diemTwoOne.text = danhGiaKetQua.diemTwoOne.toString();
                                          diemOneTwo.text = danhGiaKetQua.diemOneTwo.toString();
                                          diemTwoTwo.text = danhGiaKetQua.diemTwoTwo.toString();
                                          // diemOneThree.text = danhGiaKetQua.diemOneThree.toString();
                                          // diemTwoThree.text = danhGiaKetQua.diemTwoThree.toString();
                                          danhGiaKetQua.diemOne = danhGiaKetQua.diemOneOne! + danhGiaKetQua.diemTwoOne!;
                                          danhGiaKetQua.diemTwo = danhGiaKetQua.diemOneTwo! + danhGiaKetQua.diemTwoTwo!;
                                          // danhGiaKetQua.diemThree = danhGiaKetQua.diemOneThree! + danhGiaKetQua.diemTwoThree!;
                                        } else {
                                          nguoiDanhGiaOne.text = "";
                                          donViOne.text = "";
                                          hocViOne.text = "";
                                          nguoiDanhGiaTwo.text = "";
                                          donViTwo.text = "";
                                          hocViTwo.text = "";
                                          // nguoiDanhGiaThree.text = "";
                                          // donViThree.text = "";
                                          diemOneOne.text = "";
                                          diemTwoOne.text = "";
                                          diemOneTwo.text = "";
                                          diemTwoTwo.text = "";
                                          // diemOneThree.text = "";
                                          // diemTwoThree.text = "";
                                          danhGiaKetQua.diemOne = null;
                                          danhGiaKetQua.diemTwo = null;
                                          // danhGiaKetQua.diemThree = null;
                                        }
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Text('Huỷ', style: textBtnWhite),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: borderRadiusContainer,
                    boxShadow: [boxShadowContainer],
                    border: borderAllContainerBox,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Điểm đánh giá: ",
                                style: titleContainerBox,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: TextField(
                                enabled: false,
                                controller: TextEditingController(
                                  text: (danhGiaKetQua.diemOne != null && danhGiaKetQua.diemTwo != null)
                                      ? "${danhGiaKetQua.diemOne! * 0.4 + danhGiaKetQua.diemTwo! * 0.6} (${((danhGiaKetQua.diemOne! * 0.4 + danhGiaKetQua.diemTwo! * 0.6) > 8.5) ? "A" : ((danhGiaKetQua.diemOne! * 0.4 + danhGiaKetQua.diemTwo! * 0.6) > 7.7) ? "B+" : ((danhGiaKetQua.diemOne! * 0.4 + danhGiaKetQua.diemTwo! * 0.6) > 7) ? "B" : ((danhGiaKetQua.diemOne! * 0.4 + danhGiaKetQua.diemTwo! * 0.6) > 6.2) ? "C+" : ((danhGiaKetQua.diemOne! * 0.4 + danhGiaKetQua.diemTwo! * 0.6) > 5.5) ? "C" : ((danhGiaKetQua.diemOne! * 0.4 + danhGiaKetQua.diemTwo! * 0.6) > 4.7) ? "D+" : ((danhGiaKetQua.diemOne! * 0.4 + danhGiaKetQua.diemTwo! * 0.6) > 4) ? "D" : "F"})"
                                      : "",
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.fromLTRB(10, 7, 5, 0),
                                  filled: true,
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 100),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "File báo cáo: ",
                                style: titleContainerBox,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: OutlinedButton(
                                child: Text("Tải"),
                                onPressed: () async {
                                  if (widget.data.fileBaoCao != null && widget.data.fileBaoCao != "") {
                                    downloadFile(widget.data.fileBaoCao!);
                                  } else {
                                    showToast(
                                      context: context,
                                      msg: "Không có file báo cáo",
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
                    ],
                  ),
                ),
                (widget.data.nguoiDung!.nganh == 0 || widget.data.nguoiDung!.nganh == 1)
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("PHIẾU ĐIỂM HƯỚNG DẪN", style: textTitleMenu1),
                              ],
                            ),
                            SizedBox(height: 30),
                            Text("I. THÔNG TIN CHUNG", style: textTitleMenu2),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFieldValidatedForm(
                                    type: 'None',
                                    height: 40,
                                    controller: nguoiDanhGiaOne,
                                    label: 'Người đánh giá: ',
                                    flexLable: 2,
                                    enabled: edit,
                                  ),
                                ),
                                SizedBox(width: 100),
                                Expanded(
                                  flex: 3,
                                  child: TextFieldValidatedForm(
                                    type: 'None',
                                    height: 40,
                                    controller: hocViOne,
                                    label: 'Học hàm, học vị: ',
                                    flexLable: 2,
                                    enabled: edit,
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
                                    controller: donViOne,
                                    label: 'Đơn vị công tác: ',
                                    flexLable: 2,
                                    enabled: edit,
                                  ),
                                ),
                                SizedBox(width: 100),
                                Expanded(
                                  flex: 3,
                                  child: Container(),
                                ),
                              ],
                            ),
                            Text("II. ĐÁNH GIÁ (Điểm làm tròn đến 1 chữ số thập phân)", style: textTitleMenu2),
                            SizedBox(height: 30),
                            Center(
                              child: Table(
                                border: TableBorder.all(),
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FixedColumnWidth(60),
                                  1: FixedColumnWidth(90),
                                  2: FixedColumnWidth(90),
                                  3: FixedColumnWidth(100),
                                },
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                children: <TableRow>[
                                  TableRow(
                                    children: <Widget>[
                                      Center(child: Text('STT', style: textDataColumn)),
                                      Center(child: Text('  Mã\nCĐRHP', style: textDataColumn)),
                                      Center(child: Text('Điểm\ntối đa', style: textDataColumn)),
                                      Center(child: Text('  Điểm\nđánh giá', style: textDataColumn)),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      Center(child: Text('1', style: textDataRow)),
                                      Center(child: Text('L1', style: textDataRow)),
                                      Center(child: Text('5', style: textDataRow)),
                                      Center(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            hintText: "Nhập điểm",
                                            contentPadding: const EdgeInsets.fromLTRB(10, 7, 5, 0),
                                            filled: true,
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(0),
                                            ),
                                          ),
                                          controller: diemOneOne,
                                          onChanged: (value) {
                                            setState(() {
                                              if (diemOneOne.text != "") {
                                                danhGiaKetQua.diemOneOne = int.tryParse(diemOneOne.text);
                                                if (danhGiaKetQua.diemOneOne == null || danhGiaKetQua.diemOneOne! < 0 || danhGiaKetQua.diemOneOne! > 5) {
                                                  showToast(
                                                    context: context,
                                                    msg: "Phải nhật số từ 0 đến 5",
                                                    color: Color.fromRGBO(245, 117, 29, 1),
                                                    icon: const Icon(Icons.info),
                                                  );
                                                  danhGiaKetQua.diemOne = null;
                                                  danhGiaKetQua.diemOneOne = null;
                                                  diemOneOne.text = "";
                                                } else {
                                                  if (danhGiaKetQua.diemTwoOne != null) {
                                                    danhGiaKetQua.diemOne = danhGiaKetQua.diemOneOne! + danhGiaKetQua.diemTwoOne!;
                                                  } else {
                                                    danhGiaKetQua.diemOne = null;
                                                  }
                                                }
                                              } else {
                                                danhGiaKetQua.diemOne = null;
                                              }
                                            });
                                          },
                                          enabled: edit,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      Center(child: Text('2', style: textDataRow)),
                                      Center(child: Text('L3', style: textDataRow)),
                                      Center(child: Text('5', style: textDataRow)),
                                      Center(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            hintText: "Nhập điểm",
                                            contentPadding: const EdgeInsets.fromLTRB(10, 7, 5, 0),
                                            filled: true,
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(0),
                                            ),
                                          ),
                                          controller: diemTwoOne,
                                          onChanged: (value) {
                                            setState(() {
                                              if (diemTwoOne.text != "") {
                                                danhGiaKetQua.diemTwoOne = int.tryParse(diemTwoOne.text);
                                                if (danhGiaKetQua.diemTwoOne == null || danhGiaKetQua.diemTwoOne! < 0 || danhGiaKetQua.diemTwoOne! > 5) {
                                                  showToast(
                                                    context: context,
                                                    msg: "Phải nhật số từ 0 đến 5",
                                                    color: Color.fromRGBO(245, 117, 29, 1),
                                                    icon: const Icon(Icons.info),
                                                  );
                                                  danhGiaKetQua.diemOne = null;
                                                  danhGiaKetQua.diemTwoOne = null;
                                                  diemTwoOne.text = "";
                                                } else {
                                                  if (danhGiaKetQua.diemOneOne != null) {
                                                    danhGiaKetQua.diemOne = danhGiaKetQua.diemOneOne! + danhGiaKetQua.diemTwoOne!;
                                                  } else {
                                                    danhGiaKetQua.diemOne = null;
                                                  }
                                                }
                                              } else {
                                                danhGiaKetQua.diemOne = null;
                                              }
                                            });
                                          },
                                          enabled: edit,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      Center(child: Text('', style: textDataRow)),
                                      Center(child: Text('Tổng', style: textDataColumn)),
                                      Center(child: Text('10 điểm', style: textDataColumn)),
                                      Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text((danhGiaKetQua.diemOne != null) ? "${danhGiaKetQua.diemOne}" : "", style: textDataColumn),
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : (widget.data.nguoiDung!.nganh == 3)
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("PHIẾU ĐIỂM HƯỚNG DẪN", style: textTitleMenu1),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Text("I. THÔNG TIN CHUNG", style: textTitleMenu2),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: TextFieldValidatedForm(
                                        type: 'None',
                                        height: 40,
                                        controller: nguoiDanhGiaOne,
                                        label: 'Người đánh giá: ',
                                        flexLable: 2,
                                        enabled: edit,
                                      ),
                                    ),
                                    SizedBox(width: 100),
                                    Expanded(
                                      flex: 3,
                                      child: TextFieldValidatedForm(
                                        type: 'None',
                                        height: 40,
                                        controller: hocViOne,
                                        label: 'Học hàm, học vị: ',
                                        flexLable: 2,
                                        enabled: edit,
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
                                        controller: donViOne,
                                        label: 'Đơn vị công tác: ',
                                        flexLable: 2,
                                        enabled: edit,
                                      ),
                                    ),
                                    SizedBox(width: 100),
                                    Expanded(
                                      flex: 3,
                                      child: Container(),
                                    ),
                                  ],
                                ),
                                Text("II. ĐÁNH GIÁ (Điểm làm tròn đến 1 chữ số thập phân)", style: textTitleMenu2),
                                SizedBox(height: 30),
                                Center(
                                  child: Table(
                                    border: TableBorder.all(),
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FixedColumnWidth(60),
                                      1: FixedColumnWidth(90),
                                      2: FixedColumnWidth(90),
                                      3: FixedColumnWidth(100),
                                    },
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    children: <TableRow>[
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('STT', style: textDataColumn)),
                                          Center(child: Text('  Mã\nCĐRHP', style: textDataColumn)),
                                          Center(child: Text('Điểm\ntối đa', style: textDataColumn)),
                                          Center(child: Text('  Điểm\nđánh giá', style: textDataColumn)),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('1', style: textDataRow)),
                                          Center(child: Text('L1', style: textDataRow)),
                                          Center(child: Text('7', style: textDataRow)),
                                          Center(
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: "Nhập điểm",
                                                contentPadding: const EdgeInsets.fromLTRB(10, 7, 5, 0),
                                                filled: true,
                                                fillColor: Colors.white,
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(0),
                                                ),
                                              ),
                                              controller: diemOneOne,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (diemOneOne.text != "") {
                                                    danhGiaKetQua.diemOneOne = int.tryParse(diemOneOne.text);
                                                    if (danhGiaKetQua.diemOneOne == null || danhGiaKetQua.diemOneOne! < 0 || danhGiaKetQua.diemOneOne! > 7) {
                                                      showToast(
                                                        context: context,
                                                        msg: "Phải nhật số từ 0 đến 7",
                                                        color: Color.fromRGBO(245, 117, 29, 1),
                                                        icon: const Icon(Icons.info),
                                                      );
                                                      danhGiaKetQua.diemOne = null;
                                                      danhGiaKetQua.diemOneOne = null;
                                                      diemOneOne.text = "";
                                                    } else {
                                                      if (danhGiaKetQua.diemTwoOne != null) {
                                                        danhGiaKetQua.diemOne = danhGiaKetQua.diemOneOne! + danhGiaKetQua.diemTwoOne!;
                                                      } else {
                                                        danhGiaKetQua.diemOne = null;
                                                      }
                                                    }
                                                  } else {
                                                    danhGiaKetQua.diemOne = null;
                                                  }
                                                });
                                              },
                                              enabled: edit,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('2', style: textDataRow)),
                                          Center(child: Text('L3', style: textDataRow)),
                                          Center(child: Text('3', style: textDataRow)),
                                          Center(
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: "Nhập điểm",
                                                contentPadding: const EdgeInsets.fromLTRB(10, 7, 5, 0),
                                                filled: true,
                                                fillColor: Colors.white,
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(0),
                                                ),
                                              ),
                                              controller: diemTwoOne,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (diemTwoOne.text != "") {
                                                    danhGiaKetQua.diemTwoOne = int.tryParse(diemTwoOne.text);
                                                    if (danhGiaKetQua.diemTwoOne == null || danhGiaKetQua.diemTwoOne! < 0 || danhGiaKetQua.diemTwoOne! > 3) {
                                                      showToast(
                                                        context: context,
                                                        msg: "Phải nhật số từ 0 đến 3",
                                                        color: Color.fromRGBO(245, 117, 29, 1),
                                                        icon: const Icon(Icons.info),
                                                      );
                                                      danhGiaKetQua.diemOne = null;
                                                      danhGiaKetQua.diemTwoOne = null;
                                                      diemTwoOne.text = "";
                                                    } else {
                                                      if (danhGiaKetQua.diemOneOne != null) {
                                                        danhGiaKetQua.diemOne = danhGiaKetQua.diemOneOne! + danhGiaKetQua.diemTwoOne!;
                                                      } else {
                                                        danhGiaKetQua.diemOne = null;
                                                      }
                                                    }
                                                  } else {
                                                    danhGiaKetQua.diemOne = null;
                                                  }
                                                });
                                              },
                                              enabled: edit,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('', style: textDataRow)),
                                          Center(child: Text('Tổng', style: textDataColumn)),
                                          Center(child: Text('10 điểm', style: textDataColumn)),
                                          Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text((danhGiaKetQua.diemOne != null) ? "${danhGiaKetQua.diemOne}" : "", style: textDataColumn),
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.all(15),
                            width: MediaQuery.of(context).size.width * 1,
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: borderRadiusContainer,
                              boxShadow: [boxShadowContainer],
                              border: borderAllContainerBox,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("PHIẾU ĐIỂM HƯỚNG DẪN", style: textTitleMenu1),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Text("I. THÔNG TIN CHUNG", style: textTitleMenu2),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: TextFieldValidatedForm(
                                        type: 'None',
                                        height: 40,
                                        controller: nguoiDanhGiaOne,
                                        label: 'Người đánh giá: ',
                                        flexLable: 2,
                                        enabled: edit,
                                      ),
                                    ),
                                    SizedBox(width: 100),
                                    Expanded(
                                      flex: 3,
                                      child: TextFieldValidatedForm(
                                        type: 'None',
                                        height: 40,
                                        controller: hocViOne,
                                        label: 'Học hàm, học vị: ',
                                        flexLable: 2,
                                        enabled: edit,
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
                                        controller: donViOne,
                                        label: 'Đơn vị công tác: ',
                                        flexLable: 2,
                                        enabled: edit,
                                      ),
                                    ),
                                    SizedBox(width: 100),
                                    Expanded(
                                      flex: 3,
                                      child: Container(),
                                    ),
                                  ],
                                ),
                                Text("II. ĐÁNH GIÁ (Điểm làm tròn đến 1 chữ số thập phân)", style: textTitleMenu2),
                                SizedBox(height: 30),
                                Center(
                                  child: Table(
                                    border: TableBorder.all(),
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FixedColumnWidth(60),
                                      1: FixedColumnWidth(90),
                                      2: FixedColumnWidth(90),
                                      3: FixedColumnWidth(100),
                                    },
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    children: <TableRow>[
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('STT', style: textDataColumn)),
                                          Center(child: Text('  Mã\nCĐRHP', style: textDataColumn)),
                                          Center(child: Text('Điểm\ntối đa', style: textDataColumn)),
                                          Center(child: Text('  Điểm\nđánh giá', style: textDataColumn)),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('1', style: textDataRow)),
                                          Center(child: Text('L2', style: textDataRow)),
                                          Center(child: Text('2', style: textDataRow)),
                                          Center(
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: "Nhập điểm",
                                                contentPadding: const EdgeInsets.fromLTRB(10, 7, 5, 0),
                                                filled: true,
                                                fillColor: Colors.white,
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(0),
                                                ),
                                              ),
                                              controller: diemOneOne,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (diemOneOne.text != "") {
                                                    danhGiaKetQua.diemOneOne = int.tryParse(diemOneOne.text);
                                                    if (danhGiaKetQua.diemOneOne == null || danhGiaKetQua.diemOneOne! < 0 || danhGiaKetQua.diemOneOne! > 2) {
                                                      showToast(
                                                        context: context,
                                                        msg: "Phải nhật số từ 0 đến 2",
                                                        color: Color.fromRGBO(245, 117, 29, 1),
                                                        icon: const Icon(Icons.info),
                                                      );
                                                      danhGiaKetQua.diemOne = null;
                                                      danhGiaKetQua.diemOneOne = null;
                                                      diemOneOne.text = "";
                                                    } else {
                                                      if (danhGiaKetQua.diemTwoOne != null && danhGiaKetQua.diemOneThree != null) {
                                                        danhGiaKetQua.diemOne = danhGiaKetQua.diemOneOne! + danhGiaKetQua.diemTwoOne! + danhGiaKetQua.diemOneThree!;
                                                      } else {
                                                        danhGiaKetQua.diemOne = null;
                                                      }
                                                    }
                                                  } else {
                                                    danhGiaKetQua.diemOne = null;
                                                  }
                                                });
                                              },
                                              enabled: edit,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('2', style: textDataRow)),
                                          Center(child: Text('L3', style: textDataRow)),
                                          Center(child: Text('3', style: textDataRow)),
                                          Center(
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: "Nhập điểm",
                                                contentPadding: const EdgeInsets.fromLTRB(10, 7, 5, 0),
                                                filled: true,
                                                fillColor: Colors.white,
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(0),
                                                ),
                                              ),
                                              controller: diemTwoOne,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (diemTwoOne.text != "") {
                                                    danhGiaKetQua.diemTwoOne = int.tryParse(diemTwoOne.text);
                                                    if (danhGiaKetQua.diemTwoOne == null || danhGiaKetQua.diemTwoOne! < 0 || danhGiaKetQua.diemTwoOne! > 3) {
                                                      showToast(
                                                        context: context,
                                                        msg: "Phải nhật số từ 0 đến 3",
                                                        color: Color.fromRGBO(245, 117, 29, 1),
                                                        icon: const Icon(Icons.info),
                                                      );
                                                      danhGiaKetQua.diemOne = null;
                                                      danhGiaKetQua.diemTwoOne = null;
                                                      diemTwoOne.text = "";
                                                    } else {
                                                      if (danhGiaKetQua.diemOneOne != null && danhGiaKetQua.diemOneThree != null) {
                                                        danhGiaKetQua.diemOne = danhGiaKetQua.diemOneOne! + danhGiaKetQua.diemTwoOne! + danhGiaKetQua.diemOneThree!;
                                                      } else {
                                                        danhGiaKetQua.diemOne = null;
                                                      }
                                                    }
                                                  } else {
                                                    danhGiaKetQua.diemOne = null;
                                                  }
                                                });
                                              },
                                              enabled: edit,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('2', style: textDataRow)),
                                          Center(child: Text('L4', style: textDataRow)),
                                          Center(child: Text('5', style: textDataRow)),
                                          Center(
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: "Nhập điểm",
                                                contentPadding: const EdgeInsets.fromLTRB(10, 7, 5, 0),
                                                filled: true,
                                                fillColor: Colors.white,
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(0),
                                                ),
                                              ),
                                              controller: diemOneThree,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (diemOneThree.text != "") {
                                                    danhGiaKetQua.diemOneThree = int.tryParse(diemOneThree.text);
                                                    if (danhGiaKetQua.diemOneThree == null || danhGiaKetQua.diemOneThree! < 0 || danhGiaKetQua.diemOneThree! > 5) {
                                                      showToast(
                                                        context: context,
                                                        msg: "Phải nhật số từ 0 đến 5",
                                                        color: Color.fromRGBO(245, 117, 29, 1),
                                                        icon: const Icon(Icons.info),
                                                      );
                                                      danhGiaKetQua.diemOne = null;
                                                      danhGiaKetQua.diemOneThree = null;
                                                      diemOneThree.text = "";
                                                    } else {
                                                      if (danhGiaKetQua.diemOneOne != null && danhGiaKetQua.diemTwoOne != null) {
                                                        danhGiaKetQua.diemOne = danhGiaKetQua.diemOneOne! + danhGiaKetQua.diemTwoOne! + danhGiaKetQua.diemOneThree!;
                                                      } else {
                                                        danhGiaKetQua.diemOne = null;
                                                      }
                                                    }
                                                  } else {
                                                    danhGiaKetQua.diemOne = null;
                                                  }
                                                });
                                              },
                                              enabled: edit,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('', style: textDataRow)),
                                          Center(child: Text('Tổng', style: textDataColumn)),
                                          Center(child: Text('10 điểm', style: textDataColumn)),
                                          Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text((danhGiaKetQua.diemOne != null) ? "${danhGiaKetQua.diemOne}" : "", style: textDataColumn),
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                (widget.data.nguoiDung!.nganh == 0 || widget.data.nguoiDung!.nganh == 1)
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("PHIẾU ĐÁNH GIÁ ĐIỂM HỘI ĐỒNG", style: textTitleMenu1),
                              ],
                            ),
                            SizedBox(height: 30),
                            Text("I. THÔNG TIN CHUNG", style: textTitleMenu2),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFieldValidatedForm(
                                    type: 'Người đánh giá: ',
                                    height: 40,
                                    controller: nguoiDanhGiaTwo,
                                    label: 'Tên:',
                                    flexLable: 2,
                                    enabled: edit,
                                  ),
                                ),
                                SizedBox(width: 100),
                                Expanded(
                                  flex: 3,
                                  child: TextFieldValidatedForm(
                                    type: 'None',
                                    height: 40,
                                    controller: hocViTwo,
                                    label: 'Học hàm, học vị: ',
                                    flexLable: 2,
                                    enabled: edit,
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
                                    controller: donViTwo,
                                    label: 'Đơn vị công tác: ',
                                    flexLable: 2,
                                    enabled: edit,
                                  ),
                                ),
                                SizedBox(width: 100),
                                Expanded(
                                  flex: 3,
                                  child: Container(),
                                ),
                              ],
                            ),
                            Text("II. ĐÁNH GIÁ (Điểm làm tròn đến 1 chữ số thập phân)", style: textTitleMenu2),
                            SizedBox(height: 30),
                            Center(
                              child: Table(
                                border: TableBorder.all(),
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FixedColumnWidth(60),
                                  1: FixedColumnWidth(90),
                                  2: FixedColumnWidth(90),
                                  3: FixedColumnWidth(100),
                                },
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                children: <TableRow>[
                                  TableRow(
                                    children: <Widget>[
                                      Center(child: Text('STT', style: textDataColumn)),
                                      Center(child: Text('  Mã\nCĐRHP', style: textDataColumn)),
                                      Center(child: Text('Điểm\ntối đa', style: textDataColumn)),
                                      Center(child: Text('  Điểm\nđánh giá', style: textDataColumn)),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      Center(child: Text('1', style: textDataRow)),
                                      Center(child: Text('L2', style: textDataRow)),
                                      Center(child: Text('5', style: textDataRow)),
                                      Center(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            hintText: "Nhập điểm",
                                            contentPadding: const EdgeInsets.fromLTRB(10, 7, 5, 0),
                                            filled: true,
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(0),
                                            ),
                                          ),
                                          controller: diemOneTwo,
                                          onChanged: (value) {
                                            setState(() {
                                              if (diemOneTwo.text != "") {
                                                danhGiaKetQua.diemOneTwo = int.tryParse(diemOneTwo.text);
                                                if (danhGiaKetQua.diemOneTwo == null || danhGiaKetQua.diemOneTwo! < 0 || danhGiaKetQua.diemOneTwo! > 5) {
                                                  showToast(
                                                    context: context,
                                                    msg: "Phải nhật số từ 0 đến 5",
                                                    color: Color.fromRGBO(245, 117, 29, 1),
                                                    icon: const Icon(Icons.info),
                                                  );
                                                  danhGiaKetQua.diemTwo = null;
                                                  danhGiaKetQua.diemOneTwo = null;
                                                  diemOneTwo.text = "";
                                                } else {
                                                  if (danhGiaKetQua.diemTwoTwo != null) {
                                                    danhGiaKetQua.diemTwo = danhGiaKetQua.diemOneTwo! + danhGiaKetQua.diemTwoTwo!;
                                                  } else {
                                                    danhGiaKetQua.diemTwo = null;
                                                  }
                                                }
                                              } else {
                                                danhGiaKetQua.diemTwo = null;
                                              }
                                            });
                                          },
                                          enabled: edit,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      Center(child: Text('2', style: textDataRow)),
                                      Center(child: Text('L3', style: textDataRow)),
                                      Center(child: Text('5', style: textDataRow)),
                                      Center(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            hintText: "Nhập điểm",
                                            contentPadding: const EdgeInsets.fromLTRB(10, 7, 5, 0),
                                            filled: true,
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(0),
                                            ),
                                          ),
                                          controller: diemTwoTwo,
                                          onChanged: (value) {
                                            setState(() {
                                              if (diemTwoTwo.text != "") {
                                                danhGiaKetQua.diemTwoTwo = int.tryParse(diemTwoTwo.text);
                                                if (danhGiaKetQua.diemTwoTwo == null || danhGiaKetQua.diemTwoTwo! < 0 || danhGiaKetQua.diemTwoTwo! > 5) {
                                                  showToast(
                                                    context: context,
                                                    msg: "Phải nhật số từ 0 đến 5",
                                                    color: Color.fromRGBO(245, 117, 29, 1),
                                                    icon: const Icon(Icons.info),
                                                  );
                                                  danhGiaKetQua.diemTwo = null;
                                                  danhGiaKetQua.diemTwoTwo = null;
                                                  diemTwoTwo.text = "";
                                                } else {
                                                  if (danhGiaKetQua.diemOneTwo != null) {
                                                    danhGiaKetQua.diemTwo = danhGiaKetQua.diemOneTwo! + danhGiaKetQua.diemTwoTwo!;
                                                  } else {
                                                    danhGiaKetQua.diemTwo = null;
                                                  }
                                                }
                                              } else {
                                                danhGiaKetQua.diemTwo = null;
                                              }
                                            });
                                          },
                                          enabled: edit,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      Center(child: Text('', style: textDataRow)),
                                      Center(child: Text('Tổng', style: textDataColumn)),
                                      Center(child: Text('10 điểm', style: textDataColumn)),
                                      Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text((danhGiaKetQua.diemTwo != null) ? "${danhGiaKetQua.diemTwo}" : "", style: textDataColumn),
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : (widget.data.nguoiDung!.nganh == 3)
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("PHIẾU ĐÁNH GIÁ ĐIỂM HỘI ĐỒNG", style: textTitleMenu1),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Text("I. THÔNG TIN CHUNG", style: textTitleMenu2),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: TextFieldValidatedForm(
                                        type: 'Người đánh giá: ',
                                        height: 40,
                                        controller: nguoiDanhGiaTwo,
                                        label: 'Tên:',
                                        flexLable: 2,
                                        enabled: edit,
                                      ),
                                    ),
                                    SizedBox(width: 100),
                                    Expanded(
                                      flex: 3,
                                      child: TextFieldValidatedForm(
                                        type: 'None',
                                        height: 40,
                                        controller: hocViTwo,
                                        label: 'Học hàm, học vị: ',
                                        flexLable: 2,
                                        enabled: edit,
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
                                        controller: donViTwo,
                                        label: 'Đơn vị công tác: ',
                                        flexLable: 2,
                                        enabled: edit,
                                      ),
                                    ),
                                    SizedBox(width: 100),
                                    Expanded(
                                      flex: 3,
                                      child: Container(),
                                    ),
                                  ],
                                ),
                                Text("II. ĐÁNH GIÁ (Điểm làm tròn đến 1 chữ số thập phân)", style: textTitleMenu2),
                                SizedBox(height: 30),
                                Center(
                                  child: Table(
                                    border: TableBorder.all(),
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FixedColumnWidth(60),
                                      1: FixedColumnWidth(90),
                                      2: FixedColumnWidth(90),
                                      3: FixedColumnWidth(100),
                                    },
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    children: <TableRow>[
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('STT', style: textDataColumn)),
                                          Center(child: Text('  Mã\nCĐRHP', style: textDataColumn)),
                                          Center(child: Text('Điểm\ntối đa', style: textDataColumn)),
                                          Center(child: Text('  Điểm\nđánh giá', style: textDataColumn)),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('1', style: textDataRow)),
                                          Center(child: Text('L1', style: textDataRow)),
                                          Center(child: Text('6', style: textDataRow)),
                                          Center(
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: "Nhập điểm",
                                                contentPadding: const EdgeInsets.fromLTRB(10, 7, 5, 0),
                                                filled: true,
                                                fillColor: Colors.white,
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(0),
                                                ),
                                              ),
                                              controller: diemOneTwo,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (diemOneTwo.text != "") {
                                                    danhGiaKetQua.diemOneTwo = int.tryParse(diemOneTwo.text);
                                                    if (danhGiaKetQua.diemOneTwo == null || danhGiaKetQua.diemOneTwo! < 0 || danhGiaKetQua.diemOneTwo! > 6) {
                                                      showToast(
                                                        context: context,
                                                        msg: "Phải nhật số từ 0 đến 6",
                                                        color: Color.fromRGBO(245, 117, 29, 1),
                                                        icon: const Icon(Icons.info),
                                                      );
                                                      danhGiaKetQua.diemTwo = null;
                                                      danhGiaKetQua.diemOneTwo = null;
                                                      diemOneTwo.text = "";
                                                    } else {
                                                      if (danhGiaKetQua.diemTwoTwo != null) {
                                                        danhGiaKetQua.diemTwo = danhGiaKetQua.diemOneTwo! + danhGiaKetQua.diemTwoTwo!;
                                                      } else {
                                                        danhGiaKetQua.diemTwo = null;
                                                      }
                                                    }
                                                  } else {
                                                    danhGiaKetQua.diemTwo = null;
                                                  }
                                                });
                                              },
                                              enabled: edit,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('2', style: textDataRow)),
                                          Center(child: Text('L2', style: textDataRow)),
                                          Center(child: Text('4', style: textDataRow)),
                                          Center(
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: "Nhập điểm",
                                                contentPadding: const EdgeInsets.fromLTRB(10, 7, 5, 0),
                                                filled: true,
                                                fillColor: Colors.white,
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(0),
                                                ),
                                              ),
                                              controller: diemTwoTwo,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (diemTwoTwo.text != "") {
                                                    danhGiaKetQua.diemTwoTwo = int.tryParse(diemTwoTwo.text);
                                                    if (danhGiaKetQua.diemTwoTwo == null || danhGiaKetQua.diemTwoTwo! < 0 || danhGiaKetQua.diemTwoTwo! > 4) {
                                                      showToast(
                                                        context: context,
                                                        msg: "Phải nhật số từ 0 đến 4",
                                                        color: Color.fromRGBO(245, 117, 29, 1),
                                                        icon: const Icon(Icons.info),
                                                      );
                                                      danhGiaKetQua.diemTwo = null;
                                                      danhGiaKetQua.diemTwoTwo = null;
                                                      diemTwoTwo.text = "";
                                                    } else {
                                                      if (danhGiaKetQua.diemOneTwo != null) {
                                                        danhGiaKetQua.diemTwo = danhGiaKetQua.diemOneTwo! + danhGiaKetQua.diemTwoTwo!;
                                                      } else {
                                                        danhGiaKetQua.diemTwo = null;
                                                      }
                                                    }
                                                  } else {
                                                    danhGiaKetQua.diemTwo = null;
                                                  }
                                                });
                                              },
                                              enabled: edit,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('', style: textDataRow)),
                                          Center(child: Text('Tổng', style: textDataColumn)),
                                          Center(child: Text('10 điểm', style: textDataColumn)),
                                          Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text((danhGiaKetQua.diemTwo != null) ? "${danhGiaKetQua.diemTwo}" : "", style: textDataColumn),
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.all(15),
                            width: MediaQuery.of(context).size.width * 1,
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: borderRadiusContainer,
                              boxShadow: [boxShadowContainer],
                              border: borderAllContainerBox,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("PHIẾU ĐÁNH GIÁ ĐIỂM HỘI ĐỒNG", style: textTitleMenu1),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Text("I. THÔNG TIN CHUNG", style: textTitleMenu2),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: TextFieldValidatedForm(
                                        type: 'Người đánh giá: ',
                                        height: 40,
                                        controller: nguoiDanhGiaTwo,
                                        label: 'Tên:',
                                        flexLable: 2,
                                        enabled: edit,
                                      ),
                                    ),
                                    SizedBox(width: 100),
                                    Expanded(
                                      flex: 3,
                                      child: TextFieldValidatedForm(
                                        type: 'None',
                                        height: 40,
                                        controller: hocViTwo,
                                        label: 'Học hàm, học vị: ',
                                        flexLable: 2,
                                        enabled: edit,
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
                                        controller: donViTwo,
                                        label: 'Đơn vị công tác: ',
                                        flexLable: 2,
                                        enabled: edit,
                                      ),
                                    ),
                                    SizedBox(width: 100),
                                    Expanded(
                                      flex: 3,
                                      child: Container(),
                                    ),
                                  ],
                                ),
                                Text("II. ĐÁNH GIÁ (Điểm làm tròn đến 1 chữ số thập phân)", style: textTitleMenu2),
                                SizedBox(height: 30),
                                Center(
                                  child: Table(
                                    border: TableBorder.all(),
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FixedColumnWidth(60),
                                      1: FixedColumnWidth(90),
                                      2: FixedColumnWidth(90),
                                      3: FixedColumnWidth(100),
                                    },
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    children: <TableRow>[
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('STT', style: textDataColumn)),
                                          Center(child: Text('  Mã\nCĐRHP', style: textDataColumn)),
                                          Center(child: Text('Điểm\ntối đa', style: textDataColumn)),
                                          Center(child: Text('  Điểm\nđánh giá', style: textDataColumn)),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('1', style: textDataRow)),
                                          Center(child: Text('L1', style: textDataRow)),
                                          Center(child: Text('2', style: textDataRow)),
                                          Center(
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: "Nhập điểm",
                                                contentPadding: const EdgeInsets.fromLTRB(10, 7, 5, 0),
                                                filled: true,
                                                fillColor: Colors.white,
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(0),
                                                ),
                                              ),
                                              controller: diemOneTwo,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (diemOneTwo.text != "") {
                                                    danhGiaKetQua.diemOneTwo = int.tryParse(diemOneTwo.text);
                                                    if (danhGiaKetQua.diemOneTwo == null || danhGiaKetQua.diemOneTwo! < 0 || danhGiaKetQua.diemOneTwo! > 2) {
                                                      showToast(
                                                        context: context,
                                                        msg: "Phải nhật số từ 0 đến 2",
                                                        color: Color.fromRGBO(245, 117, 29, 1),
                                                        icon: const Icon(Icons.info),
                                                      );
                                                      danhGiaKetQua.diemTwo = null;
                                                      danhGiaKetQua.diemOneTwo = null;
                                                      diemOneTwo.text = "";
                                                    } else {
                                                      if (danhGiaKetQua.diemTwoTwo != null && danhGiaKetQua.diemTwoThree != null) {
                                                        danhGiaKetQua.diemTwo = danhGiaKetQua.diemOneTwo! + danhGiaKetQua.diemTwoTwo! + danhGiaKetQua.diemTwoThree!;
                                                      } else {
                                                        danhGiaKetQua.diemTwo = null;
                                                      }
                                                    }
                                                  } else {
                                                    danhGiaKetQua.diemTwo = null;
                                                  }
                                                });
                                              },
                                              enabled: edit,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('2', style: textDataRow)),
                                          Center(child: Text('L3', style: textDataRow)),
                                          Center(child: Text('3', style: textDataRow)),
                                          Center(
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: "Nhập điểm",
                                                contentPadding: const EdgeInsets.fromLTRB(10, 7, 5, 0),
                                                filled: true,
                                                fillColor: Colors.white,
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(0),
                                                ),
                                              ),
                                              controller: diemTwoTwo,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (diemTwoTwo.text != "") {
                                                    danhGiaKetQua.diemTwoTwo = int.tryParse(diemTwoTwo.text);
                                                    if (danhGiaKetQua.diemTwoTwo == null || danhGiaKetQua.diemTwoTwo! < 0 || danhGiaKetQua.diemTwoTwo! > 3) {
                                                      showToast(
                                                        context: context,
                                                        msg: "Phải nhật số từ 0 đến 3",
                                                        color: Color.fromRGBO(245, 117, 29, 1),
                                                        icon: const Icon(Icons.info),
                                                      );
                                                      danhGiaKetQua.diemTwo = null;
                                                      danhGiaKetQua.diemTwoTwo = null;
                                                      diemTwoTwo.text = "";
                                                    } else {
                                                      if (danhGiaKetQua.diemOneTwo != null && danhGiaKetQua.diemTwoThree != null) {
                                                        danhGiaKetQua.diemTwo = danhGiaKetQua.diemOneTwo! + danhGiaKetQua.diemTwoTwo! + danhGiaKetQua.diemTwoThree!;
                                                      } else {
                                                        danhGiaKetQua.diemTwo = null;
                                                      }
                                                    }
                                                  } else {
                                                    danhGiaKetQua.diemTwo = null;
                                                  }
                                                });
                                              },
                                              enabled: edit,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('2', style: textDataRow)),
                                          Center(child: Text('L4', style: textDataRow)),
                                          Center(child: Text('5', style: textDataRow)),
                                          Center(
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: "Nhập điểm",
                                                contentPadding: const EdgeInsets.fromLTRB(10, 7, 5, 0),
                                                filled: true,
                                                fillColor: Colors.white,
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(0),
                                                ),
                                              ),
                                              controller: diemTwoThree,
                                              onChanged: (value) {
                                                setState(() {
                                                  if (diemTwoThree.text != "") {
                                                    danhGiaKetQua.diemTwoThree = int.tryParse(diemTwoThree.text);
                                                    if (danhGiaKetQua.diemTwoThree == null || danhGiaKetQua.diemTwoThree! < 0 || danhGiaKetQua.diemTwoThree! > 5) {
                                                      showToast(
                                                        context: context,
                                                        msg: "Phải nhật số từ 0 đến 5",
                                                        color: Color.fromRGBO(245, 117, 29, 1),
                                                        icon: const Icon(Icons.info),
                                                      );
                                                      danhGiaKetQua.diemTwo = null;
                                                      danhGiaKetQua.diemTwoThree = null;
                                                      diemTwoThree.text = "";
                                                    } else {
                                                      if (danhGiaKetQua.diemOneTwo != null && danhGiaKetQua.diemTwoTwo != null) {
                                                        danhGiaKetQua.diemTwo = danhGiaKetQua.diemOneTwo! + danhGiaKetQua.diemTwoTwo! + danhGiaKetQua.diemTwoThree!;
                                                      } else {
                                                        danhGiaKetQua.diemTwo = null;
                                                      }
                                                    }
                                                  } else {
                                                    danhGiaKetQua.diemTwo = null;
                                                  }
                                                });
                                              },
                                              enabled: edit,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Center(child: Text('', style: textDataRow)),
                                          Center(child: Text('Tổng', style: textDataColumn)),
                                          Center(child: Text('10 điểm', style: textDataColumn)),
                                          Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text((danhGiaKetQua.diemTwo != null) ? "${danhGiaKetQua.diemTwo}" : "", style: textDataColumn),
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
              ],
            ),
          )
        : CommonApp().loadingCallAPi();
  }
}
