class ExpenseList {
  String id;
  String fieldOfficerId;
  String fundRequestId;
  String farmExpenseId;
  String farmId;
  String mobile;
  String purpose;
  String amount;
  String noofunits;
  String unitcost;
  String subtot;
  String particulars;
  String attachBill;
  String signature;
  String requestTimestamp;
  String approvedStatus;
  String approvedBy;
  String approvedTimestamp;

  ExpenseList(
      {this.id,
      this.fieldOfficerId,
      this.fundRequestId,
      this.farmExpenseId,
      this.farmId,
      this.mobile,
      this.purpose,
      this.amount,
      this.noofunits,
      this.unitcost,
      this.subtot,
      this.particulars,
      this.attachBill,
      this.signature,
      this.requestTimestamp,
      this.approvedStatus,
      this.approvedBy,
      this.approvedTimestamp});

  ExpenseList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fieldOfficerId = json['field_officer_id'];
    fundRequestId = json['fund_request_id'];
    farmExpenseId = json['farm_expense_id'];
    farmId = json['farm_id'];
    mobile = json['mobile'];
    purpose = json['purpose'];
    amount = json['amount'];
    noofunits = json['noofunits'];
    unitcost = json['unitcost'];
    subtot = json['subtot'];
    particulars = json['particulars'];
    attachBill = json['attach_bill'];
    signature = json['signature'];
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
    data['farm_expense_id'] = this.farmExpenseId;
    data['farm_id'] = this.farmId;
    data['mobile'] = this.mobile;
    data['purpose'] = this.purpose;
    data['amount'] = this.amount;
    data['noofunits'] = this.noofunits;
    data['unitcost'] = this.unitcost;
    data['subtot'] = this.subtot;
    data['particulars'] = this.particulars;
    data['attach_bill'] = this.attachBill;
    data['signature'] = this.signature;
    data['request_timestamp'] = this.requestTimestamp;
    data['approved_status'] = this.approvedStatus;
    data['approved_by'] = this.approvedBy;
    data['approved_timestamp'] = this.approvedTimestamp;
    return data;
  }
}
