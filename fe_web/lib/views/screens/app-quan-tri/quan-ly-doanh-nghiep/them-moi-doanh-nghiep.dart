// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'package:fe_web/models/company.dart';
import 'package:fe_web/views/common/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/api.dart';
import '../../../../controllers/provider.dart';
import '../../../common/footer.dart';
import '../../../common/header-admin.dart';
import '../../../common/text-file.dart';
import '../../../common/title_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';

import '../../../common/toast.dart';

class ThemMoiDoanhNghiep extends StatefulWidget {
  Function callbackChange;
  ThemMoiDoanhNghiep({Key? key, required this.callbackChange}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<ThemMoiDoanhNghiep> {
  TextEditingController ten = TextEditingController();
  TextEditingController mst = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController manager = TextEditingController();
  TextEditingController managerSdt = TextEditingController();
  TextEditingController managerEmail = TextEditingController();
  TextEditingController slNhan = TextEditingController();
  Map<int, String> listHopDong = {
    0: '<<<--Chọn-->>>',
    1: 'Có',
    2: 'Không',
  };
  int selectedHopDong = 0;
  Map<int, String> listTrangthai = {
    0: '<<<--Chọn-->>>',
     1: 'Kích hoạt',
    2: 'Khoá',
  };
  int selectedTrangThai = 0;
  String? fileHopDong;
  late Company data;

  @override
  void initState() {
    super.initState();
    data = Company();
  }

  void dispose() {
    ten.dispose();
    mst.dispose();
    address.dispose();
    manager.dispose();
    managerSdt.dispose();
    managerEmail.dispose();
    slNhan.dispose();
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
                  {'url': "/quan-ly-doanh-nghiep", 'title': 'Quản lý doanh nghiệp'},
                ],
                content: 'Thêm mới doanh nghiệp',
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
                                    child: TextFieldValidatedForm(type: 'Text', height: 40, controller: address, label: 'Địa chỉ:', flexLable: 2, requiredValue: 1),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextFieldValidatedForm(type: 'Text', height: 40, controller: mst, label: 'Mã số thuế:', flexLable: 2, requiredValue: 1),
                                  ),
                                  SizedBox(width: 100),
                                  Expanded(
                                    flex: 3,
                                    child: TextFieldValidatedForm(type: 'Text', height: 40, controller: manager, label: 'Người quản lý:', flexLable: 2, requiredValue: 1),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextFieldValidatedForm(type: 'Email', height: 40, controller: managerEmail, label: 'Email:', flexLable: 2, requiredValue: 1),
                                  ),
                                  SizedBox(width: 100),
                                  Expanded(
                                    flex: 3,
                                    child: TextFieldValidatedForm(type: 'Text', height: 40, controller: managerSdt, label: 'SĐT:', flexLable: 2, requiredValue: 1),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 30),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Text('Hợp đồng:', style: titleContainerBox),
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
                                              )),
                                          Expanded(
                                            flex: 5,
                                            child: Container(
                                              color: Colors.white,
                                              width: MediaQuery.of(context).size.width * 0.20,
                                              height: 40,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2(
                                                  dropdownMaxHeight: 250,
                                                  items: listHopDong.entries.map((item) => DropdownMenuItem<int>(value: item.key, child: Text(item.value))).toList(),
                                                  value: selectedHopDong,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedHopDong = value as int;
                                                    });
                                                  },
                                                  buttonHeight: 40,
                                                  itemHeight: 40,
                                                  dropdownDecoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(216, 218, 229, 1))),
                                                  buttonDecoration: BoxDecoration(border: Border.all(width: 0.5, style: BorderStyle.solid)),
                                                  buttonElevation: 0,
                                                  buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                                                  itemPadding: const EdgeInsets.only(left: 14, right: 14),
                                                  dropdownElevation: 5,
                                                  focusColor: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Text('Trạng thái:', style: titleContainerBox),
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
                                              )),
                                          Expanded(
                                            flex: 5,
                                            child: Container(
                                              color: Colors.white,
                                              width: MediaQuery.of(context).size.width * 0.20,
                                              height: 40,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2(
                                                  dropdownMaxHeight: 250,
                                                  items: listTrangthai.entries.map((item) => DropdownMenuItem<int>(value: item.key, child: Text(item.value))).toList(),
                                                  value: selectedTrangThai,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedTrangThai = value as int;
                                                    });
                                                  },
                                                  buttonHeight: 40,
                                                  itemHeight: 40,
                                                  dropdownDecoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(216, 218, 229, 1))),
                                                  buttonDecoration: BoxDecoration(border: Border.all(width: 0.5, style: BorderStyle.solid)),
                                                  buttonElevation: 0,
                                                  buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                                                  itemPadding: const EdgeInsets.only(left: 14, right: 14),
                                                  dropdownElevation: 5,
                                                  focusColor: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              (selectedHopDong == 1)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 30),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text('File hợp đồng:', style: titleContainerBox),
                                                ),
                                                Expanded(
                                                  flex: 5,
                                                  child: Container(
                                                      child: TextButton(
                                                    child: Text('${(data.fileHopDong != null) ? data.fileHopDong : "Tải"}'),
                                                    onPressed: () async {
                                                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                        type: FileType.custom,
                                                        allowedExtensions: ['png', 'JPEG', 'JPG', 'TIFF', 'GIF'],
                                                        withReadStream: true,
                                                        allowMultiple: false,
                                                      );
                                                      if (result != null) {
                                                        fileHopDong = await uploadFile(result, context: context);
                                                        setState(() {
                                                          data.fileHopDong = fileHopDong;
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
                                        SizedBox(width: 100),
                                        Expanded(
                                          flex: 3,
                                          child: TextFieldValidatedForm(
                                            type: 'None',
                                            height: 40,
                                            controller: slNhan,
                                            label: 'SL nhận:',
                                            flexLable: 2,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(),
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
                                        if (ten.text == "" || address.text == "" || manager.text == "" || managerSdt.text == "" || managerEmail.text == "" || mst.text == "" || selectedHopDong == 0 || selectedTrangThai == 0) {
                                          showToast(
                                            context: context,
                                            msg: "Cần điền đầy đủ thông tin",
                                            color: Color.fromRGBO(245, 117, 29, 1),
                                            icon: const Icon(Icons.info),
                                          );
                                          Navigator.pop(context);
                                        } else {
                                          data.name = ten.text;
                                          data.address = address.text;
                                          data.manager = manager.text;
                                          data.managerSdt = managerSdt.text;
                                          data.managerEmail = managerEmail.text;
                                          data.mst = mst.text;
                                          data.type = 1;
                                          if (selectedHopDong == 1) {
                                            data.hopDong = true;
                                            data.soLuongNhan = int.tryParse(slNhan.text);
                                          } else {
                                            data.hopDong = false;
                                            data.fileHopDong = null;
                                            data.soLuongNhan = null;
                                          }
                                          if (selectedTrangThai == 1) {
                                            data.status = 1;
                                          } else {
                                            data.status = 2;
                                          }
                                          await httpPost("/api/doanh-nghiep/post", data.toJson(), context);
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
                                        foregroundColor: Theme.of(context).iconTheme.color, padding: const EdgeInsets.symmetric(
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
