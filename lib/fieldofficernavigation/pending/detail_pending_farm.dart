import 'package:apps/model/pendingListModel.dart';
import 'package:flutter/material.dart';

class DetailPendingFarm extends StatelessWidget {
  final PendingListModel farmInfo;
  DetailPendingFarm({this.farmInfo});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        title: Text(
         'Pending Fund Details',
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
                Container(
                  height: MediaQuery.of(context).size.height / 6,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.orange[300]),
                  child: Center(
                      child: CircleAvatar(
                    backgroundColor: Colors.orange[300],
                    foregroundColor: Colors.orange[300],
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  )),
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
                        "ID: ${farmInfo.id}",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      Text(
                        int.parse(farmInfo.status) == 0
                            ? 'Active'
                            : 'Not Active',
                        style: TextStyle(
                            color: int.parse(farmInfo.status) == 0
                                ? Colors.green
                                : Colors.red,
                            fontSize: 18),
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
                        "${farmInfo.farmerId}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.black),
                details("Land Type", farmInfo.landType),
                Divider(color: Colors.black),
                details("Irrigation", farmInfo.irrigation),
                Divider(color: Colors.black),
                // SizedBox(height: 20),
                // Container(
                //   padding: const EdgeInsets.all(8.8),
                //   child: Text(
                //     "Bank Details",
                //     style: TextStyle(color: Color(0xff4749A0), fontSize: 18),
                //   ),
                // ),
                details("Soil Type", farmInfo.soilType),
                Divider(color: Colors.black),
                details("Acerage", farmInfo.acerage),
                Divider(color: Colors.black),
                details("Plots", farmInfo.plots),
                Divider(color: Colors.black),
                details("Description", farmInfo.description),
                Divider(color: Colors.black),
                SizedBox(height: 100)
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
