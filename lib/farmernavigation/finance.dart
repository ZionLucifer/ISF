import 'package:apps/farmernavigation/farmerprofile.dart';
import 'package:apps/farmernavigation/myfarms.dart';
import 'package:flutter/material.dart';
import 'package:apps/farmerdashboard.dart';
import 'package:apps/farmernavigation/financedata.dart';
import 'package:apps/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'farmupdate.dart';
import 'myrequest.dart';

class finance extends StatefulWidget {
  @override
  _financeState createState() => _financeState();
}

class _financeState extends State<finance> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<PaymentModel> getPaymentsCard() {
    List<PaymentModel> paymentCards = [
      PaymentModel("Loan ID: F123", "Total Amount : 50000",
          "Total Expense : 20000", "Balance : 30000"),
      PaymentModel("Loan ID: F124", "Total Amount : 80000",
          "Total Expense : 50000", "Balance : 30000"),
      PaymentModel("Loan ID: F125", "Total Amount : 90000",
          "Total Expense : 70000", "Balance : 20000"),
      PaymentModel("Loan ID: F126", "Total Amount : 40000",
          "Total Expense : 20000", "Balance : 20000"),
    ];

    return paymentCards;
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

  void _popups(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //String token = sharedPreferences.getString("token");
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Theme(
          data: ThemeData.light(),
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.orange,
              title: Text(
                "Finance Data",
                textAlign: TextAlign.center,
                style:
                    (TextStyle(fontFamily: 'JosefinSans', color: Colors.white)),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => farmerdash()));
                },
              ),
              actions: [],
            ),
            body: Stack(children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(top: 20),
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 25.0,
                        bottom: 15,
                        top: 15,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        NotificationListener<OverscrollIndicatorNotification>(
                          child: ListView.separated(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 85.0),
                                child: Divider(),
                              );
                            },
                            padding: EdgeInsets.zero,
                            itemCount: getPaymentsCard().length,
                            itemBuilder: (BuildContext context, int index) {
                              return financeData(
                                payment: getPaymentsCard()[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ]),
            drawer: new Drawer(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      //print(loginId);
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => farmerdash()));
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: Icon(
                          Icons.home,
                          color: Color(0xff1D2952),
                        ),
                        title: Text(
                          "Home",
                          style: TextStyle(color: Color(0xff1D2952)),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          ListTile(
                            title: new Text(
                              "My Farm",
                              style: TextStyle(color: Color(0xff1D2952)),
                            ),
                            leading: Icon(
                              Icons.portrait,
                              color: Color(0xff1D2925),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => myfarms()));
                            },
                          ),
                          ListTile(
                            title: new Text(
                              "My Messages",
                              style: TextStyle(color: Color(0xff1D2952)),
                            ),
                            leading:
                                Icon(Icons.person, color: Color(0xff1D2925)),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => farmernoti()));
                            },
                          ),
                          ListTile(
                            title: new Text(
                              "Notifications",
                              style: TextStyle(color: Color(0xff1D2952)),
                            ),
                            leading: Icon(
                              Icons.notifications,
                              color: Color(0xff1D2925),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => farmernoti()));
                            },
                          ),
                          ListTile(
                            title: new Text(
                              "Financial Data",
                              style: TextStyle(color: Color(0xff1D2952)),
                            ),
                            leading:
                                Icon(Icons.message, color: Color(0xff1D2925)),
                            onTap: () {
                              Navigator.of(context).pop();
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => finance()));
                            },
                          ),
                          ListTile(
                            title: new Text(
                              "My Requests",
                              style: TextStyle(color: Color(0xff1D2952)),
                            ),
                            leading: Icon(
                              Icons.format_list_numbered_rtl,
                              color: Color(0xff1D2925),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => request()));
                            },
                          ),
                          Divider(),
                          ListTile(
                            title: new Text("Logout"),
                            leading: Icon(
                              Icons.cancel,
                              color: Colors.red[200],
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              _popups(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "Powered By Farmingly",
                        style: TextStyle(color: Color(0xff1D2952)),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class PaymentModel {
  String _fundid, _totalloan, _totalexp, _balance;

  PaymentModel(this._fundid, this._totalloan, this._totalexp, this._balance);

  String get fundid => _fundid;

  String get totalloan => _totalloan;

  String get totalexp => _totalexp;

  String get balance => _balance;
}
