class CartModel {
  String id;
  String cropsId;
  String cropsName;
  String cropsImage;
  String description;
  String status;
  String timestamp;
  String investerId;
  String quantity;

  CartModel(
      {this.id,
      this.cropsId,
      this.cropsName,
      this.cropsImage,
      this.description,
      this.status,
      this.timestamp,
      this.investerId,
      this.quantity});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cropsId = json['crops_id'];
    cropsName = json['crops_name'];
    cropsImage =
        "http://isf.breaktalks.com/img/field_officer/" + json['crops_image'];
    description = json['description'];
    status = json['status'];
    timestamp = json['timestamp'];
    investerId = json['invester_id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['crops_id'] = this.cropsId;
    data['crops_name'] = this.cropsName;
    data['crops_image'] = this.cropsImage;
    data['description'] = this.description;
    data['status'] = this.status;
    data['timestamp'] = this.timestamp;
    data['invester_id'] = this.investerId;
    data['quantity'] = this.quantity;
    return data;
  }
}
