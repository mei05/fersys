import 'dart:convert';
import 'package:fersys/riwayat_spv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'main.dart';

class EditPelaksanaanWidget extends StatefulWidget {
  final id;
  EditPelaksanaanWidget({this.id});

  @override
  _EditPelaksanaanWidgetState createState() => _EditPelaksanaanWidgetState();
}

const List<String> stat = <String>[
  'Belum Dipupuk',
  'Dalam Proses',
  'Sudah Selesai',
  'Dibatalkan'
];

String? statVal;

class _EditPelaksanaanWidgetState extends State<EditPelaksanaanWidget> {
  final scaffoldKey = GlobalKey<FormState>();
  final _unfocusNode = FocusNode();

  var tanggal_mulai = TextEditingController();
  var tanggal_selesai = TextEditingController();
  var dosis = TextEditingController();
  var kebun = TextEditingController();
  var pupuk = TextEditingController();
  var status = TextEditingController();

  bool muncul = false;

  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          //you have to take the ip address of your computer.
          //because using localhost will cause an error
          //get detail data with id
          "https://fersys.pocari.id/fersys/detail_pemupukan.php?id_pemupukan='${widget.id}'"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          dosis = TextEditingController(text: data['dosis']);
          tanggal_mulai = TextEditingController(text: data['tanggal_mulai']);
          tanggal_selesai = TextEditingController(text: data['tanggal_selesai']);
          kebun = TextEditingController(text: data['kode_kebun']);
          pupuk = TextEditingController(text: data['nama_pupuk']);
          status = TextEditingController(text: data['status']);

          statVal = data['status'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _onUpdate(context) async {
    try {
      return await http.post(
        Uri.parse("https://fersys.pocari.id/fersys/update_pemupukan.php"),
        body: {
          "id_pemupukan": widget.id,
          "tanggal_selesai": tanggal_selesai.text,
          "status": statVal,
        },
      ).then((value) {
        //print message after insert to database
        //you can improve this message with alert dialog
        var data = jsonDecode(value.body);
        print(data["message"]);

        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (c) => RiwayatPemupukanSpvWidget()));
      });
    } catch (e) {
      print(e);
    }
  }

  bool _isLoggedIn = false;
  String? level;
  String mail = '';
  bool _isAdmin = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _getData();
  }

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('id_ID', null).then((_) => runApp(MyApp()));
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
    // stat.dispose();
    tanggal_selesai.dispose();
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
                        "Detail Pemupukan",
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
                                      child: TextFormField(
                                        style: const TextStyle(
                                          fontFamily: "WorkSans",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color.fromARGB(167, 4, 14, 5),
                                        ),
                                        controller: kebun,
                                        readOnly: true,
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
                                  Expanded(
                                    child: Container(
                                      width: 200,
                                      height: 40,
                                      child: TextFormField(
                                        style: const TextStyle(
                                          fontFamily: "WorkSans",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color.fromARGB(167, 4, 14, 5),
                                        ),
                                        controller: pupuk,
                                        readOnly: true,
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
                                    child: TextFormField(
                                      style: const TextStyle(
                                        fontFamily: "WorkSans",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Color.fromARGB(167, 4, 14, 5),
                                      ),
                                      controller: tanggal_mulai,
                                      readOnly: true,
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
                                      style: const TextStyle(
                                        fontFamily: "WorkSans",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Color.fromARGB(167, 4, 14, 5),
                                      ),
                                      controller: dosis,
                                      readOnly: true,
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
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              25.verticalSpace,
                              Visibility(
                                visible: level == "owner" ? true : false,
                                child: Row(children: [
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
                                      child: TextFormField(
                                        style: const TextStyle(
                                          fontFamily: "WorkSans",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color.fromARGB(167, 4, 14, 5),
                                        ),
                                        controller: status,
                                        readOnly: true,
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
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              // 25.verticalSpace,
                              Visibility(
                                visible: level == "spv" ? true : false,
                                child: Row(children: [
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
                                                if (statVal == "Sudah Selesai")
                                                {
                                                  muncul = true;
                                                }
                                              });
                                            },
                                            isDense: true,
                                            // elevation: 8,
                                            dropdownColor: Color.fromARGB(
                                                255, 193, 221, 194),
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
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
                              ),
                              25.verticalSpace,
                              Visibility(
                                visible: muncul,
                                child: Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Tanggal Selesai',
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
                                        controller: tanggal_selesai,
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
                                              tanggal_selesai.text =
                                                  formattedDate; //set output date to TextField value.
                                            });
                                          } else {}
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              ),
                            ]),
                      ),
                    ),
                    // 20.verticalSpace,
                    Visibility(
                      visible: level == "spv" ? true : false,
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
                            _onUpdate(context);
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
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
