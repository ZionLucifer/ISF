import 'dart:convert';

import 'package:apps/dashboard.dart';
import 'package:apps/farmernavigation/farmupdate.dart';
import 'package:apps/model/flash_messge.dart';
import 'package:flutter/material.dart';
import 'package:apps/farmernavigation/farmerprofile.dart';
import 'package:apps/farmernavigation/finance.dart';
import 'package:apps/farmernavigation/myfarms.dart';
import 'package:apps/farmernavigation/myrequest.dart';
import 'package:apps/loginpage.dart';
import 'package:http/http.dart' as http;
import 'package:apps/category/farmermenus.dart' as categoriesList;
import 'package:shared_preferences/shared_preferences.dart';

class farmerdash extends StatefulWidget {
  @override
  _farmerdashState createState() => _farmerdashState();
}

class _farmerdashState extends State<farmerdash> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
  String userId, mobile;

  String name = 'Farmer';

  void _popups(BuildContext context) async {
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

  Future<List> obtenerUsuarios() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var name = sharedPreferences.getString("token");
    print(name);
    final response = await http
        .post("https://breaktalks.com/isf/appconnect/farmerprofile.php", body: {
      "login_id": '$name',
    });
    var data = json.decode(response.body);

    if (sharedPreferences.getString("token") == data[0]['login_id']) {
      setState(() {
        return json.decode(response.body);
      });
    }
    return data;
  }

  bool nodata;
  Future<List<FlashMessage>> _getOverViewInfo() async {
    print(userId);
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/flashmessage.php",
        body: {"farmer_id": userId});

    var value = json.decode(response.body);
    var farmlist = value['message'];
    nodata = value['message'].toString().trim()  == 'No data Found';

    if (response.statusCode == 200) {
      List spacecrafts = farmlist;
      return spacecrafts
          .map((spacecraft) => new FlashMessage.fromJson(spacecraft))
          .toList();
    } else
      throw Exception(
          'We were not able to successfully download the json data.');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
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
          "Farmer",
          style: TextStyle(
              fontFamily: 'JosefinSans', color: Colors.white, fontSize: 25),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            color: Colors.white,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Promodels()));
            },
          ),
          IconButton(
            icon: Icon(Icons.power_settings_new),
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              _popups(context);
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Column(children: <Widget>[
        SizedBox(
          height: 15,
        ),
        FutureBuilder<List>(
          future: obtenerUsuarios(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ProfileCard(
                    lista: snapshot.data, userId: userId, mobile: mobile)
                : new Center(
                    child: new CircularProgressIndicator(),
                  );
          },
        ),
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
              crossAxisCount: 2,
              mainAxisSpacing: 55.0,
              crossAxisSpacing: 45.0,
            ),
            padding: const EdgeInsets.all(50.0),
            itemCount: categoriesList.list.length,
            itemBuilder: (BuildContext context, int index) {
              return new GridTile(
                footer: Text(
                  categoriesList.list[index]["name"],
                  style: (TextStyle(
                      fontFamily: 'JosefinSans', fontWeight: FontWeight.bold)),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                child: new Container(
                  height: 30.0,
                  child: new GestureDetector(
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.orange[100]),
                      child: new CircleAvatar(
                        backgroundColor: Colors.orange[100],
                        radius: 35.0,
                        child: Image.asset(
                          categoriesList.list[index]["image"],
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                    ),
                    onTap: () {
                      if (categoriesList.list[index]['id'] == 'financialdata') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => finance()));
                      } else if (categoriesList.list[index]['id'] ==
                          'profile') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Promodels()));
                      } else if (categoriesList.list[index]['id'] ==
                          'notification') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => farmernoti()));
                      } else if (categoriesList.list[index]['id'] ==
                          'myrequests') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => request()));
                      } else if (categoriesList.list[index]['id'] ==
                          'myfarms') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => myfarms()));
                      } else if (categoriesList.list[index]['id'] ==
                          'mymessage') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    farmernoti(userId: userId)));
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          height: 50,
          child: FutureBuilder<List<FlashMessage>>(
              future: _getOverViewInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<FlashMessage> overview = snapshot.data;
                  if (nodata) {
                    return Center(
                        child: Container(child: Text('No Data Found')));
                  }
                  return new FarmListView(overview);
                } else if (snapshot.hasError) {
                  return Center(
                      child: Container(child: new CircularProgressIndicator()));
                }
                return Center(
                    child: Container(child: new CircularProgressIndicator()));
              }),
        )
      ])),
      drawer: SafeArea(
        child: new Drawer(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
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
                        leading: Icon(Icons.person, color: Color(0xff1D2925)),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => farmernoti()));
                        },
                      ),
                      ListTile(
                        title: new Text("Notifications",
                            style: TextStyle(color: Color(0xff1D2952))),
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
                        leading: Icon(Icons.message, color: Color(0xff1D2925)),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => finance()));
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
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final List lista;
  const ProfileCard({
    Key key,
    @required this.lista,
    @required this.userId,
    @required this.mobile,
  }) : super(key: key);

  final String userId;
  final String mobile;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        margin:
            EdgeInsets.only(left: 10.0, right: 10.0, top: 12.0, bottom: 8.0),
        padding: EdgeInsets.all(8.0),
        child: Row(
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Name: ${lista[0]['farmer_name']}",
                  style: TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                ),
                Text(
                  "User ID: $userId",
                  style: TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                ),
                Text(
                  "Mobile: $mobile",
                  style: TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class FarmListView extends StatelessWidget {
  final List<FlashMessage> farmList1;
  FarmListView(this.farmList1);
  SharedPreferences sp;

  Widget build(context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: farmList1.length,
      itemBuilder: (context, int currentIndex) {
        //print(farmList1[currentIndex]);
        return createViewItem(farmList1[currentIndex], context, currentIndex);
      },
    );
  }

  Widget createViewItem(
      FlashMessage farmList, BuildContext context, int index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => FarmWorkReporting(farmInfo: farmList)));
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          height: 100,
          width: 400,
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Text(
              "${farmList.messageBody}",
              style: TextStyle(
                color: Color(0xff1D2952),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
