import 'dart:convert';

import 'package:apps/model/expense_overview.dart';
import 'package:apps/model/fo_overview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseOverview extends StatefulWidget {
  final FOOverview farmInfo;
  ExpenseOverview({this.farmInfo});
  @override
  _ExpenseOverviewState createState() => _ExpenseOverviewState();
}

class _ExpenseOverviewState extends State<ExpenseOverview> {
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
  Future<List<ExpenseOverviewModel>> _getOverViewInfo() async {
    print(widget.farmInfo.fundRequestId);
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/expenselistbyfundid.php",
        body: {
          "field_officer_id": userId,
          "fund_request_id": widget.farmInfo.fundRequestId
        });

    var value = json.decode(response.body);
    //print("Farmlist");
    print(value);
    var farmlist = value;
    nodata = value['message'].toString().trim() == 'No data Found';
    if (response.statusCode == 200) {
      List spacecrafts = farmlist;

      return spacecrafts
          .map((spacecraft) => new ExpenseOverviewModel.fromJson(spacecraft))
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
      appBar: AppBar(
        title: Text(
          "Expense List",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(1.0),
              //   child: Container(
              //     child: Padding(
              //       padding: const EdgeInsets.all(5.0),
              //       child: Text("LIST 0F EXPENSES",
              //           style: TextStyle(fontSize: 20, color: Colors.orange)),
              //     ),
              //   ),
              // ),
              SizedBox(height: 5),
              Container(
                height: MediaQuery.of(context).size.height / 1.2,
                child: FutureBuilder<List<ExpenseOverviewModel>>(
                    future: _getOverViewInfo(),
                    builder: (context, snapshot) {
                      // if (snapshot.hasData) {
                      //   List<ExpenseOverviewModel> overview = snapshot.data;
                      //   return new FarmListView(overview);
                      // } else if (snapshot.hasError) {
                      //   return Center(child: Text('No Data Found'));
                      // }
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (nodata ?? false) {
                          return Center(
                              child: Container(child: Text('No Data Found')));
                        }
                        if (snapshot.hasData) {
                          List<ExpenseOverviewModel> overview = snapshot.data;
                          return new FarmListView(overview);
                        }
                      }
                      return Center(
                          child: Container(
                              child: new CircularProgressIndicator()));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class FarmListView extends StatelessWidget {
  final List<ExpenseOverviewModel> farmList1;
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
      ExpenseOverviewModel farmList, BuildContext context, int index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => ExpenseOverview(farmInfo: farmList)));
        },
        child: Container(
          height: 100,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.orange[300],
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "Expense ID ",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Purpose ",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            ":",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            ":",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "${farmList.farmExpenseId}",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            farmList.purpose == null
                                ? "N/A"
                                : "${farmList.purpose}",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                height: 50,
                width: 2,
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "Amount",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Text(
                        farmList.total == null ? "N/A" : "₹${farmList.total}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
