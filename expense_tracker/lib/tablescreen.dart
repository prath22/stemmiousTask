import 'dart:developer';

import 'package:flutter/material.dart';
import 'databaseFile.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:google_fonts/google_fonts.dart';

import 'expence_modal.dart';
import 'myutilities.dart';

class Tabelscreen extends StatefulWidget {
  const Tabelscreen({super.key});

  @override
  State<Tabelscreen> createState() => _TabelscreenState();
}

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

class _TabelscreenState extends State<Tabelscreen> {
  Database? database;

  Future<void> initiateDatabase() async {
    database = await initialiseDatabase();
    await fetchInitialValues();
    log('Database initialized');
  }

  Future<void> fetchInitialValues() async {
    expenceList = await fetchExpenceData();
    setState(() {});
  }

  Future<List<ExpenceModal>> fetchExpenceData() async {
    final localDb = database;
    if (localDb == null) {
      return [];
    }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaction Table',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color.fromRGBO(33, 33, 33, 1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            border: TableBorder.all(),
            columnSpacing: 16.0, // Reduce spacing between columns
            horizontalMargin: 8.0, // Reduce horizontal margin
            dataRowMinHeight: 40.0,
            headingRowColor: WidgetStateColor.resolveWith(
                (states) => Color.fromARGB(255, 50, 220, 164)),
            headingTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            columns: const [
              DataColumn(
                  label: Text(
                'Item Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                'Category',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                'Price',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                'Date',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                'Time',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ],
            rows: expenceList.map((transaction) {
              return DataRow(
                cells: [
                  DataCell(Text(transaction.description)),
                  DataCell(Text(transaction.category)),
                  DataCell(Text(transaction.amount.toString())),
                  DataCell(Text(transaction.currDate)),
                  DataCell(Text(transaction.currTime)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}
