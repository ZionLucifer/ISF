import 'package:apps/farmreporting/fr_notification_screen.dart';
import 'package:apps/farmreporting/record_activities.dart';
import 'package:apps/fieldofficernavigation/sensing_page.dart';
import 'package:apps/fieldofficernavigation/soil_test.dart';
import 'package:apps/model/overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'harvesting.dart';

class FarmWorkReporting extends StatefulWidget {
  FarmWorkReporting({this.farmInfo});
  final Overview farmInfo;

  @override
  _FarmWorkReportingState createState() => _FarmWorkReportingState();
}

class _FarmWorkReportingState extends State<FarmWorkReporting> {
  @override
  void initState() {
    super.initState();
    print("Farmlist Data Showing farm Work reporting");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        elevation: 0.0,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 6,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.orange[300]),
                  child: Center(
                      child: Image.network(widget.farmInfo.profilePhoto,
                          fit: BoxFit.fitHeight,  
            width: double.infinity,
            height: double.infinity,
                          errorBuilder: (c, n, o) => CircleAvatar(
                                backgroundColor: Colors.orange[300],
                                foregroundColor: Colors.orange[300],
                                child: Icon(Icons.person,
                                    size: 50, color: Colors.white),
                              ))),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Farmer Name",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      Text(
                        "${widget.farmInfo.farmerName.toString().toUpperCase()}",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(8.8),
                  child: Text(
                    "Farm Information",
                    style: TextStyle(color: Color(0xff4749A0), fontSize: 18),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Farmer ID",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "${widget.farmInfo.farmerId}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Irrigation",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "${widget.farmInfo.irrigation}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Land Type",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "${widget.farmInfo.landType}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Soil Type",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "${widget.farmInfo.soilType}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Base Location",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "${widget.farmInfo.baseLocation}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Acreage",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "${widget.farmInfo.acerage}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                SizedBox(
                  height: 100,
                )
              ],
            )
          ],
        ),
      )),
      floatingActionButton: SpeedDial(
          closeManually: true,
          backgroundColor: Colors.orange[300],
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(color: Colors.white),
          children: [
            SpeedDialChild(
              child: const Icon(
                Icons.spa,
                color: Colors.white,
              ),
              backgroundColor: Colors.orange[300],
              label: "Harvest",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            harvesting(farmInfo: widget.farmInfo)));
              },
            ),
            SpeedDialChild(
              child: const Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              backgroundColor: Colors.orange[300],
              label: "Farmer Notify",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FRNotificationScreen(
                              farmInfo: widget.farmInfo,
                            )));
              },
            ),
            SpeedDialChild(
              child: const Icon(
                Icons.face,
                color: Colors.white,
              ),
              backgroundColor: Colors.orange[300],
              label: "Sensing",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SensingPage(farmInfo: widget.farmInfo)));
              },
            ),
            SpeedDialChild(
              child: const Icon(
                Icons.event_available,
                color: Colors.white,
              ),
              label: "Soil Test",
              backgroundColor: Colors.orange[300],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SoilTest(
                              farmInfo: widget.farmInfo,
                            )));
              },
            ),
            SpeedDialChild(
              child: const Icon(
                Icons.local_activity,
                color: Colors.white,
              ),
              backgroundColor: Colors.orange[300],
              label: "Timeline",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecordActivities(
                              farmInfo: widget.farmInfo,
                            )));
              },
            ),
          ]),
    );
  }
}
