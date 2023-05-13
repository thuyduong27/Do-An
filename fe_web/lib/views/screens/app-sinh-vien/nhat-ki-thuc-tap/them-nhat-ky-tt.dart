// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'package:fe_web/models/nhat-ky-thuc-tap.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../common/date-pick-time.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/text-file.dart';
import '../../../common/title_page.dart';

import '../../../common/toast.dart';

class ThemMoiNKTT extends StatefulWidget {
  Function callbackChange;
  ThemMoiNKTT({Key? key, required this.callbackChange}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<ThemMoiNKTT> {
  TextEditingController ten = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController ketQua = TextEditingController();
  TextEditingController ghiChu = TextEditingController();
  var time1;
  var time2;

  late NhatKyTT data;

  @override
  void initState() {
    super.initState();
    data = NhatKyTT();
  }

  void dispose() {
    ten.dispose();
    content.dispose();
    ketQua.dispose();
    ghiChu.dispose();
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
                  // {'url': "/nhan-su", 'title': 'Trang chủ'},
                  // {'url': "/quan-ly-doanh-nghiep", 'title': 'Quản lý doanh nghiệp'},
                ],
                content: 'Thêm mới nhật ký thực tập',
              ),
              Container(
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
                                    child: TextFieldValidatedForm(type: 'Text', height: 40, controller: ten, label: 'Tên:', flexLable: 2, requiredValue: 1),
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
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: DatePickerBox1(
                                        requestDayBefore: time2,
                                        isTime: false,
                                        label: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                "Từ ngày: ",
                                                style: titleContainerBox,
                                              ),
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
                                        label: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'Đến ngày: ',
                                                style: titleContainerBox,
                                              ),
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
                                        ),
                                        dateDisplay: time1,
                                        selectedDateFunction: (day) {
                                          time2 = day;
                                          print(day);
                                          setState(() {});
                                        }),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
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
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  "Nội dung ",
                                                  style: titleContainerBox,
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 5),
                                                child: Text("*",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 16,
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: TextField(
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
                                            controller: content,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 100),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  "Kết quả ",
                                                  style: titleContainerBox,
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 5),
                                                child: Text("*",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 16,
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: TextField(
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
                                            controller: ketQua,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextFieldValidatedForm(type: 'Text', height: 40, controller: ghiChu, label: 'Ghi chú: ', flexLable: 2),
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
                                            child: Text('File đính kèm: ', style: titleContainerBox),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Container(
                                                child: TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Theme.of(context).iconTheme.color,
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 20.0,
                                                  horizontal: 40.0,
                                                ),
                                                backgroundColor: mainColor,
                                                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                              ),
                                              child: Text(
                                                '${(data.file != null && data.file != "") ? data.file : "Tải"}',
                                                style: TextStyle(color: white, fontSize: 14),
                                              ),
                                              onPressed: () async {
                                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                  type: FileType.custom,
                                                  allowedExtensions: [],
                                                  withReadStream: true,
                                                  allowMultiple: false,
                                                );
                                                if (result != null) {
                                                  var fileHopDong = await uploadFile(result, context: context);
                                                  setState(() {
                                                    data.file = fileHopDong;
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
                                ],
                              ),
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
                                        if (ten.text == "" || content.text == "" || ketQua.text == "" || time1 == null || time2 == null) {
                                          showToast(
                                            context: context,
                                            msg: "Cần điền đầy đủ thông tin",
                                            color: Color.fromRGBO(245, 117, 29, 1),
                                            icon: const Icon(Icons.info),
                                          );
                                          Navigator.pop(context);
                                        } else {
                                          data.idSv = user.sinhVien.id;
                                          data.name = ten.text;
                                          data.startDate = convertTimeStamp(time1, "00:00:00");
                                          data.endDate = convertTimeStamp(time2, "23:59:59");
                                          data.content = content.text;
                                          data.ketQua = ketQua.text;
                                          data.ghiChu = ghiChu.text;
                                          data.status = 1;
                                          await httpPost("/api/nhat-ky-thuc-tap/post", data.toJson(), context);
                                          showToast(
                                            context: context,
                                            msg: "Thêm mới thành công",
                                            color: mainColor,
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
                                        foregroundColor: Theme.of(context).iconTheme.color,
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
