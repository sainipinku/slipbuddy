class AppointmentModel {
  int? id;
  int? srNo;
  String? status;
  String? patientName;
  String? age;
  String? oPDNumber;
  String? consultantDoctor;
  String? HospitalName;
  String? action;
  String? hospitalName;
  String? hospitalEmail;
  String? hospitalMobile;
  String? drName;
  String? drPic;
  String? hospitalAddress;
  String? appointmentDate;
  String? timeSlot;
  String? department;
  String? TokenNo;

  AppointmentModel(
      {this.id,
        this.srNo,
        this.status,
        this.patientName,
        this.age,
        this.oPDNumber,
        this.consultantDoctor,
        this.HospitalName,
        this.action,
        this.hospitalName,
        this.hospitalEmail,
        this.hospitalMobile,
        this.drName,
        this.drPic,
        this.hospitalAddress,
        this.appointmentDate,
        this.timeSlot,
        this.department,this.TokenNo});

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    srNo = json['SrNo'];
    status = json['Status'];
    patientName = json['PatientName'];
    age = json['Age'];
    oPDNumber = json['oPDNumber'];
    consultantDoctor = json['ConsultantDoctor'];
    HospitalName = json['HospitalName'];
    action = json['Action'];
    hospitalName = json['Hospital_Name'];
    hospitalEmail = json['Hospital_Email'];
    hospitalMobile = json['Hospital_Mobile'];
    drName = json['Dr_Name'];
    drPic = json['Dr_Pic'];
    hospitalAddress = json['Hospital_Address'];
    appointmentDate = json['AppointmentDate'] ?? '4/7/2025 12:00:00 AM';
    timeSlot = json['TimeSlot'] ?? '12:30:00';
    department = json['Department'];
    TokenNo = json['TokenNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['SrNo'] = this.srNo;
    data['Status'] = this.status;
    data['PatientName'] = this.patientName;
    data['Age'] = this.age;
    data['oPDNumber'] = this.oPDNumber;
    data['ConsultantDoctor'] = this.consultantDoctor;
    data['HospitalName'] = this.HospitalName;
    data['Action'] = this.action;
    data['Hospital_Name'] = this.hospitalName;
    data['Hospital_Email'] = this.hospitalEmail;
    data['Hospital_Mobile'] = this.hospitalMobile;
    data['Dr_Name'] = this.drName;
    data['Dr_Pic'] = this.drPic;
    data['Hospital_Address'] = this.hospitalAddress;
    data['AppointmentDate'] = this.appointmentDate;
    data['TimeSlot'] = this.timeSlot;
    data['Department'] = this.department;
    data['TokenNo'] = this.TokenNo;
    return data;
  }
}