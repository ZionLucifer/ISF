import 'dart:io';
import 'package:apps/components/logout_overlay.dart';
import 'package:apps/model/records.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import '../Utils/Image/PickImage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as int;

class DetailRecordActivities extends StatefulWidget {
  DetailRecordActivities({this.farmInfo, this.isended});
  final Records farmInfo;
  final bool isended;
  @override
  _DetailRecordActivitiesState createState() => _DetailRecordActivitiesState();
}

class _DetailRecordActivitiesState extends State<DetailRecordActivities> {
  SharedPreferences sharedPreferences;
  String userId, mobile;
  bool onPressed = true;
  String endDate = '';
  Widget displaySelectedFile(File file) {
    return new Container(
        height: 200.0,
        width: 300.0,
        child: Center(
          child: file == null
              ? new Text('Sorry nothing selected!!')
              : new Image.file(file),
        ));
  }

  // final picker = ImagePicker();
  Future getImage() async {
    // String ipath = await ImageUtils.getimage(context);
    // final image = await picker.getImage(source: ImageSource.camera);
    setState(() {});
  }

  String getdate(String datestr) {
    try {
      return int.DateFormat('dd-MM-yyyy hh:mm aa')
          .format(DateTime.parse(datestr));
    } catch (e) {
      return datestr;
    }
  }

  _getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (userId == "") {
        userId = (sharedPreferences.getString('user_id') ?? '');
        mobile = (sharedPreferences.getString('mobile') ?? '');
      } else {
        userId = (sharedPreferences.getString('user_id') ?? '');
        mobile = (sharedPreferences.getString('mobile') ?? '');
        print("Test Else");
        print(userId);
        print(mobile);
      }
    });
  }

  _sendEndData() async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "http://isf.breaktalks.com/appconnect/updaterecordactivities.php"))
      ..fields['field_officer_id'] = userId
      ..fields['farm_id'] = widget.farmInfo.farmId
      ..fields['activity_id'] = widget.farmInfo.activityId
      ..fields['activity_title'] = widget.farmInfo.activityTitle
      ..fields['end_date'] = "${DateTime.now()}";
    var response = await request.send();
    if (response.statusCode == 200) {
      print("Uploaded");

    } else {
      print("${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
    print(widget.farmInfo.activityId);
    print(widget.farmInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Information', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Status: ",
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                        widget.farmInfo.endDate == ""
                            ? Text("Active",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold))
                            : Text("Not Active",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                // SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Table(
                    textDirection: TextDirection.rtl,
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    border: TableBorder.all(width: 1.5, color: Colors.black),
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${widget.farmInfo.activityId}",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Activity Id",
                            textScaleFactor: 1.5,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${widget.farmInfo.activityTitle}",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Title",
                            textScaleFactor: 1.5,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${widget.farmInfo.description}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Description",
                            textScaleFactor: 1.5,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${getdate(widget.farmInfo.startDate)}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Start Date",
                            textScaleFactor: 1.5,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${getdate(widget.farmInfo.endDate)}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "End Date",
                            textScaleFactor: 1.5,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: onPressed ? Colors.orange[300] : Colors.grey,
          // color: onPressed ? Colors.orange[300] : Colors.grey,
          onPressed: onPressed
              ? () {
                  setState(() {
                    endDate = DateTime.now().toString();
                  });
                  _sendEndData();
                  setState(() {
                    onPressed = false;
                  });
                  // Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) =>
                          LogoutOverlay(message: "Data Updated Successfully"));

                }
              : null,
          label: Text("End Record", style: TextStyle(color: Colors.white)),
        ));
  }
}
