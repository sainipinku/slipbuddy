class SlotsModel {
  String? date;
  String? dayName;
  String? slotTime;
  String? period;

  SlotsModel({this.date, this.dayName, this.slotTime, this.period});

  SlotsModel.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    dayName = json['DayName'];
    slotTime = json['SlotTime'];
    period = json['Period'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    data['DayName'] = this.dayName;
    data['SlotTime'] = this.slotTime;
    data['Period'] = this.period;
    return data;
  }
}