import 'dart:convert';
import 'package:apps/investornavigation/dashboard_screen.dart';
import 'package:apps/investornavigation/edit_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apps/investordash.dart';
import 'package:apps/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'investorfarm.dart';
import 'investorfarmer.dart';
import 'notification.dart';
import 'InvestorDrawer.dart';

class Promodel extends StatefulWidget {
  @override
  _PromodelState createState() => _PromodelState();
}

class _PromodelState extends State<Promodel> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;

  Future<List> obtenerUsuarios() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var datas = sharedPreferences.getString("token");
    final response = await http
        .post("https://breaktalks.com/isf/appconnect/profile.php", body: {
      "login_id": '$datas',
    });
    var data = json.decode(response.body);

    if (sharedPreferences.getString("token") == data[0]['login_id']) {
      setState(() {
        return json.decode(response.body);
      });
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: (TextStyle(fontFamily: 'JosefinSans', color: Colors.white)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => investorss()));
          },
        ),
      ),
      body: new SafeArea(
          child: new FutureBuilder<List>(
        future: obtenerUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new Profile(
                  lista: snapshot.data,
                  scaffoldKey: _scaffoldKey,
                )
              : new Center(
                  child: new CircularProgressIndicator(),
                );
        },
      )),
      drawer: InvestorDrawer.getdrawer(context, onpop: () {
        _popup(context);
      }),
    );
  }

  void _popup(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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
                  sharedPreferences.clear();
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
}

class Profile extends StatelessWidget {
  final List lista;
  final GlobalKey<ScaffoldState> scaffoldKey;

  Profile({this.lista, this.scaffoldKey});

  void _popups(BuildContext context) {
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
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    _buildTitle("Personal Details"),
                    _buildExperienceRow(
                        company: "Father Name",
                        position: lista[0]['fathers_name']),
                    _buildExperienceRow(
                        company: "Gender", position: lista[0]['gender']),
                    _buildExperienceRow(
                        company: "DOB", position: lista[0]['dob']),
                    _buildExperienceRow(
                        company: "Place", position: lista[0]['address']),
                    _buildExperienceRow(
                        company: "Aadhar Number", position: lista[0]['aadhar']),
                    SizedBox(height: 20.0),
                    _buildTitle("Bank Details"),
                    SizedBox(height: 5.0),
                    _buildExperienceRow(
                        company: "Account Number",
                        position: lista[0]['account_number']),
                    _buildExperienceRow(
                        company: "Bank Name", position: lista[0]['bank_name']),
                    _buildExperienceRow(
                        company: "IFSC Code", position: lista[0]['ifsc']),
                    _buildExperienceRow(
                        company: "Pan Number", position: lista[0]['pan']),
                    SizedBox(height: 20.0),
                    _buildTitle("Contact"),
                    SizedBox(height: 5.0),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 30.0),
                        Icon(
                          Icons.mail,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          lista[0]['email'],
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 30.0),
                        Icon(
                          Icons.phone,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          lista[0]['mobile'],
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Divider(),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile _buildExperienceRow({
    String company,
    String position,
  }) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 20.0),
      ),
      title: Text(
        company,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'JosefinSans'),
      ),
      subtitle: Text(
        "$position ",
        style: TextStyle(fontFamily: 'JosefinSans'),
      ),
    );
  }

  Row _buildSkillRow(String skill, double level) {
    return Row(
      children: <Widget>[
        SizedBox(width: 16.0),
        Expanded(
            flex: 2,
            child: Text(
              skill.toUpperCase(),
              textAlign: TextAlign.right,
            )),
        SizedBox(width: 10.0),
        Expanded(
          flex: 5,
          child: LinearProgressIndicator(
            value: level,
          ),
        ),
        SizedBox(width: 16.0),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'JosefinSans'),
          ),
          Divider(
            color: Colors.black54,
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ProfileContainer(double height, double width) {
    return Container(
      child: ClipPath(
        clipper: ProfileClipper(height: height, width: width),
        child: Container(
          height: height,
          width: width,
          color: Colors.orange,
        ),
      ),
    );
  }
}

class ProfileClipper extends CustomClipper<Path> {
  ProfileClipper({this.height, this.width});
  final double height;
  final double width;
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, height - 50);
    path.quadraticBezierTo(size.width / 2, height, size.width, height - 50);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
