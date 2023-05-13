// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'package:fe_web/controllers/api.dart';
import 'package:fe_web/views/common/loadApi.dart';
import 'package:fe_web/views/common/style.dart';
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

class FileGuiSVScreen extends StatefulWidget {
  // final SinhVien myProvider;
  FileGuiSVScreen({Key? key}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<FileGuiSVScreen> {
  bool statusData = false;
  SecurityModel? myProvider;
  List<FileGuiSv> listFileGuiSv = [];
  Future<List<FileGuiSv>> getFileGuiSv() async {
    myProvider = Provider.of<SecurityModel>(context, listen: false);
    var idGVHD = myProvider!.sinhVien.idGvhd;
    var responseThongBao = await httpGet("/api/file-gvhd-gui-sv/get/page?filter=idGvhd:$idGVHD and status:1&sort=id,desc", context);
    listFileGuiSv = [];
    if (responseThongBao.containsKey("body")) {
      setState(() {
        var body = jsonDecode(responseThongBao['body']);
        var content = [];
        content = body['result']['content'];
        listFileGuiSv = content.map((e) {
          return FileGuiSv.fromJson(e);
        }).toList();
      });
    }
    return listFileGuiSv;
  }

  callApi() async {
    await getFileGuiSv();
    setState(() {
      statusData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      callApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Header(widgetBody: Consumer<SecurityModel>(builder: (context, user, child) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(color: colorPage),
          child: (statusData)
              ? ListView(
                  controller: ScrollController(),
                  children: [
                    TitlePage(
                      listPreTitle: [],
                      content: 'Kho file',
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.83,
                        child: ListView(
                          controller: ScrollController(),
                          children: [
                            SizedBox(height: 15),
                            for (FileGuiSv element in listFileGuiSv)
                              Container(
                                margin: EdgeInsets.all(15),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: borderRadiusContainer,
                                  boxShadow: [boxShadowContainer],
                                  border: borderAllContainerBox,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${element.title}",
                                          style: textNormal,
                                        ),
                                        Text(
                                          " (${DateFormat('HH:mm a dd-MM-yyyy').format(DateTime.parse(element.modifiedDate!))})",
                                          style: textCardContentBlue,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      "${element.moTa}",
                                      style: textDropdownTitle,
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.fromLTRB(0, 0, 30, 0),
                                            child: InkWell(
                                                onTap: () {
                                                  if (element.fileName != "" && element.fileName != null) downloadFile(element.fileName!);
                                                },
                                                child: Icon(
                                                  Icons.download,
                                                  size: 25,
                                                  color: mainColor,
                                                ))),
                                        Container(
                                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                            child: InkWell(
                                                onTap: () {
                                                  Clipboard.setData(ClipboardData(text: "$baseUrl/api/files/${element.fileName}"));
                                                  showToast(context: context, msg: "Đã sao chép đường link tải", color: Color.fromARGB(255, 97, 248, 102), icon: const Icon(Icons.copy), timeHint: 2);
                                                },
                                                child: Icon(
                                                  Icons.copy,
                                                  size: 25,
                                                  color: mainColor,
                                                ))),
                                      ],
                                    )
                                  ],
                                ),
                              )
                          ],
                        )),
                    Footer()
                  ],
                )
              : CommonApp().loadingCallAPi(),
        ),
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
