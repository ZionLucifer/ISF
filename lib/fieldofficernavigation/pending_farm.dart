import 'package:apps/fieldofficernavigation/pending/approved_farm_requests.dart';
import 'package:apps/fieldofficernavigation/pending/pending_farm_requests.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class PendingFarm extends StatefulWidget {
  @override
  _PendingFarmState createState() => _PendingFarmState();
}

class _PendingFarmState extends State<PendingFarm> {
  int _currentIndex = 0;
  List _pages = [PendingFarmRequests(), ApprovedFarmRequests()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Farm Status", style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: SafeArea(
          child: Center(
        child: _pages[_currentIndex],
      )),
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
            icon: Icon(Icons.priority_high),
            label: ("Pending"),
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.code),
            label: ("Approved"),
          ),
        ],
      ),
    );
  }
}
