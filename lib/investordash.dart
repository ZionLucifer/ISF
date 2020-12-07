import 'dart:convert';
import 'package:apps/dashboard.dart';
import 'package:apps/investornavigation/cart_screen.dart';
import 'package:apps/investornavigation/dashboard_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:apps/investornavigation/addfund.dart';
import 'package:apps/investornavigation/investorfarm.dart';
import 'package:apps/investornavigation/investorfarmer.dart';
import 'package:apps/investornavigation/investorprofile.dart';
import 'package:apps/investornavigation/messages.dart';
import 'package:apps/investornavigation/myinvestments.dart';
import 'package:apps/investornavigation/notification.dart';
import 'package:apps/category/investormenu.dart' as categoriesList;
import 'package:shared_preferences/shared_preferences.dart';
import 'investornavigation/InvestorDrawer.dart';

class investorss extends StatefulWidget {
  @override
  _investorssState createState() => _investorssState();
}

// ignore: camel_case_types
class _investorssState extends State<investorss> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
  String userId, mobile;
  var data;
  // ignore: non_constant_identifier_names
  var login_id;

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
                      MaterialPageRoute(builder: (context) => SplashScreen()),
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

  Future<String> getInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("user_id");
  }

  setData() {
    getInfo().then((value) {
      setState(() {
        login_id = value;
      });
    });
    print(login_id);
  }

  _getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (userId == "") {
        userId = (sharedPreferences.getString('user_id') ?? '');
        mobile = (sharedPreferences.getString('mobile') ?? '');
      } else {
        userId = (sharedPreferences.getString('user_id') ?? '');
        mobile = (sharedPreferences.getString('mobile') ?? '');
        print("Test Else");
        print(userId);
        print(mobile);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFFFF9100),
        title: Text(
          "Investor",
          style: TextStyle(fontFamily: 'JosefinSans', color: Colors.white),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: IconButton(
            icon: Icon(Icons.menu),
            color: Colors.white,
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 0),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 0),
            child: IconButton(
              icon: Icon(Icons.person),
              color: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Promodel()));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 2),
            child: IconButton(
              icon: Icon(Icons.power_settings_new),
              color: Colors.white,
              onPressed: () {
                _popup(context);
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
      SizedBox(height: 15),
      Card(
        elevation: 5,
        child: Container(
          margin: EdgeInsets.only(
              left: 8.0, right: 8.0, top: 12.0, bottom: 8.0),
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                backgroundColor: Color(0xff1D2952),
                foregroundColor: Colors.white,
                radius: 40,
                child: Icon(
                  Icons.account_circle,
                  size: 40,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Investor ID",
                    style:
                        TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Mobile",
                    style:
                        TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ":",
                    style:
                        TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    ":",
                    style:
                        TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$userId",
                    style:
                        TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "$mobile",
                    style:
                        TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[],
        ),
      ),
      Expanded(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          padding: const EdgeInsets.all(10.0),
          itemCount: categoriesList.list.length,
          itemBuilder: (BuildContext context, int index) {
            return new GridTile(
              footer: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(categoriesList.list[index]["name"],
                        style: (TextStyle(
                            fontFamily: 'JosefinSans',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange)),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip),
                  ]),
              child: new Container(
                height: 25,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: new GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(10)),
                    child: new CircleAvatar(
                      backgroundColor: Colors.orange[100],
                      radius: 25,
                      child: Image.asset(
                          categoriesList.list[index]["image"],
                          fit: BoxFit.cover,
                          height: 50),
                    ),
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  ),
                  onTap: () {
                    if (categoriesList.list[index]['id'] == 'myprofile') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Promodel()));
                    } else if (categoriesList.list[index]['id'] ==
                        'myfarmers') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Chat()));
                    } else if (categoriesList.list[index]['id'] ==
                        'investments') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => fundnew()));
                    } else if (categoriesList.list[index]['id'] ==
                        'addfund') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyApps()));
                    } else if (categoriesList.list[index]['id'] ==
                        'Dashboard') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardScreen()));
                    } else if (categoriesList.list[index]['id'] ==
                        'Farmupdates') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => farmernoti()));
                    } else if (categoriesList.list[index]['id'] ==
                        'mymessage') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Chating()));
                    } else if (categoriesList.list[index]['id'] ==
                        'myfarm') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Farms()));
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
        ]),
      )),
      drawer: InvestorDrawer.getdrawer(context, onpop: () {
        _popup(context);
      }),
    );
  }
}
