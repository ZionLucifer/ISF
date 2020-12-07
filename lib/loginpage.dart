import 'dart:convert';
import 'package:apps/components/logout_overlay.dart';
import 'package:apps/fieldofficerdash.dart';
import 'package:apps/investordash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:apps/farmerdashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool visible = false;

  TextEditingController loginid = new TextEditingController();
  TextEditingController password = new TextEditingController();

  String msg = '';

  // ignore: missing_return
  Future<List> _login() async {
    setState(() {
      visible = true;
    });
    final response = await http
        .post("https://breaktalks.com/isf/appconnect/login.php", body: {
      "mobile": loginid.text,
      "password": password.text,
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var datauser = json.decode(response.body);
    print('response : $datauser');

    if ((datauser?.length ?? 0) == 0) {
      setState(() {
        visible = false;
      });
      showDialog(
          context: context,
          builder: (_) =>
              LogoutOverlay(message: "Enter Valid Credential"));
    } else {
      if (datauser[0]['role_id'] == 'ROL0003' && datauser[0]['status'] == '2') {
        setState(() {
          visible = false;
        });

        sharedPreferences.setString("username", datauser[0]["user_id"]);
        sharedPreferences.setString("mobile", datauser[0]["mobile"]);
        sharedPreferences.setString("user_id", datauser[0]['user_id']);
        sharedPreferences.setString("token", datauser[0]['role_id']);
        showDialog(
          context: context,
          builder: (_) => Center(child: CircularProgressIndicator()),
        );

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => investorss()),
                (route) => false);
      } else if (datauser[0]['role_id'] == 'ROL0003') {
        setState(() {
          visible = false;
        });
        sharedPreferences.setString("username", datauser[0]["user_id"]);
        sharedPreferences.setString("mobile", datauser[0]["mobile"]);
        sharedPreferences.setString("user_id", datauser[0]['user_id']);
        sharedPreferences.setString("token", datauser[0]['role_id']);

        showDialog(
          context: context,
          builder: (_) => Center(child: CircularProgressIndicator()),
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => investorss()),
                (route) => false);
      } else if (datauser[0]['role_id'] == 'ROL0002') {
        setState(() {
          visible = false;
        });
        sharedPreferences.setString("username", datauser[0]["user_id"]);
        sharedPreferences.setString("mobile", datauser[0]["mobile"]);
        sharedPreferences.setString("user_id", datauser[0]['user_id']);
        sharedPreferences.setString("token", datauser[0]['role_id']);

        showDialog(
          context: context,
          builder: (_) => Center(child: CircularProgressIndicator()),
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => farmerdash()),
                (route) => false);
      } else if (datauser[0]['role_id'] == 'ROL0001') {
        setState(() {
          visible = false;
        });
        sharedPreferences.setString("username", datauser[0]["user_id"]);
        sharedPreferences.setString("mobile", datauser[0]["mobile"]);
        sharedPreferences.setString("user_id", datauser[0]['user_id']);
        // sharedPreferences.setString("token", datauser[0]['login_id']);
        sharedPreferences.setString("token", datauser[0]['role_id']);
        showDialog(
          context: context,
          builder: (_) => Center(child: CircularProgressIndicator()),
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => fielddash()),
                (route) => false);
      } else {
        setState(() {
          visible = false;
        });
        showDialog(
            context: context,
            builder: (_) =>
                LogoutOverlay(message: "Enter Valid Credential"));
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              key: _formKey,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Center(
                    child: Image.asset(
                      "assets/img/log.png",
                      height: 150,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Text("Welcome",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Divider(
                    endIndent: MediaQuery.of(context).size.width / 1.6,
                    thickness: 2,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: TextField(
                      controller: loginid,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                          labelText: "Enter Mobile No",
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true)),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Enter Password",
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true)),
                ),
                SizedBox(
                  height: 35,
                ),
                visible
                    ? Container(
                    child: Center(child: CircularProgressIndicator()))
                    : Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: MaterialButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                      ),
                      color: Colors.orange,
                      textColor: Colors.white,
                      disabledColor: Colors.black12,
                      disabledTextColor: Colors.black26,
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      splashColor: Colors.indigoAccent,
                      elevation: 2.0,
                      onPressed: () {
                        print("Login Button Pressed");

                        if (loginid.text.isNotEmpty && password.text.isNotEmpty
                             || loginid.text.length == 10 ) {
                          setState(() {
                            visible = true;
                          });
                          _login();
                        }
                        // else if( loginid.text.length != 10){
                        //   showDialog(
                        //       context: context,
                        //       builder: (_) => LogoutOverlay(message: "Enter a Valid Mobile Number"));
                        // }
                        else {
                          showDialog(
                              context: context,
                              builder: (_) =>
                                  LogoutOverlay(message: "Enter All fields"));
                        }
                      },
                      child: Text("LOG IN",
                          style: TextStyle(fontSize: 14.0))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget TopContainer() {
    return ClipPath(
      clipper: TopClipper(),
      child: new Container(
        height: 200,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.orange[300],
              Colors.orange[500],
              Colors.orange
            ])),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget LoginContainer(BuildContext context, double height, double width) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      elevation: 10,
      shadowColor: Colors.orange[200],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        height: height / 1.3,
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              key: _formKey,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  "assets/img/log.png",
                  height: 120,
                ),
                Text("LOGIN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: 20,
                ),
                TextField(
                    controller: loginid,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                        labelText: "Enter Mobile No",
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true)),
                SizedBox(
                  height: 20,
                ),
                TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Enter Password",
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true)),
                SizedBox(
                  height: 20,
                ),
                ButtonTheme(
                  minWidth: 320,
                  child: MaterialButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                      ),
                      color: Colors.orange,
                      textColor: Colors.white,
                      disabledColor: Colors.black12,
                      disabledTextColor: Colors.black26,
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      splashColor: Colors.indigoAccent,
                      elevation: 2.0,
                      onPressed: () {
                        print("Login Button Pressed");

                        if (loginid.text.isNotEmpty && loginid.text.length == 10 &&
                            password.text.isNotEmpty) {
                          _login();
                        } else {
                          showDialog(
                              context: context,
                              builder: (_) => LogoutOverlay(message: "Enter All fields"));
                        }
                      },
                      child: Text("LOG IN", style: TextStyle(fontSize: 14.0))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget BottomContainer() {
    return ClipPath(
      clipper: BottomClipper(),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.orange,
              Colors.orange[300],
              Colors.orange[500],
              Colors.orange,
              Colors.deepOrange
            ])),
      ),
    );
  }
}



class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    var firstControlPoint = Offset(55, size.height / 1.4);
    var firstEndPoint = Offset(size.width / 1.7, size.height / 1.3);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width - (35), size.height - 35);
    var secondEndPoint = Offset(size.width, size.height / 2.5);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height - 30);
    var firstControlPoint = Offset(size.width - 35, -5);
    var firstEndpoint = Offset(size.width / 2, size.height / 1.3);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndpoint.dx, firstEndpoint.dy);
    var secondControlPoint = Offset(30, size.height - 30);
    var secondEndPoint = Offset(1, 0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
