class AppointmentModel {
  int? id;
  int? srNo;
  String? patientName;
  String? age;
  String? oPDNumber;
  String? consultantDoctor;
  String? hospitalName;
  String? action;
  String? hospitalEmail;
  String? hospitalMobile;
  String? drName;
  String? hospitalAddress;
  String? appointmentDate;
  String? timeSlot;
  String? department;

  AppointmentModel(
      {this.id,
        this.srNo,
        this.patientName,
        this.age,
        this.oPDNumber,
        this.consultantDoctor,
        this.hospitalName,
        this.action,
        this.hospitalEmail,
        this.hospitalMobile,
        this.drName,
        this.hospitalAddress,
        this.appointmentDate,
        this.timeSlot,
        this.department});

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    srNo = json['SrNo'];
    patientName = json['PatientName'];
    age = json['Age'];
    oPDNumber = json['oPDNumber'];
    consultantDoctor = json['ConsultantDoctor'];
    hospitalName = json['HospitalName'];
    action = json['Action'];
    hospitalEmail = json['Hospital_Email'];
    hospitalMobile = json['Hospital_Mobile'];
    drName = json['Dr_Name'];
    hospitalAddress = json['Hospital_Address'];
    appointmentDate = json['AppointmentDate'];
    timeSlot = json['TimeSlot'];
    department = json['Department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['SrNo'] = this.srNo;
    data['PatientName'] = this.patientName;
    data['Age'] = this.age;
    data['oPDNumber'] = this.oPDNumber;
    data['ConsultantDoctor'] = this.consultantDoctor;
    data['Action'] = this.action;
    data['Hospital_Name'] = this.hospitalName;
    data['Hospital_Email'] = this.hospitalEmail;
    data['Hospital_Mobile'] = this.hospitalMobile;
    data['Dr_Name'] = this.drName;
    data['Hospital_Address'] = this.hospitalAddress;
    data['AppointmentDate'] = this.appointmentDate;
    data['TimeSlot'] = this.timeSlot;
    data['Department'] = this.department;
    return data;
  }
}