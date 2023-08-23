import 'dart:convert';

import 'package:fersys/edit_spv.dart';
import 'package:fersys/owner_page.dart';
import 'package:fersys/tambah_spv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class DataSpvWidget extends StatefulWidget {
  const DataSpvWidget({Key? key}) : super(key: key);

  @override
  _DataSpvWidgetState createState() => _DataSpvWidgetState();
}

class _DataSpvWidgetState extends State<DataSpvWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  //make list variable to accomodate all data from database
  List _get = [];

  Future _getData() async {
    var client = new http.Client();
    try {
      final response = await client.get(Uri.parse(
          //you have to take the ip address of your computer.
          //because using localhost will cause an error
          "https://fersys.pocari.id/fersys/list_spv.php"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // entry data to variabel list _get
        setState(() {
          _get = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  bool _isLoggedIn = false;
  String? mail;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    //in first time, this method will be executed
    _getData();
  }

  bool _isAdmin = true;

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mail = prefs.getString('email') ?? '';
    String level = prefs.getString('level') ?? '';
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
                  alignment: Alignment.center,
                  child: Text(
                    'Data Supervisor',
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      color: Color(0xFF001A01),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    backgroundColor: Color(0x332C5A2E),
                    child: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          //routing into add page
                          MaterialPageRoute(
                              builder: (context) => TambahSPVWidget()));
                    },
                  ),
                ),
                8.verticalSpace,
                Center(
                  child: Container(
                    width: 346.6,
                    height: 500,
                    decoration: BoxDecoration(
                      color: Color(0x332C5A2E),
                      borderRadius: BorderRadius.circular(25),
                      shape: BoxShape.rectangle,
                    ),
                    child: _get.length != 0
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: _get.length,
                            itemBuilder: (_, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      //routing into edit page
                                      //we pass the id note
                                      MaterialPageRoute(
                                          builder: (context) => EditSPVWidget(
                                                id: _get[index]['id'],
                                              )));
                                },
                                child: Card(
                                  color: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  child: ListTile(
                                    title: Text(
                                      '${_get[index]['username']}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Row(
                                      children: <Widget>[Icon(Icons.edit)],
                                      mainAxisSize: MainAxisSize.min,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          //routing into edit page
                                          //we pass the id note
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditSPVWidget(
                                                    id: _get[index]['id'],
                                                  )));
                                    },
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              "Data Tidak Tersedia",
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: 'WorkSans',
                                fontSize: 20,
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
