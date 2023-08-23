import 'package:fersys/prediksi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cuaca.dart';
import 'main.dart';
import 'owner_page.dart';

// import 'info_model.dart';
// export 'info_model.dart';

class InfoWidget extends StatefulWidget {
  const InfoWidget({Key? key}) : super(key: key);

  @override
  _InfoWidgetState createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  // late InfoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  bool _isLoggedIn = false;
  String? mail;
  String? level;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
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
                  alignment: Alignment.center,
                  child: Text(
                    'Info',
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
                    width: 350,
                    height: 340,
                    decoration: BoxDecoration(
                      color: Color(0x332C5A2E),
                      borderRadius: BorderRadius.circular(25),
                      shape: BoxShape.rectangle,
                    ),
                    child: Center(
                      child: Text(
                        '• Pemupukan idealnya dilakukan 2 kali \n  dalam setahun\n\n• Waktu optimal untuk melaksanakan \n  ' 
                        ' pemupukan pada saat curah hujan \n   berkisar 150-250 mm/bulan\n\n• Minimal saat curah hujan berkisar 60 \n'   
                        '   mm/bulan dan maksimal saat curah \n   hujan 300 mm/bulan\n\n• Jenis pupuk Urea kurang baik dilakukan \n'   
                        '   saat musim kemarau karena akan \n   mempercepat penguapan pupuk',
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: 'WorkSans',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    width: 150,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Color(0x00FFFFFF),
                    ),
                    child: Align(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0x99DB8D62),
                          onPrimary: Colors.white,
                          shadowColor: Color(0x6CDB8D62),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          minimumSize: Size(100, 50), //////// HERE
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (c) => HomepageOwner()));
                        },
                        child: Text(
                          'Beranda',
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