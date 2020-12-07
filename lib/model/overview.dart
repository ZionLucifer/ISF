class Overview {
  String id;
  String fieldOfficerId;
  String farmerId;
  String farmerName;
  String profilePhoto;
  String farmId;
  String landType;
  String irrigation;
  String crops;
  String soilType;
  String acerage;
  String baseLocation;
  String enterprise;
  String creditWorthiness;
  String socialCredibility;
  String landFactors;
  String healthFactors;
  String latlong;
  String description;
  String status;
  String timestamp;
  String cropimage;
  Overview(
      {this.id,
      this.fieldOfficerId,
      this.farmerId,
      this.farmerName,
      this.profilePhoto,
      this.farmId,
      this.landType,
      this.irrigation,
      this.crops,
      this.soilType,
      this.acerage,
      this.baseLocation,
      this.enterprise,
      this.creditWorthiness,
      this.socialCredibility,
      this.landFactors,
      this.healthFactors,
      this.latlong,
      this.cropimage,
      this.description,
      this.status,
      this.timestamp});

  Overview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fieldOfficerId = json['field_officer_id'];
    farmerId = json['farmer_id'];
    farmerName = json['farmer_name'];
    profilePhoto = json['profile_photo'];
    farmId = json['farm_id'];
    landType = json['land_type'];
    irrigation = json['irrigation'];
    crops = json['crops'];
    soilType = json['soil_type'];
    acerage = json['acerage'];
    baseLocation = json['base_location'];
    enterprise = json['enterprise'];
    creditWorthiness = json['credit_worthiness'];
    socialCredibility = json['social_credibility'];
    landFactors = json['land_factors'];
    healthFactors = json['health_factors'];
    latlong = json['latlong'];
    description = json['description'];
    status = json['status'];
    timestamp = json['timestamp'];
    cropimage = json['crop_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['field_officer_id'] = this.fieldOfficerId;
    data['farmer_id'] = this.farmerId;
    data['farmer_name'] = this.farmerName;
    data['profile_photo'] = this.profilePhoto;
    data['farm_id'] = this.farmId;
    data['land_type'] = this.landType;
    data['irrigation'] = this.irrigation;
    data['crops'] = this.crops;
    data['soil_type'] = this.soilType;
    data['acerage'] = this.acerage;
    data['base_location'] = this.baseLocation;
    data['enterprise'] = this.enterprise;
    data['credit_worthiness'] = this.creditWorthiness;
    data['social_credibility'] = this.socialCredibility;
    data['land_factors'] = this.landFactors;
    data['health_factors'] = this.healthFactors;
    data['latlong'] = this.latlong;
    data['description'] = this.description;
    data['status'] = this.status;
    data['timestamp'] = this.timestamp;
    data['crop_photo'] = this.cropimage;
    return data;
  }
}
