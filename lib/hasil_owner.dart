import 'dart:convert';

import 'package:fersys/riwayat_spv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'owner_page.dart';

class HasilRekomendasiOwnerWidget extends StatefulWidget {
  final kebun;
  final pupuk;
  final dosPohon;
  final dosKebun;
  final biaya;
  HasilRekomendasiOwnerWidget({this.kebun, this.pupuk, this.dosPohon, this.dosKebun, this.biaya});

  @override
  _HasilRekomendasiOwnerWidgetState createState() =>
      _HasilRekomendasiOwnerWidgetState();
}

class _HasilRekomendasiOwnerWidgetState
    extends State<HasilRekomendasiOwnerWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  //make list variable to accomodate all data from database

  bool _isLoggedIn = false;
  String? mail;
  String? level;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _getDataCH();
  }

  var sekarang = DateTime.now().year;
  var bulan = DateTime.now().month;
  Map<dynamic, dynamic> dataCH = {};
  var sem1 = '';
  var sem2 = '';


  // var dataCH;

  Future<Map> _getDataCH() async {
    var client = new http.Client();
    try {
      final response = await client.get(Uri.parse(
          //you have to take the ip address of your computer.
          //because using localhost will cause an error
          "https://fersys.pocari.id/fersys/rekomendasi.php?thn=$sekarang"));
          var jan, feb, mar, apr, mei, jun, jul, agt, sep, okt, nov, des;

      // if response successful
      if (response.statusCode == 200) {
        dataCH = jsonDecode(response.body);
        setState(() {
          int.parse(dataCH['jan']) >= 150 && int.parse(dataCH['jan']) <= 250 ?
            jan = 'Januari  ' : jan = '';
          int.parse(dataCH['feb']) >= 150 && int.parse(dataCH['feb']) <= 250 ?
            feb = 'Februari  ' : feb = '';
          int.parse(dataCH['mar']) >= 150 && int.parse(dataCH['mar']) <= 250 ?
            mar = 'Maret  ' : mar = '';
          int.parse(dataCH['apr']) >= 150 && int.parse(dataCH['apr']) <= 250 ?
            apr = 'April  ' : apr = '';
          int.parse(dataCH['mei']) >= 150 && int.parse(dataCH['mei']) <= 250 ?
            mei = 'Mei  ' : mei = '';
          int.parse(dataCH['jun']) >= 150 && int.parse(dataCH['jun']) <= 250 ?
            jun = 'Juni  ' : jun = '';
          int.parse(dataCH['jul']) >= 150 && int.parse(dataCH['jul']) <= 250 ?
            jul = 'Juli  ' : jul = '';
          int.parse(dataCH['agt']) >= 150 && int.parse(dataCH['agt']) <= 250 ?
            agt = 'Agustus  ' : agt = '';
          int.parse(dataCH['sep']) >= 150 && int.parse(dataCH['sep']) <= 250 ?
            sep = 'September  ' : sep = '';
          int.parse(dataCH['okt']) >= 150 && int.parse(dataCH['okt']) <= 250 ?
            okt = 'Oktober  ' : okt = '';
          int.parse(dataCH['nov']) >= 150 && int.parse(dataCH['nov']) <= 250 ?
            nov = 'November  ' : nov = '';
          int.parse(dataCH['des']) >= 150 && int.parse(dataCH['des']) <= 250 ?
            des = 'Desember  ' : des = '';
          sem1 = jan + feb + mar + apr + mei + jun;
          sem2 = jul + agt + sep + okt + nov + des;
        });
        print("dataCH : $dataCH");
      }
    } catch (e) {
      print(e);
    }
    return dataCH;
  }

  bool _isAdmin = true;

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mail = prefs.getString('email') ?? '';
    level = prefs.getString('level') ?? '';
    _isAdmin = prefs.getBool('admin') ?? true;
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn == false) {
      if (level == 'owner') {
        _isAdmin = true;
        // Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (c) => HomepageOwner(email: getmail)));
      } else if (level == 'spv') {
        _isAdmin = false;
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (c) => HomepageOwner(email: getmail)));
      }
      Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (c) => HomepageOwner(email: mail)));
    } else {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }
  
  Future deleteLoginSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('level');
    prefs.remove('admin');
    prefs.setBool('isLoggedIn', false);
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 24.w),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/images/fersys-logo.png',
                          scale: 350,
                          height: 100,
                          width: 350,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0x332C5A2E),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          color: Colors.transparent,
                          splashRadius: 30,
                          iconSize: 30,
                          icon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                MediaQuery.of(context).size.width,
                                kToolbarHeight,
                                0,
                                0,
                              ),
                              items: [
                                PopupMenuItem(
                                  child: Text('Hallo, $mail'),
                                  value: '',
                                ),
                                PopupMenuItem(
                                  child: Text('Logout'),
                                  value: 'logout',
                                ),
                              ],
                            ).then((value) async {
                              if (value == 'logout') {
                                // kode untuk melakukan logout
                                await deleteLoginSession();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
//=========================================HEADER=====================================================//
                25.verticalSpace,
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Rekomendasi Dosis Pupuk per Semester',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      color: Color(0xFF001A01),
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                25.verticalSpace,
                Center(
                  child: Container(
                    width: 346.6,
                    height: 430,
                    decoration: BoxDecoration(
                      color: Color(0x332C5A2E),
                      borderRadius: BorderRadius.circular(25),
                      shape: BoxShape.rectangle,
                    ),
                    child: GridView(
                        padding: EdgeInsets.only(left: 20, top: 30, bottom: 20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 2.5),
                        children: [
                          Text(
                            'Rekomendasi Bulan',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          bulan < 7 ?
                          Text(
                            '$sem1',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ) :
                          Text(
                            '$sem2',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            'Nama Kebun',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            '${widget.kebun}',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            'Jenis Pupuk',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            '${widget.pupuk}',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            'Dosis per Pohon',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            '${widget.dosPohon} kg/pohon',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            'Dosis per Lahan',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            '${widget.dosKebun} kg/semester',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            'Estimasi Biaya',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            'Rp${widget.biaya}',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                        ]),
                  ),
                ),
                20.verticalSpace,
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    width: 250,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0x00FFFFFF),
                    ),
                    child: Align(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0x99205B22),
                          onPrimary: Colors.white,
                          shadowColor: Color(0x58265F27),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          minimumSize: Size(100, 50), //////// HERE
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (c) => RiwayatPemupukanSpvWidget()));
                        },
                        child: Text(
                          'Riwayat Pemupukan',
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
