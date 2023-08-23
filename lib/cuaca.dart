import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'dart:convert';

import 'detail_cuaca.dart';
import 'main.dart';

class PrakiraanCuacaWidget extends StatefulWidget {
  const PrakiraanCuacaWidget({Key? key}) : super(key: key);

  @override
  _PrakiraanCuacaWidgetState createState() => _PrakiraanCuacaWidgetState();
}

class _PrakiraanCuacaWidgetState extends State<PrakiraanCuacaWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  TextEditingController searchController = TextEditingController();
  String textSearch = '';
  StreamController? streamDataBMKG;

  Future<List<dynamic>> fetchDataBMKGRiau() async {
    var uRL =
        "https://data.bmkg.go.id/DataMKG/MEWS/DigitalForecast/DigitalForecast-Riau.xml";

    final result = await http.get(Uri.parse(uRL));
    final Xml2Json xml2Json = Xml2Json();
    xml2Json.parse(result.body);
    var json = xml2Json.toGData();

    Map<String, dynamic> map = jsonDecode(json);
    return map['data']['forecast']['area'];
  }

  Widget buildListKota(item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => DetailInfo(
                title: item['description'],
                headerInfo: item['name'],
                infoData: item['parameter']))));
      },
      child: Card(
          child: ListTile(
        title: Text(
          item['description'],
          style: TextStyle(
            fontFamily: 'WorkSans',
            color: Color(0xFF001A01),
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
                        ),
        ),
        subtitle: Text(
          item['name'][1]['\$t'].toString(),
          style: TextStyle(
            fontFamily: 'WorkSans',
            color: Color.fromARGB(166, 0, 26, 1),
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
                        ),),
      )),
    );
  }

  @override
  void dispose() {
    // _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  bool _isLoggedIn = false;
  String? level;
  String mail = '';
  bool _isAdmin = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    // bool _isAdmin = prefs.getBool('admin') ?? true;
    level = prefs.getString('level');
    mail = prefs.getString('email')!;

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
                    10.verticalSpace,
                    Center(
                      child: Text(
                        "Cuaca",
                        style: TextStyle(
                          fontFamily: 'WorkSans',
                          color: Color(0xFF001A01),
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // 20.verticalSpace,
                    Center(
                      child: Container(
                        width: 350,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                          shape: BoxShape.rectangle,
                        ),
                        child: Column(children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                setState(() {
                                  textSearch = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.r),
                                  borderSide: BorderSide(
                                      color: Color(0x412C5A2E), width: 0.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.r),
                                  borderSide: BorderSide(
                                      color: Color(0x412C5A2E), width: 0.5),
                                ),
                                labelText: 'Cari disini ...',
                                suffixIcon: Icon(Icons.search),
                                  fillColor: Color(0x332C5A2E),
                                  filled: true,
                                  ),
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                color: Color(0xFF001A01),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                        ),
                            ),
                          ),
                          Container(
                            height: 20,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 0.5, color: Color(0x332C5A2E)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder<List<dynamic>>(
                              future: fetchDataBMKGRiau(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }

                                if (snapshot.hasData) {
                                  List<dynamic> dataKota = snapshot.data;
                                  if (textSearch.isNotEmpty) {
                                    dataKota = dataKota.where((element) {
                                      return element['description']
                                          .toString()
                                          .toLowerCase()
                                          .contains(textSearch
                                              .toString()
                                              .toLowerCase());
                                    }).toList();
                                  }
                                  return ListView.builder(
                                      padding: const EdgeInsets.all(10),
                                      itemCount: dataKota.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var item = dataKota[index];
                                        return buildListKota(item);
                                      });
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0x99205B22),
                                      ));
                                }
                              },
                            ),
                          ),
                        ]),
                      ),
                    ),
                    // 20.verticalSpace,
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       primary: Color(0x99205B22),
                    //       onPrimary: Colors.white,
                    //       shadowColor: Color(0x58265F27),
                    //       elevation: 3,
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(40.0)),
                    //       minimumSize: Size(150, 50), //////// HERE
                    //     ),
                    //     onPressed: () {
                    //       // _onUpdate(context);
                    //     },
                    //     child: Text(
                    //       "Simpan",
                    //       style: TextStyle(
                    //         fontFamily: 'WorkSans',
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 18.sp,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
