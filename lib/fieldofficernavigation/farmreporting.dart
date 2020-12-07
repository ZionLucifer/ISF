import 'package:apps/farmreporting/farm_work_reporting.dart';
import 'package:apps/fieldofficerdash.dart';
import 'package:apps/fieldofficernavigation/pending_requests.dart';
import 'package:apps/fieldofficernavigation/reports_screen.dart';
import 'package:apps/loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/overview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'fundrequest.dart';

class farm extends StatefulWidget {
  @override
  _farmState createState() => _farmState();
}

class _farmState extends State<farm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController searchController = new TextEditingController();
  TextEditingController searchMobileController = new TextEditingController();
  TextEditingController searchFarmController = new TextEditingController();
  TextEditingController searchCropController = new TextEditingController();
  SharedPreferences sharedPreferences;
  String userId;
  String mobile, fundRequestId, farmId, purpose, amount, approvedStatus;
  String filter;
  List<Overview> farmList;
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

  bool nodata;
  Future<List<Overview>> _getOverViewInfo() async {
    var response = await http
        .post("http://isf.breaktalks.com/appconnect/farmlist.php", body: {
      "field_officer_id": userId,
    });
    var value = json.decode(response.body);
    var farmlist = value['farm_list'];
    nodata = value['message'].toString().trim() == 'No data Found';
    if (response.statusCode == 200) {
      List spacecrafts = farmlist;
      farmList = spacecrafts
          .map((spacecraft) => new Overview.fromJson(spacecraft))
          .toList();
      print(farmList[0]);
      return farmList;
    } else
      throw Exception(
          'We were not able to successfully download the json data.');
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    _getData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Farm List',
          style: TextStyle(
              fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: Builder(
          builder: (context) => InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, color: Colors.white)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
                onTap: () {
                  showSearch(
                      context: context, delegate: FarmSearchDelegate(farmList));
                },
                child: Icon(Icons.search, size: 30.0, color: Colors.white)),
          )
        ],
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: FutureBuilder<List<Overview>>(
                      future: _getOverViewInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (nodata ?? false) {
                            return Center(
                                child: Container(child: Text('No Data Found')));
                          }
                          if (snapshot.hasData) {
                            List<Overview> overview = snapshot.data;
                            return new FarmListView(overview);
                          }
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                ),
              ],
            );
          }, childCount: 1))
        ],
      ),
    );
  }
}

class Contact {
  final String fullName;
  final String location;

  const Contact({this.fullName, this.location});
}

// ignore: must_be_immutable
class FarmListView extends StatelessWidget {
  final List<Overview> farmList1;
  FarmListView(this.farmList1);
  SharedPreferences sp;

  Widget build(context) {
    return ListView.separated(
      separatorBuilder: (ctx, idx) {
        return Divider(height: 2, thickness: 2, indent: 5, endIndent: 5);
      },
      scrollDirection: Axis.vertical,
      itemCount: farmList1.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(farmList1[currentIndex], context, currentIndex);
      },
    );
  }

  Widget createViewItem(Overview farmList, BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FarmWorkReporting(farmInfo: farmList)));
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.16,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.orange[100],
                        child: Image.network(farmList.profilePhoto,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (c, n, o) => Icon(
                                Icons.account_circle,
                                color: Colors.white))),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Farmer Name"),
                      SizedBox(
                        height: 2,
                      ),
                      Text("Farmer ID"),
                      SizedBox(
                        height: 2,
                      ),
                      Text("Farm ID"),
                      SizedBox(
                        height: 2,
                      ),
                      Text("Base Location"),
                      SizedBox(
                        height: 2,
                      ),
                      Text("Crop"),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(":"),
                      SizedBox(height: 2),
                      Text(":"),
                      SizedBox(height: 2),
                      Text(":"),
                      SizedBox(height: 2),
                      Text(":"),
                      SizedBox(height: 2),
                      Text(":")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farmList.farmerName == null
                            ? "N/A"
                            : "${farmList.farmerName}",
                        style: TextStyle(
                            // color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        farmList.farmerId == null
                            ? "N/A "
                            : "${farmList.farmerId}",
                        style: TextStyle(
                            // color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        farmList.farmId == null ? "N/A " : "${farmList.farmId}",
                        style: TextStyle(
                            // color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        farmList.baseLocation == null
                            ? "N/A "
                            : "${farmList.baseLocation}",
                        style: TextStyle(
                            // color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        farmList.crops == null ? "N/A " : "${farmList.crops}",
                        style: TextStyle(
                            // color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Image.network(farmList.irrigation,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          // height: double.infinity,
                          errorBuilder: (c, n, o) => Icon(Icons.photo,
                              color: Colors.orange[200], size: 50))),
                )
              ],
            )),
      ),
    );
  }
}
