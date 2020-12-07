import 'dart:convert';
import 'package:apps/farmreporting/add_new_record.dart';
import 'package:apps/farmreporting/detail_record_activities.dart';
import 'package:apps/fieldofficernavigation/fundrequest.dart';
import 'package:apps/model/overview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/records.dart';
import 'package:intl/intl.dart';

class RecordActivities extends StatefulWidget {
  RecordActivities({this.farmInfo});
  final Overview farmInfo;

  @override
  _RecordActivitiesState createState() => _RecordActivitiesState();
}

class _RecordActivitiesState extends State<RecordActivities> {
  SharedPreferences sharedPreferences;
  String userId;
  String mobile, fundRequestId, farmId, purpose, amount, approvedStatus;
  String filter;
  List<Records> farmList;
  _getData() async {
    print(widget.farmInfo.farmId);
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

  bool nodata;

//this api shows the list of all the  record! got it??@vignesh???
  Future<List<Records>> _getRecordInfo() async {
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/recordactivitieslist.php",
        body: {"field_officer_id": userId, "farm_id": widget.farmInfo.farmId});

    var value = json.decode(response.body);
    var farmlist = value['activity_title'];
    nodata = value['message'].toString().trim() == 'No data Found';
    print('>>$value');
    if (response.statusCode == 200) {
      List spacecrafts = farmlist;
      farmList = spacecrafts
          .map((spacecraft) => new Records.fromJson(spacecraft))
          .toList();
      return farmList;
    } else
      throw Exception(
          'We were not able to successfully download the json data.');
  }

  @override
  void initState() {
    super.initState();
    print("This is the overView screen: ${widget.farmInfo.fieldOfficerId}");
    _getData();
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Record Activities",
          textAlign: TextAlign.center,
          style: (TextStyle(fontFamily: 'JosefinSans', color: Colors.white)),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
                onTap: () {
                  showSearch(
                      context: context,
                      delegate: RecordSearchDelegate(farmList));
                },
                child: Icon(Icons.search, size: 30.0, color: Colors.white)),
          )
        ],
      ),
      body: SafeArea(
          child: ListView(children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.farmInfo.farmerId} :",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  Text("${widget.farmInfo.farmerName} ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.grey[200], spreadRadius: 2)],
                  color: Colors.white),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              height: MediaQuery.of(context).size.height / 1.25,
              child: FutureBuilder<List<Records>>(
                  future: _getRecordInfo(),
                  builder: (context, snapshot) {
                    // if (snapshot.hasData) {
                    //   List<Records> overview = snapshot.data;
                    //   if (_currentIndex == 0) {
                    //     overview.removeWhere((e) => e.status != '0');
                    //   } else {
                    //     overview.removeWhere((e) => e.status == '0');
                    //   }
                    //   return new FarmListView(overview);
                    // } else if (snapshot.hasError) {
                    //   // return Center(
                    //   //     child: Text('Please Wait While we Load From Servers'));
                    //   return Center(
                    //       child: Container(child: new CircularProgressIndicator()));
                    // }
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (nodata ?? false) {
                        return Center(
                            child: Container(child: Text('No Data Found')));
                      }
                      List<Records> overview = snapshot.data;
                      if (_currentIndex == 0) {
                        overview.removeWhere((e) => e.endDate != '');
                      } else {
                        overview.removeWhere((e) => e.endDate == '');
                      }
                      return new FarmListView(overview);
                    }
                    return Center(
                        child: Container(child: new CircularProgressIndicator()));
                  }),
            ),
            SizedBox(height: 20)
          ])),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[300],
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNewRecord(
                    farmInfo: widget.farmInfo,
                  )));
        },
        child: Icon(Icons.add, color: Colors.white),
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
            icon: Icon(Icons.run_circle),
            label: ("InProgress"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: ("Completed"),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class FarmListView extends StatelessWidget {
  final List<Records> farmList1;
  FarmListView(this.farmList1);
  SharedPreferences sp;

  Widget build(context) {
    return ListView.separated(
      // separatorBuilder: (ctx, idx) => SizedBox.shrink(),
      separatorBuilder: (ctx, idx) =>
          Divider(indent: 10, endIndent: 10, height: 2, color: Colors.black87),
      itemCount: farmList1.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(farmList1[currentIndex], context, currentIndex);
      },
    );
  }

  Widget createViewItem(Records farmList, BuildContext context, int index) {
    String date =
    DateFormat('dd/MM/yyyy').format(DateTime.parse(farmList.startDate));
    return Container(
      child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailRecordActivities(farmInfo: farmList, )));
          },
          title: Text(
            "${farmList.activityTitle}",
            style: TextStyle(color: Color(0xff4749A0), fontSize: 18),
          ),
          trailing: Text(
              "${farmList.endDate == '' ? 'InProgress' : 'Completed'}",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("${farmList.activityId}"),
              Text("Start Date: $date", style: TextStyle(fontSize: 14)),
            ],
          )),
    );
  }
}

class RecordSearchDelegate extends SearchDelegate {
  final List<Records> farmList1;
  RecordSearchDelegate(this.farmList1);

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
    List<Records> farm = farmList1.where((element) {
      print(element.activityId);
      return element.farmId.contains(query) ||
          element.fieldOfficerId.contains(query) ||
          element.activityTitle.toLowerCase().contains(query) ||
          element.description.toLowerCase().contains(query) ||
          element.activityId.toLowerCase().contains(query.toLowerCase());
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

  Widget createViewItem(Records farmList, BuildContext context, int index) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DetailRecordActivities(farmInfo: farmList)));
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(
              "${farmList.activityTitle}",
              style: TextStyle(
                color: Color(0xff4749A0),
              ),
            ),
            subtitle: Text(
              "${farmList.activityId}",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
// Card(
//   elevation: 5,
//   margin: EdgeInsets.all(7),
//   shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.all(Radius.circular(15))),
//   child: Container(
//     padding: EdgeInsets.all(5),
//     height: MediaQuery.of(context).size.height / 8,
//     width: MediaQuery.of(context).size.width,
//     decoration: BoxDecoration(
//       border: Border.all(color: Colors.black),
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(height: 5),
//         Container(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Farmer Name : ",
//                 style: TextStyle(color: Colors.black, fontSize: 15),
//               ),
//               Text("${widget.farmInfo.farmerName} ",
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold)),
//             ],
//           ),
//         ),
//         SizedBox(height: 4),
//         Text("${widget.farmInfo.farmId} ",
//             style: TextStyle(color: Colors.black, fontSize: 15)),
//       ],
//     ),
//   ),
// ),
