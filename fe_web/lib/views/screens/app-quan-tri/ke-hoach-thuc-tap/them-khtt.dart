// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'package:fe_web/models/company.dart';
import 'package:fe_web/models/ke-hoach-thuc-tap.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../common/date-pick-time.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/text-file.dart';
import '../../../common/title_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';

import '../../../common/toast.dart';

class ThemMoiKHTT extends StatefulWidget {
  Function callbackChange;
  ThemMoiKHTT({Key? key, required this.callbackChange}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<ThemMoiKHTT> {
  TextEditingController tieuDe = TextEditingController();
  TextEditingController noiDung = TextEditingController();

  Map<int, String> listTrangthai = {
    -1: '<<<<---Chọn--->>>>',
    0: 'Đang thực hiện',
    1: 'Hoàn thành',
    2: 'Huỷ',
  };
  int selectedTrangThai = -1;
  var time1;
  var time2;
  var time3;
  var time4;
  var time5;
  var time6;
  String? fileHopDong;
  late KeHoachThucTap data;

  @override
  void initState() {
    super.initState();
    data = KeHoachThucTap();
  }

  void dispose() {
    tieuDe.dispose();
    noiDung.dispose();
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
                  {'url': "/nhan-su", 'title': 'Trang chủ'},
                  {'url': "/ke-hoach-thuc-tap", 'title': 'Kế hoạch thực tập'},
                ],
                content: 'Thêm mới kế hoạch thực tập',
              ),
              Container(
                height: MediaQuery.of(context).size.height - 200,
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
                      padding: paddingBoxContainer,
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
                          Column(
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
                                      requiredValue: 1,
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
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Text('Trạng thái:', style: titleContainerBox),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(left: 5),
                                                    child: Text("*",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 16,
                                                        )),
                                                  ),
                                                ],
                                              )),
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
                                          // print(day);
                                          setState(() {});
                                        }),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: DatePickerBox1(
                                        isTime: false,
                                        label: Text(
                                          'Hạn đăng ký:',
                                          style: titleContainerBox,
                                        ),
                                        dateDisplay: time3,
                                        selectedDateFunction: (day) {
                                          time3 = day;
                                          setState(() {});
                                        }),
                                  ),
                                  SizedBox(width: 100),
                                  Expanded(
                                    flex: 3,
                                    child: DatePickerBox1(
                                        isTime: false,
                                        label: Text(
                                          'Hạn nộp báo cáo:',
                                          style: titleContainerBox,
                                        ),
                                        dateDisplay: time4,
                                        selectedDateFunction: (day) {
                                          time4 = day;
                                          print(day);
                                          setState(() {});
                                        }),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: DatePickerBox1(
                                        isTime: false,
                                        label: Text(
                                          'Ngày đi thực tập:',
                                          style: titleContainerBox,
                                        ),
                                        dateDisplay: time5,
                                        selectedDateFunction: (day) {
                                          time5 = day;
                                          setState(() {});
                                        }),
                                  ),
                                  SizedBox(width: 100),
                                  Expanded(
                                    flex: 3,
                                    child: DatePickerBox1(
                                        isTime: false,
                                        label: Text(
                                          'Ngày hết thực tập:',
                                          style: titleContainerBox,
                                        ),
                                        dateDisplay: time6,
                                        selectedDateFunction: (day) {
                                          time6 = day;
                                          // print(day);
                                          setState(() {});
                                        }),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 30),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text('File đính kèm: ', style: titleContainerBox),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Container(
                                                child: TextButton(
                                              child: Text('${(data.fileDanhSach != null) ? data.fileDanhSach : "Tải"}'),
                                              onPressed: () async {
                                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                  type: FileType.custom,
                                                  allowedExtensions: [],
                                                  withReadStream: true,
                                                  allowMultiple: false,
                                                );
                                                if (result != null) {
                                                  fileHopDong = await uploadFile(result, context: context);
                                                  setState(() {
                                                    data.fileDanhSach = fileHopDong;
                                                  });
                                                } else {
                                                  return showToast(
                                                    context: context,
                                                    msg: "Chọn lại file",
                                                    color: Color.fromRGBO(245, 117, 29, 1),
                                                    icon: const Icon(Icons.info),
                                                  );
                                                }
                                              },
                                            )),
                                          ),
                                        ],
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              "Nội dung:",
                                              style: titleContainerBox,
                                            )),
                                        Expanded(
                                            flex: 9,
                                            child: TextField(
                                              controller: noiDung,
                                              maxLines: 200,
                                              minLines: 5,
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                                                filled: true,
                                                fillColor: Colors.white,
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(0),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(0),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(width: 100),
                                  // Expanded(
                                  //   flex: 3,
                                  //   child: Container(),
                                  // ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //tìm kiếm
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Theme.of(context).iconTheme.color,
                                        textStyle: Theme.of(context).textTheme.caption?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20.0,
                                          horizontal: 40.0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        backgroundColor: mainColor,
                                      ),
                                      onPressed: () async {
                                        processing();
                                        if (tieuDe.text == "" || time1 == null || time2 == null || selectedTrangThai == -1) {
                                          showToast(
                                            context: context,
                                            msg: "Cần điền đầy đủ thông tin",
                                            color: Color.fromRGBO(245, 117, 29, 1),
                                            icon: const Icon(Icons.info),
                                          );
                                          Navigator.pop(context);
                                        } else {
                                          data.tilte = tieuDe.text;
                                          data.content = noiDung.text;
                                          data.startDate = convertTimeStamp(time1, "00:00:00");
                                          data.endDate = convertTimeStamp(time2, "23:59:59");
                                          if (time3 != null) data.hanDangKy = convertTimeStamp(time3, "23:59:59");
                                          if (time4 != null) data.hanNopBaoCao = convertTimeStamp(time4, "23:59:59");
                                          if (time5 != null) data.ngayDiThuctap = convertTimeStamp(time5, "23:59:59");
                                          if (time6 != null) data.ngayHetThuctap = convertTimeStamp(time6, "23:59:59");
                                          data.status = selectedTrangThai;
                                          var abc = await httpPost("/api/ke-hoach-thuc-tap/post", data.toJson(), context);
                                          print(abc);
                                          showToast(
                                            context: context,
                                            msg: "Thêm mới thành công",
                                            color: Color.fromARGB(136, 72, 238, 67),
                                            icon: const Icon(Icons.done),
                                          );
                                          widget.callbackChange(true);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Text('Lưu', style: textBtnWhite),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Theme.of(context).iconTheme.color,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20.0,
                                          horizontal: 40.0,
                                        ),
                                        backgroundColor: orange,
                                        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                      ),
                                      onPressed: () {
                                        widget.callbackChange(false);
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        children: [
                                          Text('Huỷ', style: textBtnWhite),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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
