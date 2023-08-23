import 'dart:convert';
import 'package:fersys/riwayat_spv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:intl/intl.dart';

class InputPelaksanaanWidget extends StatefulWidget {
  const InputPelaksanaanWidget({Key? key}) : super(key: key);

  @override
  _InputPelaksanaanWidgetState createState() => _InputPelaksanaanWidgetState();
}

const List<String> stat = <String>[
  'Belum Dipupuk',
  'Dalam Proses',
  'Sudah Selesai',
  'Dibatalkan',
];

  //inisialize field
  var namaKebun;
  var luas = '';
  var usia = '';
  var tanah = '-';
  var sph = '';
  int umur = 0;
  var namaPupuk;

String? statVal;

class _InputPelaksanaanWidgetState extends State<InputPelaksanaanWidget> {
  final scaffoldKey = GlobalKey<FormState>();
  final _unfocusNode = FocusNode();

  TextEditingController dateInput = TextEditingController();
  TextEditingController dosis = TextEditingController();
  TextEditingController status = TextEditingController();

  List<dynamic> _getKebun = [];
  List<dynamic> _getPupuk = [];

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

  Future _onSubmit() async {
    try {
      return await http.post(
        Uri.parse("https://fersys.pocari.id/fersys/add_pemupukan.php"),
        body: {
          "id_kebun": _selectedKebun,
          "id_pupuk": _selectedPupuk,
          "tanggal_mulai": dateInput.text,
          "tanggal_selesai": "-",
          "dosis": dosis.text,
          "status": statVal,
        },
      ).then((value) {
        //print message after insert to database
        //you can improve this message with alert dialog
        var data = jsonDecode(value.body);
        print(data["message"]);

        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (c) => RiwayatPemupukanSpvWidget()));
      });
    } catch (e) {
      print(e);
    }
  }

  String? _selectedKebun;
  String? _selectedPupuk;

  bool _isLoggedIn = false;
  String? level;
  String mail = '';
  bool _isAdmin = true;
  String dosisTxt = '0';

  @override
  void initState() {
    dateInput.text = "";
    super.initState();
    main();
    _checkLoginStatus();
    //in first time, this method will be executed
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

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('id_ID', null).then((_) => this);
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
  void dispose() {
    dosis.dispose();
    status.dispose();
    dateInput.dispose();
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
                                      child: Text('Hallo, $level'),
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
                        "Input Pemupukan",
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
                        height: 380,
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
                                        fontSize: 15.sp,
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
                                        fontSize: 15.sp,
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
                                              });
                                              hitungDosis();
                                              double jlhPohon = double.parse(sph);
                                              dosisKebun = jlhPohon * dosisPohon;
                                              dosisTxt = dosisKebun.toString();
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
                                    'Tanggal Mulai',
                                    style: TextStyle(
                                      fontFamily: 'WorkSans',
                                      color: Color(0xFF001A01),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 200,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(0x332C5A2E),
                                      borderRadius: BorderRadius.circular(30.r),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                                      child: TextFormField(
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(0xFF001A01),
                                            fontFamily: 'WorkSans',
                                            fontSize: 12.sp),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Waktu Pemupukan Tidak Boleh Kosong!';
                                          }
                                          return null;
                                        },
                                        controller: dateInput,
                                        //editing controller of this TextField
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.calendar_month_outlined,
                                            // size: 1,
                                            color:
                                                Color.fromARGB(255, 4, 14, 5),
                                          ),
                                          hintText: 'Pilih Tanggal',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                            color: Colors.grey[800],
                                            fontFamily: 'WorkSans',
                                            fontSize: 12.sp,
                                          ), //icon of text field
                                        ),
                                        readOnly: true,
                                        //set it true, so that user will not able to edit text
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                                  context: context,
                                                  cancelText: 'Batal',
                                                  confirmText: 'Pilih',
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1950),
                                                  //DateTime.now() - not to allow to choose before today.
                                                  lastDate: DateTime(2100));

                                          if (pickedDate != null) {
                                            print(
                                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                            String formattedDate = DateFormat(
                                                    "EEEE, d MMMM yyyy",
                                                    "id_ID")
                                                .format(pickedDate);
                                            print(
                                                formattedDate); //formatted date output using intl package =>  Hari, tanggal
                                            setState(() {
                                              dateInput.text =
                                                  formattedDate; //set output date to TextField value.
                                            });
                                          } else {}
                                        },
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
                                    'Jumlah Pupuk',
                                    style: TextStyle(
                                      fontFamily: 'WorkSans',
                                      color: Color(0xFF001A01),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 200,
                                    height: 40,
                                    child: TextFormField(
                                      controller: dosis,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Jumlah Pupuk Tidak Boleh Kosong!';
                                        }
                                        return null;
                                      },
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
                                        hintText: "Satuan Kilogram (kg)",
                                        hintStyle: TextStyle(
                                          color: Colors.grey[700],
                                          fontFamily: 'WorkSans',
                                          fontSize: 12.sp,
                                        ),
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
                                    'Status',
                                    style: TextStyle(
                                      fontFamily: 'WorkSans',
                                      color: Color(0xFF001A01),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
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
                                          items: stat.map(
                                            (String value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(value),
                                              );
                                            },
                                          ).toList(),
                                          value: statVal,
                                          onChanged: (String? value) {
                                            setState(() {
                                              statVal = value;
                                            });
                                          },
                                          isDense: true,
                                          // elevation: 8,
                                          dropdownColor: Color.fromARGB(
                                              255, 193, 221, 194),
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          hint: Text("Belum Dipupuk"),
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
                              ]),
                            ]),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Jumlah pupuk yang direkomendasikan adalah $dosisTxt kg',
                        style: TextStyle(
                            color: Color(0xFF001A01),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'WorkSans'),
                      ),
                    ),
                    10.verticalSpace,
                    Align(
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
                          if (scaffoldKey.currentState!.validate()) {
                            _onSubmit();
                          }
                        },
                        child: Text(
                          "Simpan",
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
        ),
      ),
    );
  }
}
