// ignore_for_file: file_names
import 'package:fe_web/models/ke-hoach-thuc-tap.dart';

class KhaoSat {
  int? id;
  String? createdDate;
  String? modifiedDate;
  int? idKhtt;
  KeHoachThucTap? keHoachThucTap;
  String? tilte;
  String? link;
  String? deadline;
  String? file;
  int? soluongSV;
  int? soluongKS;
  int? status;
  KhaoSat({
    this.id,
    this.idKhtt,
    this.createdDate,
    this.modifiedDate,
    this.keHoachThucTap,
    this.tilte,
    this.link,
    this.deadline,
    this.file,
    this.soluongSV,
    this.soluongKS,
    this.status,
  });

  KhaoSat.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idKhtt = json['idKhtt'],
        createdDate = json['createdDate'],
        modifiedDate = json['modifiedDate'],
        keHoachThucTap = KeHoachThucTap.fromJson(json['keHoachThucTap']),
        tilte = json['tilte'],
        link = json['link'],
        deadline = json['deadline'],
        file = json['file'],
        soluongSV = json['soluongSV'],
        soluongKS = json['soluongKS'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'idKhtt': idKhtt,
        'tilte': tilte,
        'link': link,
        'file': file,
        'deadline': deadline,
        'status': status,
      };
}
