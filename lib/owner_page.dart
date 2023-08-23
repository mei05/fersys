import 'dart:convert';
import 'package:fersys/data_spv.dart';
import 'prediksi.dart';
import 'cuaca.dart';
import 'hitung_dosis.dart';
import 'main.dart';
import 'tutorial_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomepageOwner extends StatefulWidget {
  final String? email;
  HomepageOwner({this.email});

  @override
  _HomepageOwnerState createState() => _HomepageOwnerState();
}

class _HomepageOwnerState extends State<HomepageOwner> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  bool _isLoggedIn = false;
  bool _isAdmin = true;
  String? level;
  String? mail;
  var sekarang = DateTime.now().year;
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

  @override
  void initState() {
    _checkLoginStatus();
    super.initState();
    _getDataCH();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    level = prefs.getString('level');
    mail = prefs.getString('email');

    if (!isLoggedIn) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (c) => LoginPage()));
    } 
    else {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  Future deleteLoginSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('level');
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
                5.verticalSpace,
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
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
                ),
                10.verticalSpace,
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/fersys-logo.png',
                    width: 356.6,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
                15.verticalSpace,
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Rekomendasi Masa Pemupukan Kelapa Sawit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      color: Color(0xFF001A01),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                20.verticalSpace,
                Center(
                  child: Container(
                    width: 346.6,
                    height: 198.6,
                    decoration: BoxDecoration(
                      color: Color(0x332C5A2E),
                      borderRadius: BorderRadius.circular(25),
                      shape: BoxShape.rectangle,
                    ),
                    child: GridView(
                        padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 2.0),
                        children: [
                          Text(
                            'Semester 1',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            '$sem1',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                            ),
                          ),
                          Text(
                            'Semester 2',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            '$sem2',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                            ),
                          ),
                        ]),
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    width: 250,
                    height: 70,
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
                          minimumSize: Size(230, 50), //////// HERE
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const HitungDosisWidget()),
                          );
                        },
                        child: Text(
                          'Hitung Dosis',
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
                                // 10.verticalSpace,
                  Center(
                  child: Container(
                    // padding: EdgeInsets.only(top: 20),
                    width: 250,
                    height: 60,
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
                          minimumSize: Size(230, 50), //////// HERE
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (c) => PrakiraanCuacaWidget()));
                        },
                        child: Text(
                          'Prakiraan Cuaca',
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
                // 10.verticalSpace,
                  Center(
                  child: Container(
                    // padding: EdgeInsets.only( bottom: 20),
                    width: 250,
                    height: 60,
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
                          minimumSize: Size(230, 50), //////// HERE
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (c) => PrediksiWidget()));
                        },
                        child: Text(
                          'Prediksi Curah Hujan',
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
                Center(
                  child: Container(
                    width: 250,
                    height: 60,
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
                          minimumSize: Size(230, 50), //////// HERE
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TutorialWidget()),
                          );
                        },
                        child: Text(
                          'Tutorial',
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
                10.verticalSpace,
                Visibility(
                  visible: level == 'owner'? true : false,
                  child: 
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0x99205B22),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        color: Colors.black,
                        splashRadius: 30,
                        icon: Icon(
                          Icons.person_add,
                          color: Colors.black,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (c) => DataSpvWidget()));
                        },
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
