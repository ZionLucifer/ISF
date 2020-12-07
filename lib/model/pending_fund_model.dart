class PendingFundModel {
  String id;
  String fieldOfficerId;
  String fundRequestId;
  String farmId;
  String mobile;
  String investerId;
  String purpose;
  String amount;
  String requestTimestamp;
  String approvedStatus;
  String approvedBy;
  String approvedTimestamp;

  PendingFundModel(
      {this.id,
      this.fieldOfficerId,
      this.fundRequestId,
      this.farmId,
      this.mobile,
      this.investerId,
      this.purpose,
      this.amount,
      this.requestTimestamp,
      this.approvedStatus,
      this.approvedBy,
      this.approvedTimestamp});

  PendingFundModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fieldOfficerId = json['field_officer_id'];
    fundRequestId = json['fund_request_id'];
    farmId = json['farm_id'];
    mobile = json['mobile'];
    investerId = json['invester_id'];
    purpose = json['purpose'];
    amount = json['amount'];
    requestTimestamp = json['request_timestamp'];
    approvedStatus = json['approved_status'];
    approvedBy = json['approved_by'];
    approvedTimestamp = json['approved_timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['field_officer_id'] = this.fieldOfficerId;
    data['fund_request_id'] = this.fundRequestId;
    data['farm_id'] = this.farmId;
    data['mobile'] = this.mobile;
    data['invester_id'] = this.investerId;
    data['purpose'] = this.purpose;
    data['amount'] = this.amount;
    data['request_timestamp'] = this.requestTimestamp;
    data['approved_status'] = this.approvedStatus;
    data['approved_by'] = this.approvedBy;
    data['approved_timestamp'] = this.approvedTimestamp;
    return data;
  }
}
