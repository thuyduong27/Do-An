// ignore_for_file: file_names

class KeHoachThucTap {
  int? id;
  String? tilte;
  String? content;
  String? startDate;
  String? endDate;
  String? hanDangKy;
  String? hanNopBaoCao;
  String? ngayDiThuctap;
  String? ngayHetThuctap;
  String? fileDanhSach;
  int? status;
  KeHoachThucTap({
    this.id,
    this.tilte,
    this.content,
    this.startDate,
    this.endDate,
    this.hanDangKy,
    this.hanNopBaoCao,
    this.ngayDiThuctap,
    this.ngayHetThuctap,
    this.fileDanhSach,
    this.status,
  });

  KeHoachThucTap.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        tilte = json['tilte'],
        content = json['content'],
        startDate = json['startDate'],
        endDate = json['endDate'],
        hanDangKy = json['hanDangKy'],
        ngayDiThuctap = json['ngayDiTt'],
        ngayHetThuctap = json['ngayVeTt'],
        hanNopBaoCao = json['hanNopBaoCao'],
        fileDanhSach = json['fileDanhSach'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'tilte': tilte,
        'content': content,
        'startDate': startDate,
        'endDate': endDate,
        'hanDangKy': hanDangKy,
        'hanNopBaoCao': hanNopBaoCao,
        'ngayDiTt': ngayDiThuctap,
        'ngayVeTt': ngayHetThuctap,
        'fileDanhSach': fileDanhSach,
        'status': status
      };
}
