import 'dart:convert';
import 'package:apps/dashboard.dart';
import 'package:apps/investordash.dart';
import 'package:apps/model/investor_farm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'InvestorDrawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:collection';

class Farms extends StatefulWidget {
  @override
  _FarmsState createState() => _FarmsState();
}


class _FarmsState extends State<Farms> {
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
        mobile = (sharedPreferences.getString('mobile') ?? '');
      }
    });
  }


Future<List<InvestorFarm>> _getOverViewInfo() async {
    print('...');
    var response = await http.post(
        "https://breaktalks.com/isf/appconnect/investerfarmbyinvesterId.php");
    var value = json.decode(response.body);
    //print("Farmlist");
    print(value.legth);
    var farmlist = value;
    if (response.statusCode == 200) {
      List spacecrafts = farmlist;
      return spacecrafts
          .map((spacecraft) => new InvestorFarm.fromJson(spacecraft))
          .toList();
    } else
      throw Exception(
          'We were not able to successfully download the json data.');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Forms'),
      ),
      body: Container(
        child: FutureBuilder( 
          future: _getOverViewInfo(),
          builder: (BuildContext context , AsyncSnapshot snapshot){
            if(snapshot.hasData){
               return snapshot.data.length;
            }
            return Center(child: CircularProgressIndicator());
           
          },),
        ),
      );
  }
}