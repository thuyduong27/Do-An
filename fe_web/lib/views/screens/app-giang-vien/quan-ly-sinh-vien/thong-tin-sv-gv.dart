// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fe_web/views/common/loadApi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/provider.dart';
import '../../../../models/sinh-vien.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/style.dart';
import '../../../common/title_page.dart';
import '../../app-quan-tri/quan-ly-sinh-vien/thong-tin-sv/nhat-ky-thuc-tap.dart';
import '../../app-quan-tri/quan-ly-sinh-vien/thong-tin-sv/thong-tin-co-ban.dart';
import '../../app-quan-tri/quan-ly-sinh-vien/thong-tin-sv/thong-tin-thuc-tap.dart';
import 'danh-gia-ket-qua-sv.dart';

class ThongTinSinhVienGV extends StatefulWidget {
  SinhVien data;
  Function? callback;
  ThongTinSinhVienGV({Key? key, required this.data, this.callback}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<ThongTinSinhVienGV> {
  bool satatusData = false;

  callApi() async {
    setState(() {
      satatusData = true;
    });
  }

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

    return Header(
        widgetBody: Consumer<SecurityModel>(
      builder: (context, user, child) => Scaffold(
        body: Container(
          decoration: BoxDecoration(color: colorPage),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              children: [
                TitlePage(
                  listPreTitle: [
                    {'url': "/nhan-su", 'title': 'Trang chủ'},
                    {'url': "/quan-ly-sinh-vien", 'title': 'Quản lý sinh viên thực tập'},
                  ],
                  content: 'Thông tin chi tiết',
                  widgetBoxRight: Container(
                    margin: EdgeInsets.only(right: 15),
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
                        backgroundColor: orange,
                        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        widget.callback!(widget.data);
                      },
                      child: Row(
                        children: [
                          Text('Trở về', style: textTitleTabbarW),
                        ],
                      ),
                    ),
                  ),
                ),
                (satatusData)
                    ? Container(
                        height: 900,
                        child: DefaultTabController(
                          length: 4,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                // color: Colors.red,
                                constraints: BoxConstraints.expand(height: 50),
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: TabBar(
                                  isScrollable: true,
                                  indicatorColor: mainColor,
                                  tabs: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: mainColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Thông tin cơ bản",
                                          style: textTitleTabbar,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.feed,
                                          color: mainColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Thông tin thực tập",
                                          style: textTitleTabbar,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.history_edu,
                                          color: mainColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Nhật ký thực tập",
                                          style: textTitleTabbar,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.cast_for_education,
                                          color: mainColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Đánh giá và kết quả",
                                          style: textTitleTabbar,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TabBarView(children: [
                                  ThongTinCoBan(
                                    data: widget.data,
                                  ),
                                  ThongTinThucTap(
                                    data: widget.data,
                                    callback: (value) {
                                      setState(() {
                                        widget.data = value;
                                      });
                                    },
                                  ),
                                  NhatKyThucTap(
                                    data: widget.data,
                                  ),
                                  DanhGiaVaKetQua(
                                    data: widget.data,
                                     callback: (value) {
                                      setState(() {
                                        widget.data = value;
                                      });
                                    },
                                  ),
                                ]),
                              )
                            ],
                          ),
                        ),
                      )
                    : CommonApp().loadingCallAPi(),
                Footer()
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
