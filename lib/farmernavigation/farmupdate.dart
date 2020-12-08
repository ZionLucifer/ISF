import 'dart:convert';
import 'package:apps/farmerdashboard.dart';
import 'package:apps/loginpage.dart';
import 'package:apps/model/farmer_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'finance.dart';
import 'myrequest.dart';

class farmernoti extends StatefulWidget {
  final String userId;
  farmernoti({this.userId});
  @override
  _farmernotiState createState() => _farmernotiState();
}

class _farmernotiState extends State<farmernoti> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
  String userId, mobile;

  Future<List<FarmerNotification>> _getOverViewInfo() async {
    var response = await http.post(
        "https://breaktalks.com/isf/appconnect/getdata.php",
        body: {"farmer_id": userId});
    var value = json.decode(response.body);
    var farmlist = value;
    if (response.statusCode == 200) {
      List spacecrafts = farmlist;
      return spacecrafts
          .map((spacecraft) => new FarmerNotification.fromJson(spacecraft))
          .toList();
    } else
      throw Exception(
          'We were not able to successfully download the json data.');
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
      }
    });
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
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Farm Update",
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
          child: Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<FarmerNotification>>(
            future: _getOverViewInfo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<FarmerNotification> overview = snapshot.data;
                return (overview.length == 0)
                    ? Center(child: Text('No Data Found'))
                    : FarmListView(overview);
              } else if (snapshot.hasError) {
                return  Center(child: CircularProgressIndicator());
                // Center(child: Text('Error Occurs'));
              }
              return Center(
                  child: Container(
                      child: new CircularProgressIndicator(
                          backgroundColor: Colors.orange[300])));
            }),
      )),
      drawer: new Drawer(
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
                        "My Farm",
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
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => finance()));
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => request()));
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
    );
  }
}

class Noti extends StatefulWidget {
  final List list;
  const Noti({Key key, this.list}) : super(key: key);
  @override
  _NotiState createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  String textHolder = 'Unread';

  changeText() {
    setState(() {
      textHolder = 'Seen';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.list == null ? 0 : widget.list.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Card(
              shadowColor: Colors.orange,
              elevation: 2,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.list[i]['title'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              height: 1.6,
                              fontFamily: 'JosefinSans',
                              color: Colors.orange),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Text(
                          widget.list[i]['description'],
                          style: TextStyle(
                              fontSize: 18.0,
                              height: 1.6,
                              fontFamily: 'JosefinSans',
                              color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: FlatButton(
                            onPressed: () {
                              _displaydialog(context);
                            },
                            child: Text(
                              "Reply",
                              style: (TextStyle(
                                  fontFamily: 'JosefinSans',
                                  color: Colors.orange)),
                            ),
                          ))
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: FlatButton(
                            onPressed: () {
                              changeText();
                            },
                            child: Text(
                              '$textHolder',
                              style: (TextStyle(
                                  fontFamily: 'JosefinSans',
                                  backgroundColor: Colors.orange[300])),
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

_displaydialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Reply',
            style: TextStyle(fontFamily: 'JosefinSans'),
          ),
          content: TextField(
            controller: _textfield,
            decoration: InputDecoration(hintText: "Type Your message"),
          ),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  senddata();
                },
                child: new Text(
                  'Send',
                  style: TextStyle(
                      fontFamily: 'JosefinSans',
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                ))
          ],
        );
      });
}

TextEditingController _textfield = TextEditingController();
// ignore: missing_return


Future<List> senddata() async {
  final response = await http.post(
      "https://breaktalks.com/isf/appconnect/sendmessage.php",
      body: {"send_receive_message": _textfield.text, "sender_id": 'INV001'});

  name();
}

void name() {
  _textfield.clear();
}

// ignore: must_be_immutable
class FarmListView extends StatelessWidget {
  final List<FarmerNotification> farmList1;
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
      FarmerNotification farmList, BuildContext context, int index) {
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
            leading: CircleAvatar(
              backgroundColor: Colors.orange[300],
              child: Text(
                "${farmList.id}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              farmList.description.toString() != ""
                  ? "${farmList.description}"
                  : "N/A",
              style: TextStyle(
                color: Color(0xff1D2952),
              ),
            ),
            subtitle: Text(
              farmList.timestamp.toString() != ""
                  ? "${farmList.timestamp}"
                  : "N/A",
              style: TextStyle(
                color: Color(0xff1D2952),
              ),
            ),
          )),
    );
  }
}
