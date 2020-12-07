class HarvestingList {
  String id;
  String fieldOfficerId;
  String harvestId;
  String farmId;
  String details;
  String noOfUnits;
  String unitCost;
  String bills;
  String signature;
  String timestamp;
  String status;

  HarvestingList(
      {this.id,
      this.fieldOfficerId,
      this.harvestId,this.status,
      this.farmId,
      this.details,
      this.noOfUnits,
      this.unitCost,
      this.bills,
      this.signature,
      this.timestamp});

  HarvestingList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fieldOfficerId = json['field_officer_id'];
    harvestId = json['harvest_id'];
    farmId = json['farm_id'];
    details = json['details'];
    noOfUnits = json['no_of_units'];
    unitCost = json['unit_cost'];
    bills = json['bills'];
    signature = json['signature'];
    timestamp = json['timestamp'];
    status = json['status1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['field_officer_id'] = this.fieldOfficerId;
    data['harvest_id'] = this.harvestId;
    data['farm_id'] = this.farmId;
    data['details'] = this.details;
    data['no_of_units'] = this.noOfUnits;
    data['unit_cost'] = this.unitCost;
    data['bills'] = this.bills;
    data['signature'] = this.signature;
    data['timestamp'] = this.timestamp;
    data['status1'] = this.status;
    return data;
  }
}
