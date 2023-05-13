// ignore_for_file: file_names

import 'package:fe_web/models/gvhd.dart';
import 'package:fe_web/models/ke-hoach-thuc-tap.dart';

import 'company.dart';

class SinhVien {
  int? id;
  String? modifiedDate;
  int? idKhtt;
  KeHoachThucTap? keHoachThucTap;
  int? idNguoiDung;
  GVHD? nguoiDung;
  int? idGvhd;
  GVHD? giaoVien;
  int? idDoanhNghiep;
  Company? doanhNghiep;
  String? deTai;
  String? fileBaoCao;
  String? diem;
  int? countNTT;
  int? status;

  SinhVien({
    this.id,
    this.idKhtt,
    this.modifiedDate,
    this.keHoachThucTap,
    this.idNguoiDung,
    this.nguoiDung,
    this.idGvhd,
    this.giaoVien,
    this.idDoanhNghiep,
    this.doanhNghiep,
    this.deTai,
    this.fileBaoCao,
    this.diem,
    this.countNTT,
    this.status,
  });
  SinhVien.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idKhtt = json['idKhtt'],
        modifiedDate = json['modifiedDate'],
        keHoachThucTap = KeHoachThucTap.fromJson(json['keHoachThucTap']),
        idNguoiDung = json['idNguoiDung'],
        nguoiDung = GVHD.fromJson(json['nguoiDung']),
        idGvhd = json['idGvhd'],
        giaoVien = (json['giaoVien'] != null) ? GVHD.fromJson(json['giaoVien']['nguoiDung']) : null,
        idDoanhNghiep = json['idDoanhNghiep'],
        doanhNghiep = (json['doanhNghiep'] != null) ? Company.fromJson(json['doanhNghiep']) : null,
        deTai = json['deTai'],
        fileBaoCao = json['fileBaoCao'],
        diem = json['diem'],
        countNTT = json['countNTT'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'idKhtt': idKhtt,
        'idNguoiDung': idNguoiDung,
        'idGvhd': idGvhd,
        'idDoanhNghiep': idDoanhNghiep,
        'deTai': deTai,
        'fileBaoCao': fileBaoCao,
        'diem': diem,
        'status': status,
      };
}
