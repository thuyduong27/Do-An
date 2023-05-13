// ignore_for_file: file_names
class DanhGiaKetQua {
  int? id;
  int? idSinhVien;
  int? diemOne;
  int? diemOneOne;
  int? diemTwoOne;
  int? diemTwo;
  int? diemOneTwo;
  int? diemTwoTwo;
  // int? diemThree;
  int? diemOneThree;
  int? diemTwoThree;
  String? nguoiDanhGiaOne;
  String? donViOne;
  String? hocViOne;
  String? nguoiDanhGiaTwo;
  String? donViTwo;
  String? hocViTwo;
  // String? nguoiDanhGiaThree;
  // String? donViThree;
  // String? hocViThree;
  int? status;
  DanhGiaKetQua({
    this.id,
    this.idSinhVien,
    this.diemOne,
    this.diemOneOne,
    this.diemTwoOne,
    this.diemTwo,
    this.diemOneTwo,
    this.diemTwoTwo,
    // this.diemThree,
    this.diemOneThree,
    this.diemTwoThree,
    this.nguoiDanhGiaOne,
    this.donViOne,
    this.hocViOne,
    this.nguoiDanhGiaTwo,
    this.donViTwo,
    this.hocViTwo,
    // this.nguoiDanhGiaThree,
    // this.donViThree,
    // this.hocViThree,
    this.status,
  });

  DanhGiaKetQua.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idSinhVien = json['idSinhVien'],
        diemOne = json['diemOne'],
        diemOneOne = json['diemOneOne'],
        diemTwoOne = json['diemTwoOne'],
        diemTwo = json['diemTwo'],
        diemOneTwo = json['diemOneTwo'],
        diemTwoTwo = json['diemTwoTwo'],
        // diemThree = json['diemThree'],
        diemOneThree = json['diemOneThree'],
        diemTwoThree = json['diemTwoThree'],
        nguoiDanhGiaOne = json['nguoiDanhGiaOne'],
        donViOne = json['donViOne'],
        hocViOne = json['hocViOne'],
        nguoiDanhGiaTwo = json['nguoiDanhGiaTwo'],
        donViTwo = json['donViTwo'],
        hocViTwo = json['hocViTwo'],
        // nguoiDanhGiaThree = json['nguoiDanhGiaThree'],
        // donViThree = json['donViThree'],
        // hocViThree = json['hocViThree'],
        status = json['status'];
  Map<String, dynamic> toJson() => {
        'idSinhVien': idSinhVien,
        'diemOne': diemOne,
        'diemOneOne': diemOneOne,
        'diemTwoOne': diemTwoOne,
        'diemTwo': diemTwo,
        'diemOneTwo': diemOneTwo,
        'diemTwoTwo': diemTwoTwo,
        // 'diemThree': diemThree,
        'diemOneThree': diemOneThree,
        'diemTwoThree': diemTwoThree,
        'nguoiDanhGiaOne': nguoiDanhGiaOne,
        'donViOne': donViOne,
        'hocViOne': hocViOne,
        'nguoiDanhGiaTwo': nguoiDanhGiaTwo,
        'donViTwo': donViTwo,
        'hocViTwo': hocViTwo,
        // 'nguoiDanhGiaThree': nguoiDanhGiaThree,
        // 'donViThree': donViThree,
        // 'hocViThree': hocViThree,
        'status': status,
      };
}
