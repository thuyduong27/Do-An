import 'package:fe_web/views/screens/app-quan-tri/quan-ly-doanh-nghiep/quan-ly-screen.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'controllers/provider.dart';
import 'views/screens/app-giang-vien/kho-file/kho-file.dart';
import 'views/screens/app-giang-vien/quan-ly-sinh-vien/quan-ly-sinh-vien-gv.dart';
import 'views/screens/app-giang-vien/thong-bao-gui-sv/thong-bao-gui-sv.dart';
import 'views/screens/app-giang-vien/trang-chu/trang-chu.dart';
import 'views/screens/app-quan-tri/ke-hoach-thuc-tap/ke-hoach-thuc-tap.dart';
import 'views/screens/app-quan-tri/quan-ly-doanh-nghiep/xac-thuc-doanh-nghiep.dart';
import 'views/screens/app-quan-tri/quan-ly-giao-vien/quan-ly-gvhd-screen.dart';
import 'views/screens/app-quan-tri/quan-ly-sinh-vien/khao-sat/khao-sat-screen.dart';
import 'views/screens/app-quan-tri/quan-ly-sinh-vien/phan-cong-gvhd.dart';
import 'views/screens/app-quan-tri/quan-ly-sinh-vien/quan-ly-sinh-vien.dart';
import 'views/screens/app-quan-tri/trang-chu/trang-chu.dart';
import 'views/screens/app-sinh-vien/dang-ky-de-tai/dang-ky-de-tai-screen.dart';
import 'views/screens/app-sinh-vien/file-gui-sv/file-gui-sv-screen.dart';
import 'views/screens/app-sinh-vien/ke-hoach-thuc-tap/ke-hoach-thuc-tap-sv.dart';
import 'views/screens/app-sinh-vien/khao-sat-sv/khao-sat-sv.dart';
import 'views/screens/app-sinh-vien/nhat-ki-thuc-tap/nhat-ky-thuc-tap.dart';
import 'views/screens/app-sinh-vien/nop-bao-cao/nop-bao-cao-sv.dart';
import 'views/screens/app-sinh-vien/thong-bao-cua-gvhd/thong-bao-cua-gvhd.dart';
import 'views/screens/login/login-screen.dart';

void main() async {
  var securityModel = SecurityModel(LocalStorage('storage'));
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => securityModel),
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            routes: {
              '/login': (context) => LoginScreen(),
              '/trang-chu': (context) => TrangChuScreen(),
              '/ke-hoach-thuc-tap': (context) => KeHoachThucTapScreen(),
              '/quan-ly-doanh-ngiep': (context) => QuanLyDNScreen(),
              '/xac-thuc-doanh-ngiep': (context) => XacThucDNScreen(),
              '/quan-ly-gvhd': (context) => QuanLyGVHDScreen(),
              '/quan-ly-sinh-vien': (context) => QuanLySinhVienScreen(),
              '/ke-hoach-thuc-tap-sv': (context) => KHTTSVScreen(),
              '/dang-ky-de-tai': (context) => DangKyDeTaiScreen(),
              '/thong-bao-gvhd': (context) => TBGVHDScreen(),
              '/nhat-ky-thuc-tap': (context) => NhatKyTTScreen(),
              '/file-gui-sv': (context) => FileGuiSVScreen(),
              '/phan-cong-gvhd': (context) => PhanCongGVHDScreen(),
              '/quan-ly-sinh-vien-gv': (context) => QuanLySinhVienGVScreen(),
              '/thong-bao-gui-sv': (context) => const ThongBaoGuiSVScreen(),
              '/kho-file': (context) => const KhoFileScreen(),
              '/trang-chu-gv': (context) => TrangChuGVScreen(),
              '/khao-sat': (context) => KhaoSatScreen(),
              '/nop-bao-cao-sv': (context) => NopBaoCaoScreen(),
              '/khao-sat-sv': (context) => const KhaoSatSinhVienScreen(),
            },
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            // supportedLocales: [Locale('vi'), Locale('en')],
            locale: const Locale('vi'),
            home: LoginScreen())),
  );
}
