class ExpenseOverviewModel {
  String farmExpenseId;
  String total;
  String purpose;
  String approvedStatus;
  String createdOn;
  String approvedOn;

  ExpenseOverviewModel(
      {this.farmExpenseId,
      this.total,
      this.purpose,
      this.approvedStatus,
      this.createdOn,
      this.approvedOn});

  ExpenseOverviewModel.fromJson(Map<String, dynamic> json) {
    farmExpenseId = json['farm_expense_id'];
    total = json['total'];
    purpose = json['purpose'];
    approvedStatus = json['approved_status'];
    createdOn = json['created_on'];
    approvedOn = json['approved_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['farm_expense_id'] = this.farmExpenseId;
    data['total'] = this.total;
    data['purpose'] = this.purpose;
    data['approved_status'] = this.approvedStatus;
    data['created_on'] = this.createdOn;
    data['approved_on'] = this.approvedOn;
    return data;
  }
}
