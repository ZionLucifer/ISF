import 'package:apps/fieldofficernavigation/pending/approved_farmer_requests.dart';
import 'package:apps/fieldofficernavigation/pending/detail_approved_farmer.dart';
import 'package:apps/fieldofficernavigation/pending/detail_pending_farmer.dart';
import 'package:apps/fieldofficernavigation/pending/pending_farmer_requests.dart';
import 'package:apps/model/pending_farmer_model.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class PendingFarmer extends StatefulWidget {
  final String userId;
  PendingFarmer({this.userId});
  @override
  _PendingFarmerState createState() => _PendingFarmerState();
}

class _PendingFarmerState extends State<PendingFarmer> {
  int _currentIndex = 0;
  List<StatefulWidget> _pages = List<StatefulWidget>();

  @override
  void initState() {
    super.initState();
    _pages.add(PendingFarmerRequests());
    _pages.add(ApprovedFarmerRequests());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Farmer Status", style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
                onTap: () {
                  showSearch(
                      context: context,
                      delegate:
                          FarmerRequestSearchDelegate(_currentIndex, _pages));
                },
                child: Icon(
                  Icons.search,
                  size: 30.0,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: SafeArea(child: Center(child: _pages[_currentIndex])),
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
              icon: Icon(Icons.priority_high), label: ("Pending")),
          BottomNavigationBarItem(
              icon: Icon(LineIcons.code), label: ("Approved")),
        ],
      ),
    );
  }
}

class FarmerRequestSearchDelegate extends SearchDelegate {
  List<StatefulWidget> _pages;
  int _currentIndex;
  FarmerRequestSearchDelegate(this._currentIndex, this._pages);

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
    // print("q-" + query);
    List _farmList;
    if (_currentIndex == 0) {
      PendingFarmerRequests req = _pages[0];
      _farmList = req.getFarmerList();
    } else {
      ApprovedFarmerRequests req = _pages[1];
      _farmList = req.getFarmerList();
    }
    List<PendingFarmerModel> farm = _farmList.where((element) {
      return element.farmerName.toLowerCase().contains(query.toLowerCase()) ||
          element.farmerId.toLowerCase().contains(query.toLowerCase()) ||
          element.description.toLowerCase().contains(query.toLowerCase()) ||
          element.accountNumber.toLowerCase().contains(query.toLowerCase());
    }).toList();
    if (farm.isEmpty) {
      return Center(
        child: Text("No Result Present"),
      );
    }
    return ListView.builder(
      itemCount: farm.length,
      itemBuilder: (context, int currentIndex) {
        if (_currentIndex == 0) {
          return createPendingViewItem(
              farm[currentIndex], context, currentIndex);
        } else {
          return createApprovedViewItem(
              farm[currentIndex], context, currentIndex);
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }

  Widget createPendingViewItem(
      PendingFarmerModel farmList, BuildContext context, int index) {
    print(farmList.farmerName);
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailPendingFarmer(farmInfo: farmList)));
          },
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.orange[300],
                child: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                )),
            title: Text(
              "${farmList.farmerName ?? 'N\A'}",
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              "${farmList.farmerId}",
              style: TextStyle(color: Colors.black),
            ),
            trailing: IconButton(
                icon: Icon(
                  Icons.arrow_right,
                  color: Colors.orange[300],
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => DetailPendingFarmer(
                            farmInfo: farmList,
                          )));
                }),
          )),
    );
  }

  Widget createApprovedViewItem(
      PendingFarmerModel farmList, BuildContext context, int index) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailApprovedFarmer(farmInfo: farmList)));
          },
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.orange[300],
                child: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                )),
            title: Text(
              "${farmList.farmerName} ?? 'N\A'",
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              "${farmList.farmerId}",
              style: TextStyle(color: Colors.black),
            ),
            trailing: IconButton(
                icon: Icon(
                  Icons.arrow_right,
                  color: Colors.orange[300],
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => DetailApprovedFarmer(
                            farmInfo: farmList,
                          )));
                }),
          )),
    );
  }
}
