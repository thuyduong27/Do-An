// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fe_web/controllers/api.dart';
import 'package:fe_web/models/company.dart';
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

class DangKyDeTaiScreen extends StatefulWidget {
  // final SinhVien myProvider;
  DangKyDeTaiScreen({Key? key}) : super(key: key);

  @override
  _QuanLyDNScreenState createState() => _QuanLyDNScreenState();
}

class _QuanLyDNScreenState extends State<DangKyDeTaiScreen> {
  TextEditingController ten = TextEditingController();
  TextEditingController mst = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController manager = TextEditingController();
  TextEditingController managerSdt = TextEditingController();
  TextEditingController managerEmail = TextEditingController();
  TextEditingController deTai = TextEditingController();

  int selectedDiaDiem = -1;
  Map<int, String> listDiadiem = {
    -1: '--Chọn--',
    0: 'Tại trường',
    1: 'Tại doanh nghiệp',
  };

  int selectedOption = -1;
  Map<int, String> listOption = {
    -1: '--Chọn--',
    0: 'Doanh nghiệp đã xác thực',
    1: 'Đề xuất doanh nghiệp',
  };

  Company selectedCSTT = Company(id: null, name: "--Chọn--");
  Future<List<Company>> getCSTT() async {
    List<Company> resultCSTT = [];
    var response1 = await httpGet("/api/doanh-nghiep/get/page?filter=status:1 and type!0", context);
    resultCSTT = [];
    if (response1.containsKey("body")) {
      setState(() {
        var body = jsonDecode(response1['body']);
        var content = [];
        content = body['result']['content'];
        resultCSTT = content.map((e) {
          return Company.fromJson(e);
        }).toList();
      });
      Company all = Company(id: null, name: "--Chọn--");
      setState(() {
        resultCSTT.insert(0, all);
      });
    }
    return resultCSTT;
  }

  Company daiHoc = Company();
  callApi() async {
    var responseDaiHoc = await httpGet("/api/doanh-nghiep/get/page?filter=type:0 and status:1", context);
    List<Company> resultDaiHoc = [];
    if (responseDaiHoc.containsKey("body")) {
      setState(() {
        var body = jsonDecode(responseDaiHoc['body']);
        var content = [];
        content = body['result']['content'];
        resultDaiHoc = content.map((e) {
          return Company.fromJson(e);
        }).toList();
        if (resultDaiHoc.isNotEmpty) {
          daiHoc = resultDaiHoc.first;
        }
      });
    }
    setState(() {
      statusData = true;
    });

    myProvider = Provider.of<SecurityModel>(context, listen: false);
    deTai.text = myProvider!.sinhVien.deTai ?? "";
    if (myProvider!.sinhVien.doanhNghiep != null) {
      if (myProvider!.sinhVien.doanhNghiep!.type == 0) {
        selectedDiaDiem = 0;
        ten.text = daiHoc.name ?? "";
        address.text = daiHoc.address ?? "";
        mst.text = daiHoc.mst ?? "";
        manager.text = daiHoc.manager ?? "";
        managerEmail.text = daiHoc.managerEmail ?? "";
        managerSdt.text = daiHoc.managerSdt ?? "";
      } else {
        selectedDiaDiem = 1;
        if (myProvider!.sinhVien.doanhNghiep!.status == 1) {
          selectedOption = 0;
          selectedCSTT = myProvider!.sinhVien.doanhNghiep!;
        } else {
          selectedOption = 1;
          ten.text = myProvider!.sinhVien.doanhNghiep!.name ?? "";
          address.text = myProvider!.sinhVien.doanhNghiep!.address ?? "";
          mst.text = myProvider!.sinhVien.doanhNghiep!.mst ?? "";
          manager.text = myProvider!.sinhVien.doanhNghiep!.manager ?? "";
          managerEmail.text = myProvider!.sinhVien.doanhNghiep!.managerEmail ?? "";
          managerSdt.text = myProvider!.sinhVien.doanhNghiep!.managerSdt ?? "";
        }
      }
    }
  }

