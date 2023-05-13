// ignore_for_file: file_names
class ThongBaoGVHD {
  int? id;
  String? modifiedDate;
  int? idGvhd;
  String? title;
  String? content;
  int? status;
  ThongBaoGVHD({
    this.id,
    this.modifiedDate,
    this.idGvhd,
    this.title,
    this.content,
    this.status,
  });

  ThongBaoGVHD.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idGvhd = json['idGvhd'],
        modifiedDate = json['modifiedDate'],
        title = json['title'],
        content = json['content'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'idGvhd': idGvhd,
        'title': title,
        'content': content,
        'status': status,
      };
}
