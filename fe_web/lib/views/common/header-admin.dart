// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously
import 'dart:convert';

import 'package:fe_web/confing.dart';
import 'package:fe_web/controllers/api.dart';
import 'package:fe_web/models/sinh-vien-khao-sat.dart';
import 'package:fe_web/models/sinh-vien.dart';
import 'package:fe_web/views/common/loadApi.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import '../../controllers/provider.dart';
import '../../models/gvhd.dart';
import '../../models/ke-hoach-thuc-tap.dart';
import '../screens/app-quan-tri/quan-ly-giao-vien/xem-gvhd/xem-gvhd.dart';
import '../screens/app-quan-tri/quan-ly-sinh-vien/thong-tin-sinh-vien.dart';
import '../screens/change-pass/change-password.dart';

class Header extends StatefulWidget {
  final Widget widgetBody;
  const Header({Key? key, required this.widgetBody}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool checkShow = true;
  bool checkShowSV = true;
  bool checkShowHT = true;
  bool showMenu = true;
  late double widthMenu;
  late double widthContent;
  String? noti;
  var appBarHeight = AppBar().preferredSize.height;
  LocalStorage storage = LocalStorage("storage");
  String? id;
  String? role;
  bool statusInfo = false;
  String name = "";
  caillInfo() async {
    role = storage.getItem("role");
    id = storage.getItem("id");
    await callUser();
    if (role == "2") {
      await callSinhVien();
    }
    await getKeHoacThucTapNow();
    setState(() {
      statusInfo = true;
    });
  }

  GVHD userLogin = GVHD();
  callUser() async {
    var securityModel = Provider.of<SecurityModel>(context, listen: false);
    var responseUser = await httpGet("/api/nguoi-dung/get/$id", context);
    var bodyUser = jsonDecode(responseUser['body']);
    userLogin = GVHD.fromJson(bodyUser['result']);
    List<String> listName = userLogin.fullName!.split(" ");
    name = listName.last;
    securityModel.changeUser(userLogin);
    securityModel.changeSinhVien(SinhVien(id: -1));
  }

  SinhVien sinhVien = SinhVien();
  List<int> listKs = [];
  callSinhVien() async {
    var securityModel = Provider.of<SecurityModel>(context, listen: false);
    List<SinhVien> listsinhVien = [];
    List<SinhVien> listsinhVienHT = [];
    var responseSinhVien = await httpGet("/api/sinh-vien-thuc-tap/get/page?filter=idNguoiDung:$id and keHoachThucTap.status:0", context);
    var responseSinhVienHT = await httpGet("/api/sinh-vien-thuc-tap/get/page?filter=idNguoiDung:$id and keHoachThucTap.status:1&sort=keHoachThucTap.endDate,desc", context);
    if (responseSinhVien.containsKey("body")) {
      setState(() {
        var body = jsonDecode(responseSinhVien['body']);
        var content = [];
        content = body['result']['content'];
        listsinhVien = content.map((e) {
          return SinhVien.fromJson(e);
        }).toList();
        if (listsinhVien.isNotEmpty) {
          sinhVien = listsinhVien.first;
          securityModel.changeSinhVien(sinhVien);
        } else {
          var bodyHT = jsonDecode(responseSinhVienHT['body']);
          var contentHT = [];
          contentHT = bodyHT['result']['content'];
          listsinhVienHT = contentHT.map((e) {
            return SinhVien.fromJson(e);
          }).toList();
          if (listsinhVienHT.isNotEmpty) {
            sinhVien = listsinhVienHT.first;
            securityModel.changeSinhVien(sinhVien);
          } else {
            securityModel.changeSinhVien(SinhVien(id: -1));
          }
        }
      });
    }
  }

  getKeHoacThucTapNow() async {
    List<KeHoachThucTap> resultNow = [];
    var securityModel = Provider.of<SecurityModel>(context, listen: false);
    var response2 = await httpGet("/api/ke-hoach-thuc-tap/get/page?filter=status:0", context);
    var response3 = await httpGet("/api/ke-hoach-thuc-tap/get/page?filter=status:1", context);
    if (response2.containsKey("body")) {
      setState(() {
        var body = jsonDecode(response2['body']);
        var content = [];
        content = body['result']['content'];
        if (content.isNotEmpty) {
          KeHoachThucTap selectedKHTT = KeHoachThucTap.fromJson(content.first);
          securityModel.changeKhtt(selectedKHTT);
        } else {
          var body2 = jsonDecode(response3['body']);
          var content2 = [];
          content2 = body2['result']['content'];
          if (content2.isNotEmpty) {
            KeHoachThucTap selectedKHTT = KeHoachThucTap.fromJson(content2.first);
            securityModel.changeKhtt(selectedKHTT);
          }
        }

        if (securityModel.getSttPage() == 3 || securityModel.getSttPage() == 4 || securityModel.getSttPage() == 5) {
          checkShowSV = true;
          checkShow = false;
          checkShowHT = false;
        } else if (securityModel.getSttPage() == 6 || securityModel.getSttPage() == 7) {
          checkShowSV = false;
          checkShow = true;
          checkShowHT = false;
        } else if (securityModel.getSttPage() == 9) {
          checkShowSV = false;
          checkShow = false;
          checkShowHT = true;
        } else {
          checkShowSV = false;
          checkShow = false;
          checkShowHT = false;
        }
      });
    }
    var response4;
    if (securityModel.sinhVien.id != -1) {
      List<SinhVienKhaoSat> listSVKS = [];
      response4 = await httpGet("/api/sinh-vien-khao-sat/get/page?filter=idSv:${securityModel.sinhVien.id}", context);
      if (response4.containsKey("body")) {
        var body4 = jsonDecode(response4['body']);
        var content4 = [];
        content4 = body4['result']['content'];
        if (content4.isNotEmpty) {
          listSVKS = content4.map((e) {
            return SinhVienKhaoSat.fromJson(e);
          }).toList();
        }

        List<int> listKSN = [];
        for (var e in listSVKS) {
          if (e.idSv != null && e.idKhaoSat != null) {
            listKSN.add(e.idKhaoSat!);
          }
        }
        print(listKSN);
        securityModel.changeListKs(listKSN);
      } else {
        print(response4);
      }
    }
  }

  int solgSVPCGVHD = 0;

  @override
  void initState() {
    super.initState();
    caillInfo();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;

    return Material(
      child: Consumer<SecurityModel>(builder: (context, user, child) {
        return (statusInfo)
            ? Scaffold(
                body: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    (showMenu)
                        ? Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 4,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                )
                              ],
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                              border: Border.all(width: 0, color: Color(0xffDADADA)),
                              color: mainColor,
                            ),
                            child: Column(
                              children: [
                                (role == "0")
                                    ? Expanded(
                                        child: Container(
                                          width: 300,
                                          decoration: BoxDecoration(color: mainColor),
                                          margin: EdgeInsets.only(top: 20),
                                          child: SingleChildScrollView(
                                            controller: ScrollController(),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                  decoration: BoxDecoration(
                                                    color: (user.getSttPage() == 1) ? white : mainColor,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: TextButton.icon(
                                                    icon: Icon(
                                                      Icons.home,
                                                      color: (user.getSttPage() == 1) ? mainColor : white,
                                                    ),
                                                    label: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                          child: Text(
                                                            "Trang chủ",
                                                            style: TextStyle(color: (user.getSttPage() == 1) ? mainColor : white, fontSize: 16, fontWeight: FontWeight.w500),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pushNamed(context, '/trang-chu');
                                                      setState(() {
                                                        user.changeSttMenu(1);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                  decoration: BoxDecoration(
                                                    color: (user.getSttPage() == 2) ? white : mainColor,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: TextButton.icon(
                                                    icon: Icon(
                                                      Icons.calendar_month,
                                                      color: (user.getSttPage() == 2) ? mainColor : white,
                                                    ),
                                                    label: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      // ignore: prefer_const_literals_to_create_immutables
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                          child: Text(
                                                            "Kế hoạch thực tập",
                                                            style: TextStyle(color: (user.getSttPage() == 2) ? mainColor : white, fontSize: 16, fontWeight: FontWeight.w500),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        user.changeSttMenu(2);
                                                      });
                                                      Navigator.pushNamed(context, '/ke-hoach-thuc-tap');
                                                    },
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                      decoration: BoxDecoration(
                                                        color: checkShowSV ? Colors.white : mainColor,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: TextButton.icon(
                                                        icon: Icon(
                                                          Icons.groups,
                                                          color: checkShowSV ? mainColor : Colors.white,
                                                        ),
                                                        label: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                              child: SizedBox(
                                                                // width: daddy,
                                                                // width: 300,
                                                                child: Text(
                                                                  "Quản lý sinh viên",
                                                                  // style: TextStyle(color: checkShow ? mainColor : Colors.white, fontSize: fontSize, fontWeight: FontWeight.w500),
                                                                  style: TextStyle(color: checkShowSV ? mainColor : Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                            ),
                                                            Icon(
                                                              checkShowSV ? Icons.expand_less : Icons.expand_more,
                                                              color: checkShowSV ? mainColor : Colors.white,
                                                            )
                                                          ],
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            checkShowSV = !checkShowSV;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.fromLTRB(28, 0, 0, 0),
                                                        decoration: BoxDecoration(
                                                          border: Border(left: BorderSide(width: 1, color: Colors.grey)),
                                                        ),
                                                        child: Container(
                                                          child: checkShowSV
                                                              ? Column(
                                                                  children: [
                                                                    Container(
                                                                        margin: EdgeInsets.only(right: 20, top: 5, bottom: 5),
                                                                        decoration: BoxDecoration(
                                                                          color: mainColor,
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                        child: TextButton(
                                                                          onPressed: () {
                                                                            Navigator.pushNamed(context, '/quan-ly-sinh-vien');
                                                                            user.changeSttMenu(3);
                                                                          },
                                                                          child: Row(
                                                                            // ignore: prefer_const_literals_to_create_immutables
                                                                            children: [
                                                                              SizedBox(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                                                                                  child: Text(
                                                                                    "Sinh viên",
                                                                                    overflow: TextOverflow.fade,
                                                                                    style: TextStyle(
                                                                                      color: (user.getSttPage() == 3) ? orange : Colors.white,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: 15,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Container(
                                                                        margin: EdgeInsets.only(right: 20, top: 5, bottom: 5),
                                                                        decoration: BoxDecoration(
                                                                          color: mainColor,
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                        child: TextButton(
                                                                          onPressed: () {
                                                                            Navigator.pushNamed(context, '/phan-cong-gvhd');
                                                                            user.changeSttMenu(4);
                                                                          },
                                                                          child: Row(
                                                                            // ignore: prefer_const_literals_to_create_immutables
                                                                            children: [
                                                                              SizedBox(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                                                                                  child: Text(
                                                                                    "Phân công GVHD",
                                                                                    overflow: TextOverflow.fade,
                                                                                    style: TextStyle(
                                                                                      color: (user.getSttPage() == 4) ? orange : Colors.white,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: 15,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Container(
                                                                        margin: EdgeInsets.only(right: 20, top: 5, bottom: 5),
                                                                        decoration: BoxDecoration(
                                                                          color: mainColor,
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                        child: TextButton(
                                                                          onPressed: () {
                                                                            Navigator.pushNamed(context, '/khao-sat');
                                                                            user.changeSttMenu(5);
                                                                          },
                                                                          child: Row(
                                                                            // ignore: prefer_const_literals_to_create_immutables
                                                                            children: [
                                                                              SizedBox(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                                                                                  child: Text(
                                                                                    "Khảo sát",
                                                                                    overflow: TextOverflow.fade,
                                                                                    style: TextStyle(
                                                                                      color: (user.getSttPage() == 5) ? orange : Colors.white,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: 15,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ))
                                                                  ],
                                                                )
                                                              : Container(),
                                                        ))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                      decoration: BoxDecoration(
                                                        color: checkShow ? Colors.white : mainColor,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: TextButton.icon(
                                                        icon: Icon(
                                                          Icons.apartment,
                                                          color: checkShow ? mainColor : Colors.white,
                                                        ),
                                                        label: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                              child: SizedBox(
                                                                // width: daddy,
                                                                // width: 300,
                                                                child: Text(
                                                                  "Doanh nghiệp",
                                                                  // style: TextStyle(color: checkShow ? mainColor : Colors.white, fontSize: fontSize, fontWeight: FontWeight.w500),
                                                                  style: TextStyle(color: checkShow ? mainColor : Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                            ),
                                                            Icon(
                                                              checkShow ? Icons.expand_less : Icons.expand_more,
                                                              color: checkShow ? mainColor : Colors.white,
                                                            )
                                                          ],
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            checkShow = !checkShow;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.fromLTRB(28, 0, 0, 0),
                                                        decoration: BoxDecoration(
                                                          border: Border(left: BorderSide(width: 1, color: Colors.grey)),
                                                        ),
                                                        child: Container(
                                                          child: checkShow
                                                              ? Column(
                                                                  children: [
                                                                    Container(
                                                                        margin: EdgeInsets.only(right: 20, top: 5, bottom: 5),
                                                                        decoration: BoxDecoration(
                                                                          color: mainColor,
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                        child: TextButton(
                                                                          onPressed: () {
                                                                            Navigator.pushNamed(context, '/quan-ly-doanh-ngiep');
                                                                            user.changeSttMenu(6);
                                                                          },
                                                                          child: Row(
                                                                            // ignore: prefer_const_literals_to_create_immutables
                                                                            children: [
                                                                              SizedBox(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                                                                                  child: Text(
                                                                                    "Quản lý",
                                                                                    overflow: TextOverflow.fade,
                                                                                    style: TextStyle(
                                                                                      color: (user.getSttPage() == 6) ? orange : Colors.white,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: 15,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Container(
                                                                        margin: EdgeInsets.only(right: 20, top: 5, bottom: 5),
                                                                        decoration: BoxDecoration(
                                                                          color: mainColor,
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                        child: TextButton(
                                                                          onPressed: () {
                                                                            Navigator.pushNamed(context, '/xac-thuc-doanh-ngiep');
                                                                            user.changeSttMenu(7);
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              SizedBox(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                                                                                  child: Text(
                                                                                    "Xác thực",
                                                                                    overflow: TextOverflow.fade,
                                                                                    style: TextStyle(
                                                                                      color: (user.getSttPage() == 7) ? orange : Colors.white,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: 15,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ))
                                                                  ],
                                                                )
                                                              : Container(),
                                                        ))
                                                  ],
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                  decoration: BoxDecoration(
                                                    color: (user.getSttPage() == 8) ? white : mainColor,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: TextButton.icon(
                                                    icon: Icon(
                                                      Icons.supervisor_account,
                                                      color: (user.getSttPage() == 8) ? mainColor : white,
                                                    ),
                                                    label: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      // ignore: prefer_const_literals_to_create_immutables
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                          child: Text(
                                                            "Giảng viên hướng dẫn",
                                                            style: TextStyle(color: (user.getSttPage() == 8) ? mainColor : white, fontSize: 16, fontWeight: FontWeight.w500),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pushNamed(context, '/quan-ly-gvhd');
                                                      setState(() {
                                                        user.changeSttMenu(8);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                // Column(
                                                //   crossAxisAlignment: CrossAxisAlignment.end,
                                                //   children: [
                                                //     Container(
                                                //       margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                //       decoration: BoxDecoration(
                                                //         color: checkShowHT ? Colors.white : mainColor,
                                                //         borderRadius: BorderRadius.circular(10),
                                                //       ),
                                                //       child: TextButton.icon(
                                                //         icon: Icon(
                                                //           Icons.groups,
                                                //           color: checkShowHT ? mainColor : Colors.white,
                                                //         ),
                                                //         label: Row(
                                                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                //           children: [
                                                //             Padding(
                                                //               padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                //               child: SizedBox(
                                                //                 // width: daddy,
                                                //                 // width: 300,
                                                //                 child: Text(
                                                //                   "Quản lý hệ thống",
                                                //                   // style: TextStyle(color: checkShow ? mainColor : Colors.white, fontSize: fontSize, fontWeight: FontWeight.w500),
                                                //                   style: TextStyle(color: checkShowHT ? mainColor : Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                                //                 ),
                                                //               ),
                                                //             ),
                                                //             Icon(
                                                //               checkShowHT ? Icons.expand_less : Icons.expand_more,
                                                //               color: checkShowHT ? mainColor : Colors.white,
                                                //             )
                                                //           ],
                                                //         ),
                                                //         onPressed: () {
                                                //           setState(() {
                                                //             checkShowHT = !checkShowHT;
                                                //           });
                                                //         },
                                                //       ),
                                                //     ),
                                                //     Container(
                                                //         margin: EdgeInsets.fromLTRB(28, 0, 0, 0),
                                                //         decoration: BoxDecoration(
                                                //           border: Border(left: BorderSide(width: 1, color: Colors.grey)),
                                                //         ),
                                                //         child: Container(
                                                //           child: checkShowHT
                                                //               ? Column(
                                                //                   children: [
                                                //                     Container(
                                                //                         margin: EdgeInsets.only(right: 20, top: 5, bottom: 5),
                                                //                         decoration: BoxDecoration(
                                                //                           color: mainColor,
                                                //                           borderRadius: BorderRadius.circular(10),
                                                //                         ),
                                                //                         child: TextButton(
                                                //                           onPressed: () {
                                                //                             user.changeSttMenu(9);
                                                //                           },
                                                //                           child: Row(
                                                //                             // ignore: prefer_const_literals_to_create_immutables
                                                //                             children: [
                                                //                               SizedBox(
                                                //                                 child: Padding(
                                                //                                   padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                                                //                                   child: Text(
                                                //                                     "Nhóm quyền",
                                                //                                     overflow: TextOverflow.fade,
                                                //                                     style: TextStyle(
                                                //                                       color: (user.getSttPage() == 9) ? orange : Colors.white,
                                                //                                       fontWeight: FontWeight.w500,
                                                //                                       fontSize: 15,
                                                //                                     ),
                                                //                                   ),
                                                //                                 ),
                                                //                               )
                                                //                             ],
                                                //                           ),
                                                //                         )),
                                                //                   ],
                                                //                 )
                                                //               : Container(),
                                                //         ))
                                                //   ],
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : (role == "1")
                                        ? Expanded(
                                            child: Container(
                                            width: 300,
                                            decoration: BoxDecoration(color: mainColor),
                                            margin: EdgeInsets.only(top: 20),
                                            child: SingleChildScrollView(
                                              controller: ScrollController(),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                    decoration: BoxDecoration(
                                                      color: (user.getSttPage() == 20) ? white : mainColor,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: TextButton.icon(
                                                      icon: Icon(
                                                        Icons.home,
                                                        color: (user.getSttPage() == 20) ? mainColor : white,
                                                      ),
                                                      label: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        // ignore: prefer_const_literals_to_create_immutables
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                            child: Text(
                                                              "Trang chủ",
                                                              style: TextStyle(color: (user.getSttPage() == 20) ? mainColor : white, fontSize: 16, fontWeight: FontWeight.w500),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pushNamed(context, '/trang-chu-gv');
                                                        setState(() {
                                                          user.changeSttMenu(20);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                    decoration: BoxDecoration(
                                                      color: (user.getSttPage() == 21) ? white : mainColor,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: TextButton.icon(
                                                      icon: Icon(
                                                        Icons.groups,
                                                        color: (user.getSttPage() == 21) ? mainColor : white,
                                                      ),
                                                      label: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        // ignore: prefer_const_literals_to_create_immutables
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                            child: Text(
                                                              "Sinh viên thực tập",
                                                              style: TextStyle(color: (user.getSttPage() == 21) ? mainColor : white, fontSize: 16, fontWeight: FontWeight.w500),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pushNamed(context, '/quan-ly-sinh-vien-gv');
                                                        setState(() {
                                                          user.changeSttMenu(21);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                    decoration: BoxDecoration(
                                                      color: (user.getSttPage() == 22) ? white : mainColor,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: TextButton.icon(
                                                      icon: Icon(
                                                        Icons.notifications_active,
                                                        color: (user.getSttPage() == 22) ? mainColor : white,
                                                      ),
                                                      label: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        // ignore: prefer_const_literals_to_create_immutables
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                            child: Text(
                                                              "Thông báo sinh viên",
                                                              style: TextStyle(color: (user.getSttPage() == 22) ? mainColor : white, fontSize: 16, fontWeight: FontWeight.w500),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pushNamed(context, '/thong-bao-gui-sv');
                                                        setState(() {
                                                          user.changeSttMenu(22);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                    decoration: BoxDecoration(
                                                      color: (user.getSttPage() == 23) ? white : mainColor,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: TextButton.icon(
                                                      icon: Icon(
                                                        Icons.folder,
                                                        color: (user.getSttPage() == 23) ? mainColor : white,
                                                      ),
                                                      label: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        // ignore: prefer_const_literals_to_create_immutables
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                            child: Text(
                                                              "Kho file",
                                                              style: TextStyle(color: (user.getSttPage() == 23) ? mainColor : white, fontSize: 16, fontWeight: FontWeight.w500),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pushNamed(context, '/kho-file');
                                                        setState(() {
                                                          user.changeSttMenu(23);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))
                                        : Expanded(
                                            child: Container(
                                            width: 300,
                                            decoration: BoxDecoration(color: mainColor),
                                            margin: EdgeInsets.only(top: 20),
                                            child: SingleChildScrollView(
                                              controller: ScrollController(),
                                              child: (user.sinhVien.id != -1)
                                                  ? Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Container(
                                                          margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                          decoration: BoxDecoration(
                                                            color: (user.getSttPage() == 10) ? white : mainColor,
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: TextButton.icon(
                                                            icon: Icon(
                                                              Icons.home,
                                                              color: (user.getSttPage() == 10) ? mainColor : white,
                                                            ),
                                                            label: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              // ignore: prefer_const_literals_to_create_immutables
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                                  child: Text(
                                                                    "Trang chủ",
                                                                    style: TextStyle(color: (user.getSttPage() == 10) ? mainColor : white, fontSize: 16, fontWeight: FontWeight.w500),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pushNamed(context, '/ke-hoach-thuc-tap-sv');
                                                              setState(() {
                                                                user.changeSttMenu(10);
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        (sinhVien.status! <= 1 && user.khttNow.status == 0)
                                                            ? Container(
                                                                margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                                decoration: BoxDecoration(
                                                                  color: (user.getSttPage() == 11) ? white : mainColor,
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                                child: TextButton.icon(
                                                                  icon: Icon(
                                                                    Icons.follow_the_signs,
                                                                    color: (user.getSttPage() == 11) ? mainColor : white,
                                                                  ),
                                                                  label: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    // ignore: prefer_const_literals_to_create_immutables
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                                        child: Text(
                                                                          "Đăng ký đề tài",
                                                                          style: TextStyle(color: (user.getSttPage() == 11) ? mainColor : white, fontSize: 16, fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.pushNamed(context, '/dang-ky-de-tai');
                                                                    setState(() {
                                                                      user.changeSttMenu(11);
                                                                    });
                                                                  },
                                                                ),
                                                              )
                                                            : Column(
                                                                children: [
                                                                  if (user.khttNow.status == 0)
                                                                    Container(
                                                                      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                                      decoration: BoxDecoration(
                                                                        color: (user.getSttPage() == 12) ? white : mainColor,
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: TextButton.icon(
                                                                        icon: Icon(
                                                                          Icons.mark_chat_unread,
                                                                          color: (user.getSttPage() == 12) ? mainColor : white,
                                                                        ),
                                                                        label: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          // ignore: prefer_const_literals_to_create_immutables
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                                              child: Text(
                                                                                "Thông báo của GVHD",
                                                                                style: TextStyle(color: (user.getSttPage() == 12) ? mainColor : white, fontSize: 16, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        onPressed: () {
                                                                          Navigator.pushNamed(context, '/thong-bao-gvhd');
                                                                          setState(() {
                                                                            user.changeSttMenu(12);
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  if (user.khttNow.status == 0)
                                                                    Container(
                                                                      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                                      decoration: BoxDecoration(
                                                                        color: (user.getSttPage() == 13) ? white : mainColor,
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: TextButton.icon(
                                                                        icon: Icon(
                                                                          Icons.folder,
                                                                          color: (user.getSttPage() == 13) ? mainColor : white,
                                                                        ),
                                                                        label: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          // ignore: prefer_const_literals_to_create_immutables
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                                              child: Text(
                                                                                "Kho file",
                                                                                style: TextStyle(color: (user.getSttPage() == 13) ? mainColor : white, fontSize: 16, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        onPressed: () {
                                                                          Navigator.pushNamed(context, '/file-gui-sv');
                                                                          setState(() {
                                                                            user.changeSttMenu(13);
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  if (user.sinhVien.status! >= 3 && user.khttNow.status == 0)
                                                                    Container(
                                                                      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                                      decoration: BoxDecoration(
                                                                        color: (user.getSttPage() == 14) ? white : mainColor,
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: TextButton.icon(
                                                                        icon: Icon(
                                                                          Icons.history_edu,
                                                                          color: (user.getSttPage() == 14) ? mainColor : white,
                                                                        ),
                                                                        label: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          // ignore: prefer_const_literals_to_create_immutables
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                                              child: Text(
                                                                                "Nhật ký thực tập",
                                                                                style: TextStyle(color: (user.getSttPage() == 14) ? mainColor : white, fontSize: 16, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        onPressed: () {
                                                                          Navigator.pushNamed(context, '/nhat-ky-thuc-tap');
                                                                          setState(() {
                                                                            user.changeSttMenu(14);
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  if (user.khttNow.status == 0)
                                                                    Container(
                                                                      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                                      decoration: BoxDecoration(
                                                                        color: (user.getSttPage() == 15) ? white : mainColor,
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: TextButton.icon(
                                                                        icon: Icon(
                                                                          Icons.mood,
                                                                          color: (user.getSttPage() == 15) ? mainColor : white,
                                                                        ),
                                                                        label: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          // ignore: prefer_const_literals_to_create_immutables
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                                              child: Text(
                                                                                "Khảo sát",
                                                                                style: TextStyle(color: (user.getSttPage() == 15) ? mainColor : white, fontSize: 16, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        onPressed: () {
                                                                          Navigator.pushNamed(context, '/khao-sat-sv');
                                                                          setState(() {
                                                                            user.changeSttMenu(15);
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  if (user.sinhVien.status == 4 || user.sinhVien.status == 5)
                                                                    if (user.khttNow.status == 0)
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                                        decoration: BoxDecoration(
                                                                          color: (user.getSttPage() == 16) ? white : mainColor,
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                        child: TextButton.icon(
                                                                          icon: Icon(
                                                                            Icons.description,
                                                                            color: (user.getSttPage() == 16) ? mainColor : white,
                                                                          ),
                                                                          label: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            // ignore: prefer_const_literals_to_create_immutables
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                                                child: Text(
                                                                                  "Nộp báo cáo",
                                                                                  style: TextStyle(color: (user.getSttPage() == 16) ? mainColor : white, fontSize: 16, fontWeight: FontWeight.w500),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          onPressed: () {
                                                                            Navigator.pushNamed(context, '/nop-bao-cao-sv');
                                                                            setState(() {
                                                                              user.changeSttMenu(16);
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                ],
                                                              ),
                                                      ],
                                                    )
                                                  : Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Container(
                                                          margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                          decoration: BoxDecoration(
                                                            color: (user.getSttPage() == 10) ? white : mainColor,
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: TextButton.icon(
                                                            icon: Icon(
                                                              Icons.home,
                                                              color: (user.getSttPage() == 10) ? mainColor : white,
                                                            ),
                                                            label: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              // ignore: prefer_const_literals_to_create_immutables
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.fromLTRB(6, 15, 20, 15),
                                                                  child: Text(
                                                                    "Trang chủ",
                                                                    style: TextStyle(color: (user.getSttPage() == 10) ? mainColor : white, fontSize: 16, fontWeight: FontWeight.w500),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pushNamed(context, '/ke-hoach-thuc-tap-sv');
                                                              setState(() {
                                                                user.changeSttMenu(10);
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          )),
                              ],
                            ))
                        : Container(),
                    Container(
                        width: (showMenu) ? width - 300 : width,
                        decoration: BoxDecoration(
                            // borderRadius: borderRadiusContainer,
                            // boxShadow: [boxShadowContainer],
                            // border: borderAllContainerBox,
                            ),
                        child: widget.widgetBody)
                  ],
                ),
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(70.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: mainColor,
                        ),
                      ),
                      color: Color.fromARGB(0, 242, 242, 242),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 229, 229, 229).withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Custom drawer icon
                        AppBar(
                          automaticallyImplyLeading: false,
                          leading: Builder(
                            builder: (BuildContext context) {
                              return IconButton(
                                icon: Icon(
                                  showMenu ? Icons.menu_open_outlined : Icons.menu,
                                  size: 22,
                                  color: mainColor, // Change Custom Drawer Icon Color
                                ),
                                onPressed: () {
                                  showMenu = !showMenu;
                                  setState(() {});
                                },
                                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                              );
                            },
                          ),
                          backgroundColor: Colors.transparent, // 1
                          elevation: 0,
                          title: Row(
                            children: [
                              Image.asset(
                                "/images/logo.png",
                                width: 150,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  'HỆ THỐNG QUẢN LÝ THỰC TẬP TỐT NGHIỆP',
                                  style: TextStyle(
                                    color: orange,
                                    fontSize: 25,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            // MenuPopupTest(),
                            SizedBox(
                              width: 20,
                            ),
                            PopupMenuButton<String>(
                              tooltip: 'Thông tin cá nhân',
                              offset: Offset(0.0, appBarHeight + 8),
                              child: SizedBox(
                                width: size.width * 0.12,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ClipOval(
                                        child: (user.user.avatar != null && user.user.avatar != "")
                                            ? Image.network(
                                                "$baseUrl/api/files/${user.user.avatar!}",
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                "/images/noavatar.png",
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        name,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  enabled: false,
                                  child: Container(
                                    decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
                                    child: Column(
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                                            minimumSize: Size(50, 30),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                "${user.user.fullName}",
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                                style: textNormal,
                                              )
                                            ],
                                          ),
                                          onPressed: (role != "0")
                                              ? () {
                                                  if (role == "1") {
                                                    Navigator.push<void>(
                                                      context,
                                                      MaterialPageRoute<void>(
                                                        builder: (BuildContext context) => XemGVHD(
                                                          gvhd: user.user,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    Navigator.push<void>(
                                                      context,
                                                      MaterialPageRoute<void>(
                                                        builder: (BuildContext context) => ThongTinSinhVien(
                                                          data: user.sinhVien,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                              : null,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 20, top: 10),
                                          child: Row(
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    'Chức vụ:',
                                                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
                                                  )),
                                              Expanded(
                                                  flex: 5,
                                                  child: Text(
                                                      (role == "0")
                                                          ? "Cán bộ khoa / TTDT"
                                                          : (role == "1")
                                                              ? "Giảng viên"
                                                              : (role == "2")
                                                                  ? "Sinh viên"
                                                                  : "",
                                                      style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600)))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const PopupMenuItem(
                                  enabled: false,
                                  child: Text(
                                    'Cài đặt',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: Container(width: 30, height: 30, alignment: Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Color.fromARGB(235, 209, 209, 209)), child: Icon(Icons.key)),
                                    contentPadding: const EdgeInsets.all(0),
                                    hoverColor: Colors.transparent,
                                    title: const Text(
                                      'Đổi mật khẩu',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    onTap: (() {
                                      showDialog(context: context, builder: (BuildContext context) => ChangePassword());
                                    }),
                                  ),
                                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: Container(width: 30, height: 30, alignment: Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Color.fromARGB(235, 209, 209, 209)), child: Icon(Icons.logout)),
                                    contentPadding: const EdgeInsets.all(0),
                                    hoverColor: Colors.transparent,
                                    title: const Text(
                                      'Đăng xuất',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    onTap: (() {
                                      Navigator.pushNamed(context, '/login');
                                    }),
                                  ),
                                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ))
            : CommonApp().loadingCallAPi();
      }),
    );
  }
}
