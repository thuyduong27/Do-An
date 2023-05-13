class GVHD {
  int? id;
  String? fullName;
  String? password;
  String? username;
  String? userCode;
  int? role;
  String? email;
  String? sdt;
  String? address;
  String? avatar;
  bool? gioiTinh;
  String? ngaySinh;
  String? khoa;
  int? nganh;
  String? lop;
  String? maSv;
  int? status;
  int? hocVi;
  String? donVi;
  int? daNhan;
  int? gioiHanNhan;
  GVHD({
    this.id,
    this.fullName,
    this.password,
    this.username,
    this.userCode,
    this.role,
    this.email,
    this.sdt,
    this.address,
    this.avatar,
    this.gioiTinh,
    this.ngaySinh,
    this.status,
    this.hocVi,
    this.khoa,
    this.nganh,
    this.lop,
    this.maSv,
    this.daNhan,
    this.gioiHanNhan,
    this.donVi,
  });
  GVHD.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fullName = json['fullName'],
        username = json['username'],
        password = json['password'],
        userCode = json['userCode'],
        email = json['email'],
        role = json['role'],
        sdt = json['sdt'],
        address = json['address'],
        avatar = json['avatar'],
        gioiTinh = json['gioiTinh'],
        ngaySinh = json['ngaySinh'],
        status = json['status'],
        hocVi = int.tryParse(json['hocVi'].toString()),
        gioiHanNhan = (json['hocVi'] == "1")
            ? 15
            : (json['hocVi'] == "2")
                ? 20
                : null,
        daNhan = 0,
        khoa = json['khoa'],
        maSv = json['maSv'],
        nganh = json['nganh'],
        lop = json['lop'],
        donVi = json['donVi'];
  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'username': username,
        'password': password,
        'email': email,
        'role': role,
        'sdt': sdt,
        'address': address,
        'avatar': avatar,
        'gioiTinh': gioiTinh,
        'ngaySinh': ngaySinh,
        'status': status,
        'maSv': maSv,
        'hocVi': hocVi.toString(),
        'donVi': donVi,
        'khoa': khoa,
        'nganh': nganh,
        'lop': lop,

      };
}
