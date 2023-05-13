// ignore_for_file: file_names

class Company {
  int? id;
  String? name;
  int? type;
  String? mst;
  String? address;
  String? manager;
  String? managerSdt;
  String? managerEmail;
  bool? hopDong;
  String? fileHopDong;
  int? soLuongNhan;
  int? status;
  Company({
    this.id,
    this.name,
    this.type,
    this.mst,
    this.address,
    this.manager,
    this.managerSdt,
    this.managerEmail,
    this.hopDong,
    this.fileHopDong,
    this.soLuongNhan,
    this.status,
  });

  Company.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = json['type'],
        mst = json['mst'],
        address = json['address'],
        manager = json['manager'],
        managerSdt = json['managerSdt'],
        managerEmail = json['managerEmail'],
        hopDong = json['hopDong'],
        fileHopDong = json['fileHopDong'],
        soLuongNhan = json['soLuongNhan'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'mst': mst,
        'address': address,
        'manager': manager,
        'managerSdt': managerSdt,
        'managerEmail': managerEmail,
        'hopDong': hopDong,
        'fileHopDong': fileHopDong,
        'soLuongNhan': soLuongNhan,
        'status': status
      };
}
