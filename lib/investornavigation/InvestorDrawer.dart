import 'package:flutter/material.dart';
import 'package:apps/investornavigation/investorfarm.dart';
import 'package:apps/investornavigation/investorfarmer.dart';
import 'package:apps/investornavigation/investorprofile.dart';
import 'package:apps/investornavigation/notification.dart';
import 'package:apps/investornavigation/dashboard_screen.dart';

import 'investorfarm.dart';

class InvestorDrawer {
  static Widget getdrawer(BuildContext context, {Function onpop}) {
    return new Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 5),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: ListTile(
                tileColor: Colors.orange[50],
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
            Divider(),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    ListTile(
                      title: new Text("My PortFolio",
                          style: TextStyle(color: Color(0xff1D2952))),
                      leading: Icon(Icons.portrait, color: Color(0xff1D2925)),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardScreen()));
                      },
                    ),
                    ListTile(
                      title: new Text("My Profile",
                          style: TextStyle(color: Color(0xff1D2952))),
                      leading: Icon(Icons.person, color: Color(0xff1D2925)),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Promodel()));
                      },
                    ),
                    ListTile(
                      title: new Text(
                        "Notifications",
                        style: TextStyle(color: Color(0xff1D2952)),
                      ),
                      leading: Icon(
                        Icons.notifications,
                        color: Color(0xff1D2925),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => farmernoti()));
                      },
                    ),
                    ListTile(
                      title: new Text(
                        "Messages",
                        style: TextStyle(color: Color(0xff1D2952)),
                      ),
                      leading: Icon(Icons.message, color: Color(0xff1D2925)),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Farms()));
                      },
                    ),
                    ListTile(
                      title: new Text(
                        "My Farmer",
                        style: TextStyle(color: Color(0xff1D2952)),
                      ),
                      leading: Icon(
                        Icons.format_list_numbered_rtl,
                        color: Color(0xff1D2925),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Chat()));
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
                        // _popup(context);
                        onpop();
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
    );
  }
}
