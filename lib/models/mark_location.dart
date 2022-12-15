class MarkLocationModel {
  List<MarkLocation> markLocation;

  MarkLocationModel({this.markLocation});

  // MarkLocation.fromJson(Map<String, dynamic> json) {
  //   responseMessege = json['responseMessege'] != null
  //       ? new ResponseMessege.fromJson(json['responseMessege'])
  //       : null;
  //   if (json['MarkLocation'] != null) {
  //     markLocation = <MarkLocation>[];
  //     json['MarkLocation'].forEach((v) {
  //       markLocation!.add(new MarkLocation.fromJson(v));
  //     });
  //   }
  // }

  factory MarkLocationModel.fromJson(Map<String, dynamic> json) => MarkLocationModel(
    // markLocation: List<dynamic>.from(json["MarkLocation"].map((x) => x)),
    markLocation: List<MarkLocation>.from(json["MarkLocation"].map((x) => MarkLocation.fromJson(x))),
  );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //
  //   if (this.markLocation != null) {
  //     data['MarkLocation'] = this.markLocation!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }

  Map<String, dynamic> toJson() => {
    "MarkLocation": List<dynamic>.from(markLocation.map((x) => x)),
  };
}



class MarkLocation {
  String containerNo;
  String locationID;
  String locationName;
  String userName;

  MarkLocation(
      {this.containerNo, this.locationID, this.locationName, this.userName});

  // MarkLocation.fromJson(Map<String, dynamic> json) {
  //   containerNo = json['ContainerNo'];
  //   locationID = json['LocationID'];
  //   locationName = json['LocationName'];
  //   userName = json['UserName'];
  // }

  factory MarkLocation.fromJson(Map<String, dynamic> json) => MarkLocation(
    containerNo: json["ContainerNo"],
    locationID: json["LocationID"],
    locationName: json["LocationName"],
    userName: json["UserName"],
  );


  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['ContainerNo'] = containerNo;
  //   data['LocationID'] = locationID;
  //   data['LocationName'] = locationName;
  //   data['UserName'] = userName;
  //   return data;
  // }
  //
  // Map<String, dynamic> toJson() => {
  //   "SrNo": srNo,
  //   "Name": name,
  //   "Debit": debit,
  //   "Credit": credit,
  //   "Pending": pending,
  // };
}