  SinhVien data = SinhVien();

  bool statusData = false;
  SecurityModel? myProvider;
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
                        content: 'Đăng ký đề tài',
                        widgetBoxRight: Container(
                          margin: EdgeInsets.only(top: 15),
                          // decoration: BoxDecoration(color: Colors.amber),
                          child: Row(
                            children: [
                              Icon(
                                Icons.av_timer,
                                size: 25,
                                color: Colors.red,
                              ),
                              SizedBox(width: 10),
                              Text((user.sinhVien.keHoachThucTap!.hanDangKy != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user.sinhVien.keHoachThucTap!.hanDangKy!)) : "", style: titleContainerBox),
                              SizedBox(width: 5),
                              Text((user.sinhVien.keHoachThucTap!.hanDangKy != null) ? "(Còn ${DateTime.parse(user.sinhVien.keHoachThucTap!.hanDangKy!).difference(DateTime.now()).inDays} ngày để đăng ký)" : "", style: titleContainerBox),
                            ],
                          ),
                        )),
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
                                            child: Text('Hình thức:', style: titleContainerBox),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Container(
                                              color: Colors.white,
                                              width: MediaQuery.of(context).size.width * 0.20,
                                              height: 40,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2(
                                                  dropdownMaxHeight: 250,
                                                  items: listDiadiem.entries.map((item) => DropdownMenuItem<int>(value: item.key, child: Text(item.value))).toList(),
                                                  value: selectedDiaDiem,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedDiaDiem = value as int;
                                                      if (selectedDiaDiem == 0) {
                                                        ten.text = daiHoc.name ?? "";
                                                        address.text = daiHoc.address ?? "";
                                                        mst.text = daiHoc.mst ?? "";
                                                        manager.text = daiHoc.manager ?? "";
                                                        managerEmail.text = daiHoc.managerEmail ?? "";
                                                        managerSdt.text = daiHoc.managerSdt ?? "";
                                                      } else {
                                                        ten.text = "";
                                                        address.text = "";
                                                        mst.text = "";
                                                        manager.text = "";
                                                        managerEmail.text = "";
                                                        managerSdt.text = "";
                                                      }
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
                                    )),
                                SizedBox(width: 100),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 30),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: colorPage,
                            ),
                            SizedBox(height: 10),
                            Text("Cơ sở thực tập", style: titleContainerBox),
                            (selectedDiaDiem == 0)
                                ? Column(
                                    children: [
                                      SizedBox(height: 30),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Tooltip(
                                              verticalOffset: 0,
                                              message: ten.text,
                                              child: TextFieldValidatedForm(
                                                type: 'None',
                                                height: 40,
                                                controller: ten,
                                                label: 'Tên:',
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
                                              message: address.text,
                                              child: TextFieldValidatedForm(
                                                type: 'None',
                                                height: 40,
                                                controller: address,
                                                label: 'Địa chỉ:',
                                                flexLable: 2,
                                                enabled: false,
                                              ),
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
                                              message: managerEmail.text,
                                              child: TextFieldValidatedForm(
                                                type: 'None',
                                                height: 40,
                                                controller: managerEmail,
                                                label: 'Email:',
                                                flexLable: 2,
                                                enabled: false,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 100),
                                          Expanded(
                                            flex: 3,
                                            child: Tooltip(
                                              message: managerSdt.text,
                                              verticalOffset: 0,
                                              child: TextFieldValidatedForm(
                                                type: 'None',
                                                height: 40,
                                                controller: managerSdt,
                                                label: ' Số điện thoại:',
                                                flexLable: 2,
                                                enabled: false,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : (selectedDiaDiem == 1)
                                    ? Column(
                                        children: [
                                          SizedBox(height: 30),
                                          Row(
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
                                                          child: Text('Doanh nghiệp:', style: titleContainerBox),
                                                        ),
                                                        Expanded(
                                                          flex: 5,
                                                          child: Container(
                                                            color: Colors.white,
                                                            width: MediaQuery.of(context).size.width * 0.20,
                                                            height: 40,
                                                            child: DropdownButtonHideUnderline(
                                                              child: DropdownButton2(
                                                                dropdownMaxHeight: 250,
                                                                items: listOption.entries.map((item) => DropdownMenuItem<int>(value: item.key, child: Text(item.value))).toList(),
                                                                value: selectedOption,
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    selectedOption = value as int;
                                                                    if (selectedOption == 1) {
                                                                      ten.text = "";
                                                                      address.text = "";
                                                                      mst.text = "";
                                                                      manager.text = "";
                                                                      managerEmail.text = "";
                                                                      managerSdt.text = "";
                                                                    }
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
                                                  )),
                                              SizedBox(width: 100),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  margin: EdgeInsets.only(bottom: 30),
                                                ),
                                              ),
                                            ],
                                          ),
                                          (selectedOption == 0)
                                              ? Column(
                                                  children: [
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
                                                                    child: Text('Tên:', style: titleContainerBox),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child: Container(
                                                                      color: Colors.white,
                                                                      height: 40,
                                                                      child: DropdownSearch<Company>(
                                                                        popupProps: PopupPropsMultiSelection.menu(
                                                                          showSearchBox: true,
                                                                        ),
                                                                        dropdownDecoratorProps: DropDownDecoratorProps(
                                                                          dropdownSearchDecoration: InputDecoration(
                                                                            constraints: const BoxConstraints.tightFor(
                                                                              width: 300,
                                                                              height: 40,
                                                                            ),
                                                                            contentPadding: const EdgeInsets.only(left: 14, bottom: 10),
                                                                            focusedBorder: const OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(0),
                                                                              ),
                                                                              borderSide: BorderSide(color: Colors.black, width: 0.5),
                                                                            ),
                                                                            hintText: "--Chọn--",
                                                                            hintMaxLines: 1,
                                                                            enabledBorder: const OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(0),
                                                                              ),
                                                                              borderSide: BorderSide(color: Colors.black, width: 0.5),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        asyncItems: (String? filter) => getCSTT(),
                                                                        itemAsString: (Company u) => "${u.name}",
                                                                        selectedItem: selectedCSTT,
                                                                        onChanged: (value) {
                                                                          setState(() {
                                                                            selectedCSTT = value!;
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                        SizedBox(width: 100),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Tooltip(
                                                            message: selectedCSTT.mst ?? "",
                                                            verticalOffset: 0,
                                                            child: TextFieldValidatedForm(
                                                              type: 'None',
                                                              height: 40,
                                                              controller: TextEditingController(text: selectedCSTT.mst ?? ""),
                                                              label: 'Mst:',
                                                              flexLable: 2,
                                                              enabled: false,
                                                            ),
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
                                                            message: selectedCSTT.manager ?? "",
                                                            child: TextFieldValidatedForm(
                                                              type: 'None',
                                                              height: 40,
                                                              controller: TextEditingController(text: selectedCSTT.manager ?? ""),
                                                              label: 'Người đại diện:',
                                                              flexLable: 2,
                                                              enabled: false,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 100),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Tooltip(
                                                            message: selectedCSTT.managerSdt ?? "",
                                                            verticalOffset: 0,
                                                            child: TextFieldValidatedForm(
                                                              type: 'None',
                                                              height: 40,
                                                              controller: TextEditingController(text: selectedCSTT.managerSdt ?? ""),
                                                              label: 'Số điện thoại:',
                                                              flexLable: 2,
                                                              enabled: false,
                                                            ),
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
                                                            message: selectedCSTT.managerEmail ?? "",
                                                            child: TextFieldValidatedForm(
                                                              type: 'None',
                                                              height: 40,
                                                              controller: TextEditingController(text: selectedCSTT.managerEmail ?? ""),
                                                              label: 'Email:',
                                                              flexLable: 2,
                                                              enabled: false,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 100),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Tooltip(
                                                            message: (selectedCSTT.hopDong == true)
                                                                ? "Đã ký hợp đồng với trường"
                                                                : (selectedCSTT.hopDong == false)
                                                                    ? "Chưa ký hợp đồng với trường"
                                                                    : "",
                                                            verticalOffset: 0,
                                                            child: TextFieldValidatedForm(
                                                              type: 'None',
                                                              height: 40,
                                                              controller: TextEditingController(text: (selectedCSTT.hopDong == true) ? "Đã ký hợp đồng với trường" : "Chưa ký hợp đồng với trường"),
                                                              label: 'Hợp đồng:',
                                                              flexLable: 2,
                                                              enabled: false,
                                                            ),
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
                                                            message: selectedCSTT.address ?? "",
                                                            child: TextFieldValidatedForm(
                                                              type: 'None',
                                                              height: 40,
                                                              controller: TextEditingController(text: selectedCSTT.address ?? ""),
                                                              label: 'Địa chỉ:',
                                                              flexLable: 2,
                                                              enabled: false,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 100),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Tooltip(
                                                            message: (selectedCSTT.soLuongNhan != null) ? selectedCSTT.soLuongNhan.toString() : "",
                                                            verticalOffset: 0,
                                                            child: TextFieldValidatedForm(
                                                              type: 'None',
                                                              height: 40,
                                                              controller: TextEditingController(text: (selectedCSTT.soLuongNhan != null) ? selectedCSTT.soLuongNhan.toString() : ""),
                                                              label: 'Số lượng nhận:',
                                                              flexLable: 2,
                                                              enabled: false,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : (selectedOption == 1)
                                                  ? Column(
                                                      children: [
                                                        if (user.sinhVien.doanhNghiep != null && user.sinhVien.doanhNghiep!.status == 0) Center(child: Container(margin: EdgeInsets.only(bottom: 30), child: Text("Doanh nghiệp đang chờ được xác nhận", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red)))),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Expanded(
                                                              flex: 3,
                                                              child: TextFieldValidatedForm(
                                                                type: 'None',
                                                                height: 40,
                                                                controller: ten,
                                                                label: 'Tên công ty:',
                                                                flexLable: 2,
                                                              ),
                                                            ),
                                                            SizedBox(width: 100),
                                                            Expanded(
                                                              flex: 3,
                                                              child: TextFieldValidatedForm(
                                                                type: 'None',
                                                                height: 40,
                                                                controller: mst,
                                                                label: 'MST:',
                                                                flexLable: 2,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Expanded(
                                                              flex: 3,
                                                              child: TextFieldValidatedForm(
                                                                type: 'None',
                                                                height: 40,
                                                                controller: manager,
                                                                label: 'Người đại diện:',
                                                                flexLable: 2,
                                                              ),
                                                            ),
                                                            SizedBox(width: 100),
                                                            Expanded(
                                                              flex: 3,
                                                              child: TextFieldValidatedForm(
                                                                type: 'None',
                                                                height: 40,
                                                                controller: managerSdt,
                                                                label: 'Số điện thoại:',
                                                                flexLable: 2,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Expanded(
                                                              flex: 3,
                                                              child: TextFieldValidatedForm(
                                                                type: 'None',
                                                                height: 40,
                                                                controller: managerEmail,
                                                                label: 'Email:',
                                                                flexLable: 2,
                                                              ),
                                                            ),
                                                            SizedBox(width: 100),
                                                            Expanded(
                                                              flex: 3,
                                                              child: TextFieldValidatedForm(
                                                                type: 'None',
                                                                height: 40,
                                                                controller: address,
                                                                label: 'Địa chỉ:',
                                                                flexLable: 2,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : Container()
                                        ],
                                      )
                                    : Column(),
                            SizedBox(height: 10),
                            Divider(
                              thickness: 1,
                              color: colorPage,
                            ),
                            SizedBox(height: 10),
                            Text("Đề tài", style: titleContainerBox),
                            SizedBox(height: 10),
                            TextField(
                              maxLines: 20,
                              minLines: 3,
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
                              controller: deTai,
                            ),
                            SizedBox(height: 30),
                            if(user.sinhVien.status!=2)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Theme.of(context).iconTheme.color,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                        horizontal: 40.0,
                                      ),
                                      backgroundColor: mainColor,
                                      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                    ),
                                    onPressed: () async {
                                      processing();
                                      if (selectedDiaDiem == -1) {
                                        showToast(
                                          context: context,
                                          msg: "Cần điền đầy đủ thông tin",
                                          color: Color.fromRGBO(245, 117, 29, 1),
                                          icon: const Icon(Icons.info),
                                        );
                                        Navigator.pop(context);
                                      } else {
                                        data = user.sinhVien;
                                        if (selectedDiaDiem == 0) {
                                          data.idDoanhNghiep = daiHoc.id;
                                          data.deTai = deTai.text;
                                        } else {
                                          if (selectedOption == 0) {
                                            data.idDoanhNghiep = selectedCSTT.id;
                                            data.doanhNghiep = selectedCSTT;
                                            data.deTai = deTai.text;
                                            print(data.idDoanhNghiep);
                                          } else {
                                            if (ten.text == "" || mst.text == "" || manager.text == "" || managerEmail.text == "" || managerSdt.text == "" || address.text == "") {
                                              showToast(
                                                context: context,
                                                msg: "Cần điền đầy đủ thông tin",
                                                color: Color.fromRGBO(245, 117, 29, 1),
                                                icon: const Icon(Icons.info),
                                              );
                                            } else {
                                              if (data.doanhNghiep == null) {
                                                data.doanhNghiep = Company();
                                                data.doanhNghiep!.type = 1;
                                                data.doanhNghiep!.name = ten.text;
                                                data.doanhNghiep!.mst = mst.text;
                                                data.doanhNghiep!.manager = manager.text;
                                                data.doanhNghiep!.managerEmail = managerEmail.text;
                                                data.doanhNghiep!.managerSdt = managerSdt.text;
                                                data.doanhNghiep!.address = address.text;
                                                data.doanhNghiep!.status = 0;
                                                var responseDeXuat = await httpPost("/api/doanh-nghiep/post", data.doanhNghiep!.toJson(), context);
                                                var bodyDeXuat = jsonDecode(responseDeXuat["body"]);
                                                var resultDeXuat = int.tryParse(bodyDeXuat['result'].toString());
                                                data.idDoanhNghiep = resultDeXuat;
                                              } else {
                                                data.doanhNghiep!.type = 1;
                                                data.doanhNghiep!.name = ten.text;
                                                data.doanhNghiep!.mst = mst.text;
                                                data.doanhNghiep!.manager = manager.text;
                                                data.doanhNghiep!.managerEmail = managerEmail.text;
                                                data.doanhNghiep!.managerSdt = managerSdt.text;
                                                data.doanhNghiep!.address = address.text;
                                                data.doanhNghiep!.status = 0;
                                                var responseDeXuat = await httpPut("/api/doanh-nghiep/put/${data.doanhNghiep!.id}", data.doanhNghiep!.toJson(), context);
                                                var bodyDeXuat = jsonDecode(responseDeXuat["body"]);
                                                var resultDeXuat = int.tryParse(bodyDeXuat['result'].toString());
                                                data.idDoanhNghiep = resultDeXuat;
                                              }
                                              data.deTai = deTai.text;
                                            }
                                          }
                                        }
                                        data.status = 1;
                                        print(data.toJson());
                                        var responseDangKy = await httpPut("/api/sinh-vien-thuc-tap/put/${data.id}", data.toJson(), context);
                                        print(responseDangKy);
                                        showToast(
                                          context: context,
                                          msg: "Cập nhật thành công",
                                          color: mainColor,
                                          icon: const Icon(Icons.done),
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Text('Cập nhật', style: textBtnWhite),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
