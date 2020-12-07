class FarmerNotification {
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

  FarmerNotification(
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
      this.timestamp});

  FarmerNotification.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
