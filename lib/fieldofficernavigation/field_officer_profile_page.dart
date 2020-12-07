import 'dart:convert';
import 'package:apps/fieldofficerdash.dart';
import 'package:apps/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FieldOfficerProfile extends StatefulWidget {
  final String userId;
  FieldOfficerProfile({this.userId});
  @override
  _FieldOfficerProfileState createState() => _FieldOfficerProfileState();
}

class _FieldOfficerProfileState extends State<FieldOfficerProfile> {
  Future<ProfileModel> futureProfile;
  Future<ProfileModel> fetchProfile() async {
    try {
      final response = await http.post(
          "http://isf.breaktalks.com/appconnect/fieldofficerprofileget.php",
          body: {"field_officer_id": widget.userId});

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return ProfileModel.fromJson(json.decode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureProfile = fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FutureBuilder<ProfileModel>(
            future: futureProfile,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FarmerProfile(
                  profile: snapshot.data,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class FarmerProfile extends StatelessWidget {
  final ProfileModel profile;

  FarmerProfile({this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  height: MediaQuery.of(context).size.height / 3,
                  color: Colors.orange[300],
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 19,
                                ),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => fielddash()),
                                      (route) => false);
                                }),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            margin: EdgeInsets.all(8.0),
                            child: Text(
                              "My Account",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Container(
                            width: 100,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CircleAvatar(
                        radius: 50,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.orange[300],
                          size: 80,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          "${profile.fieldOfficerName.toString().toUpperCase()}",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.zero,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(12.5),
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Aadhar Number",
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      Text(
                        "${profile.aadhar.toString().toUpperCase()}",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Personal Details",
                        style:
                            TextStyle(color: Color(0xff4749A0), fontSize: 25),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      InfoTile(
                          title: "Father's Name",
                          value:
                              "${profile.fathersName.toString().toUpperCase()}"),
                      Divider(),
                      InfoTile(
                          title: "Address",
                          value: "${profile.address.toString()}"),
                      Divider(),
                      InfoTile(
                          title: "Gender",
                          value: "${profile.gender.toString().toUpperCase()}"),
                      Divider(),
                      InfoTile(
                          title: "DOB",
                          value: "${profile.dob.toString().toUpperCase()}"),
                      Divider(),
                      InfoTile(
                          title: "Account Number",
                          value:
                              "${profile.accountNumber.toString().toUpperCase()}"),
                      Divider(),
                      InfoTile(
                          title: "Mobile Number",
                          value: "${profile.mobile.toString().toUpperCase()}"),
                      Divider(),
                      InfoTile(
                          title: "Email", value: "${profile.email.toString()}"),
                      Divider(),
                      InfoTile(
                          title: "Pan Card",
                          value: "${profile.pan.toString()}"),
                      Divider(),
                      InfoTile(
                          title: "Bank Name",
                          value:
                              "${profile.bankName.toString().toUpperCase()}"),
                      Divider(),
                      InfoTile(
                          title: "Account No",
                          value:
                              "${profile.accountNumber.toString().toUpperCase()}"),
                      Divider(),
                      InfoTile(
                          title: "IFSC Code",
                          value: "${profile.ifsc.toString().toUpperCase()}"),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget InfoTile({String title, String value}) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            value == "" ? "N/A" : value,
            style: TextStyle(color: Colors.black, fontSize: 18),
          )
        ],
      ),
    );
  }
}
