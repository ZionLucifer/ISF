import 'dart:convert';

class FOOverview {
  String fundRequestId;
  String total;
  String availableBalance;
  String purpose;
  String approvedStatus;
  String createdOn;
  String approvedOn;

  FOOverview(
      {this.fundRequestId,
      this.total,
      this.availableBalance,
      this.purpose,
      this.approvedStatus,
      this.createdOn,
      this.approvedOn});

  FOOverview.fromJson(Map<String, dynamic> json) {
    fundRequestId = json['fund_request_id'];
    total = json['total'];
    availableBalance = json['available_balance'];
    purpose = json['purpose'];
    approvedStatus = json['approved_status'];
    createdOn = json['created_on'];
    approvedOn = json['approved_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fund_request_id'] = this.fundRequestId;
    data['total'] = this.total;
    data['available_balance'] = this.availableBalance;
    data['purpose'] = this.purpose;
    data['approved_status'] = this.approvedStatus;
    data['created_on'] = this.createdOn;
    data['approved_on'] = this.approvedOn;
    return data;
  }
}

class ExpenceList {
  String id;
  String purpose;
  String amount;
  ExpenceList({this.id, this.purpose, this.amount});

  factory ExpenceList.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ExpenceList(
      id: map['fund_request_id'],
      purpose: map['purpose'],
      amount: map['subtot'],
    );
  }
  factory ExpenceList.fromJson(String source) =>
      ExpenceList.fromMap(json.decode(source));
}

class FarmDetails {
  String farmname;
  String cropname;
  String activitycompleted;
  String actinprogress;
  String lastdate;
  String totalexpence;
  String farmstatus;
  FarmDetails({
    this.farmname,
    this.cropname,
    this.activitycompleted,
    this.actinprogress,
    this.lastdate,
    this.totalexpence,
    this.farmstatus,
  });


  factory FarmDetails.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return FarmDetails(
      farmname: map['farmer_name'],
      cropname: map['crops_name'],
      activitycompleted: map['activities_completed'],
      actinprogress: map['activities_inprogress'],
      lastdate: map['activity_last_date'],
      totalexpence: map['total_expense'],
      farmstatus: map['farming_status'],
    );
  }
}
