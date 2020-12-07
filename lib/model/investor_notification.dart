class InvestorNotification {
  String id;
  String notificationId;
  String fieldOfficerId;
  String farmId;
  String title;
  String description;
  String image;
  String image1;
  String audio;
  String video;
  String status;
  String timestamp;
  String mappingId;
  String requestId;
  String investerId;
  String farmerId;

  InvestorNotification(
      {this.id,
      this.notificationId,
      this.fieldOfficerId,
      this.farmId,
      this.title,
      this.description,
      this.image,
      this.image1,
      this.audio,
      this.video,
      this.status,
      this.timestamp,
      this.mappingId,
      this.requestId,
      this.investerId,
      this.farmerId});

  InvestorNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notificationId = json['notification_id'];
    fieldOfficerId = json['field_officer_id'];
    farmId = json['farm_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    image1 = json['image1'];
    audio = json['audio'];
    video = json['video'];
    status = json['status'];
    timestamp = json['timestamp'];
    mappingId = json['mapping_id'];
    requestId = json['request_id'];
    investerId = json['invester_id'];
    farmerId = json['farmer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['notification_id'] = this.notificationId;
    data['field_officer_id'] = this.fieldOfficerId;
    data['farm_id'] = this.farmId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['image1'] = this.image1;
    data['audio'] = this.audio;
    data['video'] = this.video;
    data['status'] = this.status;
    data['timestamp'] = this.timestamp;
    data['mapping_id'] = this.mappingId;
    data['request_id'] = this.requestId;
    data['invester_id'] = this.investerId;
    data['farmer_id'] = this.farmerId;
    return data;
  }
}
