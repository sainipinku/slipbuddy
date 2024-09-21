class DepartmentListModel {
  int? iD;
  String? deptName;
  int? deptCode;
  String? icon;

  DepartmentListModel({this.iD, this.deptName, this.deptCode, this.icon});

  DepartmentListModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    deptName = json['DeptName'];
    deptCode = json['DeptCode'];
    icon = json['Icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['DeptName'] = this.deptName;
    data['DeptCode'] = this.deptCode;
    data['Icon'] = this.icon;
    return data;
  }
}
