import 'dart:convert';
import 'package:apps/farmernavigation/farms/detail_farms.dart';
import 'package:apps/farmreporting/farm_work_reporting.dart';
import 'package:apps/model/farmer_get_all_farms.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PendingFarms extends StatefulWidget {
  @override
  _PendingFarmsState createState() => _PendingFarmsState();
}

class _PendingFarmsState extends State<PendingFarms> {
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
  Future<List<FarmerGetAllFarms>> _getOverViewInfo() async {
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/farmgetall.php",
        body: {"farmer_id": userId});

    var value = json.decode(response.body);
    var farmlist = value['others'];
    nodata = value['message'].toString().trim()  == 'No data Found';
    print(farmlist);
    if (response.statusCode == 200) {
      List spacecrafts = farmlist;
      return spacecrafts
          .map((spacecraft) => new FarmerGetAllFarms.fromJson(spacecraft))
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
    _getOverViewInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.2,
              child: FutureBuilder<List<FarmerGetAllFarms>>(
                  future: _getOverViewInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<FarmerGetAllFarms> overview = snapshot.data;
                      print(overview);
                      if (nodata ?? false) {
                        return Center(
                            child: Container(child: Text('No Data Found')));
                      }
                      return new FarmListView(overview);
                    } else if (snapshot.hasError) {
                      // return Center(
                      //     child:
                      //         Text('Please Wait while we check our Servers'));
                      return Center(
                          child: Container(
                              child: new CircularProgressIndicator()));
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
    );
  }
}

// ignore: must_be_immutable
class FarmListView extends StatelessWidget {
  final List<FarmerGetAllFarms> farmList1;
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
      FarmerGetAllFarms farmList, BuildContext context, int index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DetailFarms(farmerGetAllFarms: farmList)));
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          height: 100,
          width: 200,
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Text(
              "${farmList.farmId}",
              style: TextStyle(
                color: Color(0xff1D2952),
              ),
            ),
          ),
        ),
      ),
    );
  }
}