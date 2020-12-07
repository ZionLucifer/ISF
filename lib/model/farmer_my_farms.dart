class FarmerMyFarms {
  String id;
  String fieldOfficerId;
  String farmerId;
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
  String plots;
  String description;
  String status;
  String timestamp;
  String cropsName;
  String irrigationName;
  String soilTypeName;
  String acreageName;
  String landTypeName;
  String baseLocationName;
  String enterpriseName;

  FarmerMyFarms(
      {this.id,
      this.fieldOfficerId,
      this.farmerId,
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
      this.plots,
      this.description,
      this.status,
      this.timestamp,
      this.cropsName,
      this.irrigationName,
      this.soilTypeName,
      this.acreageName,
      this.landTypeName,
      this.baseLocationName,
      this.enterpriseName});

  FarmerMyFarms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fieldOfficerId = json['field_officer_id'];
    farmerId = json['farmer_id'];
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
    plots = json['plots'];
    description = json['description'];
    status = json['status'];
    timestamp = json['timestamp'];
    cropsName = json['crops_name'];
    irrigationName = json['irrigation_name'];
    soilTypeName = json['soil_type_name'];
    acreageName = json['acreage_name'];
    landTypeName = json['land_type_name'];
    baseLocationName = json['base_location_name'];
    enterpriseName = json['enterprise_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['field_officer_id'] = this.fieldOfficerId;
    data['farmer_id'] = this.farmerId;
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
    data['plots'] = this.plots;
    data['description'] = this.description;
    data['status'] = this.status;
    data['timestamp'] = this.timestamp;
    data['crops_name'] = this.cropsName;
    data['irrigation_name'] = this.irrigationName;
    data['soil_type_name'] = this.soilTypeName;
    data['acreage_name'] = this.acreageName;
    data['land_type_name'] = this.landTypeName;
    data['base_location_name'] = this.baseLocationName;
    data['enterprise_name'] = this.enterpriseName;
    return data;
  }
}
