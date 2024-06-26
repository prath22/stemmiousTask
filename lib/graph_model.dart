import 'package:flutter/material.dart';

class GraphModel extends ChangeNotifier {
  double total;

  Map<String, CategoryModal> categoryMap = {
    "Food": CategoryModal(amount: 0, imgUrl: ""),
    "Fuel": CategoryModal(amount: 0, imgUrl: ""),
    "Medicine": CategoryModal(amount: 0, imgUrl: ""),
    "Entertainment": CategoryModal(amount: 0, imgUrl: ""),
    "Shopping": CategoryModal(amount: 0, imgUrl: ""),
  };

  GraphModel({required this.total});

  List<Map<String, dynamic>> getGraphMap() {
    List<Map<String, dynamic>> graphData = [];
    categoryMap.forEach((category, modal) {
      graphData.add({
        "category": category,
        "imgUrl": modal.imgUrl,
        "amount": modal.amount,
      });
    });
    return graphData;
  }
}

class CategoryModal {
  double amount;
  String imgUrl;

  CategoryModal({required this.amount, required this.imgUrl});

  String toString() {
    return "$amount";
  }
}
