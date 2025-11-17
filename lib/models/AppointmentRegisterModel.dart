class AppointmentRegisterModel {
  bool? status;
  int? errorCode;
  String? message;
  bool? isRedirect;
  bool? isPost;
  String? orderNo;

  AppointmentRegisterModel(
      {this.status,
        this.errorCode,
        this.message,
        this.isRedirect,
        this.isPost,
        this.orderNo});

  AppointmentRegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    errorCode = json['ErrorCode'];
    message = json['Message'];
    isRedirect = json['isRedirect'];
    isPost = json['IsPost'];
    orderNo = json['OrderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['ErrorCode'] = this.errorCode;
    data['Message'] = this.message;
    data['isRedirect'] = this.isRedirect;
    data['IsPost'] = this.isPost;
    data['OrderNo'] = this.orderNo;
    return data;
  }
}