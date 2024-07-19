// import 'dart:developer';


import 'package:expense_tracker/databaseFile.dart';
import 'package:expense_tracker/myutilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Charts extends StatefulWidget {
  const Charts({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChartsState();
  }
}

List<Color> colorList = [
  const Color.fromRGBO(214, 3, 3, 0.7),
  const Color.fromRGBO(0, 148, 255, 0.7),
  const Color.fromRGBO(0, 174, 91, 0.7),
  const Color.fromRGBO(100, 62, 255, 0.7),
  const Color.fromRGBO(241, 38, 196, 0.7),
  const Color.fromARGB(176, 63, 226, 48),
];

dynamic database;
bool edit = false;

//Variable to hold total amount

double totalAmt = 0.0;
double foodTotal = 0.0;
double fuelTotal = 0.0;
double medicineTotal = 0.0;
double entertainmentTotal = 0.0;
double shoppingTotal = 0.0;
double otherTotal = 0.0;

// dataMap for storing category and its amount for pie chart
Map<String, double> dataMap = {
  "Food": foodTotal,
  "Fuel": fuelTotal,
  "Medicine": medicineTotal,
  "Entertainment": entertainmentTotal,
  "Shopping": shoppingTotal,
  "Others": otherTotal,
};

class _ChartsState extends State {
  Future<void> initiateDatabase() async {
    database = await initialiseDatabase();
    getExpenceTotal();

    foodTotal = await getTotalAmountForCategory('Food');
    fuelTotal = await getTotalAmountForCategory('Fuel');
    medicineTotal = await getTotalAmountForCategory('Medicine');
    entertainmentTotal = await getTotalAmountForCategory('Entertainment');
    shoppingTotal = await getTotalAmountForCategory('Shopping');
    otherTotal = await getTotalAmountForCategory('Others');

    fetchDataMap();
  }

// It get total amount Spent on each category
  Future<double> getTotalAmountForCategory(String category) async {
    Database db = await database;
    var result = await db.rawQuery('''
      SELECT SUM(amount) as total
      FROM expences
      WHERE category = ?
    ''', [category]);

    double total = result.first['total'] as double? ?? 0.0;
    return total;
  }


// get total amount on all Categories
  Future<void> getExpenceTotal() async {
    final localDb = await database;

    var res =
        await localDb.rawQuery('SELECT SUM(amount) as total FROM expences');

    totalAmt = res.first['total'] as double? ?? 0.0;
    setState(() {});
  }

// update the dataMAp With Total for each Category
  void fetchDataMap() {
    dataMap = {
      "Food": foodTotal,
      "Fuel": fuelTotal,
      "Medicine": medicineTotal,
      "Entertainment": entertainmentTotal,
      "Shopping": shoppingTotal,
      "Others": otherTotal,
    };
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initiateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Graphs",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color.fromRGBO(33, 33, 33, 1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.70),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              PieChart(
                animationDuration: const Duration(milliseconds: 2000),
                chartType: ChartType.ring,
                dataMap: dataMap,
                colorList: colorList,
                chartRadius: 150,
                ringStrokeWidth: 25,
                centerWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total",
                      style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(0, 0, 0, 1)),
                    ),
                    Text(
                      "$totalAmt",
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(0, 0, 0, 1)),
                    )
                  ],
                ),
                chartValuesOptions:
                    const ChartValuesOptions(showChartValues: false),
                legendOptions: LegendOptions(
                    legendPosition: LegendPosition.right,
                    legendShape: BoxShape.circle,
                    showLegends: true,
                    legendTextStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(),
              const SizedBox(
                height: 20,
              ),
              ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: colorList[0]),
                            child:
                                SvgPicture.asset("assets/SVGImages/food.svg"),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Food",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "\u20B9 $foodTotal",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: colorList[1]),
                            child:
                                SvgPicture.asset("assets/SVGImages/petrol.svg"),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Fuel",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "\u20B9 $fuelTotal",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: colorList[2]),
                            child: SvgPicture.asset(
                                "assets/SVGImages/medicine.svg"),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Medicine",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "\u20B9 $medicineTotal",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: colorList[3]),
                            child:
                                SvgPicture.asset("assets/SVGImages/movie.svg"),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Entertainment",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "\u20B9 $entertainmentTotal",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: colorList[4]),
                            child: SvgPicture.asset(
                                "assets/SVGImages/shopping.svg"),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Shopping",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "\u20B9 $shoppingTotal",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: colorList[2]),
                            child:
                                SvgPicture.asset("assets/SVGImages/dummy.svg"),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Others",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "\u20B9 $otherTotal",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                        Text(
                          "\u20B9 $totalAmt",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromRGBO(0, 0, 0, 1),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}
