import 'package:apps/model/pending_fund_model.dart';
import 'package:flutter/material.dart';

class DetailApproveFund extends StatelessWidget {
  final PendingFundModel farmInfo;
  DetailApproveFund({this.farmInfo});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
         'Approved Fund Request',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(8.8),
                  child: Text(
                    "Fund Request Information",
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
                        "Fund Request ID",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "${farmInfo.fundRequestId}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.black),
                details("Amount", farmInfo.amount),
                Divider(color: Colors.black),
                details("Purpose", farmInfo.purpose),
                Divider(color: Colors.black),
                SizedBox(height: 50)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget details(String one, String two) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(one, style: TextStyle(fontSize: 16)),
          Text(two ?? '-', style: TextStyle(color: Colors.black, fontSize: 16)),
        ],
      ),
    );
  }
}
