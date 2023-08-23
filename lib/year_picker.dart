import 'package:flutter/material.dart';

class YearPickerScreen extends StatefulWidget {
  const YearPickerScreen({super.key});

  @override
  State<YearPickerScreen> createState() => _YearPickerScreenState();
}

class _YearPickerScreenState extends State<YearPickerScreen> {
  String showYear = 'Select Year';
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
              firstDate: DateTime(DateTime.now().year - 10, 1),
              // lastDate: DateTime.now(),
              lastDate: DateTime(2025),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Year Picker Example"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
            ),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  showYear,
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
          ElevatedButton(
              onPressed: () {
                if (showYear != "Select Year") {
                  print("Selected year $showYear");
                } else {
                  print("Did not select a year");
                }
              },
              child: const Text("Submit"))
        ]),
      ),
    );
  }
}
