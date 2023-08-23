import 'hitung_dosis.dart';
import 'tutorial_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'owner_page.dart';

class HomepageSpvWidget extends StatefulWidget {
  final email;
  HomepageSpvWidget({this.email});

  @override
  _HomepageSpvWidgetState createState() => _HomepageSpvWidgetState();
}

class _HomepageSpvWidgetState extends State<HomepageSpvWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  bool _isLoggedIn = false;
  String? level;
  // String mail = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    level = prefs.getString('level');
    email = prefs.getString('email')!;

    if (!isLoggedIn) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (c) => LoginPage()));
    } else if (level == "admin") {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (c) => HomepageOwner()));
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
    prefs.setBool('isLoggedIn', false);
  }

  @override
  void dispose() {
    // _model.dispose();

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
                              child: Text('Hallo, $email'),
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
                20.verticalSpace,
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/fersys-logo.png',
                    width: 356.6,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
                30.verticalSpace,
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
                30.verticalSpace,
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
                            'Januari-Juni',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: Color(0xFF001A01),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
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
                            'Juli-Desember',
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
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    decoration: BoxDecoration(
                      color: Color(0x00FFFFFF),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0x99205B22),
                          onPrimary: Colors.white,
                          shadowColor: Color(0x58265F27),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          minimumSize: Size(150, 50), //////// HERE
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
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0x00FFFFFF),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0x99205B22),
                          onPrimary: Colors.white,
                          shadowColor: Color(0x58265F27),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          minimumSize: Size(150, 50), //////// HERE
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
