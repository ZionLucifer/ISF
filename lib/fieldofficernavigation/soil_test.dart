import 'dart:convert';
import 'package:apps/components/logout_overlay.dart';
import 'package:apps/model/overview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SoilTest extends StatefulWidget {
  final Overview farmInfo;
  SoilTest({this.farmInfo});
  @override
  _SoilTestState createState() => _SoilTestState();
}

class _SoilTestState extends State<SoilTest> {
  SharedPreferences sharedPreferences;
  String userId;
  String message;
  String _plot;
  List _plotList = [];
  TextEditingController nController = new TextEditingController();
  TextEditingController pController = new TextEditingController();
  TextEditingController kController = new TextEditingController();
  _sendData() async {
    var response = await http
        .post("http://isf.breaktalks.com/appconnect/addsoiltesting.php", body: {
      "field_officer_id": userId,
      "farm_id": widget.farmInfo.farmId,
      "n": nController.text.toString(),
      "p": pController.text.toString(),
      "k": kController.text.toString(),
      "plots": _plot
    });
    print(response.body);
    setState(() {
      message = response.body;
    });
  }

  _getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (userId == "") {
        userId = (sharedPreferences.getString('user_id') ?? '');
        print("test IF");
        print(userId);
      } else {
        userId = (sharedPreferences.getString('user_id') ?? '');
        print("Test Else");
        print(userId);
      }
    });
    print(widget.farmInfo.farmId);
    var response = await http
        .post("http://isf.breaktalks.com/appconnect/getplotslist.php", body: {
      "field_officer_id": userId,
      "farm_id": widget.farmInfo.farmId,
    });

    var data = jsonDecode(response.body);
    print(json.decode(response.body)["plots"]);
    setState(() {
      _plotList = data["plots"];
    });
    print("Prinitng the object as a Plot List");
    print(_plotList);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Soil Testing", style: TextStyle(color: Colors.white)),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.farmInfo.farmerId} :",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  Text("${widget.farmInfo.farmerName} ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: Colors.grey[200], spreadRadius: 2,blurRadius: 2)
              ], color: Colors.white),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(1.0),
                      child: Center(
                        child: Text(
                          "ADD NEW SOILING TEST INTO HERE",
                          style: TextStyle(
                              color: Colors.orange[400],
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: 300,
                          child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0),
                                    hintText: 'Please select Plot',
                                    labelText: _plotList == null
                                        ? 'Please Wait While the data is being fetched'
                                        : 'Select Plot',
                                    contentPadding: new EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _plot,
                                    items: _plotList
                                            ?.map<DropdownMenuItem<String>>(
                                                (value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        })?.toList() ??
                                        [],
                                    onChanged: (String value) {
                                      setState(() {
                                        _plot = value;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          )),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(color: Colors.orange[50]),
                      width: 300,
                      child: TextField(
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          controller: nController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: "N")),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(color: Colors.orange[50]),
                      width: 300,
                      child: TextField(
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          controller: kController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: "K")),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(color: Colors.orange[50]),
                      width: 300,
                      child: TextField(
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          controller: pController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: "P")),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange[300],
          onPressed: () {
            if (nController.text.isNotEmpty ||
                pController.text.isNotEmpty ||
                kController.text.isNotEmpty) {
              _sendData();
              setState(() {
                nController.clear();
                pController.clear();
                kController.clear();
              });
              showDialog(
                  context: context,
                  builder: (context) => LogoutOverlay(
                        message: "Data Added Successfully",
                      ));
            } else {
              showDialog(
                  context: context,
                  builder: (context) => LogoutOverlay(
                        message: "Please Enter All Fields",
                      ));
            }
          },
          child: Icon(
            Icons.file_upload,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
// Padding(
//   padding: const EdgeInsets.all(15.0),
//   child: Container(
//     decoration: BoxDecoration(
//         color: Colors.deepOrange[100],
//         borderRadius: BorderRadius.circular(10)),
//     width: 300,
//     child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         style: TextStyle(color: Colors.white, fontSize: 30),
//         controller: pController,
//         keyboardType: TextInputType.number,
//         decoration: InputDecoration(hintText: "P"),
//       ),
//     ),
//   ),
// ),

// Padding(
//   padding: const EdgeInsets.all(15.0),
//   child: Container(
//     decoration: BoxDecoration(
//         color: Colors.deepOrange[100],
//         borderRadius: BorderRadius.circular(10)),
//     width: 300,
//     child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         style: TextStyle(color: Colors.white, fontSize: 30),
//         controller: kController,
//         keyboardType: TextInputType.number,
//         decoration: InputDecoration(hintText: "K"),
//       ),
//     ),
//   ),
// ),
// Column(
//   children: [
//     Container(
//       height: 80,
//       width: 350,
//       padding: EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//           color: Colors.orange[300],
//           borderRadius: BorderRadius.circular(5)),
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Row(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Farmer Name",
//                     style: TextStyle(
//                         color: Colors.white, fontSize: 16)),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "Farm Id",
//                   style: TextStyle(
//                       color: Colors.white, fontSize: 16),
//                 ),
//               ],
//             ),
//             SizedBox(
//               width: 60,
//             ),
//             Column(
//               children: [
//                 Text(
//                   ":",
//                   style: TextStyle(
//                       color: Colors.white, fontSize: 16),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   ":",
//                   style: TextStyle(
//                       color: Colors.white, fontSize: 16),
//                 ),
//               ],
//             ),
//             SizedBox(
//               width: 60,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "${widget.farmInfo.farmerName}",
//                   style: TextStyle(
//                       color: Colors.white, fontSize: 16),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "${widget.farmInfo.farmId}",
//                   style: TextStyle(
//                       color: Colors.white, fontSize: 16),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   ],
// ),
