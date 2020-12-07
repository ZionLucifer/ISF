import 'dart:convert';
import 'package:apps/farmreporting/add_harvest.dart';
import 'package:apps/farmreporting/detail_harvesting.dart';
import 'package:apps/model/harvest.dart';
import 'package:apps/model/overview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class harvesting extends StatefulWidget {
  harvesting({this.farmInfo});
  final Overview farmInfo;
  @override
  _harvestingState createState() => _harvestingState();
}

class _harvestingState extends State<harvesting> {
  SharedPreferences sharedPreferences;
  bool isGoingDown = true;
  String userId, mobile;
  List _expenseList;
  int _currentIndex = 0;
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

  Future<List<HarvestingList>> _getHarvestInfo() async {
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/harvestinglist.php",
        body: {"field_officer_id": userId});
    // print('>>${response.body}');
    var data = jsonDecode(response.body);
    var harvestList = data["harvesting_list"];
    if (response.statusCode == 200) {
      List spacecrafts = harvestList;
      _expenseList = spacecrafts
          .map((spacecraft) => new HarvestingList.fromJson(spacecraft))
          .toList();
      return _expenseList;
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
      // backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Harvesting",
          style: (TextStyle(fontFamily: 'JosefinSans', color: Colors.white)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
                onTap: () {
                  showSearch(
                      context: context,
                      delegate: HarvestSearchDelegate(
                          _expenseList, userId, () => setState(() {})));
                },
                child: Icon(Icons.search, size: 30.0, color: Colors.white)),
          )
        ],
      ),
      body: SafeArea(
          child: Column(children: [
        FutureBuilder<List<HarvestingList>>(
            future: _getHarvestInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<HarvestingList> overview = snapshot.data
                      .where(
                          (e) => e.status == ((_currentIndex != 1) ? '1' : '0'))
                      .toList();
                  return Expanded(
                      child: new FarmListView(
                          overview, userId, () => setState(() {})));
                } else if (snapshot.hasError) {
                  return Expanded(
                    child: Center(
                        child: Container(
                      width: 400,
                      child: Text(
                          'Error Occurs, Unable To Fetch From Server. \nTry Again Later',
                          textAlign: TextAlign.center),
                    )),
                  );
                }
              }
              return Expanded(
                child: Center(
                    child: Container(
                        child: new CircularProgressIndicator(
                            backgroundColor: Colors.orange[100]))),
              );
            }),
        SizedBox(height: 25)
      ])),
      floatingActionButton: _currentIndex != 0
          ? null
          : FloatingActionButton.extended(
              label: Text('Add Harvest Details'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddHarvest(farmInfo: widget.farmInfo)));
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: _currentIndex == 0 ? Colors.red : Colors.green,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.run_circle),
            label: ("InProgress"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: ("Completed"),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class FarmListView extends StatelessWidget {
  final List<HarvestingList> farmList1;
  final String userid;
  final Function setstate;
  FarmListView(this.farmList1, this.userid, this.setstate);
  Widget build(context) {
    return ListView.separated(
      separatorBuilder: (c, i) => Divider(height: 3, thickness: 1.5),
      scrollDirection: Axis.vertical,
      itemCount: farmList1.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(farmList1[currentIndex], context, currentIndex);
      },
    );
  }

  Widget createViewItem(
      HarvestingList farmList, BuildContext context, int index) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailHarvesting(
                      harvestInfo: farmList,
                      userid: userid))).whenComplete(() => setstate());
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange[300],
            child:
                Text("${farmList.id}", style: TextStyle(color: Colors.white)),
          ),
          title: Text(
            "${farmList.harvestId}",
            style: TextStyle(color: Color(0xff1D2952)),
          ),
          subtitle: Text("${farmList.timestamp}"),
          trailing: IconButton(
              icon: Icon(
                Icons.arrow_right,
                size: 40,
                color: Colors.orange[300],
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailHarvesting(
                            harvestInfo: farmList, userid: userid)));
              }),
        ));
  }
}

class HarvestSearchDelegate extends SearchDelegate {
  final List<HarvestingList> farmList1;
  final String userid;
  final Function setstate;
  HarvestSearchDelegate(this.farmList1, this.userid, this.setstate);

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
    List<HarvestingList> farm = farmList1.where((element) {
      return element.fieldOfficerId
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          element.harvestId.toLowerCase().contains(query.toLowerCase()) ||
          element.farmId.toLowerCase().contains(query.toLowerCase()) ||
          element.details.toLowerCase().contains(query.toLowerCase());
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

  Widget createViewItem(
      HarvestingList farmList, BuildContext context, int index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailHarvesting(
                        harvestInfo: farmList,
                        userid: userid))).whenComplete(() => setstate());
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange[300],
              child: Text(
                "${farmList.id}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              "${farmList.harvestId}",
              style: TextStyle(
                color: Color(0xff1D2952),
              ),
            ),
            subtitle: Text(
              "${farmList.details}",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: IconButton(
                icon: Icon(
                  Icons.arrow_right,
                  size: 40,
                  color: Colors.orange[300],
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailHarvesting(
                              harvestInfo: farmList, userid: userid)));
                }),
          )),
    );
  }
}
