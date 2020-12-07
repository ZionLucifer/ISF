import 'dart:convert';
import 'dart:ui';
import 'package:apps/fieldofficerdash.dart';
import 'package:apps/fieldofficernavigation/add_fund_page.dart';
import 'package:apps/fieldofficernavigation/pending_requests.dart';
import 'package:apps/fieldofficernavigation/reports_screen.dart';
import 'package:apps/loginpage.dart';
import 'package:apps/model/overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'addfarm.dart';
import 'addfarmer.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  TextEditingController purposeController = new TextEditingController();
  SharedPreferences sharedPreferences;
  String userId;
  String mobile, fundRequestId, farmId, purpose, amount, approvedStatus;
  List<Overview> farmList;
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

  Future<List<Overview>> _getOverViewInfo() async {
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/farmlist.php",
        body: {"field_officer_id": userId});

    var value = json.decode(response.body);
    var farmlist = value['farm_list'];

    if (response.statusCode == 200) {
      List spacecrafts = farmlist;
      farmList = spacecrafts
          .map((spacecraft) => new Overview.fromJson(spacecraft))
          .toList();
      return farmList;
    } else
      throw Exception(
          'We were not able to successfully download the json data.');
  }

  sendGeneralFund() async {
    try {
      var response = await http.post(
          "http://isf.breaktalks.com/appconnect/generalfundrequest.php",
          body: {
            "field_officer_id": userId,
            "mobile": mobileController.text.toString(),
            "amount": amountController.text.toString(),
            "purpose": purposeController.text.toString()
          }).then((value) => print(value.body));
      setState(() {
        mobileController.clear();
        amountController.clear();
      });
    } catch (e) {
      print(e);
    }
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
    mobileController.clear();
    amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Fund Request",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              debugPrint("came here");

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => fielddash()));
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: (){
                showSearch(
                    context: context,
                    delegate: FarmSearchDelegate(farmList));
              },
                child: Icon(Icons.search,size: 30.0,color: Colors.white,)),
          )
        ],
      ),
      body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top: 10, left: 7, right: 7, bottom: 0.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:10.0,left: 15.0,right: 15.0,bottom: 0.0),
                  child: Text('SELECT A FARM TO RAISE FUND',style: TextStyle(fontSize: 20.0,
                      color: Colors.orange[300],fontWeight: FontWeight.bold),),
                ),
                SizedBox(
                  height: 10.0,
                ),
                ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: FutureBuilder<List<Overview>>(
                          future: _getOverViewInfo(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<Overview> overview = snapshot.data;
                              return new FarmListView(overview);
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                      'Please wait while we fetch data from our Servers')
                              );
                            }
                            return Center(
                                child: Container(
                                    child: CircularProgressIndicator()));
                          }),

                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(5.5),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.orange[300],borderRadius: BorderRadius.circular(5.0)),
                        width: MediaQuery.of(context).size.width / 2,
                        child: Center(
                            child: FlatButton(
                              onPressed: () {
                                showModalBottomSheet<dynamic>(
                                    isScrollControlled: true,
                                    context: (context),
                                    builder: (BuildContext bc) {
                                      return Container(
                                        height: MediaQuery.of(context).size.height / 1.5,
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20))),
                                          child: ListView(
                                            shrinkWrap: true,
                                            children: [
                                              Form(
                                                key: _formKey,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "General Fund Request",
                                                        style: TextStyle(
                                                            color: Theme.of(context)
                                                                .primaryColor,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(12)),
                                                      child: TextFormField(
                                                        keyboardType: TextInputType.number,
                                                        controller: mobileController,
                                                        decoration: const InputDecoration(
                                                            labelText: 'Mobile No'),
                                                        validator: (String value) {
                                                          if (value.isEmpty) {
                                                            return 'Please enter your Mobile No';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(12)),
                                                      child: TextFormField(
                                                        keyboardType: TextInputType.number,
                                                        controller: amountController,
                                                        decoration: const InputDecoration(
                                                            labelText: 'Amount'),
                                                        validator: (String value) {
                                                          if (value.isEmpty) {
                                                            return 'Please enter Amount';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(12)),
                                                      child: TextFormField(
                                                        keyboardType: TextInputType.text,
                                                        controller: purposeController,
                                                        decoration: const InputDecoration(
                                                            labelText: 'Purpose'),
                                                        validator: (String value) {
                                                          if (value.isEmpty) {
                                                            return 'Please enter your Purpose';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      padding: const EdgeInsets.all(8.0),
                                                      width:
                                                      MediaQuery.of(context).size.width,
                                                      decoration: BoxDecoration(
                                                        color: Colors.orange[300],

                                                      ),
                                                      child: FlatButton(
                                                          onPressed: () {
                                                            if (_formKey.currentState
                                                                .validate()) {
                                                              sendGeneralFund();
                                                            }
                                                          },
                                                          child: Text(
                                                            "Request  Fund",
                                                            style: TextStyle(fontWeight: FontWeight.bold,
                                                              color: Colors.white,fontSize: 20.0,
                                                            ),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Text("General Fund Request",
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                    color: Colors.white,fontSize: 20.0,
                                  )),
                            )),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
      drawer: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: new Drawer(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => fielddash()));
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: Icon(
                        Icons.home,
                        color: Color(0xff1D2952),
                      ),
                      title: Text(
                        "Home",
                        style: TextStyle(color: Color(0xff1D2952)),
                      ),
                    ),
                  ),
                ),
                Divider(),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        ListTile(
                          title: new Text(
                            "Add Farmer",
                            style: TextStyle(color: Color(0xff1D2952)),
                          ),
                          leading: Icon(
                            Icons.portrait,
                            color: Color(0xff1D2925),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AndroidMessagesPage()));
                          },
                        ),
                        ListTile(
                          title: new Text(
                            "Add Farm",
                            style: TextStyle(color: Color(0xff1D2952)),
                          ),
                          leading: Icon(Icons.filter_frames,
                              color: Color(0xff1D2925)),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AndroidMessagesPages()));
                          },
                        ),
                        ListTile(
                          title: new Text(
                            "Pending Requests",
                            style: TextStyle(color: Color(0xff1D2952)),
                          ),
                          leading: Icon(
                            Icons.list,
                            color: Color(0xff1D2925),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PendingRequests()));
                          },
                        ),
                        ListTile(
                          title: new Text(
                            "Report",
                            style: TextStyle(color: Color(0xff1D2952)),
                          ),
                          leading: Icon(Icons.report, color: Color(0xff1D2925)),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReportsScreen()));
                          },
                        ),
                        Divider(),
                        ListTile(
                          title: new Text("Logout"),
                          leading: Icon(
                            Icons.cancel,
                            color: Colors.red[200],
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            _popups(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "Powered By Farmingly",
                      style: TextStyle(color: Color(0xff1D2952)),
                    )),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _popups(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Alert',
              style: TextStyle(fontFamily: 'JosefinSans'),
            ),
            content: Text(
              'Are Your Sure Want to logout',
              style: TextStyle(fontFamily: 'JosefinSans'),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  sharedPreferences.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                      fontFamily: 'JosefinSans', color: Color(0xFFFF9100)),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                      fontFamily: 'JosefinSans', color: Color(0xFFFF9100)),
                ),
              )
            ],
          );
        });
  }
}

