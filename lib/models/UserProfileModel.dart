class UserProfileModel {
  int? msrNo;
  int? userId;
  String? name;
  String? email;
  String? mobile;
  String? fullAddress;
  String? city;
  int? age;
  String? status;
  String? dob;
  String? gender;
  String? image;

  UserProfileModel({
    this.msrNo,
    this.userId,
    this.name,
    this.email,
    this.mobile,
    this.fullAddress,
    this.city,
    this.age,
    this.status,
    this.dob,
    this.gender,
    this.image,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      msrNo: json['MsrNo'],
      userId: json['UserId'],
      name: json['Name'],
      email: json['Email'],
      mobile: json['Mobile'],
      fullAddress: json['FullAddress'],
      city: json['City'],
      age: json['Age'],
      status: json['Status'],
      dob: json['DOB'],
      gender: json['Gender'],
      image: json['Image'],
    );
  }
}
