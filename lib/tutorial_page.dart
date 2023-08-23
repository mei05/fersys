import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'info_page.dart';
import 'main.dart';
import 'owner_page.dart';

class TutorialWidget extends StatefulWidget {
  const TutorialWidget({Key? key}) : super(key: key);

  @override
  _TutorialWidgetState createState() => _TutorialWidgetState();
}

class _TutorialWidgetState extends State<TutorialWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  bool _isLoggedIn = false;
  String? mail;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  bool _isAdmin = true;
  String? level;

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
                    'Tutorial',
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
                    height: 450,
                    decoration: BoxDecoration(
                      color: Color(0x332C5A2E),
                      borderRadius: BorderRadius.circular(25),
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 30, left: 25, right: 10, bottom: 30),
                      child: level == 'spv' ? Text(
                        '1. Menekan tombol Hitung Dosis \n\n'
                        '2. Memilih kode kebun dan jenis  \n    pupuk \n\n'
                        '3. Menekan tombol Hitung   \n    untuk melihat hasilnya \n\n'
                        '4. Menekan tombol Riwayat  \n    Pemupukan\n\n'
                        '5. Menekan ikon tanda tambah untuk  \n    membuat riwayat pemupukan baru\n\n'
                        '6. Menekan ikon pensil untuk  \n    mengubah status pemupukan\n\n',
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: 'WorkSans',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ):
                      Text(
                        '1. Menekan tombol Hitung Dosis \n\n'
                        '2. Memilih kode kebun dan jenis  \n    pupuk \n\n'
                        '3. Menekan tombol Hitung   \n    untuk melihat hasilnya \n\n'
                        '4. Menekan tombol Riwayat  \n    Pemupukan\n\n'
                        '5. Untuk melihat Prakiraan Cuaca  \n    dan Prediksi Curah Hujan \n    tahunan,'
                        ' tekan tombol Info berikut',
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
                // 10.verticalSpace,
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
                                  builder: (c) => InfoWidget()));
                        },
                        child: Text(
                          'Info',
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
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
