import 'dart:io';
import 'package:apps/components/logout_overlay.dart';
import 'package:apps/model/overview.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class SensingPage extends StatefulWidget {
  SensingPage({this.farmInfo});
  final Overview farmInfo;
  @override
  _SensingPageState createState() => _SensingPageState();
}

class _SensingPageState extends State<SensingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
  String userId;
  String message;
  TextEditingController descController = new TextEditingController();
  String responseCode;
  _sendData() async {
    try {
      var uri =
          Uri.parse("http://isf.breaktalks.com/appconnect/addsensing.php");
      var request = http.MultipartRequest('POST', uri)
        ..fields['field_officer_id'] = userId
        ..fields['farm_id'] = widget.farmInfo.farmId
        ..files
            .add(await http.MultipartFile.fromPath('file', _aadharImage?.path))
        ..fields['description'] = descController.text.toString();
      var response = await request.send();
      setState(() {
        responseCode = responseCode;
      });
      if (response.statusCode == 200) {
        print("Uploaded Sucessfully");
      } else {
        print(response.statusCode);
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
        print("test IF");
        print(userId);
      } else {
        userId = (sharedPreferences.getString('user_id') ?? '');
        print("Test Else");
        print(userId);
      }
    });
  }

  File _aadharImage;
  final picker = ImagePicker();
  Future getAadharImage() async {
    final image =
        await picker.getImage(imageQuality: 50, source: ImageSource.gallery);
    // String ipath = await ImageUtils.getimage(context);

    setState(() {
      _aadharImage = File(image.path);
    });
  }

  Widget displaySelectedFile(File file) {
    return new Container(
      child: file == null
          ? new Text('Sorry nothing selected!!')
          : new Image.file(
              file,
              fit: BoxFit.contain,
            ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Sensing",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [],
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
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
                  BoxShadow(
                      color: Colors.grey[400], spreadRadius: 2, blurRadius: 2)
                ], color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: [
              Text(
                "ADD NEW SENSING INFO HERE",
                style: TextStyle(
                    fontSize: 19.0,
                    color: Colors.orange[300],
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: descController,
                      maxLines: 5,
                      decoration: InputDecoration(
                          hintText: 'Enter the Description',
                          hintStyle:
                              TextStyle(fontSize: 17.0, color: Colors.black45),
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Container(
                child: buildGridView(),
              ),
              Container(
                width: 100,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.orange[300],
                    borderRadius: BorderRadius.circular(5.0)),
                child: Center(
                  child: _aadharImage == null
                      ? FlatButton(
                          onPressed: () {
                            getAadharImage();
                          },
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 50,
                          ),
                        )
                      : Column(
                          children: [
                            displaySelectedFile(_aadharImage),
                            FlatButton(
                                onPressed: () {
                                  setState(() {
                                    _aadharImage = null;
                                  });
                                },
                                child: Text("Retake"))
                          ],
                        ),
                ),
              ),
            ],
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[300],
        onPressed: () {
          if (descController.text.isNotEmpty) {
            print("Going to send Data");
            _sendData();
            setState(() {
              descController.clear();
              _aadharImage = null;
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
                      message: "Please Add All the Fields",
                    ));
          }
        },
        child: Icon(
          Icons.file_upload,
          color: Colors.white,
        ),
      ),
    );
  }
}
