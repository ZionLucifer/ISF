import 'package:apps/farmernavigation/farms/approved_farms.dart';
import 'package:apps/farmernavigation/farms/pending_farms.dart';
import 'package:apps/model/farmer_my_farms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:apps/farmerdashboard.dart';
import 'package:apps/loginpage.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'farmupdate.dart';
import 'finance.dart';
import 'myrequest.dart';

class myfarms extends StatefulWidget {
  @override
  _myfarmsState createState() => _myfarmsState();
}

class _myfarmsState extends State<myfarms> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  List _pages = [PendingFarms(), ApprovedFarms()];

  @override
  void initstate() {
    super.initState();
  }

  // ignore: unused_element
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "My Farms",
          textAlign: TextAlign.center,
          style: (TextStyle(fontFamily: 'JosefinSans', color: Colors.white)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => farmerdash()));
          },
        ),
        actions: [],
      ),
      body: SafeArea(
        child: Center(
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: _currentIndex == 0 ? Colors.red : Colors.green,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.priority_high),
            title: Text("Pending"),
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.code),
            title: Text("Approved"),
          ),
        ],
      ),
      drawer: SafeArea(
        child: new Drawer(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => farmerdash()));
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
                          "My Farms",
                          style: TextStyle(color: Color(0xff1D2952)),
                        ),
                        leading: Icon(
                          Icons.portrait,
                          color: Color(0xff1D2925),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        title: new Text(
                          "My Message",
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

Widget _request() {
  return Container(
    height: 50.0,
    child: RaisedButton(
      onPressed: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB9F65A), Color(0xFFFF9100)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
          alignment: Alignment.center,
          child: Text(
            "Farm updates",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'JosefinSans'),
          ),
        ),
      ),
    ),
  );
}

// ignore: must_be_immutable
class FarmListView extends StatelessWidget {
  final List<FarmerMyFarms> farmList1;
  FarmListView(this.farmList1);
  SharedPreferences sp;

  Widget build(context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: farmList1.length,
      itemBuilder: (context, int currentIndex) {
        //print(farmList1[currentIndex]);
        return createViewItem(farmList1[currentIndex], context, currentIndex);
      },
    );
  }

  Widget createViewItem(
      FarmerMyFarms farmList, BuildContext context, int index) {
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
          child: ListTile(
            title: Text(
              "${farmList.farmId}",
              style: TextStyle(
                color: Color(0xff1D2952),
              ),
            ),
            subtitle: Text(
              "${farmList.enterprise}",
              style: TextStyle(
                color: Color(0xff1D2952),
              ),
            ),
          )),
    );
  }
}
