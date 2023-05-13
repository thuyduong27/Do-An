// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:convert';

import 'package:fe_web/controllers/api.dart';
import 'package:fe_web/models/company.dart';
import 'package:fe_web/models/sinh-vien.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/provider.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/text-file.dart';
import '../../../common/title_page.dart';
import '../../../common/toast.dart';

class KHTTSVScreen extends StatefulWidget {
  KHTTSVScreen({Key? key}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<KHTTSVScreen> {
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
  LocalStorage storage = LocalStorage("storage");
  // String? id;
  // String? role;
  // SinhVien sinhVien = SinhVien();
  bool statusData = false;
  // callSinhVien() async {

  //   List<SinhVien> listsinhVien = [];
  //   var responseSinhVien = await httpGet("/api/sinh-vien-thuc-tap/get/page?filter=idNguoiDung:$id and keHoachThucTap.status:0", context);
  //   if (responseSinhVien.containsKey("body")) {
  //     setState(() {
  //       var body = jsonDecode(responseSinhVien['body']);
  //       var content = [];
  //       content = body['result']['content'];
  //       listsinhVien = content.map((e) {
  //         return SinhVien.fromJson(e);
  //       }).toList();
  //       if (listsinhVien.isNotEmpty) {
  //         sinhVien = listsinhVien.first;

  //       }
  //     });
  //   }
  // }

  void callApi() async {
    // role = storage.getItem("role");
    // id = storage.getItem("id");
    // await callSinhVien();
    statusData = true;
  }

  @override
  void initState() {
    super.initState();
    callApi();
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
                  content: 'Tổng quan',
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
                  child: (user.sinhVien.id != -1)
                      ? ListView(
                          controller: ScrollController(),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Tooltip(
                                    verticalOffset: 0,
                                    message: listTrangthai[user.sinhVien.status],
                                    child: TextFieldValidatedForm(
                                      type: 'None',
                                      height: 40,
                                      controller: TextEditingController(text: listTrangthai[user.sinhVien.status]),
                                      label: "Trạng thái: ",
                                      flexLable: 2,
                                      enabled: false,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 100),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (user.sinhVien.status! >= 6)
                              Column(
                                children: [
                                  Row(
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
                                                  text: user.sinhVien.diem ?? "",
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
                                                  if (user.sinhVien.fileBaoCao != null && user.sinhVien.fileBaoCao != "") {
                                                    downloadFile(user.sinhVien.fileBaoCao!);
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
                                  SizedBox(
                                    height: 30,
                                  )
                                ],
                              ),
                            keHoachThucTapWidget(),
                            giangVienWidget(),
                            companyWidget(),
                          ],
                        )
                      : Center(
                          child: Text("Bạn chưa được tham gia vào kế khoạch thực tập nào", style: titleContainerBox1),
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
          Divider(
            thickness: 1,
            color: colorPage,
          ),
          SizedBox(height: 10),
          Row(
            children: [Text("Kế hoạch thực tập", style: titleContainerBox)],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Tooltip(
                  verticalOffset: 0,
                  message: user.sinhVien.keHoachThucTap!.tilte,
                  child: TextFieldValidatedForm(
                    type: 'None',
                    height: 40,
                    controller: TextEditingController(text: user.sinhVien.keHoachThucTap!.tilte),
                    label: "Tiêu đề: ",
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
                  message: "",
                  child: TextFieldValidatedForm(
                    type: 'None',
                    height: 40,
                    // controller: address,
                    label: "File danh sách: ",
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
                  message: DateFormat('dd-MM-yyyy').format(DateTime.parse(user.sinhVien.keHoachThucTap!.startDate!)),
                  child: TextFieldValidatedForm(
                    type: 'None',
                    height: 40,
                    controller: TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.parse(user.sinhVien.keHoachThucTap!.startDate!).toLocal())),
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
                  message: DateFormat('dd-MM-yyyy').format(DateTime.parse(user.sinhVien.keHoachThucTap!.endDate!)),
                  child: TextFieldValidatedForm(
                    type: 'None',
                    height: 40,
                    controller: TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.parse(user.sinhVien.keHoachThucTap!.endDate!).toLocal())),
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
                  message: (user.sinhVien.keHoachThucTap!.hanDangKy != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.sinhVien.keHoachThucTap!.hanDangKy!).toLocal()) : "",
                  child: TextFieldValidatedForm(
                    type: 'None',
                    height: 40,
                    controller: TextEditingController(text: (user.sinhVien.keHoachThucTap!.hanDangKy != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.sinhVien.keHoachThucTap!.hanDangKy!).toLocal()) : ""),
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
                  message: (user.sinhVien.keHoachThucTap!.hanNopBaoCao != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.sinhVien.keHoachThucTap!.hanNopBaoCao!).toLocal()) : "",
                  child: TextFieldValidatedForm(
                    type: 'None',
                    height: 40,
                    controller: TextEditingController(text: (user.sinhVien.keHoachThucTap!.hanNopBaoCao != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.sinhVien.keHoachThucTap!.hanNopBaoCao!)) : ""),
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
                  message: (user.sinhVien.keHoachThucTap!.ngayDiThuctap != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.sinhVien.keHoachThucTap!.ngayDiThuctap!).toLocal()) : "",
                  child: TextFieldValidatedForm(
                    type: 'None',
                    height: 40,
                    controller: TextEditingController(text: (user.sinhVien.keHoachThucTap!.ngayDiThuctap != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.sinhVien.keHoachThucTap!.ngayDiThuctap!)) : ""),
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
                  message: (user.sinhVien.keHoachThucTap!.ngayHetThuctap != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.sinhVien.keHoachThucTap!.ngayHetThuctap!).toLocal()) : "",
                  child: TextFieldValidatedForm(
                    type: 'None',
                    height: 40,
                    controller: TextEditingController(text: (user.sinhVien.keHoachThucTap!.ngayHetThuctap != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.sinhVien.keHoachThucTap!.ngayHetThuctap!)) : ""),
                    label: "Ngày hết thực tập: ",
                    flexLable: 2,
                    enabled: false,
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
            controller: TextEditingController(text: user.sinhVien.keHoachThucTap!.content ?? ""),
            enabled: false,
          ),
        ],
      ),
    );
  }

  giangVienWidget() {
    return Consumer<SecurityModel>(
      builder: (context, user, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Divider(
            thickness: 1,
            color: colorPage,
          ),
          SizedBox(height: 10),
          Text("Giảng viên hướng dẫn", style: titleContainerBox),
          SizedBox(height: 30),
          (user.sinhVien.status == 0 || user.sinhVien.status == 1 || user.sinhVien.giaoVien == null)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Bạn chưa được phân giảng viên hướng dẫn", style: titleContainerBox),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    layoutData(
                      lable1: "Tên:",
                      data1: "${user.sinhVien.giaoVien!.fullName}",
                      lable2: "Giới tính:",
                      data2: (user.sinhVien.giaoVien!.gioiTinh == true)
                          ? "Nữ"
                          : (user.sinhVien.giaoVien!.gioiTinh == false)
                              ? "Nam"
                              : "",
                    ),
                    layoutData(
                      lable1: "Học vị:",
                      data1: (user.sinhVien.giaoVien!.hocVi == 1)
                          ? "Thạc sĩ"
                          : (user.sinhVien.giaoVien!.hocVi == 2)
                              ? "Tiến sĩ"
                              : "",
                      lable2: "Đơn vị:",
                      data2: "${user.sinhVien.giaoVien!.donVi}",
                    ),
                    layoutData(
                      lable1: "Email:",
                      data1: "${user.sinhVien.giaoVien!.email}",
                      lable2: "SĐT:",
                      data2: "${user.sinhVien.giaoVien!.sdt}",
                    ),
                  ],
                )
        ],
      ),
    );
  }

  companyWidget() {
    return Consumer<SecurityModel>(
      builder: (context, user, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Divider(
            thickness: 1,
            color: colorPage,
          ),
          SizedBox(height: 10),
          Text("Cơ sở thực tập", style: titleContainerBox),
          (user.sinhVien.status == 0 || user.sinhVien.doanhNghiep == null)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Bạn chưa đăng ký cơ sở thực tập", style: titleContainerBox),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user.sinhVien.doanhNghiep!.status == 0) Center(child: Text("Doanh nghiệp đang chờ được xác nhận", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red))),
                    SizedBox(height: 30),
                    layoutData(
                      lable1: "Tên:",
                      data1: "${user.sinhVien.doanhNghiep!.name}",
                      lable2: "MST:",
                      data2: "${user.sinhVien.doanhNghiep!.mst}",
                    ),
                    layoutData(
                      lable1: "Người quản lý:",
                      data1: "${user.sinhVien.doanhNghiep!.manager}",
                      lable2: "Email:",
                      data2: "${user.sinhVien.doanhNghiep!.managerEmail}",
                    ),
                    layoutData(
                      lable1: "SDT:",
                      data1: "${user.sinhVien.doanhNghiep!.managerSdt}",
                      lable2: "Địa chỉ",
                      data2: "${user.sinhVien.doanhNghiep!.address}",
                    ),
                    Text("Đề tài: ", style: titleContainerBox),
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
                      controller: TextEditingController(text: user.sinhVien.deTai ?? ""),
                      enabled: false,
                    ),
                  ],
                )
        ],
      ),
    );
  }
}

layoutData({String? lable1, String? data1, String? lable2, String? data2}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Tooltip(
              verticalOffset: 0,
              message: data1 ?? "",
              child: TextFieldValidatedForm(
                type: 'None',
                height: 40,
                controller: TextEditingController(text: data1 ?? ""),
                label: lable1,
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
              message: data2 ?? "",
              child: TextFieldValidatedForm(
                type: 'None',
                height: 40,
                controller: TextEditingController(text: data2 ?? ""),
                label: lable2,
                flexLable: 2,
                enabled: false,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
