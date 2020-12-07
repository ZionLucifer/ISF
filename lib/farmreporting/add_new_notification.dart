import 'dart:convert';
import 'dart:io';
import 'package:apps/components/logout_overlay.dart';
import 'package:apps/model/overview.dart';
import 'package:flutter/material.dart';
import '../Utils/Image/PickImage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AddNewNotification extends StatefulWidget {
  final Overview farmInfo;
  AddNewNotification({this.farmInfo});
  @override
  _AddNewNotificationState createState() => _AddNewNotificationState();
}

class _AddNewNotificationState extends State<AddNewNotification> {
  SharedPreferences sharedPreferences;
  String userId, mobile;
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  File _image;
  // final picker = ImagePicker();
  Widget displaySelectedFile(File file) {
    return new Container(
      child: file == null
          ? new Text('Sorry nothing selected!!')
          : new Image.file(file, fit: BoxFit.contain),
    );
  }

  Future getImage() async {
    // final image = await picker.getImage(source: ImageSource.camera);
    String ipath = await ImageUtils.getimage(context);

    if (ipath == null) {
      print("No Image was Picked");
    }
    File temp = File(ipath);
    Directory appDir = await getApplicationDocumentsDirectory();
    final String path = appDir.path;
    final File fileImage = await temp.copy('$path/record.png');
    setState(() {
      _image = fileImage;
    });
  }

  _sendData(file) async {
    var request = http.MultipartRequest('POST',
        Uri.parse("http://isf.breaktalks.com/appconnect/addnotification.php"))
      ..fields['field_officer_id'] = userId
      ..fields['notification_id'] = ''
      ..fields['farm_id'] = widget.farmInfo.farmId
      ..fields['title'] = titleController.text.toString()
      ..fields['description'] = descriptionController.text.toString()
      ..files.add(await http.MultipartFile.fromPath('files', file));
    var response = await request.send();
    if (response.statusCode == 200) {
      print("Uploaded");
      print(response.reasonPhrase);
      print(response.request);
    } else {
      print("${response.statusCode}");
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
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Add New Notification",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: ListView(children: [
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(40.0),
                    topRight: const Radius.circular(40.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                  child: Text(
                    "ADD NEW NOTIFICATION TO INVESTOR ",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(5)),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: titleController,
                      cursorColor: Colors.orange,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter The Title",
                        hintStyle:
                            TextStyle(fontSize: 17.0, color: Colors.black45),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  padding: EdgeInsets.all(2),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: descriptionController,
                    cursorColor: Colors.orange,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Description",
                      hintStyle:
                          TextStyle(fontSize: 17.0, color: Colors.black45),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 100,
                  width: 100,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.orange[300],
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Center(
                    child: _image == null
                        ? FlatButton(
                            onPressed: () {
                              getImage();
                            },
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 50,
                            ),
                          )
                        : Column(
                            children: [
                              displaySelectedFile(_image),
                              FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      _image = null;
                                    });
                                  },
                                  child: Text("Retake"))
                            ],
                          ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: RaisedButton(
                        child: Text("ADD NEW NOTIFICATION",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        color: Colors.orange[300],
                        onPressed: () {
                          if (titleController.text.isNotEmpty &&
                              descriptionController.text.isNotEmpty) {
                            _sendData(_image.path);
                            print(base64);
                            setState(() {
                              _image = null;
                              titleController.clear();
                              descriptionController.clear();
                            });
                            showDialog(
                                context: context,
                                builder: (context) => LogoutOverlay(
                                    message: "Data Updated Successfully"));
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => LogoutOverlay(
                                    message: "Please Add all the fields"));
                          }
                        }))
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
