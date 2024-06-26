import 'package:expense_manager/databaseFile.dart';
import 'package:expense_manager/expence_modal.dart';
import 'package:expense_manager/graph_model.dart';
import 'package:expense_manager/myutilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

int flg = 0;

List<ExpenceModal> expenceList = [
  ExpenceModal(
    category: "Medicine",
    description: "painkillers",
    amount: 0,
    currDate: "24 June",
    currTime: "1:00 PM",
    imgUrl: "assets/SVGImages/medicine.svg",
  ),
];

//for selected option in dropdown

String? _selectedItem;

//For managing current dated and time
DateTime currDate = DateTime.now();
String currMonth = DateFormat.MMMM().format(currDate);
String currYear = currDate.year.toString();

class _HomePageState extends State {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  dynamic database;

  Future<void> initiateDatabase() async {
    database = await initialiseDatabase();
    await fetchInitialValues();
  }

  Future<void> fetchInitialValues() async {
    expenceList = await fetchExpenceData();
    setState(() {});
  }

  Future<void> insertExpenceData(ExpenceModal obj) async {
    final localDB = await database;

    localDB.insert(
      "Expences",
      obj.getExpenceMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteExpenceData(ExpenceModal obj) async {
    final localDb = await database;

    localDb.delete(
      "Expences",
      where: "id = ?",
      whereArgs: [obj.id],
    );
  }

  Future<List<ExpenceModal>> fetchExpenceData() async {
    final localDb = await database;

    List<Map<String, dynamic>> mapEntry = await localDb.query(
      "Expences",
    );

    return List.generate(mapEntry.length, (i) {
      return ExpenceModal(
          id: mapEntry[i]["id"],
          category: mapEntry[i]["category"],
          description: mapEntry[i]["description"],
          imgUrl: mapEntry[i]['imgUrl'],
          currDate: mapEntry[i]["date"],
          currTime: mapEntry[i]["time"],
          amount: mapEntry[i]['amount']);
    });
  }

  @override
  void initState() {
    super.initState();
    initiateDatabase();
  }

  Future<void> bottomSheet() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              top: 30,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: main,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Amount",
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w400)),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Container(
                    width: 316,
                    height: 36,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: TextFormField(
                      controller: _amountController,
                      // maxLines: 1,
                      decoration: InputDecoration(
                        // label: const Text("900"),
                        hintText: "0.0",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(107, 112, 92, 1),
                          ),
                        ),
                        hintStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 0, 0, 0.8)),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Category",
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w400)),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Container(
                    width: 316,
                    height: 36,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: DropdownButton<String>(
                      value: _selectedItem,
                      hint: Text("Select Category"),
                      items: Provider.of<GraphModel>(context)
                          .categoryMap
                          .keys
                          .map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedItem = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Description",
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w400)),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Container(
                    width: 316,
                    height: 36,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        // label: const Text("900"),
                        hintText: "Enter description ",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(107, 112, 92, 1),
                          ),
                        ),
                        hintStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 0, 0, 0.8)),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      addExpence(
                        category: _selectedItem!,
                        descritpion: _descriptionController.text,
                        amount: double.parse(_amountController.text),
                      );
                      setState(
                          () {}); //kept teporary can be replaced with state management
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(4, 161, 125, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      height: 49,
                      child: Center(
                        child: Text(
                          "Add",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          );
        });
  }

  void addExpence({
    required String category,
    required String descritpion,
    required double amount,
  }) async {
    //For managing current dated and time
    DateTime currDate = DateTime.now();
    String currMonth = DateFormat.MMMM().format(currDate);

    final timeOfDay = TimeOfDay.fromDateTime(currDate);
    final amPM = timeOfDay.period == DayPeriod.am ? "AM" : "PM";

    ExpenceModal tmpObj = ExpenceModal(
        category: category,
        description: descritpion,
        amount: amount,
        currDate: "${currDate.day} $currMonth",
        currTime: "${currDate.hour % 12}:${currDate.minute} $amPM",
        imgUrl: "assets/SVGImages/movie.svg");

    await insertExpenceData(tmpObj);

    expenceList = await fetchExpenceData();

    _selectedItem = null;
    _descriptionController.clear();
    _amountController.clear();
    setState(() {});
  }

  void deleteTransaction(ExpenceModal obj) async {
    await deleteExpenceData(obj);

    expenceList = await fetchExpenceData();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    DateTime currDate = DateTime.now();
    String currMonth = DateFormat.MMMM().format(currDate);
    String currYear = currDate.year.toString();

    return Scaffold(
      appBar: AppBar(
        actions: const [
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.search_outlined))
        ],
        title: Text(
          "$currMonth $currYear",
          style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(33, 33, 33, 1)),
        ),
      ),
      body: ListView.builder(
        itemCount: expenceList.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Color.fromRGBO(206, 206, 206, 0.5), width: 1.4),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(0, 174, 91, 0.7)),
                      child: SvgPicture.asset(expenceList[index].imgUrl),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expenceList[index].category,
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromRGBO(0, 0, 0, 1)),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            expenceList[index].description,
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromRGBO(0, 0, 0, 1)),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                deleteTransaction(expenceList[index]);
                              },
                              child: const Icon(
                                Icons.remove_circle,
                                color: Color.fromRGBO(246, 113, 49, 1),
                                size: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${expenceList[index].amount}",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromRGBO(0, 0, 0, 1)),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${expenceList[index].currDate} | ${expenceList[index].currTime}",
                      style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(0, 0, 0, 0.6)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await bottomSheet();
        },
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(67))),
        label: Container(
          child: Row(
            children: [
              const Icon(
                Icons.add_circle,
                color: Color.fromRGBO(14, 161, 125, 1),
                size: 32,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Add Transaction",
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(37, 37, 37, 1)),
              ),
            ],
          ),
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}
