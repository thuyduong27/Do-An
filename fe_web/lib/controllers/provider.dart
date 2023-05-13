import 'package:fe_web/models/sinh-vien.dart';
import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';

import '../models/gvhd.dart';
import '../models/ke-hoach-thuc-tap.dart';
import '../models/user-login.dart';

class SecurityModel with ChangeNotifier {
  late LocalStorage storage;
  late int sttMenu;

  GVHD user = GVHD();
  changeUser(GVHD newUser) {
    user = newUser;
    notifyListeners();
  }

  SinhVien sinhVien = SinhVien();
  changeSinhVien(SinhVien newSinhVien) {
    sinhVien = newSinhVien;
    notifyListeners();
  }

  KeHoachThucTap khttNow = KeHoachThucTap();
  changeKhtt(KeHoachThucTap newKhtt) {
    khttNow = newKhtt;
    notifyListeners();
  }

  List<int> listKs = [];
  changeListKs(List<int> listKsNew) {
    listKs = listKsNew;
    notifyListeners();
  }

  SecurityModel(this.storage) {
    sttMenu = storage.getItem("sttMenu") ?? 1;
  }

  void loginPage() {
    // storage.setItem("login", true);
    storage.setItem("sttMenu", 1);
  }

  getSttPage() {
    return storage.getItem("sttMenu");
  }

  changeSttMenu(int newSttMenu) {
    storage.setItem("sttMenu", newSttMenu);
    notifyListeners();
  }
}
