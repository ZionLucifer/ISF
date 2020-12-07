class ExpenseModel {
  String fundRequestId;
  String total;
  String availableBalance;
String purpose;
  ExpenseModel({this.fundRequestId, this.total, this.availableBalance,this.purpose});

  ExpenseModel.fromJson(Map<String, dynamic> json) {
    fundRequestId = json['fund_request_id'];
    total = json['total'];
    availableBalance = json['available_balance'];
    purpose = json['purpose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fund_request_id'] = this.fundRequestId;
    data['total'] = this.total;
    data['available_balance'] = this.availableBalance;
    data['purpose'] = this.purpose;
    return data;
  }
}
