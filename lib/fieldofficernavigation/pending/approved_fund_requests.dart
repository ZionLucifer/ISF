import 'dart:convert';
import 'package:apps/fieldofficernavigation/pending/detail_approve_fund.dart';
import 'package:apps/model/pending_fund_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApprovedFundRequests extends StatefulWidget {
  @override
  _ApprovedFundRequestsState createState() => _ApprovedFundRequestsState();
}

class _ApprovedFundRequestsState extends State<ApprovedFundRequests> {
  SharedPreferences sharedPreferences;
  String userId, mobile;
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
  Future<List<PendingFundModel>> _getPendingFarmer() async {
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/pendingapi.php",
        body: {"field_officer_id": userId, "type": "fund", "status": "0"});

    var value = json.decode(response.body);
    print("Farmlist");
    print(value);
    var farmlist = value['result'];
    nodata = value['message'].toString().trim() == 'No data Found';
    if (response.statusCode == 200) {
      List spacecrafts = farmlist;

      return spacecrafts
          .map((spacecraft) => new PendingFundModel.fromJson(spacecraft))
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
        body: SafeArea(
            child: ListView(
      shrinkWrap: true,
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 1.2,
          child: FutureBuilder<List<PendingFundModel>>(
              future: _getPendingFarmer(),
              builder: (context, snapshot) {
                // if (snapshot.hasData) {
                //   List<PendingFundModel> overview = snapshot.data;
                //   print(snapshot.data);
                //   return new FarmListView(overview);
                // } else if (snapshot.hasError) {
                //   return Center(
                //       child: Text('Please Wait while we fetch from Servers'));
                // }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (nodata ?? false) {
                    return Center(
                        child: Container(child: Text('No Data Found')));
                  }
                  if (snapshot.hasData) {
                    List<PendingFundModel> overview = snapshot.data;
                    return new FarmListView(overview);
                  }
                }
                return Center(
                    child: Container(child: CircularProgressIndicator()));
              }),
        )
      ],
    )));
  }
}

// ignore: must_be_immutable
class FarmListView extends StatelessWidget {
  final List<PendingFundModel> farmList1;
  FarmListView(this.farmList1);
  SharedPreferences sp;

  Widget build(context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: farmList1.length,
      itemBuilder: (context, int currentIndex) {
        print(farmList1[currentIndex]);
        return createViewItem(farmList1[currentIndex], context, currentIndex);
      },
    );
  }

  Widget createViewItem(
      PendingFundModel farmList, BuildContext context, int index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailApproveFund(farmInfo: farmList)));
          },
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            leading: CircleAvatar(
                backgroundColor: Colors.orange[300],
                child: Icon(Icons.account_circle, color: Colors.white)),
            title: Text("${farmList.farmId}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Req ID   : ${farmList.fundRequestId}"),
                if (farmList?.approvedTimestamp?.isNotEmpty ?? false)
                  Text("Req On :${farmList.approvedTimestamp}"),
              ],
            ),
            trailing: IconButton(
                icon: Icon(
                  Icons.arrow_right,
                  color: Colors.orange[300],
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => DetailApproveFund(
                            farmInfo: farmList,
                          )));
                }),
          )),
    );
  }
}
