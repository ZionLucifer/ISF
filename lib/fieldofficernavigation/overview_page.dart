import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_table/json_table.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:apps/fieldofficerdash.dart';
import 'package:apps/fieldofficernavigation/fund_overview.dart';

import '../model/overview.dart';

class OverviewPage extends StatefulWidget {
  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  SharedPreferences sharedPreferences;
  String userId;
  String mobile, fundRequestId, farmId, purpose, amount, approvedStatus;
  Future<Overview> fetchOverView;
  // List _fund, _expense;

  Map fund, expense;
  Overview farmlist;

  var fundsColumns = [
    JsonTableColumn("fund_request_id", label: "Fund Request ID"),
    JsonTableColumn("farm_id", label: "Farm ID"),
    JsonTableColumn("amount", label: "Amount")
  ];

  var expenseColumns = [
    JsonTableColumn("farm_id", label: "Farm ID"),
    JsonTableColumn("noofunits", label: "No. of Units"),
    JsonTableColumn("unitcost", label: "Unit Cost"),
    JsonTableColumn("amount", label: "Amount"),
    JsonTableColumn("fund_request_id", label: "Fund Request ID")
  ];

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
    // var response = await http.post(
    //     "http://isf.breaktalks.com/appconnect/fieldofficeroverview.php",
    //     body: {"field_officer_id": userId});
    // var data = jsonDecode(response.body);
    // print(data);
    // setState(() {
    //   _fund = data["fund"] as List;
    //   _expense = data["expense"] as List;
    // });
  }

  bool nodata;
  OverModel overmod;
  Future<List<Overview>> _getOverViewInfo() async {
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/farmlistall.php",
        body: {"field_officer_id": userId});
    var responseover = await http.post(
        "http://isf.breaktalks.com/appconnect/fieldofficeroverview_new.php",
        body: {"field_officer_id": userId});
// http://isf.breaktalks.com/appconnect/fieldofficeroverview_new.php
    var value = json.decode(response.body);
    var valueove = json.decode(responseover.body);
    print('$value -- ${valueove['fo_overview'].first}');

    nodata = value['message'].toString().trim() == 'No data Found' &&
        valueove['message'].toString().trim() == 'No data Found';
    overmod = OverModel.fromMap(valueove['fo_overview'].first);
    var farmlist = value['farm_list'];
    if (response.statusCode == 200) {
      List spacecrafts = farmlist;

      return spacecrafts
          .map((spacecraft) => new Overview.fromJson(spacecraft))
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
      appBar: AppBar(
        title: Text("Farm List", style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => fielddash()));
            }),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(5),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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

                  // overview.removeWhere((e) => e.status != '0');
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        OverVierHead(overmod: overmod),
                        if (overview.length > 0)
                          Container(
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: Text(
                                'Farms',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center),
                        Divider(),
                        new FarmListViews(overview)
                      ],
                    ),
                  );
                  }
                }
                return Center(
                    child: Container(child: 
                    // Text('Error'),
                     new CircularProgressIndicator(),
                     ),
                     );
              }),
        ),
      ),
    );
  }
}

double totalFund;
double totalExpense;
double availableFund;
String sign;
class OverVierHead extends StatelessWidget {
  final OverModel overmod;
  const OverVierHead({Key key, this.overmod}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    totalFund = double.tryParse(overmod?.totalfund ?? '0');
    totalExpense = double.tryParse(overmod?.totalexpense ?? '0');
    availableFund = totalFund - totalExpense;

    if(totalFund >= totalExpense){
       sign = '+';
    }else
     sign = '-';
     print(overmod.farmcount);
     print(overmod.farmercount);
    

    Widget grid(String one, String two) {
      return Container(
        child: Card(
          elevation: 2,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text(one ?? '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                  decoration: BoxDecoration(color: Colors.orange[50]),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('${two ?? '0'}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[900]),
                        textAlign: TextAlign.center),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: grid('Farmer Count', overmod.farmercount)),
                Expanded(child: grid('Farm Count', overmod.farmcount)),
            
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: grid('Total Fund', '₹ ${totalFund ?? 0}')),
                    // child: grid('Total Fund', '₹ ${overmod?.totalfund ?? 0}')),
                Expanded(
                    child: grid(
                        'Total Expenses', '₹ ${totalExpense ?? 0}')),
                        // 'Total Expenses', '₹ ${overmod?.totalexpense ?? 0}')),
              ],
            ),
            grid('Total Available Fund',
            '$sign ₹ $availableFund'
            )
                // '$sign ₹ ${(double.tryParse(overmod?.totalfund ?? '0') ?? 0) -
                //  (double.tryParse(overmod?.totalexpense ?? '0') ?? 0)}'),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class FarmListViews extends StatelessWidget {
  final List<Overview> farmList1;
  FarmListViews(this.farmList1);
  SharedPreferences sp;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (cts, i) =>
          Divider(color: Colors.black38, thickness: 1, height: 2),
      scrollDirection: Axis.vertical,
      itemCount: farmList1.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(farmList1[currentIndex], context, currentIndex);
      },
    );
  }

  Widget row(String one, String two) {
    return Row(children: [
      Container(
          child: Text(one,
              textAlign: TextAlign.left, style: TextStyle(fontSize: 13)),
          width: 80),
      Text(' : '),
      Expanded(
          child: Text(two,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16))),
    ]);
  }

  Widget createViewItem(Overview farmList, BuildContext context, int index) {
    return ListTile(
      contentPadding: EdgeInsets.all(5),
      title: Text('Farm ID: ${farmList.farmId ?? 'N\A'}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          overflow: TextOverflow.clip),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.orange[500],
        foregroundColor: Colors.orange[500],
        child: Image.network(farmList.profilePhoto ?? '',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (c, n, o) =>
                Icon(Icons.account_circle, color: Colors.white)),
      ),
      isThreeLine: true,
      subtitle: Column(
        children: [
          row('Farmer Name', '${farmList.farmerName ?? 'N\A'}'),
          row('Location', '${farmList.baseLocation ?? 'N\A'}'),
          // row('Crops', '${farmList.crops ?? 'N\A'}'),
          row('Status', '${farmList.status ?? 'N\A'}'),
          row('Crop', '${farmList.crops ?? 'N\A'}')
        ],
      ),
      trailing: Container(
          height: 50,
          width: 60,
          child: Image.network(farmList.cropimage ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (c, n, o) =>
                  Icon(Icons.photo, color: Colors.blue[400], size: 40))),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FundOverview(farmInfo: farmList)));
      },
    );
  }
}

