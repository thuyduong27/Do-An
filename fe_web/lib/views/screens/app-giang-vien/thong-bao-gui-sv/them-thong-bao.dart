// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'package:fe_web/confing.dart';
import 'package:fe_web/models/thong-bao-cua-gvhd.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/gvhd.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/text-file.dart';
import '../../../common/title_page.dart';

import '../../../common/toast.dart';

class ThemMoiThongBaoGuiSV extends StatefulWidget {
  int idgv;
  Function callbackChange;
  ThemMoiThongBaoGuiSV({Key? key, required this.callbackChange, required this.idgv}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<ThemMoiThongBaoGuiSV> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  late ThongBaoGVHD data;

  @override
  void initState() {
    super.initState();
    data = ThongBaoGVHD();
  }

  void dispose() {
    title.dispose();
    content.dispose();
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
                  {'url': "/thong-bao-gui-sv", 'title': 'Thông báo gửi sinh viên'},
                ],
                content: 'Thêm mới',
              ),
              Container(
                height: MediaQuery.of(context).size.height - 200,
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
                                children: [
                                  Text("Tiêu đề: ", style: titleContainerBox),
                                  Text("*", style: TextStyle(color: Colors.red)),
                                ],
                              ),
                              SizedBox(height: 10),
                              TextField(
                                maxLines: 5,
                                minLines: 1,
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
                                controller: title,
                              ),
                              SizedBox(height: 30),
                              Row(
                                children: [
                                  Text("Nội dung: ", style: titleContainerBox),
                                  Text("*", style: TextStyle(color: Colors.red)),
                                ],
                              ),
                              SizedBox(height: 10),
                              TextField(
                                maxLines: 50,
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
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //tìm kiếm
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Theme.of(context).iconTheme.color,
                                        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
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
                                        if (title.text == "" || content.text == "") {
                                          showToast(
                                            context: context,
                                            msg: "Cần điền đầy đủ thông tin",
                                            color: Color.fromRGBO(245, 117, 29, 1),
                                            icon: const Icon(Icons.info),
                                          );
                                          Navigator.pop(context);
                                        } else {
                                          data.idGvhd = widget.idgv;
                                          data.title = title.text;
                                          data.content = content.text;
                                          data.status = 1;
                                          await httpPost("/api/thong-bao-thuc-tap/post", data.toJson(), context);
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
