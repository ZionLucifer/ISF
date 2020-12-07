import 'dart:convert';

class InvestorFarm {
  String id;
  String cropsId;
  String cropsName;
  String cropsImage;
  String description;
  String status;
  String timestamp;
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
  String mappingId;
  String requestId;
  String investerId;
  String farmphoto;
  List boundaries;
// [10.67029709216464, 79.44641545414925], [10.668077055641746, 79.45013836026192], [10.667592388344943, 79.44720838218927]
// [[[10.671228197939206,79.4458481669426], [10.672183682146391,79.45012126117945], [10.666289285155345,79.44980677217245]]]
  InvestorFarm(
      {this.id,
      this.farmphoto,
      this.cropsId,
      this.cropsName,
      this.cropsImage,
      this.description,
      this.status,
      this.timestamp,
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
      this.mappingId,
      this.requestId,
      this.boundaries,
      this.investerId});

  InvestorFarm.fromJson(Map<String, dynamic> map) {
    print('<<${map['boundaries'].runtimeType}');
    id = map['id'];
    cropsId = map['crops_id'];
    cropsName = map['crops_name'];
    cropsImage = map['crops_image'];
    description = map['description'];
    status = map['status'];
    timestamp = map['timestamp'];
    fieldOfficerId = map['field_officer_id'];
    farmerId = map['farmer_id'];
    farmId = map['farm_id'];
    landType = map['land_type'];
    irrigation = map['irrigation'];
    crops = map['crops'];
    soilType = map['soil_type'];
    acerage = map['acerage'];
    baseLocation = map['base_location'];
    enterprise = map['enterprise'];
    creditWorthiness = map['credit_worthiness'];
    socialCredibility = map['social_credibility'];
    landFactors = map['land_factors'];
    healthFactors = map['health_factors'];
    latlong = map['latlong'];
    plots = map['plots'];
    mappingId = map['mapping_id'];
    requestId = map['request_id'];
    investerId = map['invester_id'];
    farmphoto = map['farm_photo'];
    boundaries = json.decode(map['boundaries'] ?? '[]');
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
    data['mapping_id'] = this.mappingId;
    data['request_id'] = this.requestId;
    data['invester_id'] = this.investerId;
    return data;
  }
}
