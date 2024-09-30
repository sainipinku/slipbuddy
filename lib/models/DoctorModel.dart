class DoctorModel {
  int? id;
  int? srNo;
  String? mobile;
  String? fullName;
  String? gender;
  String? officeMibile;
  String? email;
  int? departMentID;
  String? qualification;
  String? hospitalName;
  String? experience;
  String? fees;
  String? profilePic;
  String? location;

  DoctorModel(
      {this.id,
        this.srNo,
        this.mobile,
        this.fullName,
        this.gender,
        this.officeMibile,
        this.email,
        this.departMentID,
        this.qualification,
        this.hospitalName,
        this.experience,
        this.fees,
        this.profilePic,
        this.location});

  DoctorModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    srNo = json['SrNo'];
    mobile = json['Mobile'];
    fullName = json['FullName'];
    gender = json['Gender'];
    officeMibile = json['OfficeMibile'];
    email = json['Email'];
    departMentID = json['DepartMentID'];
    qualification = json['Qualification'];
    hospitalName = json['HospitalName'];
    experience = json['Experience'];
    fees = json['fees'];
    profilePic = json['ProfilePic'];
    location = json['Location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['SrNo'] = this.srNo;
    data['Mobile'] = this.mobile;
    data['FullName'] = this.fullName;
    data['Gender'] = this.gender;
    data['OfficeMibile'] = this.officeMibile;
    data['Email'] = this.email;
    data['DepartMentID'] = this.departMentID;
    data['Qualification'] = this.qualification;
    data['HospitalName'] = this.hospitalName;
    data['Experience'] = this.experience;
    data['fees'] = this.fees;
    data['ProfilePic'] = this.profilePic;
    data['Location'] = this.location;
    return data;
  }
}