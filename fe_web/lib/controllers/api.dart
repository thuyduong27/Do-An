// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

import '../confing.dart';

//lấy về bản ghi
httpGet(url, context) async {
  // var securityModel = Provider.of<SecurityModel>(context, listen: false);
  Map<String, String> headers = {'content-type': 'application/json'};
  // if (securityModel.authorization != null) {
  //   headers["Authorization"] = "${securityModel.authorization!}";
  // }

  var response = await http.get(Uri.parse('$baseUrl$url'), headers: headers);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
    } on FormatException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  } else if (response.statusCode == 403) {
    return false;
  } else {
    return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
  }
}

void downloadFile(String fileName) {
  html.AnchorElement anchorElement = html.AnchorElement(href: "$baseUrl/api/files/$fileName");
  anchorElement.download = "$baseUrl/api/files/$fileName";
  anchorElement.click();
}

//insert bản ghi
httpPost(url, requestBody, context) async {
  // var securityModel = Provider.of<SecurityModel>(context, listen: false);
  Map<String, String> headers = {'content-type': 'application/json'};
  // if (securityModel.authorization != null) {
  //   headers["Authorization"] = "aam ${securityModel.authorization!}";
  // }
  var finalRequestBody = json.encode(requestBody);
  var response = await http.post(Uri.parse("$baseUrl$url".toString()), headers: headers, body: finalRequestBody);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
      // ignore: unused_catch_clause
    } on FormatException catch (e) {
      //bypass
    }
  } else if (response.statusCode == 403) {
    return false;
  } else {
    return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
  }
}

httpPostNotification(url, requestBody, context) async {
  // var securityModel = Provider.of<SecurityModel>(context, listen: false);
  Map<String, String> headers = {'content-type': 'application/json'};
  // if (securityModel.authorization != null) {
  //   headers["Authorization"] = "aam ${securityModel.authorization!}";
  // }
  var finalRequestBody = json.encode(requestBody);
  var response = await http.post(Uri.parse("https://api.aamhr.com.vn$url".toString()), headers: headers, body: finalRequestBody);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
      // ignore: unused_catch_clause
    } on FormatException catch (e) {
      //bypass
    }
  } else if (response.statusCode == 403) {
    return false;
  } else {
    return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
  }
}

httpPostDiariStatus(int ttsId, int statusBefore, int statusAfter, String content, context) async {
  // var securityModel = Provider.of<SecurityModel>(context, listen: false);
  Map<String, String> headers = {'content-type': 'application/json'};
  // if (securityModel.authorization != null) {
  //   headers["Authorization"] = "aam ${securityModel.authorization!}";
  // }
  var requestBody = {"ttsId": ttsId, "ttsStatusBeforeId": statusBefore, "ttsStatusAfterId": statusAfter, "content": content};
  var finalRequestBody = json.encode(requestBody);
  var response = await http.post(Uri.parse("$baseUrl/api/tts-nhatky/post/save".toString()), headers: headers, body: finalRequestBody);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
      // ignore: unused_catch_clause
    } on FormatException catch (e) {
      //bypass
    }
  } else if (response.statusCode == 403) {
    return false;
  } else {
    return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
  }
  // print("Thành công");
}

//upload các loại file
uploadFile(file, {context}) async {
  // var securityModel = Provider.of<SecurityModel>(context, listen: false);
  if (file != null) {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/api/upload"),
    );
    request.files.add(http.MultipartFile("file", file!.files.first.readStream!, file.files.first.size, filename: file.files.first.name));
    var resp = await request.send();

    //------Read response
    String result = await resp.stream.bytesToString();
    var body = json.decode(result);
    print("========================");
    print(body);
    if (body.containsKey("1")) {
      return body['1'];
    }
    return "Chưa có báo cáo, nhấn vào để tải lên.";
  } else {
    return null;
  }
}

