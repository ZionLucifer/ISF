import 'dart:convert';
import 'package:apps/investornavigation/dashboard_screen.dart';
import 'package:apps/investornavigation/investorprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:apps/loginpage.dart';
import 'package:apps/investordash.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'investorfarm.dart';
import 'investorfarmer.dart';
import 'notification.dart';
import 'InvestorDrawer.dart';

class fundnew extends StatefulWidget {
  @override
  _fundnewState createState() => _fundnewState();
}

class _fundnewState extends State<fundnew> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<List> getdata() async {
    var url = "http://breaktalks.com/isf/appconnect/investorinvest.php";
    final response = await http.get(url);
    var dataReceived = json.decode(response.body);
    return dataReceived;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.orange,
        title: Text("My Investments",
            textAlign: TextAlign.center,
            style: (TextStyle(fontFamily: 'JosefinSans', color: Colors.white))),
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
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Promodel()));
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<List>(
          future: getdata(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(
                child: Text("Please Wait while we fetch Data from our Servers"),
              );
            return snapshot.hasData
                ? ((snapshot?.data ?? []).length == 0)
                    ? Center(child: Text('No Data Found'))
                    : myfarmers(list: snapshot.data)
                : new Center(
                    child: new CircularProgressIndicator(
                        backgroundColor: Colors.orange),
                  );
          },
        ),
      )),
      drawer: InvestorDrawer.getdrawer(context, onpop: () {
        _popup(context);
      }),
    );
  }
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

class myfarmers extends StatelessWidget {
  final List list;
  String name;
  myfarmers({this.list});
  @override
  Widget build(BuildContext context) {
    return new ListView.separated(
        separatorBuilder: (c, i) => Divider(thickness: 1),
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
              padding: EdgeInsets.all(5),
              // decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://breaktalks.com/isf/img/field_officer/' +
                                    list[i]['crops_image']),
                            minRadius: 30,
                            backgroundColor: Colors.white),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          list[i]['crops_name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18.0,
                              fontFamily: 'JosefinSans'),
                        ),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        Row(
                          children: [
                            Text('Invest Amount:  ₹',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'JosefinSans')),
                            Text(list[i]['amount'],
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 17,
                                    fontFamily: 'JosefinSans')),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
