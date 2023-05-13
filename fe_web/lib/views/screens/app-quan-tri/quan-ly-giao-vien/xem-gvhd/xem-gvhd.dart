// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'package:fe_web/confing.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../controllers/provider.dart';
import '../../../../../models/gvhd.dart';
import '../../../../common/footer.dart';
import '../../../../common/header-admin.dart';
import '../../../../common/title_page.dart';
import 'lich-su-huong-dan.dart';

class XemGVHD extends StatefulWidget {
  GVHD gvhd;
  XemGVHD({Key? key, required this.gvhd}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<XemGVHD> {
  Map<int, String> listHocVi = {
    -1: '<<<---Chọn--->>>',
    0: 'Không',
    1: 'Thạc sĩ',
    2: 'Tiến sĩ',
    3: 'Phó gíao sư',
    4: 'Giáo sư',
  };
  int selectedHocVi = -1;
  Map<int, String> listTrangthai = {
    -1: '<<<---Chọn--->>>',
    1: 'Hoạt động',
    0: 'Khoá',
  };
  int selectedTrangThai = -1;

  Map<int, String> listGender = {
    -1: '<<<---Chọn--->>>',
    0: 'Nữ',
    1: 'Nam',
  };
  int selectedGender = -1;

  bool showMenuFind = true;
  var ngaySinh;
  String avatar = "";

  late GVHD data;

  int page = 0;

  @override
  void initState() {
    super.initState();
    data = widget.gvhd;
    selectedGender = (widget.gvhd.gioiTinh == true) ? 0 : 1;
    selectedTrangThai = widget.gvhd.status ?? -1;
    selectedHocVi = widget.gvhd.hocVi ?? -1;
    avatar = widget.gvhd.avatar ?? "";
    if (widget.gvhd.ngaySinh != null && widget.gvhd.ngaySinh != "") ngaySinh = DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.gvhd.ngaySinh!));
  }

  @override
  void dispose() {
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
                  {'url': "/quan-ly-doanh-nghiep", 'title': 'Giáo viên hướng dẫn'},
                ],
                content: 'Thông tin',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        // color: Colors.red,
                        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                        constraints: BoxConstraints.expand(height: 50),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: TabBar(
                          onTap: (value) {
                            setState(() {
                              page = value;
                            });
                          },
                          isScrollable: true,
                          indicatorColor: Colors.blue,
                          labelColor: Colors.blue,
                          tabs: [
                            Row(
                              children: [
                                Icon(Icons.contact_page_outlined, size: 24, color: (page == 0) ? mainColor : Colors.black),
                                SizedBox(width: 10),
                                Text(
                                  "Thông tin",
                                  style: (page == 0) ? textBtnTopicBlue : textBtnTopic,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.history, size: 24, color: (page == 1) ? mainColor : Colors.black),
                                SizedBox(width: 10),
                                Text(
                                  "Lịch sử hướng dẫn",
                                  style: (page == 1) ? textBtnTopicBlue : textBtnTopic,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(children: [
                          Container(
                            // height: MediaQuery.of(context).size.height - 200,
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
                                            'Giáo viên: ${data.fullName}',
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
                                          SizedBox(
                                            child: SizedBox(
                                              width: 150,
                                              height: 150,
                                              child: (avatar == "") ? Image.asset("/images/noavatar.png") : Image.network("$baseUrl/api/files/$avatar"),
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                          // Text("${data.fullname}")
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          'Tên:',
                                                          style: titleContainerBox,
                                                        )),
                                                    Expanded(
                                                      flex: 5,
                                                      child: SelectableText("${data.fullName}"),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 100),
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          'Giới tính:',
                                                          style: titleContainerBox,
                                                        )),
                                                    Expanded(
                                                      flex: 5,
                                                      child: SelectableText((data.gioiTinh == true) ? "Nữ" : "Nam"),
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
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          'Email:',
                                                          style: titleContainerBox,
                                                        )),
                                                    Expanded(
                                                      flex: 5,
                                                      child: SelectableText("${data.email}"),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 100),
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          'SĐT:',
                                                          style: titleContainerBox,
                                                        )),
                                                    Expanded(
                                                      flex: 5,
                                                      child: SelectableText("${data.sdt}"),
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
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          'Học vị:',
                                                          style: titleContainerBox,
                                                        )),
                                                    Expanded(
                                                      flex: 5,
                                                      child: SelectableText("${listHocVi[data.hocVi]}"),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 100),
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          'Đơn vị:',
                                                          style: titleContainerBox,
                                                        )),
                                                    Expanded(
                                                      flex: 5,
                                                      child: SelectableText("${data.donVi}"),
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
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          'Ngày sinh:',
                                                          style: titleContainerBox,
                                                        )),
                                                    Expanded(
                                                      flex: 5,
                                                      child: SelectableText((data.ngaySinh != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(data.ngaySinh!)) : ""),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 100),
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          'Địa chỉ:',
                                                          style: titleContainerBox,
                                                        )),
                                                    Expanded(
                                                      flex: 5,
                                                      child: SelectableText(data.address ?? ""),
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
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          'Trạng thái:',
                                                          style: titleContainerBox,
                                                        )),
                                                    Expanded(
                                                      flex: 5,
                                                      child: SelectableText(listTrangthai[data.status] ?? ""),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 100),
                                              Expanded(
                                                flex: 3,
                                                child: Container(),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 30),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
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
                                                    Navigator.pop(context);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text('Trở về', style: textBtnWhite),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          LichSuHuongDan(
                            gvhd: data,
                          )
                        ]),
                      )
                    ],
                  ),
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
