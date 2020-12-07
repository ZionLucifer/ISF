import 'package:apps/fieldofficerdash.dart';
import 'package:apps/fieldofficernavigation/pending_farm.dart';
import 'package:apps/fieldofficernavigation/pending_farmer.dart';
import 'package:apps/fieldofficernavigation/pending_funds.dart';
import 'package:flutter/material.dart';

class PendingRequests extends StatefulWidget {
  final String userId;
  PendingRequests({this.userId});
  @override
  _PendingRequestsState createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Pending Requests", style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => fielddash()),
                  (route) => false);
            }),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(3.0),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 10),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PendingFarmer(userId: widget.userId)));
              },
              child: Container(
                margin: const EdgeInsets.all(5.5),
                padding: const EdgeInsets.all(12),
                height: MediaQuery.of(context).size.height / 6,
                decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                  child: ListTile(
                    hoverColor: Colors.orange[300],
                    leading: Icon(Icons.event_busy),
                    title: Text("Farmer Requests",
                      style: TextStyle(color: Colors.black, fontSize: 20),),
                    trailing: IconButton(
                        icon: Icon(Icons.arrow_right,
                            color: Colors.black, size: 29),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PendingFarmer()));
                        }),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PendingFarm()));
              },
              child: Container(
                margin: const EdgeInsets.all(5.5),
                padding: const EdgeInsets.all(12.0),
                height: MediaQuery.of(context).size.height / 6,
                decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                  child: ListTile(
                    hoverColor: Colors.orange[300],
                    leading: Icon(Icons.event_busy),
                    title: Text(
                      "Farm Requests",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_right,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PendingFarm()));
                        }),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PendingFunds()));
              },
              child: Container(
                margin: const EdgeInsets.all(5.5),
                padding: const EdgeInsets.all(12.0),
                height: MediaQuery.of(context).size.height / 6,
                decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                  child: ListTile(
                    hoverColor: Colors.orange[300],
                    leading: Icon(Icons.event_busy),
                    title: Text(
                      "Fund Requests",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_right,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PendingFunds()));
                        }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
