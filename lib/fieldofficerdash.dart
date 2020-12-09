import 'dart:convert';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:apps/dashboard.dart';
import 'package:apps/fieldofficernavigation/addfarm.dart';
import 'package:apps/fieldofficernavigation/addfarmer.dart';
import 'package:apps/fieldofficernavigation/farmreporting.dart';
// import 'package:apps/fieldofficernavigation/fundrequest.dart';
import 'package:apps/fieldofficernavigation/overview_page.dart';
import 'package:apps/fieldofficernavigation/pending_requests.dart';
import 'package:apps/fieldofficernavigation/reports_screen.dart';
import 'package:apps/loginpage.dart';
import 'package:apps/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:apps/category/fieldmenu.dart' as categoriesList;
import 'package:shared_preferences/shared_preferences.dart';
import 'fieldofficernavigation/field_officer_profile_page.dart';
import 'fieldofficernavigation/add_fund_page.dart';
import 'farmreporting/request_expense_id.dart';

class fielddash extends StatefulWidget {
  @override
  _fielddashState createState() => _fielddashState();
}

class _fielddashState extends State<fielddash> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
  String userId, mobile;
  Future<ProfileModel> futureProfile;

  Future<ProfileModel> fetchProfile() async {
    try {
      final response = await http.post(
          "http://isf.breaktalks.com/appconnect/fieldofficerprofileget.php",
          body: {"field_officer_id": userId});

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
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SplashScreen()));
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
          "Field Officer",
          style: TextStyle(fontFamily: 'JosefinSans', color: Colors.white),
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FieldOfficerProfile(
                            userId: userId,
                          )));
            },
          ),
          IconButton(
            icon: Icon(Icons.power_settings_new),
            color: Colors.white,
            onPressed: () {
              _popups(context);
            },
          ),
        ],
      ),
      body: SafeArea(
          child: SafeArea(
              child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          SizedBox(height: 10),
          FutureBuilder<ProfileModel>(
            future: fetchProfile(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                return ProfileCard(
                  userId: userId,
                  mobile: mobile,
                  profile: snapshot.data,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 7 / 9,
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 15.0,
              ),
              padding: const EdgeInsets.all(5),
              itemCount: categoriesList.list.length,
              itemBuilder: (BuildContext context, int index) {
                return new Grids(
                  footer: categoriesList.list[index]["name"],
                  child: categoriesList.list[index]["image"],
                  onTap: () {
                    if (categoriesList.list[index]['id'] == 'overview') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OverviewPage()));
                    } else if (categoriesList.list[index]['id'] ==
                        'addfarmer') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AndroidMessagesPage()));
                    } else if (categoriesList.list[index]['id'] ==
                        'recexpence') {
                      print("Record Expenses");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReqeuestExpenseID()));
                    } else if (categoriesList.list[index]['id'] == 'addfarm') {
                      print("Add Farm clicked");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AndroidMessagesPages()));
                    } else if (categoriesList.list[index]['id'] ==
                        'expensereport') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => farm()));
                    } else if (categoriesList.list[index]['id'] == 'fundreq') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddFundPage()));
                    } else if (categoriesList.list[index]['id'] ==
                        'pendingrequests') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PendingRequests(userId: userId)));
                    } else if (categoriesList.list[index]['id'] == 'report') {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ReportsScreen()));
                    }
                  },
                );
              },
            ),
          ),
        ]),
      ))),
      drawer: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Drawer(
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
                            "Add Farmer",
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
                                    builder: (context) =>
                                        AndroidMessagesPage()));
                          },
                        ),
                        ListTile(
                          title: new Text("Add Farm",
                              style: TextStyle(color: Color(0xff1D2952))),
                          leading: Icon(Icons.filter_frames,
                              color: Color(0xff1D2925)),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AndroidMessagesPages()));
                          },
                        ),
                        ListTile(
                          title: new Text("Pending Requests",
                              style: TextStyle(color: Color(0xff1D2952))),
                          leading: Icon(Icons.list, color: Color(0xff1D2925)),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PendingRequests()));
                          },
                        ),
                        ListTile(
                          title: new Text("Report",
                              style: TextStyle(color: Color(0xff1D2952))),
                          leading: Icon(Icons.report, color: Color(0xff1D2925)),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReportsScreen()));
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
                            _popup(context);
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
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
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

class ProfileCard extends StatelessWidget {
  final ProfileModel profile;
  const ProfileCard({
    Key key,
    @required this.profile,
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
        margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 12.0, bottom: 8.0),
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xff1D2952),
              foregroundColor: Colors.white,
              radius: 40,
              child: Image.network(
                profile.profilePhoto,  fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
                errorBuilder: (c, n, o) =>
                    Icon(Icons.account_circle, color: Colors.white, size: 40),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  style: TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                ),
                Text(
                  "User ID",
                  style: TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                ),
                Text(
                  "Mobile",
                  style: TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ":",
                  style: TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                ),
                Text(
                  ":",
                  style: TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                ),
                Text(
                  ":",
                  style: TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fieldOfficerName == null
                      ? "N/A"
                      : "${profile.fieldOfficerName.toUpperCase()}",
                  style: TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                ),
                Text(
                  "$userId",
                  style: TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                ),
                Text(
                  "$mobile",
                  style: TextStyle(fontSize: 16, color: Color(0xff1D2952)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Grids extends StatelessWidget {
  final String footer;
  final String child;
  final Function onTap;
  const Grids({Key key, this.footer, this.child, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        decoration: BoxDecoration(
            color: Colors.orange[50], borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new Container(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: new CircleAvatar(
                radius: 40,
                backgroundColor: Colors.orange[100],
                child: Image.asset(child, fit: BoxFit.cover),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5, 2, 5, 0),
              child: Text(footer,
                  style: (TextStyle(
                      fontFamily: 'JosefinSans',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange)),
                  maxLines: 2,
                  textAlign: TextAlign.center),
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
// footer: Container(
//   padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
//   child: Text(categoriesList.list[index]["name"],
//       style: (TextStyle(
//           fontFamily: 'JosefinSans',
//           fontSize: 12,
//           color: Colors.orange)),
//       maxLines: 2,
//       textAlign: TextAlign.center),
// ),
// child: new Container(
//   child: new GestureDetector(
//     child: SizedBox(
//       child: new Container(
//         decoration: BoxDecoration(
//             color: Colors.orange[50],
//             borderRadius: BorderRadius.circular(10)),
//         child: new CircleAvatar(
//           radius: 40,
//           child: Image.asset(
//               categoriesList.list[index]["image"],
//               fit: BoxFit.cover),
//         ),
//         padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//       ),
//     ),
//   ),
// ),
