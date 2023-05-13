// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//Colors
const Color mainColor = Color.fromARGB(255, 13, 119, 206);
const Color red = Colors.red;
const Color yellow = Colors.yellow;
const Color black = Colors.black;
const Color white = Colors.white;
const Color orange = Colors.orange;
const Color grey = Colors.grey;
const Color colorPage = Color.fromARGB(255, 234, 234, 234);

//TextStyle
Color backgroundPageColor = const Color(0xffF5F7FB);

TextStyle titleWidget = TextStyle(color: const Color(0xff1C4281), fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.none);
TextStyle textBtn = TextStyle(
  letterSpacing: 0.1,
  wordSpacing: 1,
  height: 1.2,
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w600,
);
TextStyle titlePage = TextStyle(fontSize: 38, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle titlePage1 = TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500);
TextStyle textNormal = TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black);
TextStyle textTitleNavbar = TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white);
TextStyle textDropdownTitle = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black);
TextStyle textTitleTabbar = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black);
TextStyle textTitleTabbarW = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white);
TextStyle textCardContentBlack = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black);
TextStyle textCardContentBlue = TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: const Color.fromRGBO(2, 62, 116, 1));
TextStyle textCardTitle = TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: const Color.fromRGBO(2, 62, 116, 1));
TextStyle textTitleMenu2 = TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 0, 0, 0));
TextStyle textTitleMenu1 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 0, 0, 0));
TextStyle titleContainerBox1 = TextStyle(fontSize: 21, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle titleContainerBox2 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle titleContainerBox = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);
TextStyle textBtnWhite = TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.white);
TextStyle textBtnBlack = TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black);
TextStyle textDataColumn = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle textDataRow = TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black);
TextStyle textBtnTopic = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle textBtnTopicBlue = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color:mainColor);
TextStyle textBtnTopicWhite = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white);
TextStyle textTitleAlertDialog = TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black);
double verticalPaddingPage = 35;
double horizontalPaddingPage = 50;


BoxShadow boxShadowContainer = BoxShadow(
  color: Color.fromARGB(255, 224, 224, 224).withOpacity(0.5),
  spreadRadius: 2,
  blurRadius: 12,
  offset: Offset(4, 8), // changes position of shadow
);

//Borderadius box container
const borderRadiusContainer = BorderRadius.all(
  Radius.elliptical(8, 8),
);
Border borderAllContainerBox = Border.all(width: 1, color: Color(0xffDADADA));
const paddingBoxContainer = EdgeInsets.all(25);


// size icon
const double sizeIconOverviewDataBox = 20;

// Chiều rộng của box icon bên trong box to
const double widthIconOverviewDataBox = 50;

// Chiều cao của box icon bên trong box to
const double heightIconOverviewDataBox = 50;

// padding của các thẻ con bên trong
const paddingLeftOverviewDataBox = EdgeInsets.only(left: 20);

// Dữ liệu Style
TextStyle dataOverviewDataBox = TextStyle(
  color: Color(0xff141B2B),
  fontSize: 20,
  letterSpacing: 0.1,
);
TextStyle titleOverviewDataBox = TextStyle(
  color: Color(0xff7F838B),
  fontSize: 14,
  letterSpacing: 0.1,
);
TextStyle titleBox = TextStyle(
  color: Color(
    0xff000000,
  ),
  fontSize: 16,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.1,
);