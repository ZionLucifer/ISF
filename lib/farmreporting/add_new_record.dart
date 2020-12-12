import 'dart:io';
import 'package:apps/components/logout_overlay.dart';
import 'package:apps/model/overview.dart';
import 'package:flutter/material.dart';
import '../Utils/Image/PickImage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddNewRecord extends StatefulWidget {
  AddNewRecord({this.farmInfo});
  final Overview farmInfo;
  @override
  _AddNewRecordState createState() => _AddNewRecordState();
}

class _AddNewRecordState extends State<AddNewRecord> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  String startDateAndTime = '';
  String endDateAndTime = '';
  SharedPreferences sharedPreferences;
  String userId, mobile, statusCode = "0";
  // final picker = ImagePicker();
  File _activity;
  Future _sendData(file) async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              "http://isf.breaktalks.com/appconnect/addrecordactivities.php"))
        ..fields['field_officer_id'] = userId
        ..fields['activity_id'] = ''
        ..fields['farm_id'] = widget.farmInfo.farmId
        ..fields['title'] = activity //titleController.text.toString()
        ..fields['description'] = descController.text.toString()
        ..files.add(await http.MultipartFile.fromPath('file', file))
        ..fields['start_date'] = "${DateTime.now()}";
      var response = await request.send();
      setState(() {
        statusCode = response.statusCode.toString();
      });
      if (response.statusCode == 200) {
        print("Uploaded");
        print(response.reasonPhrase);
        print(response.request);
      } else {
        print("${response.statusCode}");
      }
    } catch (e) {
      print(e);
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

  Future _getActivityImage() async {
    // final image = await picker.getImage(source: ImageSource.gallery);
    String ipath = await ImageUtils.getimage(context);
    if (ipath == null) {
      print("No Image was Picked");
    }
    File temp = File(ipath);
    Directory appDir = await getApplicationDocumentsDirectory();
    final String path = appDir.path;
    final File fileImage = await temp.copy('$path/activity.png');
    print(fileImage.path);
    setState(() {
      _activity = fileImage;
    });
  }

  List activities = [];
  String activity;
  Future _getactivityInfo() async {
    print('User ID :: $userId');
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/activitieslist.php",
        body: {"field_officer_id": userId, "farm_id": widget.farmInfo.farmId});

    var value = json.decode(response.body).first;
    var valls = value['activity'];
    if (response.statusCode == 200) {
      activities = valls.toString().split(',');
    } else {
      throw Exception(
          'We were not able to successfully download the json data.');
    }
  }

  Widget displaySelectedFile(File file) {
    return new Container(
      child: file == null
          ? new Text('Sorry nothing selected!!')
          : new Image.file(file),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Record Activities",
          textAlign: TextAlign.center,
          style: (TextStyle(fontFamily: 'JosefinSans', color: Colors.white)),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: FutureBuilder(
        future: _getactivityInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              activities != null) {
            return body();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
  // child: TextField(
  //   textAlign: TextAlign.center,
  //   controller: titleController,
  //   cursorColor: Colors.orange,
  //   decoration: InputDecoration(
  //       border: InputBorder.none, hintText: "Title"),
  // ),

  Widget body() {
    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 6),
        Center(
          child: Card(
            elevation: 0,
            child: Container(
              padding: EdgeInsets.all(15.0),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      bottomLeft: const Radius.circular(40.0),
                      bottomRight: const Radius.circular(40.0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Add New Record", style: TextStyle(fontSize: 25)),
                  SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all()),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        items: activities
                            .map((e) =>
                                DropdownMenuItem(child: Text(' $e'), value: e))
                            .toList(),
                        value: activity,
                        onChanged: (val) {
                          setState(() {
                            activity = val;
                          });
                        },
                        hint: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                          child: Text('Select Activity'),
                        ),

                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all()),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: descController,
                      cursorColor: Colors.orange,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Description"),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.orange[300],
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Center(
                      child: _activity == null
                          ? FlatButton(
                              onPressed: () {
                                _getActivityImage();
                              },
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                                size: 50,
                              ),
                            )
                          : Column(
                              children: [
                                displaySelectedFile(_activity),
                                FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        _activity = null;
                                      });
                                    },
                                    child: Text("Retake"))
                              ],
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: FlatButton(
                      onPressed: () {
                        if (activities != null &&
                            descController.text.isNotEmpty &&
                            _activity != null) {
                          print("Button Clicked");
                          _sendData(_activity.path);
                          setState(() {
                            _activity = null;
                            activities = null;
                            descController.clear();
                            Navigator.pop(context);
                          });
                          showDialog(
                              context: context,
                              builder: (_) => LogoutOverlay(
                                    message: "Record Added",
                                  ));
                        } else {
                          showDialog(
                              context: context,
                              builder: (_) => LogoutOverlay(
                                    message: "Add All fields",
                                  ));
                        }
                      },
                      child: Text(
                        "Start",
                        style:
                            TextStyle(color: Colors.orange[300], fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
