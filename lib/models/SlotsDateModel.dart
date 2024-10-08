class SlotsDateModel {
  String? date;
  String? dayName;
  String? status;

  SlotsDateModel({this.date, this.dayName, this.status});

  SlotsDateModel.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    dayName = json['DayName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    data['DayName'] = this.dayName;
    data['status'] = this.status;
    return data;
  }
}