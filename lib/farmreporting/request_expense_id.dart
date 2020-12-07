import 'dart:convert';
import 'package:apps/farmreporting/detail_request_id.dart';
import 'package:apps/model/expense_model.dart';
// import 'package:apps/model/overview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReqeuestExpenseID extends StatefulWidget {
  // final Overview farmInfo;
  ReqeuestExpenseID();
  @override
  _ReqeuestExpenseIDState createState() => _ReqeuestExpenseIDState();
}

class _ReqeuestExpenseIDState extends State<ReqeuestExpenseID> {
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

  Future<List<ExpenseModel>> _getExpense() async {
    try {
      var response = await http.post(
          "http://isf.breaktalks.com/appconnect/fundreqidlist.php",
          body: {"field_officer_id": userId});
      var data = jsonDecode(response.body);
      print('Res -> $response');
      if (response.statusCode == 200) {
        List spacecrafts = data;
        return spacecrafts
            .map((spacecraft) => new ExpenseModel.fromJson(spacecraft))
            .toList();
      } else
        throw Exception(
            'We were not able to successfully download the json data.');
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    // print(widget.farmInfo.farmId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Id List", style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.2,
              child: FutureBuilder<List<ExpenseModel>>(
                  future: _getExpense(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.done) {
                      List<ExpenseModel> overview = snapshot.data ?? [];
                      return (overview.length == 0)
                          ? Center(child: Text('No Data Available'))
                          : FarmListView(farmList1: overview);
                    } else if (snapshot.hasError) {
                      return Center(
                          child:
                              Text('Please wait While we Fetch From Servers'));
                    }
                    return Center(
                        child: Container(
                            child: new CircularProgressIndicator(
                                backgroundColor: Colors.orange[200])));
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
  final List<ExpenseModel> farmList1;
  // final Overview farmInfo;
  FarmListView({this.farmList1});
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

  Widget createViewItem(
      ExpenseModel farmList, BuildContext context, int index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailRequestID(
                        expenseList: farmList,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(
              "${farmList.fundRequestId}",
              style: TextStyle(
                color: Color(0xff4749A0),
              ),
            ),
            trailing: Text(
              "${farmList.total}",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            subtitle: Text(
              "Purpose : ${farmList.purpose ?? 'N\A'} \nBalance : ${farmList.availableBalance ?? 0}",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
// requst list
// purposer 20 char
//
