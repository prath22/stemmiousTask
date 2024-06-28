class ExpenceModal {
  int? id;
  String category;
  String description;
  double amount;
  String currDate;
  String currTime;
  String imgUrl;

  ExpenceModal({
    this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.currDate,
    required this.currTime,
    required this.imgUrl,
  });

  // convert the expense object to a map

  Map<String, dynamic> getExpenceMap() {
    return {
      "category": category,
      "description": description,
      "imgUrl": imgUrl,
      "date": currDate,
      "time": currTime,
      "amount": amount,
    };
  }

  String toString() {
    return "$category $description $imgUrl , $currDate , $currTime $amount";
  }
}
