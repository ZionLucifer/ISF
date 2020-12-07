class CropsModel {
  String id;
  String cropsId;
  String cropsName;
  String cropsImage;
  String description;
  String status;
  String timestamp;
  String price;

  CropsModel(
      {this.id,
      this.cropsId,
      this.cropsName,
      this.cropsImage,
      this.description,
      this.status,
      this.price,
      this.timestamp});

  CropsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cropsId = json['crops_id'];
    cropsName = json['crops_name'];
    price = json['price'];
    cropsImage = json['crops_image'];
    //   "http://isf.breaktalks.com/img/field_officer/" +
    description = json['description'];
    status = json['status'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['crops_id'] = this.cropsId;
    data['crops_name'] = this.cropsName;
    data['price'] = this.price;
    data['crops_image'] = this.cropsImage;
    data['description'] = this.description;
    data['status'] = this.status;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
