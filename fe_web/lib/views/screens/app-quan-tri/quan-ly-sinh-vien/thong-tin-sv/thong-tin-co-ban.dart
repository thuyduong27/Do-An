// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fe_web/views/common/loadApi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../confing.dart';
import '../../../../../models/sinh-vien.dart';
import '../../../../common/style.dart';
import '../../../../common/text-file.dart';

class ThongTinCoBan extends StatefulWidget {
  SinhVien data;
  ThongTinCoBan({Key? key, required this.data}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ThongTinCoBan> {
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
  bool satatusData = false;

  callApi() async {
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

    return Container(
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      layoutData(
                        lable1: "Họ tên: ",
                        data1: "${widget.data.nguoiDung!.fullName}",
                        lable2: "Mã sinh viên: ",
                        data2: "${widget.data.nguoiDung!.maSv}",
                      ),
                      layoutData(
                        lable1: "Email: ",
                        data1: "${widget.data.nguoiDung!.email}",
                        lable2: "Số điện thoại: ",
                        data2: "${widget.data.nguoiDung!.sdt}",
                      ),
                      // layoutData(
                      //   lable1: "Giới tính: ",
                      //   data1: (widget.data.nguoiDung!.gioiTinh == true)
                      //       ? "Nữ"
                      //       : (widget.data.nguoiDung!.gioiTinh == false)
                      //           ? "Nam"
                      //           : "",
                      //   lable2: "Địa chỉ: ",
                      //   data2: widget.data.nguoiDung!.address ?? "",
                      // ),
                      layoutData(
                        lable1: "Ngày sinh: ",
                        data1: (widget.data.nguoiDung!.ngaySinh != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.data.nguoiDung!.ngaySinh!)) : "",
                        lable2: "Khoá: ",
                        data2: "${widget.data.nguoiDung!.khoa}",
                      ),
                      layoutData(
                        lable1: "Lớp: ",
                        data1: "${widget.data.nguoiDung!.lop}",
                        lable2: "Ngành: ",
                        data2: "${listNganh[widget.data.nguoiDung!.nganh]}",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Tooltip(
                              verticalOffset: 0,
                              message: "${listTrangthai[widget.data.status]}",
                              child: TextFieldValidatedForm(
                                type: 'None',
                                height: 40,
                                controller: TextEditingController(
                                  text: "${listTrangthai[widget.data.status]}",
                                ),
                                label: "Trạng thái: ",
                                flexLable: 2,
                                enabled: false,
                              ),
                            ),
                          ),
                          SizedBox(width: 100),
                          Expanded(
                            flex: 3,
                            child: Container(),
                          ),
                        ],
                      ),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    height: 250,
                    width: 150,
                    margin: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                    ),
                    child: (widget.data.nguoiDung!.avatar != null)
                        ? Image.network(
                            "$baseUrl/api/files/${widget.data.nguoiDung!.avatar!}",
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "/images/noavatar.png",
                            fit: BoxFit.cover,
                          ),
                  ))
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
