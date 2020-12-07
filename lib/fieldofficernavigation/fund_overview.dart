import 'dart:convert';
import 'package:apps/fieldofficernavigation/expense_overview.dart';
import 'package:apps/model/fo_overview.dart';
import 'package:apps/model/overview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FundOverview extends StatefulWidget {
  final Overview farmInfo;
  FundOverview({this.farmInfo});
  @override
  _FundOverviewState createState() => _FundOverviewState();
}

class _FundOverviewState extends State<FundOverview> {
  SharedPreferences sharedPreferences;
  String userId, mobile;
  List<ExpenceList> expencelist = [];
  FarmDetails farmdets;
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

  Future _getOverViewInfo() async {
    // http://isf.breaktalks.com/appconnect/farmexpenselist.php
    var response = await http.post(
        'http://isf.breaktalks.com/appconnect/farmexpenselist.php',
        body: {"field_officer_id": userId, "farm_id": widget.farmInfo.farmId});
    var responsetwo = await http.post(
        'http://isf.breaktalks.com/appconnect/farmdetail.php',
        body: {"field_officer_id": userId, "farm_id": widget.farmInfo.farmId});
    List value = json.decode(response.body)['expense_list'];
    print('$value << ');
    List valuetwo = json.decode(responsetwo.body)['farm_detail'];
    expencelist = [];
    value.forEach((e) {
      expencelist.add(ExpenceList.fromMap(e));
    });
    farmdets = FarmDetails.fromMap(valuetwo.first);
    if (response.statusCode == 200) {
    } else
      throw Exception(
          'We were not able to successfully download the json data.');
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Widget details(String one, String two) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(one ?? '--', style: TextStyle(fontSize: 16))),
          Expanded(
              child: Text(two ?? '-',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  overflow: TextOverflow.clip)),
        ],
      ),
    );
  }

// id, amout, puropose
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fund Details",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 1.1,
          child: FutureBuilder(
              future: _getOverViewInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return body();
                }
                return Center(
                    child: Container(
                        child: new CircularProgressIndicator()));
              }),
        ),
      ),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          farmdetails(),
          SizedBox(height: 7),
          Container(
            color: Colors.orange[100],
            padding: const EdgeInsets.all(8.8),
            child: Text("Expense Details",
                style: TextStyle(color: Color(0xff4749A0), fontSize: 18)),
          ),
          SizedBox(height: 7),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: expencelist.length,
            separatorBuilder: (c, i) => Divider(height: 2),
            itemBuilder: (c, i) => ListTile(
                title: Text('Farm ID: ${expencelist[i].id ?? 'N\A'}',
                    style: TextStyle(fontSize: 18)),
                subtitle: Text('Purpose : ${expencelist[i].purpose ?? 'N\A'}',
                    style: TextStyle(fontSize: 16)),
                trailing: Text(expencelist[i].amount,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
    );
  }

  Widget farmdetails() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.grey[300]),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Farm ID: ${widget.farmInfo.farmId}",
                  style: TextStyle(color: Colors.black, fontSize: 18)),
              Text(
                int.parse(farmdets.farmstatus) != 0
                    ? 'Not Started'
                    : 'In progress',
                style: TextStyle(
                    color: int.parse(farmdets.farmstatus) == 0
                        ? Colors.green
                        : Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 7),
        Container(
          color: Colors.orange[100],
          padding: const EdgeInsets.all(8.8),
          child: Text("Farm Details",
              style: TextStyle(color: Color(0xff4749A0), fontSize: 18)),
        ),
        SizedBox(height: 18),
        details("Farmer Name", farmdets.farmname),
        Divider(color: Colors.black),
        details("Crop", farmdets.cropname),
        Divider(color: Colors.black),
        details("Activity Completed", farmdets.activitycompleted),
        Divider(color: Colors.black),
        details("Activity InProgress", farmdets.actinprogress),
        Divider(color: Colors.black),
        details("Last Activity Date", farmdets.lastdate),
        Divider(color: Colors.black),
        details("Total Expense", farmdets.totalexpence),
        Divider(color: Colors.black),
      ],
    );
  }
}
