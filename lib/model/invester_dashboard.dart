class InvesterPortFolio {
  String id;
  String investProfitId;
  String fieldOfficerId;
  String farmerId;
  String farmId;
  String investerId;
  String totalAmountInvested;
  String returnProfitAmount;
  String timestamp;

  InvesterPortFolio(
      {this.id,
      this.investProfitId,
      this.fieldOfficerId,
      this.farmerId,
      this.farmId,
      this.investerId,
      this.totalAmountInvested,
      this.returnProfitAmount,
      this.timestamp});

  InvesterPortFolio.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    investProfitId = json['invest_profit_id'];
    fieldOfficerId = json['field_officer_id'];
    farmerId = json['farmer_id'];
    farmId = json['farm_id'];
    investerId = json['invester_id'];
    totalAmountInvested = json['total_amount_invested'];
    returnProfitAmount = json['return_profit_amount'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['invest_profit_id'] = this.investProfitId;
    data['field_officer_id'] = this.fieldOfficerId;
    data['farmer_id'] = this.farmerId;
    data['farm_id'] = this.farmId;
    data['invester_id'] = this.investerId;
    data['total_amount_invested'] = this.totalAmountInvested;
    data['return_profit_amount'] = this.returnProfitAmount;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
