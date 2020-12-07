import 'dart:convert';
import 'package:apps/animation/slide_right.dart';
import 'package:apps/farmreporting/detail_record_expense.dart';
import 'package:apps/farmreporting/request_expense_id.dart';
import 'package:apps/model/expense.dart';
import 'package:apps/model/overview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RecordExpense extends StatefulWidget {
  RecordExpense();
  // final Overview farmInfo;
  @override
  _RecordExpenseState createState() => _RecordExpenseState();
}

class _RecordExpenseState extends State<RecordExpense> {
  TextEditingController searchController = new TextEditingController();

  SharedPreferences sharedPreferences;
  String userId;
  String mobile, fundRequestId, farmId, purpose, approvedStatus;
  String filter;
  String amount = "2000", avaiableAmount = "200";
  List _fund;
  List _expenseList;

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
    // print(widget.farmInfo.farmId);
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/fundlist.php",
        body: {"field_officer_id": userId});
    var data = jsonDecode(response.body);
    setState(() {
      _fund = data["fund_expense_list"] as List;
    });
    // var list;
    // String baserUrl = "http://isf.breaktalks.com/appconnect";
    // for (var i = 0; i < _fund.length; i++) {
    //   if (_fund[i]["attach_bill"] != "") {
    //     list = (json.decode(_fund[i]["attach_bill"])) as List;
    //   }
    //   for (var j = 0; j < list.length; j++) {
    //     String path = baserUrl + (list[j].substring(1));
    //     print(path);
    //   }
    // }
  }

  Future<List<ExpenseList>> _getExpense() async {
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/fundlist.php",
        body: {"field_officer_id": userId});
    var data = jsonDecode(response.body)["fund_expense_list"];
    if (response.statusCode == 200) {
      List spacecrafts = data;

      _expenseList = spacecrafts
          .map((spacecraft) => new ExpenseList.fromJson(spacecraft))
          .toList();
      return _expenseList;
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(
            "$userId",
            textAlign: TextAlign.center,
            style: (TextStyle(
              fontFamily: 'JosefinSans',
              color: Colors.white,
            )),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                  onTap: () {
                    showSearch(
                        context: context,
                        delegate: RecordSearchDelegate(_expenseList));
                  },
                  child: Icon(
                    Icons.search,
                    size: 30.0,
                    color: Colors.white,
                  )),
            )
          ],
        ),
        body: SafeArea(
            child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("LIST 0F EXPENSES",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder<List<ExpenseList>>(
                    future: _getExpense(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ExpenseList> overview = snapshot.data;
                        print(snapshot.data);
                        return new FarmListView(overview);
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                'Please wait While we Fetch From Servers'));
                      }
                      return Center(
                          child: Container(
                              child: new CircularProgressIndicator(
                                  backgroundColor: Colors.orange[300])));
                    }),
              ),
            ),
          ],
        )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange[300],
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                SlideRightRoute(
                    page: ReqeuestExpenseID(
                        // farmInfo: widget.farmInfo,
                        )));
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class FarmListView extends StatelessWidget {
  final List<ExpenseList> farmList1;
  FarmListView(this.farmList1);
  SharedPreferences sp;

  Widget build(context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: farmList1.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(farmList1[currentIndex], context, currentIndex);
      },
    );
  }

  Widget createViewItem(ExpenseList farmList, BuildContext context, int index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DetailRecordExpense(expenseList: farmList)));
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
                            "Expense ID",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Request Id",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
                          Text(
                            ":",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "${farmList.farmExpenseId}",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "${farmList.fundRequestId}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Rs. ${farmList.subtot}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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

class RecordSearchDelegate extends SearchDelegate {
  final List<ExpenseList> farmList1;
  RecordSearchDelegate(this.farmList1);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    print("q-" + query);
    List<ExpenseList> farm = farmList1.where((element) {
      return element.fundRequestId
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          element.amount.toLowerCase().contains(query.toLowerCase()) ||
          element.farmExpenseId.toLowerCase().contains(query.toLowerCase());
    }).toList();
    if (farm.isEmpty) {
      return Center(
        child: Text("No Result Present"),
      );
    }
    return ListView.builder(
      itemCount: farm.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(farm[currentIndex], context, currentIndex);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }

  Widget createViewItem(ExpenseList farmList, BuildContext context, int index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DetailRecordExpense(expenseList: farmList)));
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
                            "Expense ID",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Request Id",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
                          Text(
                            ":",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "${farmList.farmExpenseId}",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "${farmList.fundRequestId}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Rs. ${farmList.subtot}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
