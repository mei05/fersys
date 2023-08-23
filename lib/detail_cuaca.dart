//import 'package:cuaca/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

import '/utils/wheater_helper.dart';

class DetailInfo extends StatefulWidget {
  const DetailInfo(
      {super.key,
      required this.title,
      required this.headerInfo,
      required this.infoData});

  final String title;
  final List<dynamic> infoData;
  final List<dynamic> headerInfo;
  

  @override
  State<DetailInfo> createState() => _DetailInfoState();
}

class _DetailInfoState extends State<DetailInfo> {
  Map<String, dynamic>? dataDetail;
  Map<String, dynamic>? dataSuhu;
  Map<String, dynamic>? dataCuaca;
  List<dynamic>? perkiraanCuaca;
  Map<String, dynamic>? dataHumadity;
  Map<String, dynamic>? windDirection;
  Map<String, dynamic>? windSpeed;

  Map<String, dynamic>? dataTemperature;
  Map<String, dynamic>? dataWeather;

  String? nama;
  String? detail;
  // final formattanggal = DateTime.
  var jam = DateTime.now().hour;
  // var jam = 23;

  final now = DateFormat("EEEE, d MMMM yy",
                                 "id_ID").format(DateTime.now());
  final besok = DateFormat("EEEE, d MMMM yy",
                                 "id_ID").format(DateTime.now().add(const Duration(days: 1)));
  final lusa = DateFormat("EEEE, d MMMM yy",
                                 "id_ID").format(DateTime.now().add(const Duration(days: 2)));

  @override
  void initState() {
    dataTemperature = widget.infoData[5];
    dataWeather = widget.infoData[6];

    dataDetail = widget.infoData[0];
    dataSuhu = widget.infoData[2];
    dataCuaca = widget.infoData[6];
    perkiraanCuaca = widget.infoData[5]['timerange'];
    dataHumadity = widget.infoData[0];
    windDirection = widget.infoData[7];
    windSpeed = widget.infoData[8];

    debugPrint(dataWeather!['timerange'][1].toString());

    super.initState();
  }

  Widget bottomInformation(h, w, start, last) {
    double widthCol = w / 4;
    double heightColumn = (h / 4) - 60;
    List<dynamic> hari = [
      "Pagi",
      "Siang",
      "Sore",
      "Malam",      
      "Pagi",
      "Siang",
      "Sore",
      "Malam",
      "Pagi",
      "Siang",
      "Sore",
      "Malam",
    ];

    final children = <Widget>[];
    for (int i = start; i <= last; i++) {
      children.add(Container(
        padding: const EdgeInsets.all(0),
        width: widthCol,
        height: heightColumn,
        child: Column(children: [
          Text(hari[i],
              style: const TextStyle(
                  color: Color.fromARGB(255, 1, 41, 2),
                  fontSize: 12,
                  fontFamily: 'WorkSans')),
          parserIconWheather(dataWeather!['timerange'][i]['value']['\$t'], 35),
          const SizedBox(height: 13),
          Text(
                    parserWheather(
                        dataWeather!['timerange'][i]['value']['\$t']),
                    style: const TextStyle(
                        fontFamily: 'WorkSans',
                        color: Color.fromARGB(255, 1, 41, 2),
                        fontSize: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  dataTemperature!['timerange'][i]['value'][0]['\$t']
                      .toString(),
                  style: const TextStyle(
                      fontFamily: 'WorkSans',
                      color: Color.fromARGB(255, 1, 41, 2))),
              const Icon(
                WeatherIcons.celsius,
                size: 14,
                color: Color.fromARGB(255, 1, 41, 2),
              )
            ],
          )
        ]),
      ));
    }

