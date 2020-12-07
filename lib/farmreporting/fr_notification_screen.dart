import 'dart:convert';
import 'package:apps/farmreporting/add_new_notification.dart';
import 'package:apps/farmreporting/detail_notification.dart';
import 'package:apps/model/notification.dart';
import 'package:apps/model/overview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FRNotificationScreen extends StatefulWidget {
  final Overview farmInfo;
  FRNotificationScreen({this.farmInfo});
  @override
  _FRNotificationScreenState createState() => _FRNotificationScreenState();
}

class _FRNotificationScreenState extends State<FRNotificationScreen> {
  TextEditingController searchController = new TextEditingController();
  SharedPreferences sharedPreferences;
  String userId;
  List _expenseList;
  _getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (userId == "") {
        userId = (sharedPreferences.getString('user_id') ?? '');
        print("test IF");
        print(userId);
      } else {
        userId = (sharedPreferences.getString('user_id') ?? '');
        print("Test Else");
        print(userId);
      }
    });
    print(widget.farmInfo.farmId);
  }

  Future<List<NotificationData>> _getNotifications() async {
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/notificationlist.php",
        body: {"field_officer_id": widget.farmInfo.fieldOfficerId});
    var data = jsonDecode(response.body)["activity_title"];
    if (response.statusCode == 200) {
      List spacecrafts = data;

      _expenseList = spacecrafts
          .map((spacecraft) => new NotificationData.fromJson(spacecraft))
          .toList();
      return _expenseList;
    } else
      throw Exception(
          'We were not able to successfully download the json data.');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    _getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          "Farmer Notify",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
                onTap: () {
                  showSearch(
                      context: context,
                      delegate: NotificationSearchDelegate(_expenseList));
                },
                child: Icon(
                  Icons.search,
                  size: 30.0,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 140,
                        child: Text( "Farmer Name",
                            style: TextStyle(
                                color: Colors.black, fontSize: 17)),
                      ),
                      Text(':'),
                      Text(" ${widget.farmInfo.farmerName}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 7),
                  Row(
                    children: [
                      Container(
                        width: 140,
                        child: Text(" Location",
                            style: TextStyle(
                                color: Colors.black, fontSize: 17)),
                      ),
                      Text(':'),
                      Text(" ${widget.farmInfo.baseLocation}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(width: 10),
                ],
              ),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.grey[400], spreadRadius: 2, blurRadius: 2)
              ], color: Colors.white),
            ),
            // Container(
            //   padding: const EdgeInsets.all(8.0),
            //   width: MediaQuery.of(context).size.width,
            //   decoration: BoxDecoration(
            //       border: Border.all(color: Colors.black54),
            //       borderRadius: BorderRadius.circular(10)),
            //   child: Column(
            //     children: [
            //       Text(
            //         "Farmer's ID: ${widget.farmInfo.farmerName}",
            //         textAlign: TextAlign.center,
            //         style: TextStyle(color: Colors.black, fontSize: 22),
            //       ),
            //       SizedBox(
            //         height: 3,
            //       ),
            //       Text(
            //         "Base Location: ${widget.farmInfo.baseLocation}",
            //         textAlign: TextAlign.center,
            //         style: TextStyle(color: Colors.black, fontSize: 22),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height / 1.7,
              child: FutureBuilder<List<NotificationData>>(
                  future: _getNotifications(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<NotificationData> overview = snapshot.data;
                      print(snapshot.data);
                      return new FarmListView(overview);
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              'Please wait While we Fetch From Servers'));
                    }
                    return Center(
                        child: Container(
                            child: new CircularProgressIndicator(
                                backgroundColor: Colors.orange[300])));
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[300],
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddNewNotification(farmInfo: widget.farmInfo)));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class FarmListView extends StatelessWidget {
  final List<NotificationData> farmList1;
  FarmListView(this.farmList1);
  SharedPreferences sp;

  Widget build(context) {
    return ListView.separated(
      separatorBuilder: (c, i) => Divider(height: 3, thickness: 1.5),
      scrollDirection: Axis.vertical,
      itemCount: farmList1.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(farmList1[currentIndex], context, currentIndex);
      },
    );
  }

  Widget createViewItem(
      NotificationData farmList, BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetailNotification(notiInfo: farmList)));
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(
            "${farmList.title}",
            style: TextStyle(color: Color(0xff4749A0)),
          ),
          subtitle: Text("${farmList.notificationId}",
              style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}

class NotificationSearchDelegate extends SearchDelegate {
  final List<NotificationData> farmList1;
  NotificationSearchDelegate(this.farmList1);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    print("q-" + query);
    List<NotificationData> farm = farmList1.where((element) {
      return element.description.toLowerCase().contains(query.toLowerCase()) ||
          element.notificationId.toLowerCase().contains(query.toLowerCase()) ||
          element.title.toLowerCase().contains(query.toLowerCase()) ||
          element.fieldOfficerId.toLowerCase().contains(query.toLowerCase());
    }).toList();
    if (farm.isEmpty) {
      return Center(
        child: Text("No Result Present"),
      );
    }
    return ListView.builder(
      itemCount: farm.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(farm[currentIndex], context, currentIndex);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }

  Widget createViewItem(
      NotificationData farmList, BuildContext context, int index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DetailNotification(notiInfo: farmList)));
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(
              "${farmList.title}",
              style: TextStyle(
                color: Color(0xff4749A0),
              ),
            ),
            subtitle: Text(
              "${farmList.notificationId}",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
