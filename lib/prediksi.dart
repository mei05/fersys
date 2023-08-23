import 'dart:convert';
import 'dart:math';

import 'package:fersys/rekomendasi_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class PrediksiWidget extends StatefulWidget {
  const PrediksiWidget({Key? key}) : super(key: key);

  @override
  _PrediksiWidgetState createState() => _PrediksiWidgetState();
}

class _PrediksiWidgetState extends State<PrediksiWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  String showYear = 'Pilih Tahun';
  DateTime _selectedYear = DateTime.now();
  selectYear(context) async {
    print("Calling date picker");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Year"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(2022),
              // lastDate: DateTime.now(),
              lastDate: DateTime(thn),
              initialDate: DateTime.now(),
              selectedDate: _selectedYear,
              onChanged: (DateTime dateTime) {
                print(dateTime.year);
                setState(() {
                  _selectedYear = dateTime;
                  showYear = "${dateTime.year}";
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

//inisialize field
  int jan = 0;
  int feb = 0;
  int mar = 0;
  int apr = 0;
  int mei = 0;
  int jun = 0;
  int jul = 0;
  int agt = 0;
  int sep = 0;
  int okt = 0;
  int nov = 0;
  int des = 0;
  List<dynamic> _getCH = [];
  List<dynamic> _getThn = [];
  List<dynamic> _getRekomendasi = [];
  List<int?> denormalizedOutputCH = []; // Tambahkan variabel ini ke state
  var thn; //data tahun terakhir + 1
  bool munculTombol = false;
  String akurasiTxt = '0.00';

  var dataRekomendasi;
  var dataSet;
  List<dynamic> inputCH = [];
  List<dynamic> outputCH = List.filled(1 * 12, 0).reshape([1, 12]);
  var akurasi = 0.00;
  var acc;
  double a = 0.00,
      b = 0.00,
      c = 0.00,
      d = 0.00,
      e = 0.00,
      f = 0.00,
      g = 0.00,
      h = 0.00;
  double i = 0.00, j = 0.00, k = 0.00, l = 0.00;
  String akurasii = '';

  Future<List> _getDataRekomendasi() async {
    var client = new http.Client();
    final response = await client.get(Uri.parse(
        "https://fersys.pocari.id/fersys/detail_ch.php")); //get data testing from db

    final interpreter = await tfl.Interpreter.fromAsset('assets/model_fix.tflite');

    // if response successful
    if (response.statusCode == 200) {
      dataSet = jsonDecode(response.body);
      int dataTahun = int.parse(dataSet['thn']);
      thn = dataTahun + 1;
      inputCH = [
        int.parse(dataSet['jan']),
        int.parse(dataSet['feb']),
        int.parse(dataSet['mar']),
        int.parse(dataSet['apr']),
        int.parse(dataSet['mei']),
        int.parse(dataSet['jun']),
        int.parse(dataSet['jul']),
        int.parse(dataSet['agt']),
        int.parse(dataSet['sep']),
        int.parse(dataSet['okt']),
        int.parse(dataSet['nov']),
        int.parse(dataSet['des'])
      ];
      // Calculate min and max values of inputCH
      int? minValue =
          inputCH.reduce((value, element) => value != null && element != null
              ? value < element
                  ? value
                  : element
              : value ?? element);
      int? maxValue =
          inputCH.reduce((value, element) => value != null && element != null
              ? value > element
                  ? value
                  : element
              : value ?? element);

      double desiredMin = 0.1;
      double desiredMax = 0.9;

      //fungsi untuk normalisasi
      List<double> normalizedInputCH = inputCH.map((value) {
        if (value != null && minValue != null && maxValue != null) {
          double normalizedValue = (value - minValue) / (maxValue - minValue);
          double scaledValue =
              desiredMin + (desiredMax - desiredMin) * normalizedValue;
          return scaledValue;
        }
        return 0.0; // Handle null values or division by zero
      }).toList();

      // Fungsi untuk melakukan denormalisasi
      List<int?> denormalizeOutputCH(
          List<double> normalizedOutputCH, int minValue, int maxValue) {
        List<int?> denormalizedOutputCH = normalizedOutputCH.map((scaledValue) {
          double normalizedValue = (scaledValue - 0.1) / (0.9 - 0.1);
          int denormalizedValue =
              (normalizedValue * (maxValue - minValue) + minValue).round();
          return denormalizedValue;
        }).toList();
        return denormalizedOutputCH;
      }

      setState(() {
        interpreter.run(normalizedInputCH, outputCH);
        a = (normalizedInputCH[0] - outputCH[0][0]) / normalizedInputCH[0];
        b = (normalizedInputCH[1] - outputCH[0][1]) / normalizedInputCH[1];
        c = (normalizedInputCH[2] - outputCH[0][2]) / normalizedInputCH[2];
        d = (normalizedInputCH[3] - outputCH[0][3]) / normalizedInputCH[3];
        e = (normalizedInputCH[4] - outputCH[0][4]) / normalizedInputCH[4];
        f = (normalizedInputCH[5] - outputCH[0][5]) / normalizedInputCH[5];
        g = (normalizedInputCH[6] - outputCH[0][6]) / normalizedInputCH[6];
        h = (normalizedInputCH[7] - outputCH[0][7]) / normalizedInputCH[7];
        i = (normalizedInputCH[8] - outputCH[0][8]) / normalizedInputCH[8];
        j = (normalizedInputCH[9] - outputCH[0][9]) / normalizedInputCH[9];
        k = (normalizedInputCH[10] - outputCH[0][10]) / normalizedInputCH[10];
        l = (normalizedInputCH[11] - outputCH[0][11]) / normalizedInputCH[11];
        acc = (a.abs() + b.abs() + c.abs() + d.abs() + e.abs() + f.abs() + g.abs()
         + h.abs() + i.abs() + j.abs() + k.abs() + l.abs())/12;
        akurasi = acc*100;
        akurasi = 100.00 - akurasi;
        akurasii = akurasi.toStringAsFixed(3);
        // Denormalisasi outputCH kembali ke _getRekomendasi
        _getRekomendasi =
            denormalizeOutputCH(outputCH[0], minValue!, maxValue!);
      });
      print("Data input: $inputCH");
      print("Data input normalized: $normalizedInputCH");
      print("Output CH: $outputCH");
      print("Denormalized output: $_getRekomendasi");
      print("Akurasi: $acc");
      print("Akurasi: $akurasi");
    }
    List<int?> convertedRekomendasi = _getRekomendasi.map((dynamic value) {
      return value as int?;
    }).toList();
    return convertedRekomendasi;
  }

  Future _onSubmit() async {
    try {
      return await http.post(
        Uri.parse("https://fersys.pocari.id/fersys/add_dataCH.php"),
        body: {
          "thn": thn.toString(),
          "jan": jan.toString(),
          "feb": feb.toString(),
          "mar": mar.toString(),
          "apr": apr.toString(),
          "mei": mei.toString(),
          "jun": jun.toString(),
          "jul": jul.toString(),
          "agt": agt.toString(),
          "sep": sep.toString(),
          "okt": okt.toString(),
          "nov": nov.toString(),
          "des": des.toString(),
          "akurasi": akurasii,
        },
      ).then((value) {
        var data = jsonDecode(value.body);
        print(data["message"]);
      });
    } catch (e) {
      print(e);
    }
  }

  var dataCH;
  Future<List> _getDataCH() async {
    var client = new http.Client();
    try {
      final response = await client.get(Uri.parse(
          //you have to take the ip address of your computer.
          //because using localhost will cause an error
          "https://fersys.pocari.id/fersys/list_ch.php"));

      // if response successful
      if (response.statusCode == 200) {
        dataCH = jsonDecode(response.body);
        print("dataCH : $dataCH");
      }
    } catch (e) {
      print(e);
    }
    return dataCH;
  }

  bool _isLoggedIn = false;
  String? level;
  String mail = '';
  bool _isAdmin = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _getDataRekomendasi().then((result) {
      setState(() {
        _getRekomendasi = result;
      });
    });
    _getDataCH().then((result) {
      setState(() {
        _getCH = result;
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
                    10.verticalSpace,
                    Center(
                      child: Text(
                        "Prediksi Curah Hujan",
                        style: TextStyle(
                          fontFamily: 'WorkSans',
                          color: Color(0xFF001A01),
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    5.verticalSpace,
                    Center(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                showYear,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 4, 88, 7),
                                  fontFamily: 'WorkSans',
                                  // fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  selectYear(context);
                                },
                                child: const Icon(
                                  Icons.calendar_month,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // 10.verticalSpace,
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0x99205B22),
                          onPrimary: Colors.white,
                          shadowColor: Color(0x58265F27),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          minimumSize: Size(100, 40), //////// HERE
                        ),
                        onPressed: () {
                          if (showYear != "Pilih Tahun") {
                            int tahunDipilih = int.parse(showYear);
                            if (tahunDipilih == thn) {
                              _getDataRekomendasi()
                                  .then((value) => _getRekomendasi);
                              jan = _getRekomendasi[0];
                              feb = _getRekomendasi[1];
                              mar = _getRekomendasi[2];
                              apr = _getRekomendasi[3];
                              mei = _getRekomendasi[4];
                              jun = _getRekomendasi[5];
                              jul = _getRekomendasi[6];
                              agt = _getRekomendasi[7];
                              sep = _getRekomendasi[8];
                              okt = _getRekomendasi[9];
                              nov = _getRekomendasi[10];
                              des = _getRekomendasi[11];
                              akurasii = akurasii;
                              akurasiTxt = akurasii.toString();
                              _onSubmit();
                              munculTombol = true;
                            } else if (tahunDipilih < thn) {
                              setState(() {
                                showYear = tahunDipilih.toString();
                                jan = int.parse(dataCH.firstWhere((element) =>
                                    element['thn'] == showYear)['jan']);
                                feb = int.parse(dataCH.firstWhere((element) =>
                                    element['thn'] == showYear)['feb']);
                                mar = int.parse(dataCH.firstWhere((element) =>
                                    element['thn'] == showYear)['mar']);
                                apr = int.parse(dataCH.firstWhere((element) =>
                                    element['thn'] == showYear)['apr']);
                                mei = int.parse(dataCH.firstWhere((element) =>
                                    element['thn'] == showYear)['mei']);
                                jun = int.parse(dataCH.firstWhere((element) =>
                                    element['thn'] == showYear)['jun']);
                                jul = int.parse(dataCH.firstWhere((element) =>
                                    element['thn'] == showYear)['jul']);
                                agt = int.parse(dataCH.firstWhere((element) =>
                                    element['thn'] == showYear)['agt']);
                                sep = int.parse(dataCH.firstWhere((element) =>
                                    element['thn'] == showYear)['sep']);
                                okt = int.parse(dataCH.firstWhere((element) =>
                                    element['thn'] == showYear)['okt']);
                                nov = int.parse(dataCH.firstWhere((element) =>
                                    element['thn'] == showYear)['nov']);
                                des = int.parse(dataCH.firstWhere((element) =>
                                    element['thn'] == showYear)['des']);
                                akurasii = dataCH.firstWhere((element) =>
                                    element['thn'] == showYear)['akurasi'];
                              akurasiTxt = akurasii.toString();
                                munculTombol = true;
                              });
                            }
                          } else {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Mohon Maaf'),
                                content:
                                    const Text('Pilih Tahun Terlebih Dahulu'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 4, 88, 7),
                                        fontFamily: 'WorkSans',
                                        // fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          ;
                        },
                        child: Text(
                          "Lihat Hasil",
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    5.verticalSpace,
                    Center(
                      child: Container(
                        width: 346.6,
                        height: 485,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                          shape: BoxShape.rectangle,
                        ),
                        child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: 70),
                            children: [
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Januari',
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
                                    padding: EdgeInsets.only(top: 10),
                                    width: 200,
                                    height: 40,
                                    child: Text(
                                      '$jan mm',
                                      style: jan < 150 || jan > 250
                                          ? TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 78, 73),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            )
                                          : TextStyle(
                                              color:
                                                  Color.fromARGB(255, 4, 88, 7),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                    ),
                                  ),
                                ),
                              ]),
                              // 3.verticalSpace,
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Februari',
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
                                      '$feb mm',
                                      style: feb < 150 || feb > 250
                                          ? TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 78, 73),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            )
                                          : TextStyle(
                                              color:
                                                  Color.fromARGB(255, 4, 88, 7),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                    ),
                                  ),
                                ),
                              ]),
                              // 5.verticalSpace,
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Maret',
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
                                      '$mar mm',
                                      style: mar < 150 || mar > 250
                                          ? TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 78, 73),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            )
                                          : TextStyle(
                                              color:
                                                  Color.fromARGB(255, 4, 88, 7),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                    ),
                                  ),
                                ),
                              ]),
                              // 5.verticalSpace,
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'April',
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
                                      '$apr mm',
                                      style: apr < 150 || apr > 250
                                          ? TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 78, 73),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            )
                                          : TextStyle(
                                              color:
                                                  Color.fromARGB(255, 4, 88, 7),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                    ),
                                  ),
                                ),
                              ]),
                              // 5.verticalSpace,
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Mei',
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
                                      '$mei mm',
                                      style: mei < 150 || mei > 250
                                          ? TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 78, 73),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            )
                                          : TextStyle(
                                              color:
                                                  Color.fromARGB(255, 4, 88, 7),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                    ),
                                  ),
                                ),
                              ]),
                              // 5.verticalSpace,
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Juni',
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
                                    padding: EdgeInsets.only(top: 10),
                                    width: 200,
                                    height: 40,
                                    child: Text(
                                      '$jun mm',
                                      style: jun < 150 || jun > 250
                                          ? TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 78, 73),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            )
                                          : TextStyle(
                                              color:
                                                  Color.fromARGB(255, 4, 88, 7),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Juli',
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
                                    padding: EdgeInsets.only(top: 10),
                                    width: 200,
                                    height: 40,
                                    child: Text(
                                      '$jul mm',
                                      style: jul < 150 || jul > 250
                                          ? TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 78, 73),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            )
                                          : TextStyle(
                                              color:
                                                  Color.fromARGB(255, 4, 88, 7),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                    ),
                                  ),
                                ),
                              ]),
                              // 3.verticalSpace,
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Agustus',
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
                                      '$agt mm',
                                      style: agt < 150 || agt > 250
                                          ? TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 78, 73),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            )
                                          : TextStyle(
                                              color:
                                                  Color.fromARGB(255, 4, 88, 7),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                    ),
                                  ),
                                ),
                              ]),
                              // 5.verticalSpace,
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'September',
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
                                      '$sep mm',
                                      style: sep < 150 || sep > 250
                                          ? TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 78, 73),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            )
                                          : TextStyle(
                                              color:
                                                  Color.fromARGB(255, 4, 88, 7),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                    ),
                                  ),
                                ),
                              ]),
                              // 5.verticalSpace,
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Oktober',
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
                                      '$okt mm',
                                      style: okt < 150 || okt > 250
                                          ? TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 78, 73),
                                              fontFamily: 'WorkSans',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            )
                                          : TextStyle(
                                              color:
                                                  Color.fromARGB(255, 4, 88, 7),
                                              fontSize: 14.sp,
                                              fontFamily: 'WorkSans',
                                              fontWeight: FontWeight.bold,
                                            ),
                                    ),
                                  ),
                                ),
                              ]),
                              // 5.verticalSpace,
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'November',
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
                                      '$nov mm',
                                      style: nov < 150 || nov > 250
                                          ? TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 78, 73),
                                              fontSize: 14.sp,
                                              fontFamily: 'WorkSans',
                                              fontWeight: FontWeight.bold,
                                            )
                                          : TextStyle(
                                              color:
                                                  Color.fromARGB(255, 4, 88, 7),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSans'),
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Container(
                                  width: 140,
                                  child: Text(
                                    'Desember',
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
                                    padding: EdgeInsets.only(top: 10),
                                    width: 200,
                                    height: 40,
                                    child: Text(
                                      '$des mm',
                                      style: des < 150 || des > 250
                                          ? TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 78, 73),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSans')
                                          : TextStyle(
                                              color:
                                                  Color.fromARGB(255, 4, 88, 7),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSans'),
                                    ),
                                  ),
                                ),
                              ]),
                            ]),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Sangat direkomendasikan melakukan pemupukan',
                        style: TextStyle(
                            color: Color.fromARGB(255, 4, 88, 7),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'WorkSans'),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Kurang direkomendasikan melakukan pemupukan',
                        style: TextStyle(
                            color: Color.fromARGB(255, 230, 78, 73),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'WorkSans'),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Akurasi hasil prediksi curah hujan adalah $akurasiTxt%',
                        style: TextStyle(
                            color: Color(0xFF001A01),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'WorkSans'),
                      ),
                    ),
                    5.verticalSpace,
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
                            minimumSize: Size(80, 50), //////// HERE
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                new MaterialPageRoute(
                                    builder: (c) => RekomendasiPage(
                                        tahun: int.parse(showYear))));
                            // }
                          },
                          child: Text(
                            "Lihat Rekomendasi Tahun ${showYear}",
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
