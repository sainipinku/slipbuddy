class DoctorScheduleDetailsModel {
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
  int? hospitalID;
  String? nextAvailable;
  String? ranking;
  String? thumsup;
  String? noOfStories;
  String? description;
  int? isCoupenAvailable;
  int? coupenAmount;
  String? promiseHeading;
  String? promiseText1;
  String? promiseText2;
  String? promiseText3;
  String? promiseText4;
  String? safty1;
  String? safty2;
  String? safty3;
  String? safty4;

  DoctorScheduleDetailsModel(
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
        this.location,
        this.hospitalID,
        this.nextAvailable,
        this.ranking,
        this.thumsup,
        this.noOfStories,
        this.description,
        this.isCoupenAvailable,
        this.coupenAmount,
        this.promiseHeading,
        this.promiseText1,
        this.promiseText2,
        this.promiseText3,
        this.promiseText4,
        this.safty1,
        this.safty2,
        this.safty3,
        this.safty4});

  DoctorScheduleDetailsModel.fromJson(Map<String, dynamic> json) {
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
    hospitalID = json['HospitalID'];
    nextAvailable = json['NextAvailable'];
    ranking = json['Ranking'];
    thumsup = json['Thumsup'];
    noOfStories = json['NoOfStories'];
    description = json['Description'];
    isCoupenAvailable = json['IsCoupenAvailable'];
    coupenAmount = json['CoupenAmount'];
    promiseHeading = json['PromiseHeading'];
    promiseText1 = json['PromiseText1'];
    promiseText2 = json['PromiseText2'];
    promiseText3 = json['PromiseText3'];
    promiseText4 = json['PromiseText4'];
    safty1 = json['Safty1'];
    safty2 = json['Safty2'];
    safty3 = json['Safty3'];
    safty4 = json['Safty4'];
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
    data['HospitalID'] = this.hospitalID;
    data['NextAvailable'] = this.nextAvailable;
    data['Ranking'] = this.ranking;
    data['Thumsup'] = this.thumsup;
    data['NoOfStories'] = this.noOfStories;
    data['Description'] = this.description;
    data['IsCoupenAvailable'] = this.isCoupenAvailable;
    data['CoupenAmount'] = this.coupenAmount;
    data['PromiseHeading'] = this.promiseHeading;
    data['PromiseText1'] = this.promiseText1;
    data['PromiseText2'] = this.promiseText2;
    data['PromiseText3'] = this.promiseText3;
    data['PromiseText4'] = this.promiseText4;
    data['Safty1'] = this.safty1;
    data['Safty2'] = this.safty2;
    data['Safty3'] = this.safty3;
    data['Safty4'] = this.safty4;
    return data;
  }
}