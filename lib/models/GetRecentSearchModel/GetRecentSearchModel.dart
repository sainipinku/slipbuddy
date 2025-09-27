class GetRecentSearchModel {
  int? searchId;
  int? msrno;
  String? searchText;
  double? latitude;
  double? longitude;
  String? searchedAt;

  GetRecentSearchModel(
      {this.searchId,
        this.msrno,
        this.searchText,
        this.latitude,
        this.longitude,
        this.searchedAt});

  GetRecentSearchModel.fromJson(Map<String, dynamic> json) {
    searchId = json['SearchId'];
    msrno = json['Msrno'];
    searchText = json['SearchText'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    searchedAt = json['SearchedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SearchId'] = this.searchId;
    data['Msrno'] = this.msrno;
    data['SearchText'] = this.searchText;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['SearchedAt'] = this.searchedAt;
    return data;
  }
}