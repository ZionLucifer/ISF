import 'dart:convert';

import 'package:apps/investordash.dart';
import 'package:apps/investornavigation/detail_portfolio.dart';
import 'package:apps/model/invester_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
      }
    });
  }

  Future<List<InvesterPortFolio>> _getOverViewInfo() async {
    var response = await http.post(
        "http://breaktalks.com/isf/appconnect/getInvestdetailsbyinvestorId.php",
        body: {"invester_id": userId});
    var value = json.decode(response.body);
    print('RES :: $value');
    var farmlist = value;
    if (response.statusCode == 200) {
      List spacecrafts = farmlist;
      return spacecrafts
          .map((spacecraft) => new InvesterPortFolio.fromJson(spacecraft))
          .toList();
    } else
      throw Exception(
          'We were not able to successfully download the json data.');
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
          "Portfolio",
          textAlign: TextAlign.center,
          style: (TextStyle(fontFamily: 'JosefinSans', color: Colors.white)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => investorss()),
                (route) => false);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<List<InvesterPortFolio>>(
              future: _getOverViewInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<InvesterPortFolio> overview = snapshot.data;
                  return (overview.length == 0)
                      ? Center(child: Text('No Data Found'))
                      : FarmListView(overview);
                }
                return Center(
                    child: new CircularProgressIndicator(
                        backgroundColor: Colors.orange));
              }),
        ),
      ),
    );
  }
}

class FarmListView extends StatelessWidget {
  final List<InvesterPortFolio> farmList1;
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
      InvesterPortFolio farmList, BuildContext context, int index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailPortfolio(investerPortFolio: farmList)));
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange[300],
              child: Text(
                farmList.id.toString() != "" ? "${farmList.id}" : "N/A",
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              farmList.investProfitId.toString() != ""
                  ? "${farmList.investProfitId}"
                  : "N/A",
              style: TextStyle(
                color: Color(0xff1D2952),
              ),
            ),
            subtitle: Text('Farm ID: ${farmList.farmId ?? ''}',
                style: TextStyle(fontSize: 12)),
            trailing: Text(
              farmList.totalAmountInvested.toString() != ""
                  ? "₹${farmList.totalAmountInvested}"
                  : "N/A",
              style: TextStyle(
                  color: Color(0xff1D2952),
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          )),
    );
  }
}
