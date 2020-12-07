import 'dart:convert';
import 'package:apps/fieldofficernavigation/pending/detail_approved_farm.dart';
import 'package:apps/model/pendingListModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApprovedFarmRequests extends StatefulWidget {
  @override
  _ApprovedFarmRequestsState createState() => _ApprovedFarmRequestsState();
}

class _ApprovedFarmRequestsState extends State<ApprovedFarmRequests> {
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
  Future<List<PendingListModel>> _getPendingFarmer() async {
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/pendingapi.php",
        body: {"field_officer_id": userId, "type": "farm", "status": "0"});

    var value = json.decode(response.body);
    print("Farmlist");
    print(value);
    var farmlist = value['result'];
    nodata = value['message'].toString().trim() == 'No data Found';

    if (response.statusCode == 200) {
      List spacecrafts = farmlist;
      return spacecrafts
          .map((spacecraft) => new PendingListModel.fromJson(spacecraft))
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
          child: FutureBuilder<List<PendingListModel>>(
              future: _getPendingFarmer(),
              builder: (context, snapshot) {
                // if (snapshot.hasData) {
                //   List<PendingListModel> overview = snapshot.data;
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
                    List<PendingListModel> overview = snapshot.data;
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
  final List<PendingListModel> farmList1;
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
      PendingListModel farmList, BuildContext context, int index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailApprovedFarm(farmInfo: farmList)));
          },
          child: ListTile(
            contentPadding: EdgeInsets.all(5),
            leading: CircleAvatar(
                backgroundColor: Colors.orange[300],
                child: Icon(Icons.photo_album, color: Colors.white)),
            title: Text("${farmList.farmId}",
                style: TextStyle(color: Colors.black)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${farmList.timestamp}"),
              ],
            ),
            trailing: IconButton(
                icon: Icon(
                  Icons.arrow_right,
                  color: Colors.orange[300],
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => DetailApprovedFarm(
                            farmInfo: farmList,
                          )));
                }),
          )),
    );
  }
}
