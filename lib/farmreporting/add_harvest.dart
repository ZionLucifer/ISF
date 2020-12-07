import 'dart:io';
import 'package:apps/components/logout_overlay.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:apps/model/overview.dart';
import 'package:flutter/material.dart';
import '../Utils/Image/PickImage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../farmreporting/detail_request_id.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_icons/flutter_icons.dart';


class AddHarvest extends StatefulWidget {
  final Overview farmInfo;
  AddHarvest({this.farmInfo});
  @override
  _AddHarvestState createState() => _AddHarvestState();
}

class _AddHarvestState extends State<AddHarvest> {
  TextEditingController detailsController = new TextEditingController();
  TextEditingController noOfUnitsController = new TextEditingController();
  TextEditingController unitOfCostController = new TextEditingController();
  TextEditingController discriptionController = new TextEditingController();
  SharedPreferences sharedPreferences;
  String userId, mobile;
  File _image;
  ByteData _sign;
  // final picker = ImagePicker();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    detailsController.clear();
    noOfUnitsController.clear();
    unitOfCostController.clear();
  }

  Widget displaySelectedFile(File file) {
    return new Container(
      child: file == null
          ? new Text('Sorry nothing selected!!')
          : new Image.file(
              file,
              fit: BoxFit.cover,
            ),
    );
  }

  Future getImage() async {
    // final image = await picker.getImage(source: ImageSource.gallery);
    String ipath = await ImageUtils.getimage(context);
    if (ipath == null) {
      print("No Image was Picked");
    }
    File temp = File(ipath);
    Directory appDir = await getApplicationDocumentsDirectory();
    final String path = appDir.path;
    final File fileImage = await temp.copy('$path/image1.png');
    setState(() {
      _image = fileImage;
    });
  }

  Future getSign() async {
    // // final image = await picker.getImage(source: ImageSource.gallery);
    //     String ipath = await ImageUtils.getimage(context);
    // File temp = File(ipath);
    // Directory appDir = await getApplicationDocumentsDirectory();
    // final String path = appDir.path;
    // final File fileImage = await temp.copy('$path/sign.png');
    // setState(() {
    //   _sign = fileImage;
    // });
    ByteData data = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignatureWidget(),
      ),
    );
    _sign = data;
    setState(() {});
  }

  Widget displaysign(ByteData _signImage) {
    return new Container(
      child: _signImage == null
          ? new Text('Sorry nothing selected!!')
          : new Image.memory(_signImage.buffer.asUint8List(),
              fit: BoxFit.cover),
    );
  }

  _sendData(bill, ByteData sign) async {
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse("http://isf.breaktalks.com/appconnect/addharvesting.php"))
        ..fields['field_officer_id'] = userId
        ..fields['harvest_id'] = ""
        ..fields['farm_id'] = widget.farmInfo.farmId
        ..fields['noofunits'] = noOfUnitsController.text.toString()
        ..fields['unitcost'] = unitOfCostController.text.toString()
        ..files.add(await http.MultipartFile.fromPath('bills[]', bill))
        // ..files.add(await http.MultipartFile.fromPath('bills[]', bill))
        // ..files.add(await http.MultipartFile.fromPath('sign', sign))
        ..fields['details'] = detailsController.text.toString()
        ..files.add(http.MultipartFile.fromBytes(
            'sign', sign.buffer.asUint8List(),
            filename: "signature.png"));
      var response = await request.send();
      // print('response ${response.request}');
      if (response.statusCode == 200) {
        print("Uploaded");
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('Error In Updating :: $e');
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Add Harvest",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Form(
                  child: new Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(40.0),
                              topRight: const Radius.circular(40.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "ADD HARVESTING FOR  \n" + widget.farmInfo.farmId,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.orange[300],
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Divider(),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(),
                                color: Colors.orange[100]),
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              cursorColor: Colors.orange,
                              controller: detailsController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 6),
                                  hintText: "Enter Details"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Cannot Leave it Empty";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.orange[100],
                                border: Border.all()),
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              controller: noOfUnitsController,
                              cursorColor: Colors.orange,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 6),
                                  hintText: "No of Units"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Cannot Leave it Empty";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.orange[100],
                                border: Border.all()),
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              controller: unitOfCostController,
                              cursorColor: Colors.orange,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 6),
                                  hintText: "Unit Cost"),
                              validator: (value) {
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 15),
                          Divider(),
                          Text(
                            "ATTACH BILLS AND SIGNATURE",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.orange[300],
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
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
                                      : FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              _image = null;
                                            });
                                          },
                                          child: Text("Retake")),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: Colors.orange[300],
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Center(
                                  child: _sign == null
                                      ? FlatButton(
                                          onPressed: () {
                                            getSign();
                                          },
                                          child: Icon(
                                             FontAwesomeIcons.fileSignature,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                        )
                                      : FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              _sign = null;
                                            });
                                          },
                                          child: Text("Retake")),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                          SizedBox(height: 70),
                          _image == null
                              ? SizedBox()
                              : Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.orange[300],
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: displaySelectedFile(_image),
                                ),
                          SizedBox(height: 20),
                          _sign == null
                              ? SizedBox()
                              : Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.orange[300],
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: displaysign(_sign),
                                ),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: () {
                                if (detailsController.text.isNotEmpty &&
                                    noOfUnitsController.text.isNotEmpty &&
                                    unitOfCostController.text.isNotEmpty &&
                                    _image != null &&
                                    _sign != null) {
                                  print("Done Pressed");
                                  _sendData(_image.path, _sign);
                                  setState(() {
                                    detailsController.clear();
                                    noOfUnitsController.clear();
                                    unitOfCostController.clear();
                                    discriptionController.clear();
                                    _image = null;
                                    _sign = null;
                                  });
                                  showDialog(
                                      context: context,
                                      builder: (_) => LogoutOverlay(
                                            message: "Added Harvest",
                                          ));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (_) => LogoutOverlay(
                                            message: "Enter All the Fields",
                                          ));
                                }
                              },
                              child: Text(
                                "ADD EXPENSE!",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                          Divider(),
                        ],
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
