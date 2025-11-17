class GetLocationModel {
  int? addressId;
  int? msrno;
  String? addressType;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? country;
  String? pincode;
  double? latitude;
  double? longitude;
  bool? isDefault;
  String? createdAt;

  GetLocationModel(
      {this.addressId,
        this.msrno,
        this.addressType,
        this.addressLine1,
        this.addressLine2,
        this.city,
        this.state,
        this.country,
        this.pincode,
        this.latitude,
        this.longitude,
        this.isDefault,
        this.createdAt});

  GetLocationModel.fromJson(Map<String, dynamic> json) {
    addressId = json['AddressId'];
    msrno = json['Msrno'];
    addressType = json['AddressType'];
    addressLine1 = json['AddressLine1'];
    addressLine2 = json['AddressLine2'];
    city = json['City'];
    state = json['State'];
    country = json['Country'];
    pincode = json['Pincode'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    isDefault = json['IsDefault'];
    createdAt = json['CreatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AddressId'] = this.addressId;
    data['Msrno'] = this.msrno;
    data['AddressType'] = this.addressType;
    data['AddressLine1'] = this.addressLine1;
    data['AddressLine2'] = this.addressLine2;
    data['City'] = this.city;
    data['State'] = this.state;
    data['Country'] = this.country;
    data['Pincode'] = this.pincode;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['IsDefault'] = this.isDefault;
    data['CreatedAt'] = this.createdAt;
    return data;
  }
}