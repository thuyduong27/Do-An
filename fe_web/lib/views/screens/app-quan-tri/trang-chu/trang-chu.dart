// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';

import 'package:fe_web/controllers/api.dart';
import 'package:fe_web/models/company.dart';
import 'package:fe_web/views/common/loadApi.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/provider.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/text-file.dart';
import '../../../common/title_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../common/toast.dart';

class TrangChuScreen extends StatefulWidget {
  TrangChuScreen({Key? key}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<TrangChuScreen> {
  SecurityModel? myProvider;
  bool statusData = false;
  int tongSV = 0;
  int tongHKTT = 0;
  int tongGVHD = 0;
  double tongSV0 = 0;
  double tongSV1 = 0;
  double tongSV2 = 0;
  double tongSV3 = 0;
  double tongSV4 = 0;
  double tongSV5 = 0;
  double tongSV7 = 0;
  double tongSV8 = 0;

  void callApi() async {
    try {
      var responseGV = await httpGet("/api/nguoi-dung/get/page?size=10000000&filter=role:1", context);
      var bodyGV = jsonDecode(responseGV["body"]);
      var responseKHTT = await httpGet("/api/ke-hoach-thuc-tap/get/page?size=10000000&filter=status!2", context);
      var bodyKHTT = jsonDecode(responseKHTT["body"]);

      var response5 = await httpGet("/api/sinh-vien-thuc-tap/get/page?size=100000000&filter=idKhtt:${myProvider!.khttNow.id ?? 0}&sort=status", context);
      var body5 = jsonDecode(response5["body"]);
      var content = [];
      content = body5['result']['content'];
      setState(() {
        tongSV = content.length;
        tongGVHD = bodyGV['result']['totalElements'];
        tongHKTT = bodyKHTT['result']['totalElements'];
      });
      content.forEach((element) {
        if (element['status'] == 0) {
          tongSV0++;
        } else if (element['status'] == 1) {
          tongSV1++;
        }
        if (element['status'] == 2) {
          tongSV2++;
        }
        if (element['status'] == 3) {
          tongSV3++;
        }
        if (element['status'] == 4) {
          tongSV4++;
        }
        if (element['status'] == 5) {
          tongSV5++;
        }
        if (element['status'] == 7) {
          tongSV7++;
        }
        if (element['status'] == 8) {
          tongSV8++;
        }
      });
    } catch (e) {
      showToast(
        context: context,
        msg: "Có lỗi trong qúa trình tải",
        color: Color.fromRGBO(245, 117, 29, 1),
        icon: const Icon(Icons.info),
      );
    }
    setState(() {
      statusData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    myProvider = Provider.of<SecurityModel>(context, listen: false);
    Timer(Duration(seconds: 1), () {
      callApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Header(
        widgetBody: Consumer<SecurityModel>(
      builder: (context, user, child) => Scaffold(
        body: Container(
          decoration: BoxDecoration(color: colorPage),
          child: ListView(
            controller: ScrollController(),
            children: [
              TitlePage(
                listPreTitle: [],
                content: 'Trang chủ',
              ),
              (statusData)
                  ? Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nhap thong tin
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 1,
                            height: MediaQuery.of(context).size.height * 0.8,
                            // padding: paddingBoxContainer,
                            child: ListView(
                              controller: ScrollController(),
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 20),
                                      width: 300,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: borderRadiusContainer,
                                        boxShadow: [boxShadowContainer],
                                        border: borderAllContainerBox,
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            user.changeSttMenu(2);
                                          });
                                          Navigator.pushNamed(context, '/ke-hoach-thuc-tap');
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: paddingLeftOverviewDataBox,
                                                  child: Container(
                                                    width: widthIconOverviewDataBox,
                                                    height: heightIconOverviewDataBox,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(255, 2, 118, 23),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Icon(
                                                      Icons.calendar_month,
                                                      color: white,
                                                      size: sizeIconOverviewDataBox,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 20),
                                                    child: SizedBox(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'Tổng kế hoạch thực tập',
                                                            style: titleOverviewDataBox,
                                                            maxLines: 2,
                                                            softWrap: false,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Text(
                                                            "$tongHKTT",
                                                            style: dataOverviewDataBox,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 20),
                                      width: 300,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: borderRadiusContainer,
                                        boxShadow: [boxShadowContainer],
                                        border: borderAllContainerBox,
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/quan-ly-gvhd');
                                          setState(() {
                                            user.changeSttMenu(8);
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: paddingLeftOverviewDataBox,
                                                  child: Container(
                                                    width: widthIconOverviewDataBox,
                                                    height: heightIconOverviewDataBox,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(255, 47, 0, 133),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Icon(
                                                      Icons.supervisor_account,
                                                      color: white,
                                                      size: sizeIconOverviewDataBox,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 20),
                                                    child: SizedBox(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'Số giảng viên',
                                                            style: titleOverviewDataBox,
                                                            maxLines: 2,
                                                            softWrap: false,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Text(
                                                            "$tongGVHD",
                                                            style: dataOverviewDataBox,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  height: 740,
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: borderRadiusContainer,
                                    boxShadow: [boxShadowContainer],
                                    border: borderAllContainerBox,
                                  ),
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Kết hoạch thực tập đang diễn ra',
                                            style: titleBox,
                                          ),
                                          Icon(
                                            Icons.more_horiz,
                                            color: Color(0xff9aa5ce),
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10, bottom: 10),
                                        child: Divider(
                                          thickness: 1,
                                          color: Color.fromARGB(255, 174, 174, 174),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Tooltip(
                                              verticalOffset: 0,
                                              message: user.khttNow.tilte,
                                              child: TextFieldValidatedForm(
                                                type: 'None',
                                                height: 40,
                                                controller: TextEditingController(text: user.khttNow.tilte),
                                                label: "Tiêu đề: ",
                                                flexLable: 2,
                                                enabled: false,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 100),
                                          Expanded(
                                            flex: 3,
                                            child: TextFieldValidatedForm(
                                              controller: TextEditingController(text: "$tongSV sinh viên"),
                                              type: 'None',
                                              height: 40,
                                              label: "Tổng sinh viên: ",
                                              flexLable: 2,
                                              enabled: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Tooltip(
                                              verticalOffset: 0,
                                              message: DateFormat('dd-MM-yyyy').format(DateTime.parse(user.khttNow.startDate!)),
                                              child: TextFieldValidatedForm(
                                                type: 'None',
                                                height: 40,
                                                controller: TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.parse(user.khttNow.startDate!))),
                                                label: "Ngày bắt đầu: ",
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
                                              message: DateFormat('dd-MM-yyyy').format(DateTime.parse(user.khttNow.endDate!)),
                                              child: TextFieldValidatedForm(
                                                type: 'None',
                                                height: 40,
                                                controller: TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.parse(user.khttNow.endDate!))),
                                                label: "Ngày kết thúc: ",
                                                flexLable: 2,
                                                enabled: false,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        // color: mainColor,
                                        width: 1000,
                                        height: 500,
                                        child: SfCircularChart(
                                          tooltipBehavior: TooltipBehavior(enable: true),
                                          legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                                          series: <CircularSeries>[
                                            // Render pie chart
                                            PieSeries<ChartDataP, String>(
                                              enableTooltip: true,
                                              dataSource: [
                                                // Bind data source
                                                ChartDataP('Chưa đăng ký đề tài', tongSV0),
                                                ChartDataP('Đã đăng ký đề tài, chờ xác nhận', tongSV1),
                                                ChartDataP('Xác nhận đề tài', tongSV2),
                                                ChartDataP('Đang thực tập', tongSV3),
                                                ChartDataP('Đã thực tập xong', tongSV4),
                                                ChartDataP('Đã nộp báo cáo', tongSV5),
                                                ChartDataP('Đạt', tongSV7),
                                                ChartDataP('Không đạt', tongSV8)
                                              ],
                                              xValueMapper: (ChartDataP data, _) => data.x,
                                              yValueMapper: (ChartDataP data, _) => data.y,
                                              // name: 'Data',
                                              dataLabelSettings: DataLabelSettings(isVisible: true),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(width: MediaQuery.of(context).size.width * 1, height: MediaQuery.of(context).size.height * 0.8, child: Center(child: CommonApp().loadingCallAPi())),
              Footer()
            ],
          ),
        ),
      ),
    ));
  }
}

class ChartDataP {
  ChartDataP(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
