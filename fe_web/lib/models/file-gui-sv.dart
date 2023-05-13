// ignore_for_file: file_names
class FileGuiSv {
  int? id;
  String? modifiedDate;
  int? idGvhd;
  String? title;
  String? fileName;
  String? moTa;
  int? status;
  FileGuiSv({
    this.id,
    this.modifiedDate,
    this.idGvhd,
    this.title,
    this.fileName,
    this.moTa,
    this.status,
  });

  FileGuiSv.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idGvhd = json['idGvhd'],
        modifiedDate = json['modifiedDate'],
        title = json['title'],
        fileName = json['fileName'],
        moTa = json['moTa'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'idGvhd': idGvhd,
        'title': title,
        'fileName': fileName,
        'moTa': moTa,
        'status': status,
      };
}
