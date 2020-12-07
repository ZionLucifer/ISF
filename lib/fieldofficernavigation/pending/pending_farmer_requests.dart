import 'dart:convert';
import 'package:apps/fieldofficernavigation/pending/detail_pending_farmer.dart';
import 'package:apps/model/pending_farmer_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PendingFarmerRequests extends StatefulWidget {
  final String userId;
  _PendingFarmerRequestsState requestsState;
  PendingFarmerRequests({this.userId});

  @override
  _PendingFarmerRequestsState createState() {
    requestsState = _PendingFarmerRequestsState();
    return requestsState;
  }

  List getFarmerList() {
    return requestsState.getFarmerData();
  }
}

class _PendingFarmerRequestsState extends State<PendingFarmerRequests> {
  SharedPreferences sharedPreferences;
  String userId, mobile;
  List _farmerList;
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
  Future<List<PendingFarmerModel>> _getPendingFarmer() async {
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/pendingapi.php",
        body: {"field_officer_id": userId, "type": "farmer", "status": "1"});

    var value = json.decode(response.body);
    print("Farmlist");
    print(value);
    var farmlist = value['result'];
    nodata = value['message'].toString().trim() == 'No data Found';
    if (response.statusCode == 200) {
      List spacecrafts = farmlist;
      _farmerList = spacecrafts
          .map((spacecraft) => new PendingFarmerModel.fromJson(spacecraft))
          .toList();
      return _farmerList;
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
          child: FutureBuilder<List<PendingFarmerModel>>(
              future: _getPendingFarmer(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (nodata ?? false) {
                    return Center(
                        child: Container(child: Text('No Data Found')));
                  }
                  if (snapshot.hasData) {
                    List<PendingFarmerModel> overview = snapshot.data;
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

  List getFarmerData() {
    return _farmerList;
  }
}

// ignore: must_be_immutable
class FarmListView extends StatelessWidget {
  final List<PendingFarmerModel> farmList1;
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
      PendingFarmerModel farmList, BuildContext context, int index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailPendingFarmer(farmInfo: farmList)));
          },
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            leading: CircleAvatar(
                backgroundColor: Colors.orange[300],
                child: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                )),
            title: Text(
              "${farmList.farmerName}",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ID: ${farmList.farmerId}"),
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
                      builder: (ctx) => DetailPendingFarmer(
                            farmInfo: farmList,
                          )));
                }),
          )),
    );
  }
}
