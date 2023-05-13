// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'package:fe_web/controllers/api.dart';
import 'package:fe_web/views/common/loadApi.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/thong-bao-cua-gvhd.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/title_page.dart';

class TBGVHDScreen extends StatefulWidget {
  // final SinhVien myProvider;
  TBGVHDScreen({Key? key}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<TBGVHDScreen> {
  bool statusData = false;
  SecurityModel? myProvider;
  List<ThongBaoGVHD> listThongBaoGVHD = [];
  Future<List<ThongBaoGVHD>> getThongBaoGVHD() async {
    myProvider = Provider.of<SecurityModel>(context, listen: false);
    var idGVHD = myProvider!.sinhVien.idGvhd;
    var responseThongBao = await httpGet("/api/thong-bao-thuc-tap/get/page?filter=idGvhd:$idGVHD and status:1&sort=id,desc", context);
    listThongBaoGVHD = [];
    if (responseThongBao.containsKey("body")) {
      setState(() {
        var body = jsonDecode(responseThongBao['body']);
        var content = [];
        content = body['result']['content'];
        listThongBaoGVHD = content.map((e) {
          return ThongBaoGVHD.fromJson(e);
        }).toList();
      });
    }
    return listThongBaoGVHD;
  }

  callApi() async {
    await getThongBaoGVHD();
    setState(() {
      statusData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
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
                      content: 'Thông báo của GVHD',
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.83,
                        child: ListView(
                          controller: ScrollController(),
                          children: [
                            SizedBox(height: 15),
                            for (ThongBaoGVHD element in listThongBaoGVHD)
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
                                      "${element.content}",
                                      style: textDropdownTitle,
                                    ),
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
