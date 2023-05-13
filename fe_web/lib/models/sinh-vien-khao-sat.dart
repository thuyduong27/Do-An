// ignore_for_file: file_names

import 'package:fe_web/models/gvhd.dart';
import 'package:fe_web/models/ke-hoach-thuc-tap.dart';

import 'company.dart';
import 'khao-sat.dart';
import 'sinh-vien.dart';

class SinhVienKhaoSat {
  int? id;
  String? modifiedDate;
  int? idSv;
  SinhVien? sinhVien;
  int? idKhaoSat;
  KhaoSat? khaoSat;

  SinhVienKhaoSat({
    this.id,
    this.modifiedDate,
    this.idSv,
    this.sinhVien,
    this.idKhaoSat,
    this.khaoSat,
  });
  SinhVienKhaoSat.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        modifiedDate = json['modifiedDate'],
        idSv = json['idSv'],
        idKhaoSat = json['idKhaoSat'];

  Map<String, dynamic> toJson() => {
        'idSv': idSv,
        'idKhaoSat': idKhaoSat,
      };
}
