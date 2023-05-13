// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'package:fe_web/controllers/api.dart';
import 'package:fe_web/views/common/loadApi.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../confing.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/file-gui-sv.dart';
import '../../../../models/thong-bao-cua-gvhd.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/title_page.dart';
import '../../../common/toast.dart';

class NopBaoCaoScreen extends StatefulWidget {
  // final SinhVien myProvider;
  NopBaoCaoScreen({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<NopBaoCaoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Header(widgetBody: Consumer<SecurityModel>(builder: (context, user, child) {
      return Scaffold(
        body: Container(
            decoration: BoxDecoration(color: colorPage),
            child: ListView(
              controller: ScrollController(),
              children: [
                TitlePage(
                  listPreTitle: [],
                  content: 'Nộp báo cáo',
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.8,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hạn nộp báo cáo: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(user.sinhVien.keHoachThucTap!.hanNopBaoCao!).toLocal())}",
                            style: textTitleTabbar,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (user.sinhVien.status == 4)
                              ? Text(
                                  "Bạn chưa nộp báo cáo, vui lòng nhấn tải báo cáo",
                                  style: textTitleTabbar,
                                )
                              : Text(
                                  "Bạn đã nộp báo cáo, bản cập nhật gần nhất vào lúc: ${DateFormat('HH:mm  dd/MM/yyyy').format(DateTime.parse(user.sinhVien.modifiedDate!).toLocal())}",
                                  style: textTitleTabbar,
                                )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      (user.sinhVien.status == 4)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  child: Text("Tải file báo cáo"),
                                  onPressed: () async {
                                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: [],
                                      withReadStream: true,
                                      allowMultiple: false,
                                    );
                                    if (result != null) {
                                      var avatarImage = await uploadFile(result, context: context);
                                      setState(() async {
                                        user.sinhVien.fileBaoCao = avatarImage;
                                        user.sinhVien.status = 5;
                                        user.sinhVien.modifiedDate = "${DateFormat('yyyy-MM-dd').format(DateTime.now())}T${DateFormat('HH:mm:ss').format(DateTime.now())}";
                                        user.changeSinhVien(user.sinhVien);
                                        await httpPut('/api/sinh-vien-thuc-tap/put/${user.sinhVien.id}', user.sinhVien.toJson(), context);
                                        showToast(
                                          context: context,
                                          msg: "Đã nộp file báo cáo thành công",
                                          color: Color.fromARGB(136, 72, 238, 67),
                                          icon: const Icon(Icons.done),
                                        );
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
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  child: Text("Tải xuống file báo cáo"),
                                  onPressed: () async {
                                    downloadFile(user.sinhVien.fileBaoCao!);
                                  },
                                ),
                                SizedBox(width: 40),
                                OutlinedButton(
                                  child: Text("Tải lên file báo cáo"),
                                  onPressed: () async {
                                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: [],
                                      withReadStream: true,
                                      allowMultiple: false,
                                    );
                                    if (result != null) {
                                      var avatarImage = await uploadFile(result, context: context);
                                      setState(() async {
                                        user.sinhVien.fileBaoCao = avatarImage;
                                        user.sinhVien.modifiedDate = "${DateFormat('yyyy-MM-dd').format(DateTime.now())}T${DateFormat('HH:mm:ss').format(DateTime.now())}";
                                        user.changeSinhVien(user.sinhVien);
                                        await httpPut('/api/sinh-vien-thuc-tap/put/${user.sinhVien.id}', user.sinhVien.toJson(), context);
                                        showToast(
                                          context: context,
                                          msg: "Đã nộp file báo cáo thành công",
                                          color: Color.fromARGB(136, 72, 238, 67),
                                          icon: const Icon(Icons.done),
                                        );
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
                              ],
                            )
                    ],
                  ),
                ),
                Footer()
              ],
            )),
      );
    }));
  }

  Future<void> processing() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Center(child: const CircularProgressIndicator());
      },
    );
  }
}
