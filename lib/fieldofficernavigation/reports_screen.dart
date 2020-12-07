import 'package:apps/fieldofficerdash.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reports",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => fielddash()),
                  (route) => false);
            }),
      ),
      body: SafeArea(
          child: Center(
        child: Text("Getting Data form the Sever"),
      )),
    );
  }
}
