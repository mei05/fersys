import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'hasil_owner.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class HitungDosisWidget extends StatefulWidget {
  const HitungDosisWidget({Key? key}) : super(key: key);

  @override
  _HitungDosisWidgetState createState() => _HitungDosisWidgetState();
}

class _HitungDosisWidgetState extends State<HitungDosisWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  //inisialize field
  var namaKebun;
  var luas = '';
  var usia = '';
  var tanah = '-';
  var sph = '';
  int umur = 0;
  var harga;
  var namaPupuk;

  List<dynamic> _getKebun = [];
  List<dynamic> _getPupuk = [];
  var hrg = TextEditingController();

  var dataPupuk;
  var dataKebun;
  Future<List> _getDataKebun() async {
    var client = new http.Client();
    try {
      final response = await client.get(Uri.parse(
          //you have to take the ip address of your computer.
          //because using localhost will cause an error
          "https://fersys.pocari.id/fersys/list_kebun.php"));

      // if response successful
      if (response.statusCode == 200) {
        dataKebun = jsonDecode(response.body);
        print("dataKebun : $dataKebun");
      }
    } catch (e) {
      print(e);
    }
    return dataKebun;
  }

  Future<List> _getDataPupuk() async {
    var client = new http.Client();
    try {
      final response = await client.get(Uri.parse(
          //you have to take the ip address of your computer.
          //because using localhost will cause an error
          "https://fersys.pocari.id/fersys/list_pupuk.php"));

      // if response successful
      if (response.statusCode == 200) {
        dataPupuk = jsonDecode(response.body);
        print("dataPupuk : $dataPupuk");
      }
    } catch (e) {
      print(e);
    }
    return dataPupuk;
  }

  String? _selectedKebun;
  String? _selectedPupuk;

  bool _isLoggedIn = false;
  String? level;
  String mail = '';
  bool _isAdmin = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _getDataPupuk().then((result) {
      setState(() {
        _getPupuk = result;
      });
    });
    _getDataKebun().then((result) {
      setState(() {
        _getKebun = result;
      });
    });
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    // bool _isAdmin = prefs.getBool('admin') ?? true;
    level = prefs.getString('level') ?? '';
    mail = prefs.getString('email') ?? '';

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

  var dosisPohon;
  var dosisKebun;
  hitungDosis() {
    if (tanah == 'Mineral') {
      if (3 < umur && umur < 8) {
        if (namaPupuk == 'Urea') {
          dosisPohon = 2.00;
        } else if (namaPupuk == 'SP-36' || namaPupuk == 'MOP') {
          dosisPohon = 1.50;
        } else if (namaPupuk == 'Kieserite') {
          dosisPohon = 1.00;
        } else if (namaPupuk == 'NPK') {
          dosisPohon = 6.00;
        }
      } else if (9 < umur && umur < 13) {
        if (namaPupuk == 'Urea') {
          dosisPohon = 2.75;
        } else if (namaPupuk == 'SP-36' || namaPupuk == 'MOP') {
          dosisPohon = 2.25;
        } else if (namaPupuk == 'Kieserite') {
          dosisPohon = 1.50;
        } else if (namaPupuk == 'NPK') {
          dosisPohon = 9.00;
        }
      } else if (14 < umur && umur < 20) {
        if (namaPupuk == 'Urea') {
          dosisPohon = 2.50;
        } else if (namaPupuk == 'SP-36' || namaPupuk == 'MOP') {
          dosisPohon = 2.00;
        } else if (namaPupuk == 'Kieserite') {
          dosisPohon = 1.50;
        } else if (namaPupuk == 'NPK') {
          dosisPohon = 7.50;
        }
      } else if (21 < umur) {
        if (namaPupuk == 'Urea') {
          dosisPohon = 1.75;
        } else if (namaPupuk == 'SP-36' || namaPupuk == 'MOP') {
          dosisPohon = 1.25;
        } else if (namaPupuk == 'Kieserite') {
          dosisPohon = 1.00;
        } else if (namaPupuk == 'NPK') {
          dosisPohon = 6.00;
        }
      }
    }
//  ===================================JENIS TANAH ==============================    //
    else {
      if (3 < umur && umur < 8) {
        if (namaPupuk == 'Urea') {
          dosisPohon = 2.00;
        } else if (namaPupuk == 'SP-36') {
          dosisPohon = 1.75;
        } else if (namaPupuk == 'MOP') {
          dosisPohon = 1.50;
        } else if (namaPupuk == 'Kieserite') {
          dosisPohon = 1.50;
        } else if (namaPupuk == 'NPK') {
          dosisPohon = 7.00;
        }
      } else if (9 < umur && umur < 13) {
        if (namaPupuk == 'Urea') {
          dosisPohon = 2.50;
        } else if (namaPupuk == 'SP-36') {
          dosisPohon = 2.75;
        } else if (namaPupuk == 'MOP') {
          dosisPohon = 2.25;
        } else if (namaPupuk == 'Kieserite') {
          dosisPohon = 2.00;
        } else if (namaPupuk == 'NPK') {
          dosisPohon = 10.00;
        }
      } else if (14 < umur && umur < 20) {
        if (namaPupuk == 'Urea') {
          dosisPohon = 1.50;
        } else if (namaPupuk == 'SP-36') {
          dosisPohon = 2.25;
        } else if (namaPupuk == 'MOP') {
          dosisPohon = 2.00;
        } else if (namaPupuk == 'Kieserite') {
          dosisPohon = 2.00;
        } else if (namaPupuk == 'NPK') {
          dosisPohon = 9.00;
        }
      } else if (21 < umur) {
        if (namaPupuk == 'Urea') {
          dosisPohon = 1.50;
        } else if (namaPupuk == 'SP-36') {
          dosisPohon = 1.50;
        } else if (namaPupuk == 'MOP') {
          dosisPohon = 1.25;
        } else if (namaPupuk == 'Kieserite') {
          dosisPohon = 1.50;
        } else if (namaPupuk == 'NPK') {
          dosisPohon = 7.00;
        }
      }
    }
    dosisPohon = dosisPohon / 2;
    print(dosisPohon);
    // dosisKebun = sph*dosisPohon;
    // return dosisPohon;
  }

  bool munculTombol = false;
  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
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
                    30.verticalSpace,
                    Center(
                      child: Text(
                        "Hitung Dosis",
                        style: TextStyle(
                          fontFamily: 'WorkSans',
                          color: Color(0xFF001A01),
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    15.verticalSpace,
                    Center(
                      child: Container(
                        width: 346.6,
                        height: 500,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                          shape: BoxShape.rectangle,
                        ),
                        child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 140,
                                    child: Text(
                                      'Kode Kebun',
                                      style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        color: Color(0xFF001A01),
                                        // fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 200,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Color(0x332C5A2E),
                                        borderRadius: BorderRadius.circular(30),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _selectedKebun,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedKebun = value;
                                                namaKebun = dataKebun
                                                    .firstWhere((element) =>
                                                        element['id'] ==
                                                        _selectedKebun)['nama'];
                                                luas = dataKebun.firstWhere(
                                                    (element) =>
                                                        element['id'] ==
                                                        _selectedKebun)['luas'];
                                                usia = dataKebun.firstWhere(
                                                    (element) =>
                                                        element['id'] ==
                                                        _selectedKebun)['usia'];
                                                tanah = dataKebun.firstWhere(
                                                        (element) =>
                                                            element['id'] ==
                                                            _selectedKebun)[
                                                    'jenis_tanah'];
                                                sph = dataKebun.firstWhere(
                                                    (element) =>
                                                        element['id'] ==
                                                        _selectedKebun)['sph'];
                                                umur = DateTime.now().year -
                                                    int.parse(usia);
                                              });
                                            },
                                            items: _getKebun
                                                .map<DropdownMenuItem<String>>(
                                                    (item) {
                                              return DropdownMenuItem<String>(
                                                value: item['id'],
                                                child: Text(item['kode_kebun']),
                                              );
                                            }).toList(),

                                            isDense: true,
                                            // elevation: 8,
                                            dropdownColor: Color.fromARGB(
                                                255, 193, 221, 194),
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            hint: Text("Pilih Kebun"),
                                            style: const TextStyle(
                                              fontFamily: "WorkSans",
                                              fontSize: 14,
                                              color:
                                                  Color.fromARGB(255, 4, 14, 5),
                                            ),
                                            isExpanded: true,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              25.verticalSpace,
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Luas',
                                    style: TextStyle(
                                      fontFamily: 'WorkSans',
                                      color: Color(0xFF001A01),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 10),
                                    width: 200,
                                    height: 40,
                                    child: Text(
                                      '$luas m\u00b2',
                                      style: TextStyle(
                                        fontFamily: "WorkSans",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color: Color.fromARGB(255, 4, 14, 5),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              25.verticalSpace,
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Jumlah Pohon',
                                    style: TextStyle(
                                      fontFamily: 'WorkSans',
                                      color: Color(0xFF001A01),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 10),
                                    width: 200,
                                    height: 40,
                                    child: Text(
                                      '$sph pohon',
                                      style: TextStyle(
                                        fontFamily: "WorkSans",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color: Color.fromARGB(255, 4, 14, 5),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              25.verticalSpace,
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Umur',
                                    style: TextStyle(
                                      fontFamily: 'WorkSans',
                                      color: Color(0xFF001A01),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 10),
                                    width: 200,
                                    height: 40,
                                    child: Text(
                                      '$umur tahun',
                                      style: TextStyle(
                                        fontFamily: "WorkSans",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color: Color.fromARGB(255, 4, 14, 5),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              25.verticalSpace,
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Jenis Tanah',
                                    style: TextStyle(
                                      fontFamily: 'WorkSans',
                                      color: Color(0xFF001A01),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 10),
                                    width: 200,
                                    height: 40,
                                    child: Text(
                                      '$tanah',
                                      style: TextStyle(
                                        fontFamily: "WorkSans",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color: Color.fromARGB(255, 4, 14, 5),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              25.verticalSpace,
                              Row(
                                children: [
                                  Container(
                                    width: 140,
                                    child: Text(
                                      'Jenis Pupuk',
                                      style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        color: Color(0xFF001A01),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      width: 200,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Color(0x332C5A2E),
                                        borderRadius: BorderRadius.circular(30),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            isDense: true,
                                            // elevation: 8,
                                            dropdownColor: Color.fromARGB(
                                                255, 193, 221, 194),
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            hint: Text("Pilih Pupuk"),
                                            style: const TextStyle(
                                              fontFamily: "WorkSans",
                                              fontSize: 14,
                                              color:
                                                  Color.fromARGB(255, 4, 14, 5),
                                            ),
                                            isExpanded: true,
                                            value: _selectedPupuk,
                                            items: _getPupuk
                                                .map<DropdownMenuItem<String>>(
                                                    (_items) {
                                              return DropdownMenuItem<String>(
                                                value: _items['id_pupuk'],
                                                child:
                                                    Text(_items['nama_pupuk']),
                                              );
                                            }).toList(),
                                            onChanged: (newvalue) {
                                              setState(() {
                                                _selectedPupuk = newvalue;
                                                namaPupuk = dataPupuk
                                                        .firstWhere((element) =>
                                                            element[
                                                                'id_pupuk'] ==
                                                            _selectedPupuk)[
                                                    'nama_pupuk'];
                                                harga = dataPupuk.firstWhere(
                                                        (element) =>
                                                            element[
                                                                'id_pupuk'] ==
                                                            _selectedPupuk)[
                                                    'harga'];
                                                hrg = TextEditingController(
                                                    text: harga);
                                                munculTombol = true;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              25.verticalSpace,
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Harga Pupuk',
                                    style: TextStyle(
                                      fontFamily: 'WorkSans',
                                      color: Color(0xFF001A01),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    // padding: EdgeInsets.only(top: 10),
                                    width: 200,
                                    height: 40,
                                    child: TextFormField(
                                      controller: hrg,
                                      style: TextStyle(
                                        fontFamily: "WorkSans",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color: Color.fromARGB(255, 4, 14, 5),
                                      ),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.r),
                                          borderSide: BorderSide(
                                              color: Color(0x412C5A2E),
                                              width: 0.5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.r),
                                          borderSide: BorderSide(
                                              color: Color(0x412C5A2E),
                                              width: 0.5),
                                        ),
                                        filled: true,
                                        fillColor: Color(0x412C5A2E),
                                        hintText: "Rp0",
                                        hintStyle: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'WorkSans',
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ]),
                      ),
                    ),
                    20.verticalSpace,
                    Visibility(
                      visible: munculTombol,
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
                            hitungDosis();
                            double jlhPohon = double.parse(sph);
                            dosisKebun = jlhPohon * dosisPohon;
                            harga = double.parse(hrg.text);
                            harga = dosisKebun * harga;
                            harga = harga.toString();
                            Navigator.of(context).pushReplacement(
                                new MaterialPageRoute(
                                    builder: (c) => HasilRekomendasiOwnerWidget(
                                        kebun: namaKebun,
                                        pupuk: namaPupuk,
                                        dosPohon: dosisPohon,
                                        dosKebun: dosisKebun,
                                        biaya: harga)));
                            // }
                          },
                          child: Text(
                            "Hitung",
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
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
