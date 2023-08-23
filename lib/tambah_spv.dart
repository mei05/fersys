import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'data_spv.dart';
import 'main.dart';

class TambahSPVWidget extends StatefulWidget {
  const TambahSPVWidget({Key? key}) : super(key: key);

  @override
  _TambahSPVWidgetState createState() => _TambahSPVWidgetState();
}

class _TambahSPVWidgetState extends State<TambahSPVWidget> {
  final scaffoldKey = GlobalKey<FormState>();
  final _unfocusNode = FocusNode();

  //inisialize field
  var uname = TextEditingController();
  var uemail = TextEditingController();
  var pass = TextEditingController();

  Future _onSubmit() async {
    try {
      return await http.post(
        Uri.parse("https://fersys.pocari.id/fersys/add_spv.php"),
        body: {
          "username": uname.text,
          "email": uemail.text,
          "password": pass.text,
        },
      ).then((value) {
        //print message after insert to database
        //you can improve this message with alert dialog
        var data = jsonDecode(value.body);
        print(data["message"]);

        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (c) => DataSpvWidget()));
      });
    } catch (e) {
      print(e);
    }
  }

  bool _isLoggedIn = false;
  String? level;
  String? mail;
  bool _isAdmin = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    //in first time, this method will be executed
    // _getData();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool _isAdmin = prefs.getBool('admin') ?? true;
    level = prefs.getString('level') ?? '';
    mail = prefs.getString('email') ?? '';
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!isLoggedIn) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (c) => LoginPage()));
    } else if (level == "spv") {
      _isAdmin = false;
      // Navigator.pushReplacement(
      //     context, new MaterialPageRoute(builder: (c) => HomepageSpvWidget()));
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
    uname.dispose();
    uemail.dispose();
    pass.dispose();
    _unfocusNode.dispose();
    super.dispose();
  }

  bool _isHidePassword = false;

  void _togglePassword() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: scaffoldKey,
        child: Padding(
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
                    50.verticalSpace,
                    Center(
                      child: Text(
                        "Tambah Supervisor",
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
                        width: 346,
                        height: 400,
                        decoration: BoxDecoration(
                          color: Color(0x332C5A2E),
                          borderRadius: BorderRadius.circular(25),
                          shape: BoxShape.rectangle,
                        ),
                        child: ListView(
                            padding: EdgeInsets.only(
                                left: 20, top: 20, bottom: 20, right: 20),
                            children: [
                              TextFormField(
                                controller: uname,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Username Tidak Boleh Kosong!';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40.r),
                                    borderSide: BorderSide(
                                        color: Color(0x412C5A2E), width: 0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40.r),
                                    borderSide: BorderSide(
                                        color: Color(0x412C5A2E), width: 0),
                                  ),
                                  filled: true,
                                  fillColor: Color(0x412C5A2E),
                                  hintText: "Username...",
                                  hintStyle: TextStyle(
                                    color: Colors.black38,
                                    fontFamily: 'WorkSans',
                                    fontSize: 14.sp,
                                  ),
                                  prefixIcon: const Icon(Icons.person),
                                ),
                              ),
                              15.verticalSpace,
                              TextFormField(
                                controller: uemail,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Email Tidak Boleh Kosong!';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40.r),
                                    borderSide: BorderSide(
                                        color: Color(0x412C5A2E), width: 0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40.r),
                                    borderSide: BorderSide(
                                        color: Color(0x412C5A2E), width: 0),
                                  ),
                                  filled: true,
                                  fillColor: Color(0x412C5A2E),
                                  hintText: "Email...",
                                  hintStyle: TextStyle(
                                    color: Colors.black38,
                                    fontFamily: 'WorkSans',
                                    fontSize: 14.sp,
                                  ),
                                  prefixIcon: const Icon(Icons.email_rounded),
                                ),
                              ),
                              15.verticalSpace,
                              TextFormField(
                                controller: pass,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Kata Sandi Tidak Boleh Kosong!';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40.r),
                                    borderSide: const BorderSide(
                                        color: Color(0x412C5A2E), width: 0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40.r),
                                    borderSide: const BorderSide(
                                        color: Color(0x412C5A2E), width: 0),
                                  ),
                                  filled: true,
                                  fillColor: Color(0x412C5A2E),
                                  prefixIcon: const Icon(Icons.key_rounded),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      _togglePassword();
                                    },
                                    focusNode: FocusNode(skipTraversal: true),
                                    child: Icon(
                                      _isHidePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 22,
                                    ),
                                  ),
                                  hintText: "Kata Sandi...",
                                  hintStyle: TextStyle(
                                    color: Colors.black38,
                                    fontFamily: 'WorkSans',
                                    fontSize: 14.sp,
                                  ),
                                ),
                                obscureText: !_isHidePassword,
                                obscuringCharacter: "*",
                              ),
                              30.verticalSpace,
                              Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0x99205B22),
                                    onPrimary: Colors.white,
                                    shadowColor: Color(0x58265F27),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40.0)),
                                    minimumSize: Size(150, 50), //////// HERE
                                  ),
                                  onPressed: () {
                                    if (scaffoldKey.currentState!.validate()) {
                                      _onSubmit();
                                    }
                                  },
                                  child: Text(
                                    "Tambah",
                                    style: TextStyle(
                                      fontFamily: 'WorkSans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
