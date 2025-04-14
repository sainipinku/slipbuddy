class BannerModel {
  int? iD;
  String? path;

  BannerModel({this.iD, this.path});

  BannerModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    path = json['Path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Path'] = this.path;
    return data;
  }
}