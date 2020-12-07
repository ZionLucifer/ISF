import 'dart:convert';
import 'package:apps/investordash.dart';
import 'package:apps/investornavigation/investorprofile.dart';
import 'package:apps/loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'InvestorDrawer.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<List> getdata() async {
    var url = "http://breaktalks.com/isf/appconnect/investorfarmer.php";
    final response = await http.get(url);
    var dataReceived = json.decode(response.body);
    return dataReceived;
  }

  void _popup(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Alert',
              style: TextStyle(fontFamily: 'JosefinSans'),
            ),
            content: Text(
              'Are Your Sure Want to logout',
              style: TextStyle(fontFamily: 'JosefinSans'),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                      fontFamily: 'JosefinSans', color: Color(0xFFFF9100)),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                      fontFamily: 'JosefinSans', color: Color(0xFFFF9100)),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.light(),
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.orange,
              title: Text(
                "My Farmer",
                style:
                    (TextStyle(fontFamily: 'JosefinSans', color: Colors.white)),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => investorss()),
                      (route) => false);
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.person),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Promodel()));
                  },
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(10),
              child: FutureBuilder<List>(
                future: getdata(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? (snapshot.data.length == 0)
                          ? Center(child: Text('No Data Found'))
                          : myfarmers(list: snapshot.data)
                      : new Center(
                          child: new CircularProgressIndicator(
                              backgroundColor: Colors.orange));
                },
              ),
            ),
            drawer: InvestorDrawer.getdrawer(context, onpop: () {
              _popup(context);
            }),
          ),
        ));
  }
}

// ignore: camel_case_types
class myfarmers extends StatelessWidget {
  final List list;
  myfarmers({this.list});
  @override
  Widget build(BuildContext context) {
    return new ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (c, i) => Divider(height: 2, thickness: 1),
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return Container(
            margin: EdgeInsets.all(5),
            child: ListTile(
              onTap: () => Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new FarmerDETS(
                        farmInfo: FarmerModel.fromJson(list[i]))),
              ),
              contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              leading: Container(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'http://breaktalks.com/isf/' +
                          list[i]['profile_photo']),
                  radius: 33,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              title: Text(
                list[i]['farmer_name'],
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'JosefinSans'),
              ),
              subtitle: Text(
                list[i]['address'],
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                    fontFamily: 'JosefinSans'),
              ),
              trailing: Icon(Icons.chevron_right, size: 28),
            ),
          );
        });
  }
}

class FarmerDETS extends StatelessWidget {
  final FarmerModel farmInfo;
  FarmerDETS({this.farmInfo});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        title: Text(
          farmInfo.farmerName,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 6,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.orange[300]),
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: CircleAvatar(
                            backgroundColor: Colors.orange[300],
                            foregroundColor: Colors.white,
                            radius: 80,
                            child: Image.network(
                              farmInfo.profilePhoto,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (c, n, o) => Icon(
                                  Icons.account_circle,
                                  color: Colors.white,
                                  size: 50),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(8.8),
                        child: Text(
                          "Farmer Information",
                          style:
                              TextStyle(color: Color(0xff4749A0), fontSize: 18),
                        ),
                      ),
                      details("Farmer Name", farmInfo.farmerName),
                      Divider(color: Colors.black),
                      details("Mobile No", farmInfo.mobile),
                      Divider(color: Colors.black),
                      details("E-mail", farmInfo.email),
                      Divider(color: Colors.black),
                      details("Gender", farmInfo.gender),
                      Divider(color: Colors.black),
                      details("Base Location", farmInfo.baseLocation),
                      Divider(color: Colors.black),
                      details("Address", farmInfo.address),
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(8.8),
                        child: Text(
                          "Bank Details",
                          style:
                              TextStyle(color: Color(0xff4749A0), fontSize: 18),
                        ),
                      ),
                      details("A/C No", farmInfo.accountNumber),
                      Divider(color: Colors.black),
                      details("Bank Name", farmInfo.bankName),
                      Divider(color: Colors.black),
                      details("Bank IFSC", farmInfo.ifsc),
                      Divider(color: Colors.black),
                      details("Pan No", farmInfo.pan),
                      Divider(color: Colors.black),
                      SizedBox(height: 100)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget details(String one, String two) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(one, style: TextStyle(fontSize: 16)),
          Text(two ?? '-', style: TextStyle(color: Colors.black, fontSize: 16)),
        ],
      ),
    );
  }
}

class FarmerModel {
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

  FarmerModel(
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

  FarmerModel.fromJson(Map<String, dynamic> json) {
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