    return Row(
      children: children,
    );
  }

  Widget topInfo(h, w, index) {
    double widthCol = w / 2;
    double heightColumn = (h / 4) + 20;
    if(jam < 6){
      index = index;
    } else if (jam < 12){
      index = index + 1;
    } else if (jam < 18){
      index = index + 2;
    } else if (jam < 24){
      index = index + 3;
    }
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          width: widthCol,
          height: heightColumn,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                parserIconWheather(
                    dataWeather!['timerange'][index]['value']['\$t'].toString(),
                    78),
                const SizedBox(height: 25),
                Text(
                    parserWheather(
                        dataWeather!['timerange'][index]['value']['\$t']),
                    style: const TextStyle(
                        fontFamily: 'WorkSans',
                        color: Color.fromARGB(255, 1, 41, 2),
                        fontSize: 18)),
                Row(
                  children: [
                    Text(
                        dataTemperature!['timerange'][index]['value'][0]['\$t']
                            .toString(),
                        style: const TextStyle(
                            fontFamily: 'WorkSans',
                            color: Color.fromARGB(255, 1, 41, 2),
                            fontSize: 32)),
                    const Icon(WeatherIcons.celsius,
                        color: Color.fromARGB(255, 1, 41, 2), size: 28)
                  ],
                )
              ]),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          width: widthCol,
          height: heightColumn,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.headerInfo[0]['\$t'].toString(),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 22,
                      color: Color.fromARGB(255, 1, 41, 2)),
                ),
                Text("(${widget.headerInfo[1]['\$t']})",
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 14,
                        color: Color.fromARGB(255, 1, 41, 2))),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.water_drop,
                            color: Colors.blueAccent, size: 28),
                        const SizedBox(height: 8),
                        Text(
                            "${dataHumadity!['timerange'][index]['value']['\$t']}%",
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 1, 41, 2),
                                fontFamily: 'WorkSans')),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(WeatherIcons.strong_wind,
                            color: Colors.yellowAccent, size: 28),
                        const SizedBox(height: 8),
                        Text(
                            windSpeed!['timerange'][index]['value'][2]['\$t']
                                .toString(),
                            style: const TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 14,
                                color: Color.fromARGB(255, 1, 41, 2))),
                        Container(
                            margin: const EdgeInsets.all(0),
                            height: 20,
                            child: const Text("km/jam",
                                style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 1, 41, 2)))),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(WeatherIcons.wind,
                            color: Colors.yellowAccent, size: 28),
                        const SizedBox(height: 8),
                        Text(
                            windDirection!['timerange'][index]['value'][1]
                                    ['\$t']
                                .toString(),
                            style: const TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 14,
                                color: Color.fromARGB(255, 1, 41, 2))),
                        const SizedBox(height: 20),
                      ],
                    )
                  ],
                )
              ]),
        ),
      ],
    );
  }

  Widget bottomInfo(h, w, data) {
    double widthCol = w / 4;
    double heightColumn = (h / 4) - 60;

    Map<String, dynamic> cuacaPagi = data[1];
    Map<String, dynamic> cuacaSiang = data[2];
    Map<String, dynamic> cuacaSore = data[3];
    Map<String, dynamic> cuacaMalam = data[4];

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          width: widthCol,
          height: heightColumn,
          child: Column(children: [
            const Text("Pagi",
                style: TextStyle(
                    fontFamily: 'WorkSans',
                    color: Color.fromARGB(255, 1, 41, 2),
                    fontSize: 12)),
            parserIconWheather(
                dataWeather!['timerange'][1]['value']['\$t'], 35),
            const SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(cuacaPagi['value'][0]['\$t'].toString(),
                    style: const TextStyle(
                        fontFamily: 'WorkSans',
                        color: Color.fromARGB(255, 1, 41, 2))),
                const Icon(
                  WeatherIcons.celsius,
                  size: 14,
                  color: Color.fromARGB(255, 1, 41, 2),
                )
              ],
            )
          ]),
        ),
        Container(
          padding: const EdgeInsets.all(0),
          width: widthCol,
          height: heightColumn,
          child: Column(children: [
            const Text("Siang",
                style: TextStyle(
                    fontFamily: 'WorkSans',
                    color: Color.fromARGB(255, 1, 41, 2),
                    fontSize: 12)),
            parserIconWheather(
                dataWeather!['timerange'][2]['value']['\$t'], 35),
            const SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(cuacaSiang['value'][0]['\$t'].toString(),
                    style: const TextStyle(
                        fontFamily: 'WorkSans',
                        color: Color.fromARGB(255, 1, 41, 2))),
                const Icon(
                  WeatherIcons.celsius,
                  size: 14,
                  color: Color.fromARGB(255, 1, 41, 2),
                )
              ],
            )
          ]),
        ),
        Container(
          padding: const EdgeInsets.all(0),
          width: widthCol,
          height: heightColumn,
          child: Column(children: [
            const Text("Malam",
                style: TextStyle(
                    fontFamily: 'WorkSans',
                    color: Color.fromARGB(255, 1, 41, 2),
                    fontSize: 12)),
            parserIconWheather(
                dataWeather!['timerange'][3]['value']['\$t'], 35),
            const SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(cuacaSore['value'][0]['\$t'].toString(),
                    style: const TextStyle(
                        fontFamily: 'WorkSans',
                        color: Color.fromARGB(255, 1, 41, 2))),
                const Icon(
                  WeatherIcons.celsius,
                  size: 14,
                  color: Color.fromARGB(255, 1, 41, 2),
                )
              ],
            )
          ]),
        ),
        Container(
          padding: const EdgeInsets.all(0),
          width: widthCol,
          height: heightColumn,
          child: Column(children: [
            const Text("Dini Hari",
                style: TextStyle(
                    fontFamily: 'WorkSans',
                    color: Color.fromARGB(255, 1, 41, 2),
                    fontSize: 12)),
            parserIconWheather(
                dataWeather!['timerange'][4]['value']['\$t'], 35),
            const SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(cuacaMalam['value'][0]['\$t'].toString(),
                    style: const TextStyle(
                        fontFamily: 'WorkSans',
                        color: Color.fromARGB(255, 1, 41, 2))),
                const Icon(
                  WeatherIcons.celsius,
                  size: 14,
                  color: Color.fromARGB(255, 1, 41, 2),
                )
              ],
            )
          ]),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;
    Size screenSize = MediaQuery.of(context).size;

    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(38, 1, 41, 2),
          surfaceTintColor: Color.fromARGB(38, 1, 41, 2),
          // title: Text(widget.title),
          bottom: TabBar(
            labelStyle: TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 12,
            ),
            unselectedLabelColor: Color.fromARGB(255, 1, 41, 2),
            tabs: <Widget>[
              Tab(
                text: '$now'
              ),
              Tab(
                text: "$besok",
              ),
              Tab(
                text: "$lusa",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0x332C5A2E),
                  // image: DecorationImage(
                  //     image: AssetImage("assets/images/bg-2.jpg"),
                  //     fit: BoxFit.cover)
                ),
                padding: const EdgeInsets.only(top: 30),
                child: Stack(children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      height: screenSize.height * 2,
                      width: double.infinity,
                      child: Column(children: [
                        topInfo(heightScreen, widthScreen, 0),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          margin: const EdgeInsets.only(top:30),
                          height: 50,
                          alignment: Alignment.topLeft,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 0.8,
                                  color: Color.fromARGB(255, 1, 41, 2)),
                            ),
                          ),
                          child: const Text("Prakiraan Cuaca",
                              style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  color: Color.fromARGB(255, 1, 41, 2),
                                  fontSize: 14)),
                        ),
                        // bottomInfo(heightScreen, widthScreen, perkiraanCuaca),
                        bottomInformation(heightScreen, widthScreen, 0, 3)
                      ]),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        // color: Color.fromARGB(255, 1, 41, 2),
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.only(
                            top: 2.0, right: 8.0, bottom: 2.0, left: 8.0),
                        child: const Text(
                          "Sumber Data: BMKG",
                          style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontSize: 12,
                              color: Color.fromARGB(255, 1, 41, 2)),
                        )),
                  ),
                ]),
              ),
            ),
            Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0x332C5A2E),
                  // image: DecorationImage(
                  //     image: AssetImage("assets/images/bg-2.jpg"),
                  //     fit: BoxFit.cover)
                ),
                padding: const EdgeInsets.only(top: 30),
                child: Stack(children: [
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        height: screenSize.height * 2,
                        width: double.infinity,
                        child: Column(children: [
                          topInfo(heightScreen, widthScreen, 4),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            margin: const EdgeInsets.only(top:30),
                            height: 50,
                            alignment: Alignment.topLeft,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 0.8,
                                    color: Color.fromARGB(255, 1, 41, 2)),
                              ),
                            ),
                            child: const Text("Prakiraan Cuaca",
                                style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    color: Color.fromARGB(255, 1, 41, 2),
                                    fontSize: 14)),
                          ),
                          // bottomInfo(heightScreen, widthScreen, perkiraanCuaca),
                          bottomInformation(heightScreen, widthScreen, 4, 7)
                        ]),
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        // color: Color.fromARGB(255, 1, 41, 2),
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.only(
                            top: 2.0, right: 8.0, bottom: 2.0, left: 8.0),
                        child: const Text(
                          "Sumber Data: BMKG",
                          style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontSize: 12,
                              color: Color.fromARGB(255, 1, 41, 2)),
                        )),
                  ),
                ]),
              ),
            ),
            Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0x332C5A2E),
                  // image: DecorationImage(
                  //     image: AssetImage("assets/images/bg-2.jpg"),
                  //     fit: BoxFit.cover)
                ),
                padding: const EdgeInsets.only(top: 30),
                child: Stack(children: [
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        height: screenSize.height * 2,
                        width: double.infinity,
                        child: Column(children: [
                          topInfo(heightScreen, widthScreen, 8),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            margin: const EdgeInsets.only(top:30),
                            height: 50,
                            alignment: Alignment.topLeft,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 0.8,
                                    color: Color.fromARGB(255, 1, 41, 2)),
                              ),
                            ),
                            child: const Text("Prakiraan Cuaca",
                                style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    color: Color.fromARGB(255, 1, 41, 2),
                                    fontSize: 16)),
                          ),
                          // bottomInfo(heightScreen, widthScreen, perkiraanCuaca),
                          bottomInformation(heightScreen, widthScreen, 8, 11)
                        ]),
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        // color: Color.fromARGB(255, 1, 41, 2),
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.only(
                            top: 2.0, right: 8.0, bottom: 2.0, left: 8.0),
                        child: const Text(
                          "Sumber Data: BMKG",
                          style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontSize: 12,
                              color: Color.fromARGB(255, 1, 41, 2)),
                        )),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
