import 'dart:convert';
import 'package:apps/farmernavigation/req/detail_req.dart';
import 'package:apps/model/farmer_fund_req.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApprovedReq extends StatefulWidget {
  @override
  _ApprovedReqState createState() => _ApprovedReqState();
}

class _ApprovedReqState extends State<ApprovedReq> {
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

  Future<List<FarmerFundReq>> _getOverViewInfo() async {
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/farmfundreqlistbyfarmer.php",
        body: {"farmer_id": userId});

    var value = json.decode(response.body);
    var farmlist = value['approved'];

    if (response.statusCode == 200) {
      List spacecrafts = farmlist;

      return spacecrafts
          .map((spacecraft) => new FarmerFundReq.fromJson(spacecraft))
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
          padding: const EdgeInsets.all(8.0),
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.2,
              child: FutureBuilder<List<FarmerFundReq>>(
                  future: _getOverViewInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<FarmerFundReq> overview = snapshot.data;
                      return new FarmListView(overview);
                    } else if (snapshot.hasError) {
                      // return Center(
                      //     child:
                      //         Text('Please Wait while we check our Servers'));
                     return Center(
                    child: Container(child: new CircularProgressIndicator()));
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
  final List<FarmerFundReq> farmList1;
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
      FarmerFundReq farmList, BuildContext context, int index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailReq(farmerFundReq: farmList)));
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          height: 100,
          width: 200,
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Text(
              "${farmList.fundRequestId}",
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
