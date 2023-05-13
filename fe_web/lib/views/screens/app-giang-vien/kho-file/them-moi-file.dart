// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'package:fe_web/views/common/style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/file-gui-sv.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/text-file.dart';
import '../../../common/title_page.dart';

import '../../../common/toast.dart';

class ThemMoiFile extends StatefulWidget {
  int idgv;
  Function callbackChange;
  ThemMoiFile({Key? key, required this.callbackChange, required this.idgv}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<ThemMoiFile> {
  TextEditingController title = TextEditingController();
  TextEditingController mota = TextEditingController();
  late FileGuiSv data;
  String fileName = "";

  @override
  void initState() {
    super.initState();
    data = FileGuiSv();
  }

  @override
  void dispose() {
    title.dispose();
    mota.dispose();
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
                  {'url': "/kho-file", 'title': 'Kh0 file'},
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextFieldValidatedForm(
                                      type: 'Text',
                                      height: 40,
                                      controller: title,
                                      label: 'Tiêu đề: ',
                                      flexLable: 2,
                                      requiredValue: 1,
                                    ),
                                  ),
                                  SizedBox(width: 100),
                                  Expanded(
                                    flex: 3,
                                    child: TextFieldValidatedForm(
                                      type: 'None',
                                      height: 40,
                                      controller: mota,
                                      label: 'Mô tả: ',
                                      flexLable: 2,
                                    ),
                                  ),
                                ],
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 30),
                                    child: Row(children: [
                                      Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  "File",
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
                                          )),
                                      Expanded(
                                        flex: 5,
                                        child: OutlinedButton(
                                          child: Text(fileName == "" ? "Tải file" : fileName),
                                          onPressed: () async {
                                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                                              allowedExtensions: [],
                                              type: FileType.custom,
                                              withReadStream: true,
                                              allowMultiple: false,
                                            );
                                            if (result != null) {
                                              var avatarImage = await uploadFile(result, context: context);
                                              setState(() {
                                                fileName = avatarImage;
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
                                        ),
                                      )
                                    ]),
                                  ),
                                ),
                                SizedBox(width: 100),
                                Expanded(flex: 3, child: Container()),
                              ]),
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
                                        if (title.text == "" || fileName == "") {
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
                                          data.moTa = mota.text;
                                          data.fileName = fileName;
                                          data.status = 1;
                                          await httpPost("/api/file-gvhd-gui-sv/post", data.toJson(), context);
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
