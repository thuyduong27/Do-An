// ignore_for_file: file_names

class NhatKyTT {
  int? id;
  int? idSv;
  String? modifiedDate;
  String? name;
  String? startDate;
  String? endDate;
  String? content;
  String? ghiChu;
  String? ketQua;
  String? file;
  int? status;
  NhatKyTT({
    this.id,
    this.idSv,
    this.modifiedDate,
    this.name,
    this.startDate,
    this.endDate,
    this.content,
    this.ghiChu,
    this.ketQua,
    this.file,
    this.status,
  });

  NhatKyTT.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        modifiedDate = json['modifiedDate'],
        idSv = json['idSv'],
        startDate = json['startDate'],
        endDate = json['endDate'],
        ghiChu = json['ghiChu'],
        content = json['content'],
        ketQua = json['ketQua'],
        file = json['file'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'idSv': idSv,
        'startDate': startDate,
        'endDate': endDate,
        'content': content,
        'ghiChu': ghiChu,
        'ketQua': ketQua,
        'file': file,
        'status': status
      };
}
