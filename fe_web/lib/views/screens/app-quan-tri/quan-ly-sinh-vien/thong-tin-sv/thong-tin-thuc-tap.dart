// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, use_build_context_synchronously

import 'package:fe_web/controllers/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../controllers/provider.dart';
import '../../../../../models/sinh-vien.dart';
import '../../../../common/style.dart';
import '../../../../common/text-file.dart';
import '../../../../common/toast.dart';

class ThongTinThucTap extends StatefulWidget {
  SinhVien data;
  Function? callback;
  ThongTinThucTap({Key? key, required this.data, this.callback}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ThongTinThucTap> {
  bool satatusData = false;
  bool editDeTai = false;
  TextEditingController deTai = TextEditingController();

  callApi() async {
    deTai.text = widget.data.deTai ?? "";
    setState(() {
      satatusData = true;
    });
  }

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

    return Consumer<SecurityModel>(
         builder: (context, user, child) =>  Container(
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
            SizedBox(height: 10),
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
                (user.user.role==1)
               ? Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: (widget.data.status == 2)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Sinh viên đi thực tập:   ",
                                style: titleContainerBox,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context).iconTheme.color,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                    horizontal: 50.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  backgroundColor: mainColor,
                                  textStyle: TextStyle(fontSize: 10.0, letterSpacing: 2.0, color: Colors.white),
                                ),
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                            title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                              SizedBox(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Xác nhận sinh viên đi thực tập',
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
                                              height: 160,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Divider(
                                                    thickness: 1,
                                                    color: colorPage,
                                                  ),
                                                  Text("Xác nhận sinh viên ${widget.data.nguoiDung!.fullName} bắt đầu đi thực tập tại doanh nghiệp"),
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
                                                style: ElevatedButton.styleFrom(
                                                  primary: orange,
                                                  onPrimary: white,
                                                  elevation: 3,
                                                  minimumSize: Size(100, 40),
                                                ),
                                                child: Text('Hủy'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    widget.data.status = 3;
                                                  });
                                                  var abc = await httpPut('/api/sinh-vien-thuc-tap/put/${widget.data.id}', widget.data.toJson(), context);
                                                  print(abc);
                                                  widget.callback!(widget.data);
                                                  showToast(
                                                    context: context,
                                                    msg: "Sinh viên đã bắt đầu đi thực tập",
                                                    color: Color.fromARGB(136, 72, 238, 67),
                                                    icon: const Icon(Icons.done),
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: mainColor,
                                                  onPrimary: white,
                                                  elevation: 3,
                                                  minimumSize: Size(100, 40),
                                                ),
                                                child: Text(
                                                  'Xác nhận',
                                                  style: TextStyle(),
                                                ),
                                              ),
                                            ],
                                          ));
                                  // Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Text('Xác nhận', style: textTitleTabbarW),
                                  ],
                                ),
                              )
                            ],
                          )
                        : (widget.data.status == 3)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sinh viên hoàn thành thực tập:   ",
                                    style: titleContainerBox,
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Theme.of(context).iconTheme.color,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                        horizontal: 50.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      backgroundColor: mainColor,
                                      textStyle: TextStyle(fontSize: 10.0, letterSpacing: 2.0, color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (BuildContext context) => AlertDialog(
                                                title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                  SizedBox(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Xác nhận sinh viên hoàn thành thực tập',
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
                                                  height: 160,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Divider(
                                                        thickness: 1,
                                                        color: colorPage,
                                                      ),
                                                      Text("Xác nhận sinh viên ${widget.data.nguoiDung!.fullName} hoàn thành thực tập tại doanh nghiệp"),
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
                                                    style: ElevatedButton.styleFrom(
                                                      primary: orange,
                                                      onPrimary: white,
                                                      elevation: 3,
                                                      minimumSize: Size(100, 40),
                                                    ),
                                                    child: Text('Hủy'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        widget.data.status = 4;
                                                      });
                                                      await httpPut('/api/sinh-vien-thuc-tap/put/${widget.data.id}', widget.data.toJson(), context);
                                                      widget.callback!(widget.data);
                                                      showToast(
                                                        context: context,
                                                        msg: "Sinh viên đã hoàn thành thực tập",
                                                        color: Color.fromARGB(136, 72, 238, 67),
                                                        icon: const Icon(Icons.done),
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      primary: mainColor,
                                                      onPrimary: white,
                                                      elevation: 3,
                                                      minimumSize: Size(100, 40),
                                                    ),
                                                    child: Text(
                                                      'Xác nhận',
                                                      style: TextStyle(),
                                                    ),
                                                  ),
                                                ],
                                              ));
                                      // Navigator.pop(context);
                                    },
                                    child: Row(
                                      children: [
                                        Text('Xác nhận', style: textTitleTabbarW),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : Row(),
                  ),
                ):Expanded(flex: 3,child: Container()),
              ],
            ),
            Divider(
              thickness: 1,
              color: colorPage,
            ),
            SizedBox(height: 10),
            giangVienWidget(widget.data),
            companyWidget(widget.data),
          ],
        ),
      ),
    );
  }

  giangVienWidget(SinhVien data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Giảng viên hướng dẫn", style: titleContainerBox),
        SizedBox(height: 30),
        (data.status == 0 || data.status == 1 || data.giaoVien == null)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Thực tập sinh chưa được phân giảng viên hướng dẫn", style: titleContainerBox),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  layoutData(
                    lable1: "Tên:",
                    data1: "${data.giaoVien!.fullName}",
                    lable2: "Giới tính:",
                    data2: (data.giaoVien!.gioiTinh == true)
                        ? "Nữ"
                        : (data.giaoVien!.gioiTinh == false)
                            ? "Nam"
                            : "",
                  ),
                  layoutData(
                    lable1: "Học vị:",
                    data1: (data.giaoVien!.hocVi == 1)
                        ? "Thạc sĩ"
                        : (data.giaoVien!.hocVi == 2)
                            ? "Tiến sĩ"
                            : "",
                    lable2: "Đơn vị:",
                    data2: "${data.giaoVien!.donVi}",
                  ),
                  layoutData(
                    lable1: "Email:",
                    data1: "${data.giaoVien!.email}",
                    lable2: "SĐT:",
                    data2: "${data.giaoVien!.sdt}",
                  ),
                ],
              )
      ],
    );
  }

  companyWidget(SinhVien data) {
    return  Consumer<SecurityModel>(
      builder: (context, user, child) =>  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Divider(
            thickness: 1,
            color: colorPage,
          ),
          SizedBox(height: 10),
          Text("Cơ sở thực tập", style: titleContainerBox),
          (data.status == 0 || data.doanhNghiep == null)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Thực tập sinh đăng ký cơ sở thực tập", style: titleContainerBox),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.doanhNghiep!.status == 0) Center(child: Text("Doanh nghiệp đang chờ được xác nhận", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red))),
                    SizedBox(height: 30),
                    layoutData(
                      lable1: "Tên:",
                      data1: "${data.doanhNghiep!.name}",
                      lable2: "MST:",
                      data2: "${data.doanhNghiep!.mst}",
                    ),
                    layoutData(
                      lable1: "Người quản lý:",
                      data1: "${data.doanhNghiep!.manager}",
                      lable2: "Email:",
                      data2: "${data.doanhNghiep!.managerEmail}",
                    ),
                    layoutData(
                      lable1: "SDT:",
                      data1: "${data.doanhNghiep!.managerSdt}",
                      lable2: "Địa chỉ",
                      data2: "${data.doanhNghiep!.address}",
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
                      controller: TextEditingController(text: widget.data.deTai ?? ""),
                      enabled: editDeTai,
                    ),
                    SizedBox(height: 15),
                    (widget.data.status == 1)
                        ? Center(
                            child: Container(
                              width: 250,
                              margin: EdgeInsets.only(top: 15),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context).iconTheme.color,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                    horizontal: 50.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  backgroundColor: mainColor,
                                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                ),
                                onPressed: () async {
                                  widget.data.status = 2;
                                  await httpPut("/api/sinh-vien-thuc-tap/put/${widget.data.id}", widget.data.toJson(), context);
                                  // ignore: use_build_context_synchronously
                                  showToast(
                                    context: context,
                                    msg: "Đã phê duyệt đề tài",
                                    color: mainColor,
                                    icon: const Icon(Icons.done),
                                  );
                                  setState(() {
                                    widget.data.status = 2;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text('Phê duyệt đề tài', style: textTitleTabbarW),
                                  ],
                                ),
                              ),
                            ),
                          )
                        :(user.user.role!=2)? Center(
                            child: Container(
                            width: 250,
                            margin: EdgeInsets.only(top: 15),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context).iconTheme.color,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 50.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                backgroundColor: mainColor,
                                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                              ),
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            SizedBox(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Đổi đề tài sinh viên',
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
                                            height: 300,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Đề tài: ", style: titleContainerBox),
                                                SizedBox(height: 10),
                                                TextField(
                                                  maxLines: 20,
                                                  minLines: 5,
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
                                                  controller: deTai,
                                                ),
                                              ],
                                            ),
                                          ),
                                          //actions
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () => Navigator.pop(context),
                                              style: ElevatedButton.styleFrom(
                                                primary: orange,
                                                onPrimary: white,
                                                elevation: 3,
                                                minimumSize: Size(100, 40),
                                              ),
                                              child: Text('Hủy'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                setState(() {
                                                  widget.data.deTai = deTai.text;
                                                });
                                                await httpPut('/api/sinh-vien-thuc-tap/put/${widget.data.id}', widget.data.toJson(), context);
                                                widget.callback!(widget.data);
                                                showToast(
                                                  context: context,
                                                  msg: "Cập nhật thành công",
                                                  color: Color.fromARGB(136, 72, 238, 67),
                                                  icon: const Icon(Icons.done),
                                                );
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: mainColor,
                                                onPrimary: white,
                                                elevation: 3,
                                                minimumSize: Size(100, 40),
                                              ),
                                              child: Text(
                                                'Xác nhận',
                                                style: TextStyle(),
                                              ),
                                            ),
                                          ],
                                        ));
                              },
                              child: Row(
                                children: [
                                  Text('Thay đổi đề tài', style: textTitleTabbarW),
                                ],
                              ),
                            ),
                          )):Row(),
                    SizedBox(height: 15),
                    if (widget.data.status! > 4)
                      layoutData(
                        lable1: "Điểm:",
                        data1: data.diem??"",
                        lable2: "File báo cáo:",
                        data2: "${data.fileBaoCao}",
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
