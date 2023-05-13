// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe_web/controllers/api.dart';
import 'package:fe_web/models/company.dart';
import 'package:fe_web/models/khao-sat.dart';
import 'package:fe_web/models/sinh-vien-khao-sat.dart';
import 'package:fe_web/models/sinh-vien.dart';
import 'package:fe_web/views/common/loadApi.dart';
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

class KhaoSatSinhVienScreen extends StatefulWidget {
  const KhaoSatSinhVienScreen({Key? key}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<KhaoSatSinhVienScreen> {
  callApi() async {
    var responsec = await httpGet("/api/khao-sat/get/page?filter=idKhtt:${myProvider?.khttNow.id}&sort=createdDate,desc", context);
    if (responsec.containsKey("body")) {
      setState(() {
        var body = jsonDecode(responsec['body']);
        var content = [];
        content = body['result']['content'];
        listData = content.map((e) {
          return KhaoSat.fromJson(e);
        }).toList();
      });
      // listData.forEach((e)=> print(e.createdDate));
    }
    setState(() {
      statusData = true;
    });
  }

  List<KhaoSat> listData = [];

  bool statusData = false;
  SecurityModel? myProvider;
  @override
  void initState() {
    super.initState();
    myProvider = Provider.of<SecurityModel>(context, listen: false);
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
                      content: 'Khảo sát',
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ListView(
                          controller: ScrollController(),
                          children: [
                            for (KhaoSat element in listData)
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                                padding: EdgeInsets.all(10),
                                height: 100,
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          element.tilte.toString(),
                                          style: TextStyle(color: black, fontSize: 20),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        (user.listKs.contains(element.id))
                                            ? Tooltip(
                                                message: "Bạn đã thực hiện khảo sát",
                                                child: Icon(
                                                  Icons.verified,
                                                  size: 30,
                                                  color: Colors.green,
                                                ),
                                              )
                                            : Tooltip(
                                                message: "Bạn chưa thực hiện khảo sát",
                                                child: Icon(
                                                  Icons.pending,
                                                  size: 30,
                                                  color: orange,
                                                ),
                                              ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    (element.status == 0)
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Hạn khảo sát: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(element.deadline!).toLocal())}",
                                                style: TextStyle(color: mainColor, fontSize: 15),
                                              ),
                                              (!user.listKs.contains(element.id))
                                                  ? Row(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(left: 10),
                                                          child: TextButton(
                                                            style: TextButton.styleFrom(
                                                              foregroundColor: Theme.of(context).iconTheme.color,
                                                              padding: const EdgeInsets.symmetric(
                                                                vertical: 1,
                                                                horizontal: 10.0,
                                                              ),
                                                              backgroundColor: mainColor,
                                                              textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                                            ),
                                                            onPressed: () async {
                                                              html.window.open('${element.link}', '_blank');
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.link, color: white),
                                                                SizedBox(width: 5),
                                                                Text('Chuyển tới trang khảo sát', style: textBtnWhite),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(left: 10),
                                                          child: TextButton(
                                                            style: TextButton.styleFrom(
                                                              foregroundColor: Theme.of(context).iconTheme.color,
                                                              padding: const EdgeInsets.symmetric(
                                                                vertical: 1,
                                                                horizontal: 10.0,
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
                                                                                  'Xác nhận hoàn thành khảo sát',
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
                                                                        content: SizedBox(
                                                                          width: 400,
                                                                        ),
                                                                        actions: [
                                                                          ElevatedButton(
                                                                            onPressed: () async {
                                                                              SinhVienKhaoSat svks = SinhVienKhaoSat();
                                                                              svks.idKhaoSat = element.id;
                                                                              svks.idSv = user.sinhVien.id;
                                                                              await httpPost("/api/sinh-vien-khao-sat/post", svks.toJson(), context);
                                                                              await httpPut("/api/khao-sat/put/${element.id}",element.toJson(), context);
                                                                              List<int> abc = user.listKs;
                                                                              abc.add(element.id!);
                                                                              user.changeListKs(abc);
                                                                              setState(() {
                                                                                element.modifiedDate = "${DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal())}T${DateFormat('HH:mm:ss').format(DateTime.now().toLocal())}";
                                                                              });
                                                                              Navigator.pop(context);
                                                                              showToast(
                                                                                context: context,
                                                                                msg: "Xác nhận thành công",
                                                                                color: Color.fromARGB(136, 72, 238, 67),
                                                                                icon: const Icon(Icons.done),
                                                                              );
                                                                            },
                                                                            style: ElevatedButton.styleFrom(
                                                                              foregroundColor: white,
                                                                              backgroundColor: mainColor,
                                                                              elevation: 3,
                                                                              minimumSize: Size(100, 40),
                                                                            ),
                                                                            child: Text(
                                                                              'Xác nhận',
                                                                              style: TextStyle(),
                                                                            ),
                                                                          ),
                                                                          ElevatedButton(
                                                                            onPressed: () => Navigator.pop(context),
                                                                            style: ElevatedButton.styleFrom(
                                                                              foregroundColor: white,
                                                                              backgroundColor: orange,
                                                                              elevation: 3,
                                                                              minimumSize: Size(100, 40),
                                                                            ),
                                                                            child: Text('Hủy'),
                                                                          ),
                                                                        ],
                                                                      ));
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.done, color: white),
                                                                SizedBox(width: 5),
                                                                Text('Xác nhận hoàn thành', style: textBtnWhite),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Text(
                                                      "Đã khảo sát lúc: ${DateFormat('HH:mm  dd-MM-yyyy').format(DateTime.parse(element.modifiedDate!).toLocal())}",
                                                      style: TextStyle(color: mainColor, fontSize: 15),
                                                    )
                                            ],
                                          )
                                        : Center(
                                            child: Text(
                                              "Khảo sát đã kết thúc",
                                              style: TextStyle(color: mainColor, fontSize: 15),
                                            ),
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