//upload các loại file
httpPatch(url, requestBody, context) async {
  // var securityModel = Provider.of<SecurityModel>(context, listen: false);
  Map<String, String> headers = {'content-type': 'application/json'};
  // if (securityModel.authorization != null) {
  //   headers["Authorization"] = securityModel.authorization!;
  // }
  var finalRequestBody = json.encode(requestBody);
  var response = await http.patch(Uri.parse('$baseUrl$url'), headers: headers, body: finalRequestBody);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
      // ignore: unused_catch_clause
    } on FormatException catch (e) {
      //bypass
    }
  }
  return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
}

//xóa bản ghi
httpDelete(url, context) async {
  // var securityModel = Provider.of<SecurityModel>(context, listen: false);
  Map<String, String> headers = {'content-type': 'application/json'};
  // if (securityModel.authorization != null) {
  //   headers["Authorization"] = "aam ${securityModel.authorization!}";
  // }
  var response = await http.delete(Uri.parse('$baseUrl$url'), headers: headers);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
      // ignore: unused_catch_clause
    } on FormatException catch (e) {
      //bypass
    }
  } else if (response.statusCode == 403) {
    return false;
  } else {
    return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
  }
}

httpDeleteAll(url, requestBody, context) async {
  // var securityModel = Provider.of<SecurityModel>(context, listen: false);
  Map<String, String> headers = {'content-type': 'application/json'};
  // if (securityModel.authorization != null) {
  //   headers["Authorization"] = "aam ${securityModel.authorization!}";
  // }
  var finalRequestBody = json.encode(requestBody);
  var response = await http.delete(Uri.parse('$baseUrl$url'), headers: headers, body: finalRequestBody);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
      // ignore: unused_catch_clause
    } on FormatException catch (e) {
      //bypass
    }
  } else if (response.statusCode == 403) {
    return false;
  } else {
    return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
  }
}

//update bản ghi
httpPut(url, requestBody, context) async {
  // var securityModel = Provider.of<SecurityModel>(context, listen: false);
  Map<String, String> headers = {'content-type': 'application/json'};
  // if (securityModel.authorization != null) {
  //   headers["Authorization"] = "aam ${securityModel.authorization!}";
  // }
  var finalRequestBody = json.encode(requestBody);
  var response = await http.put(Uri.parse('$baseUrl$url'), headers: headers, body: finalRequestBody);
  if (response.statusCode == 200 && response.headers["content-type"] == 'application/json') {
    try {
      return {"headers": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
    } on FormatException catch (e) {
      // print(e);
      //bypass
    }
  } else if (response.statusCode == 403) {
    return false;
  } else {
    return {"headers": response.headers, "body": utf8.decode(response.bodyBytes)};
  }
}

//Up file bằng bytes
uploadFileByter(bytes, {context}) async {
  // var securityModel = Provider.of<SecurityModel>(context, listen: false);
  if (bytes != null) {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/api/upload"),
    );
    //-----add other fields if needed
    // request.headers['authorization'] = "aam ${securityModel.authorization!}";

    //-----add selected file with request
    request.files.add(http.MultipartFile.fromBytes("file", bytes, filename: "Output.xlsx"));

    //-------Send request
    var resp = await request.send();

    //------Read response
    String result = await resp.stream.bytesToString();
    var body = json.decode(result);
    if (body.containsKey("1")) {
      // print(body['1']);
      return body['1'];
    }
    return null;
  } else {
    // print("null");
    return null;
  }
}

//Up file bằng bytes ảnh
uploadFileByte(bytes, {fileName, context}) async {
  // var securityModel = Provider.of<SecurityModel>(context, listen: false);
  if (bytes != null) {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/api/upload"),
    );
    //-----add other fields if needed
    // request.headers['authorization'] = "aam ${securityModel.authorization!}";

    //-----add selected file with request
    request.files.add(http.MultipartFile.fromBytes("file", bytes, filename: fileName));

    //-------Send request
    var resp = await request.send();

    //------Read response
    String result = await resp.stream.bytesToString();
    var body = json.decode(result);
    if (body.containsKey("1")) {
      // print(body['1']);
      return body['1'];
    }
    return null;
  } else {
    return null;
  }
}
