import 'package:flutter/material.dart';
class CommonApp {
 

  //loading khi call api
  Widget loadingCallAPi({String? contentLoading}) {
    return Container(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: CircularProgressIndicator()),
          Center(
            child: Text(
              contentLoading ?? "Loading...",
              style: const TextStyle(color: Color.fromARGB(255, 78, 78, 78), fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  //Đường kẻ chân trang
  Widget dividerWidget({required double height}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        height: height,
        thickness: 0.2,
        color: Colors.black,
      ),
    );
  }

}
