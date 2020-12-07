import 'package:apps/model/pending_farmer_model.dart';
import 'package:flutter/material.dart';

class DetailPendingFarmer extends StatelessWidget {
  final PendingFarmerModel farmInfo;
  DetailPendingFarmer({this.farmInfo});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        title: Text(
          farmInfo.farmerName,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
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
                        padding: EdgeInsets.all(5),
                        child: Center(
                            child: CircleAvatar(
                          backgroundColor: Colors.orange[300],
                          foregroundColor: Colors.white,
                          radius: 80,
                          child: Image.network(
                            farmInfo.profilePhoto,  fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
                            errorBuilder: (c, n, o) => Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 50),
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            Text(
                              int.parse(farmInfo.status) == 0
                                  ? 'Active'
                                  : 'Not Active',
                              style: TextStyle(
                                  color: int.parse(farmInfo.status) != 0
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
                          "Farmer Information",
                          style:
                              TextStyle(color: Color(0xff4749A0), fontSize: 18),
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
                              "Farmer Name",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "${farmInfo.farmerName}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                              "Mobile No",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "${farmInfo.mobile}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.black),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "E-mail",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "${farmInfo.email}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                              "Gender",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "${farmInfo.gender}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.black),
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
                              "${farmInfo.baseLocation}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.black),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Address",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "${farmInfo.address}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(8.8),
                        child: Text(
                          "Bank Details",
                          style:
                              TextStyle(color: Color(0xff4749A0), fontSize: 18),
                        ),
                      ),
                      details("A/C No", farmInfo.accountNumber),
                      Divider(color: Colors.black),
                      details("Bank Name", farmInfo.bankName),
                      Divider(color: Colors.black),
                      details("Bank IFSC", farmInfo.ifsc),
                      Divider(color: Colors.black),
                      details("Pan No", farmInfo.pan),
                      Divider(color: Colors.black),
                      SizedBox(height: 100)
                    ],
                  )
                ],
              ),
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
// appBar: AppBar(
//   backgroundColor: Colors.orange[300],
//   elevation: 0.0,
//   leading: IconButton(
//       icon: const Icon(
//         Icons.arrow_back,
//         color: Colors.white,
//       ),
//       onPressed: () {
//         Navigator.pop(context);
//       }),
// ),
// Container(
//   padding: const EdgeInsets.all(8.0),
//   height: 40,
//   width: double.infinity,
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Text(
//         "ID: ${farmInfo.id}",
//         style: TextStyle(fontSize: 18, color: Colors.black),
//       ),
//       int.parse(farmInfo.status) != 0
//           ? Text("Active",
//               style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.green,
//                   fontWeight: FontWeight.bold))
//           : Text("Not Active",
//               style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.bold)),
//     ],
//   ),
// ),
// Divider(),
// SizedBox(height: 20),
