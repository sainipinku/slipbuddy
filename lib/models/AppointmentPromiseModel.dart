class AppointmentPromiseModel {
  int? iD;
  String? heading;
  String? description;

  AppointmentPromiseModel({this.iD, this.heading, this.description});

  AppointmentPromiseModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    heading = json['Heading'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Heading'] = this.heading;
    data['Description'] = this.description;
    return data;
  }
}