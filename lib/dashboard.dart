import 'package:apps/farmerdashboard.dart';
import 'package:apps/fieldofficerdash.dart';
import 'package:apps/investordash.dart';
import 'package:flutter/material.dart';
import 'package:apps/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  navigationPage({String token, String loginId}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");
    print("TOKEN");
    print(token);
    if (token == "ROL0003") { 
      print("investor page");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => investorss()));
    } else if (token == "ROL0002") {
      print("Farmer Dashboard page");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => farmerdash()));
    } else if (token == "ROL0001") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => fielddash()));
    } else {
      print("Login Page");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    navigationPage();
    print("Splash Screen Page");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Image.asset(
        "assets/img/sc1.jpg",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ))
    ]);
  }
}
