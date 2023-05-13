import 'package:fe_web/views/common/style.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: white,
      ),
      child: const Center(
        child: Text(
          "Hệ thống quản lý thực tập khoa CNTT trường Đại học Công nghiệp Hà Nội",
          style: TextStyle(overflow: TextOverflow.clip, fontSize: 15, color: black),
        ),
      ),
    );
  }
}
