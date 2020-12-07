class PendingFarmerModel {
  String id;
  String fieldOfficerId;
  String farmerId;
  String farmerName;
  String loginId;
  String password;
  String email;
  String mobile;
  String level;
  String roleId;
  String dob;
  String gender;
  String profilePhoto;
  String baseLocation;
  String fathersName;
  String description;
  String address;
  String city;
  String state;
  String country;
  String pincode;
  String altMobile;
  String rolePermission;
  String status;
  String accountNumber;
  String pan;
  String aadhar;
  String ifsc;
  String bankName;
  String accountType;
  String imagePan;
  String imageAadhar;
  String facebookLink;
  String twitterLink;
  String timestamp;
  String status1;

  PendingFarmerModel(
      {this.id,
      this.fieldOfficerId,
      this.farmerId,
      this.farmerName,
      this.loginId,
      this.password,
      this.email,
      this.mobile,
      this.level,
      this.roleId,
      this.dob,
      this.gender,
      this.profilePhoto,
      this.baseLocation,
      this.fathersName,
      this.description,
      this.address,
      this.city,
      this.state,
      this.country,
      this.pincode,
      this.altMobile,
      this.rolePermission,
      this.status,
      this.accountNumber,
      this.pan,
      this.aadhar,
      this.ifsc,
      this.bankName,
      this.accountType,
      this.imagePan,
      this.imageAadhar,
      this.facebookLink,
      this.twitterLink,
      this.timestamp,
      this.status1});

  PendingFarmerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fieldOfficerId = json['field_officer_id'];
    farmerId = json['farmer_id'];
    farmerName = json['farmer_name'];
    loginId = json['login_id'];
    password = json['password'];
    email = json['email'];
    mobile = json['mobile'];
    level = json['level'];
    roleId = json['role_id'];
    dob = json['dob'];
    gender = json['gender'];
    profilePhoto = json['profile_photo'];
    baseLocation = json['base_location'];
    fathersName = json['fathers_name'];
    description = json['description'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pincode = json['pincode'];
    altMobile = json['alt_mobile'];
    rolePermission = json['role_permission'];
    status = json['status'];
    accountNumber = json['account_number'];
    pan = json['pan'];
    aadhar = json['aadhar'];
    ifsc = json['ifsc'];
    bankName = json['bank_name'];
    accountType = json['account_type'];
    imagePan = json['image_pan'];
    imageAadhar = json['image_aadhar'];
    facebookLink = json['facebook_link'];
    twitterLink = json['twitter_link'];
    timestamp = json['timestamp'];
    status1 = json['status1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['field_officer_id'] = this.fieldOfficerId;
    data['farmer_id'] = this.farmerId;
    data['farmer_name'] = this.farmerName;
    data['login_id'] = this.loginId;
    data['password'] = this.password;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['level'] = this.level;
    data['role_id'] = this.roleId;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['profile_photo'] = this.profilePhoto;
    data['base_location'] = this.baseLocation;
    data['fathers_name'] = this.fathersName;
    data['description'] = this.description;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['pincode'] = this.pincode;
    data['alt_mobile'] = this.altMobile;
    data['role_permission'] = this.rolePermission;
    data['status'] = this.status;
    data['account_number'] = this.accountNumber;
    data['pan'] = this.pan;
    data['aadhar'] = this.aadhar;
    data['ifsc'] = this.ifsc;
    data['bank_name'] = this.bankName;
    data['account_type'] = this.accountType;
    data['image_pan'] = this.imagePan;
    data['image_aadhar'] = this.imageAadhar;
    data['facebook_link'] = this.facebookLink;
    data['twitter_link'] = this.twitterLink;
    data['timestamp'] = this.timestamp;
    data['status1'] = this.status1;
    return data;
  }
}
