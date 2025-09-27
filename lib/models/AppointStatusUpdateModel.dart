class AppointStatusUpdateModel {
  bool? status;
  int? errorCode;
  String? message;
  bool? isRedirect;
  bool? isPost;

  AppointStatusUpdateModel(
      {this.status,
        this.errorCode,
        this.message,
        this.isRedirect,
        this.isPost});

  AppointStatusUpdateModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    errorCode = json['ErrorCode'];
    message = json['Message'];
    isRedirect = json['isRedirect'];
    isPost = json['IsPost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['ErrorCode'] = this.errorCode;
    data['Message'] = this.message;
    data['isRedirect'] = this.isRedirect;
    data['IsPost'] = this.isPost;
    return data;
  }
}
