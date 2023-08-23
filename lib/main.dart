import 'dart:convert';
import 'package:fersys/prediksi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'owner_page.dart';
import 'spv_page.dart';
import 'api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null).then((_) => runApp(MyApp()));
}

String email = '';

bool _isLoggedIn = false;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primaryColor: Colors.white),
          routes: <String, WidgetBuilder>{
            '/HomepageOwner': (BuildContext context) => new HomepageOwner(
                  email: email,
                ),
            '/HomepageSpvWidget': (BuildContext context) =>
                new HomepageSpvWidget(
                  email: email,
                ),
            '/LoginPage': (BuildContext context) => new LoginPage(),
          },
          home:
              !_isLoggedIn ? HomepageOwner() : LoginPage(), //BUG??????
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class LoginPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<FormState>();
  final _unfocusNode = FocusNode();
  bool _isHidePassword = false;

  Uri apiUrl = Uri.parse(Api.url);

  String msgError = "";

  Future<void> _login() async {
    var client = new http.Client();
    var url = 'https://fersys.pocari.id/fersys/login.php';
    var res = await client.post(Uri.parse(url), body: {
      "email": user.text,
      "password": pass.text,
    });
    // final res = await client.post(apiUrl, body: {
    //   "email": user.text,
    //   "password": pass.text,
    // });

    final data = jsonDecode(res.body);

    if (data['level'] == "owner") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', user.text);
      prefs.setString('level', 'owner');
      prefs.setBool('isLoggedIn', true);
      print(data['msg'] + " dan status : " + data['level']);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (c) => HomepageOwner(email: data['email'])));
      user.clear();
      pass.clear();
      setState(() {
        msgError = "";
      });
    } else if (data['level'] == "spv") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', user.text);
      prefs.setString('level', 'spv');
      prefs.setBool('isLoggedIn', true);
      print(data['msg'] + " dan status : " + data['level']);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (c) => HomepageOwner(email: data['email'])));
      user.clear();
      pass.clear();
      setState(() {
        msgError = "";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Username atau password salah'),
      ));
    }
  }

  void _togglePassword() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  @override
  void initState() {
    super.initState();
    // _checkLoginStatus();
  }

  // void _checkLoginStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String getmail = prefs.getString('email') ?? '';
  //   String level = prefs.getString('level') ?? '';
  //   bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  //   if (isLoggedIn == false) {
  //     if (level == 'owner') {
  //       Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(builder: (c) => HomepageOwner(email: getmail)));
  //     } else if (level == 'spv') {
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //           builder: (c) => HomepageSpvWidget(email: getmail)));
  //     }
  //   } else {
  //     setState(() {
  //       _isLoggedIn = true;
  //     });
  //   }
  // }

  @override
  void dispose() {
    // _model.dispose();
    _unfocusNode.dispose();
    super.dispose();
    user.dispose();
    pass.dispose();
  }

  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  String email = "";

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
                    50.verticalSpace,
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/fersys-logo.png",
                        width: 350.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                    50.verticalSpace,
                    Center(
                      child: Text(
                        "Login",
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
                        height: 300,
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
                                controller: user,
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
                                      _login();
                                    }
                                  },
                                  child: Text(
                                    "Masuk",
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

  void tampil() {
    Fluttertoast.showToast(
        msg: "LOGIN GAGAL",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0x99205B22),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
