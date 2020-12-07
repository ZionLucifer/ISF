class Records {
  String id;
  String activityId;
  String fieldOfficerId;
  String farmId;
  String activityTitle;
  String description;
  String startDate;
  String endDate;
  String files;
  String status;
  String timestamp;

  Records(
      {this.id,
      this.activityId,
      this.fieldOfficerId,
      this.farmId,
      this.activityTitle,
      this.description,
      this.startDate,
      this.endDate,
      this.files,
      this.status,
      this.timestamp});

  Records.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    activityId = json['activity_id'];
    fieldOfficerId = json['field_officer_id'];
    farmId = json['farm_id'];
    activityTitle = json['activity_title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    files = json['files'];
    status = json['status'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['activity_id'] = this.activityId;
    data['field_officer_id'] = this.fieldOfficerId;
    data['farm_id'] = this.farmId;
    data['activity_title'] = this.activityTitle;
    data['description'] = this.description;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['files'] = this.files;
    data['status'] = this.status;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