// ignore: must_be_immutable
class FarmListView extends StatelessWidget {
  final List<Overview> farmList1;
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

  Widget createViewItem(Overview farmList, BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddFundPage(farmInfo: farmList)));
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.16,
            decoration: BoxDecoration(
                color: Colors.orange[300],borderRadius: BorderRadius.circular(5.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.orange[100],
                        foregroundColor: Colors.orange[100],
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        )),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Farmer Name:",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Farmer ID",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Farm ID",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Base Location",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Crop",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ":",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        ":",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        ":",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        ":",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        ":",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farmList.farmerName == null
                            ? "N/A"
                            : "${farmList.farmerName}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        farmList.farmerId == null
                            ? "N/A "
                            : "${farmList.farmerId}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        farmList.farmId == null ? "N/A " : "${farmList.farmId}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        farmList.baseLocation == null
                            ? "N/A "
                            : "${farmList.baseLocation}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        farmList.crops == null ? "N/A " : "${farmList.crops}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Icon(
                      Icons.photo,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class FarmSearchDelegate extends SearchDelegate {
  final List<Overview> farmList1;
  FarmSearchDelegate(this.farmList1);

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

    List<Overview> farm = farmList1.where((element){
      return element.farmerName.contains(query) || element.farmerId.contains(query)
          || element.farmId.contains(query) || element.farmerName.contains(query)
          || element.baseLocation.contains(query) ;
    }).toList();
    if(farm.isEmpty){
      return Center(
        child: Text("No Result Present"),
      );
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: farm.length,
      itemBuilder: (context, int currentIndex) {
        print(farm[currentIndex]);
        return createViewItem(farm[currentIndex], context, currentIndex);
      },
    );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Column();
  }
  Widget createViewItem(Overview farmList, BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddFundPage(farmInfo: farmList)));
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.16,
            decoration: BoxDecoration(
                color: Colors.orange[300],borderRadius: BorderRadius.circular(5.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.orange[100],
                        foregroundColor: Colors.orange[100],
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        )),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Farmer Name:",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Farmer ID",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Farm ID",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Base Location",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Crop",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ":",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        ":",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        ":",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        ":",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        ":",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farmList.farmerName == null
                            ? "N/A"
                            : "${farmList.farmerName}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        farmList.farmerId == null
                            ? "N/A "
                            : "${farmList.farmerId}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        farmList.farmId == null ? "N/A " : "${farmList.farmId}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        farmList.baseLocation == null
                            ? "N/A "
                            : "${farmList.baseLocation}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        farmList.crops == null ? "N/A " : "${farmList.crops}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Icon(
                      Icons.photo,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