class OverModel {
  String farmcount;
  String farmercount;
  String totalexpense;
  String totalfund;
  String farmstatus;
  OverModel(
      this.farmcount, this.farmercount, this.totalexpense, this.totalfund , this.farmstatus);

  factory OverModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OverModel(
      map['farm_count'],
      map['farmer_count'],
      map['total_expense'],
      map['total_fund'],
      map['farmstatus'],
    );
  }

  @override
  String toString() {
    return 'OverModel(farmcount: $farmcount, farmercount: $farmercount, totalexpense: $totalexpense, totalfund: $totalfund)';
  }
}
// CircleAvatar(
//   // radius: 25,
//   backgroundColor: Colors.orange[50],
//   child: Text(two ?? '',
//       style: TextStyle(
//           fontSize: 22,
//           fontWeight: FontWeight.bold,
//           color: Colors.orange[900])),
// ),
// ignore: must_be_immutable
// class FarmListView extends StatelessWidget {
//   final List<Overview> farmList1;
//   FarmListView(this.farmList1);
//   SharedPreferences sp;

//   Widget build(context) {
//     return ListView.builder(
//       // shrinkWrap: true,
//       scrollDirection: Axis.vertical,
//       itemCount: farmList1.length,
//       itemBuilder: (context, int currentIndex) {
//         return createViewItem(farmList1[currentIndex], context, currentIndex);
//       },
//     );
//   }

//   Widget createViewItem(Overview farmList, BuildContext context, int index) {
//     return Card(
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//       color: Colors.white,
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => FundOverview(farmInfo: farmList)));
//         },
//         child: Container(
//             padding: EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//                 color: Colors.orange[50],
//                 borderRadius: BorderRadius.circular(5)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Center(
//                     child: CircleAvatar(
//                         radius: 25,
//                         backgroundColor: Colors.orange[500],
//                         foregroundColor: Colors.orange[500],
//                         child: Icon(Icons.account_circle, color: Colors.white)),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 5.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("F Name", style: TextStyle(color: Colors.black)),
//                       SizedBox(height: 2),
//                       Text("Farmer ID", style: TextStyle(color: Colors.black)),
//                       SizedBox(height: 2),
//                       Text("Farm ID", style: TextStyle(color: Colors.black)),
//                       SizedBox(height: 2),
//                       Text("Location", style: TextStyle(color: Colors.black)),
//                       SizedBox(height: 2),
//                       Text("Crop", style: TextStyle(color: Colors.black)),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 5.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(":", style: TextStyle(color: Colors.black)),
//                       SizedBox(height: 2),
//                       Text(":", style: TextStyle(color: Colors.black)),
//                       SizedBox(height: 2),
//                       Text(":", style: TextStyle(color: Colors.black)),
//                       SizedBox(height: 2),
//                       Text(":", style: TextStyle(color: Colors.black)),
//                       SizedBox(height: 2),
//                       Text(":", style: TextStyle(color: Colors.black)),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 5.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         farmList.farmerName == null
//                             ? "N/A"
//                             : "${farmList.farmerName}",
//                         style: TextStyle(
//                             color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         farmList.farmerId == null
//                             ? "N/A "
//                             : "${farmList.farmerId}",
//                         style: TextStyle(
//                             color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 2,
//                       ),
//                       Text(
//                         farmList.farmId == null ? "N/A " : "${farmList.farmId}",
//                         style: TextStyle(
//                             color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 2,
//                       ),
//                       Text(
//                         farmList.baseLocation == null
//                             ? "N/A "
//                             : "${farmList.baseLocation}",
//                         style: TextStyle(
//                             color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 2,
//                       ),
//                       Text(
//                         farmList.crops == null ? "N/A " : "${farmList.crops}",
//                         style: TextStyle(
//                             color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Center(
//                       child:
//                           Icon(Icons.photo, color: Colors.blue[400], size: 50)),
//                 )
//               ],
//             )),
//       ),
//     );
//   }
// }
// SizedBox(
//   height: 15,
// ),
// Center(
//   child: Text(
//     "FUNDS",
//     style: TextStyle(
//         color: Colors.black,
//         fontSize: 22,
//         fontWeight: FontWeight.bold),
//   ),
// ),
// Divider(),
// Container(
//   height: MediaQuery.of(context).size.height / 3,
//   child: _fund != null
//       ? JsonTable(
//           _fund,
//           columns: fundsColumns,
//         )
//       : Container(
//           child: Center(
//               child: CircularProgressIndicator())),
// ),
// Center(
//   child: Text(
//     "EXPENSE",
//     style: TextStyle(
//         color: Colors.black,
//         fontSize: 22,
//         fontWeight: FontWeight.bold),
//   ),
// ),
// Divider(),
// Container(
//   height: MediaQuery.of(context).size.height / 3,
//   child: _expense != null
//       ? JsonTable(
//           _expense,
//           columns: expenseColumns,
//         )
//       : Container(
//           child: Center(child: CircularProgressIndicator())),
// ),
