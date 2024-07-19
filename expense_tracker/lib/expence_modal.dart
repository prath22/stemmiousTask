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

  //update the property of expense object with new val

  void update({
    String? category,
    String? description,
    double? amount,
    String? currDate,
    String? currTime,
    String? imgUrl,

  }){

    if(category != null) this.category=category;
    if(description != null) this.description=description;
    if(amount != null) this.amount=amount;
    if(currDate != null) this.currDate=currDate;
    if(currTime != null) this.currTime=currTime;
    if(imgUrl != null) this.imgUrl=imgUrl;
  }

  //it convert expense obj to string representation.

  String toString() {
    return "$category $description $imgUrl , $currDate , $currTime $amount";
  }
}
