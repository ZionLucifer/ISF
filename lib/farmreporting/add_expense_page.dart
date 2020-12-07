import 'dart:io';
import 'package:apps/components/logout_overlay.dart';
import 'package:apps/model/overview.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../Utils/Image/PickImage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddExpensePage extends StatefulWidget {
  AddExpensePage({this.farmInfo});
  final Overview farmInfo;
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  TextEditingController searchController = new TextEditingController();
  TextEditingController patricularsController = new TextEditingController();
  TextEditingController noOfUnitsController = new TextEditingController();
  TextEditingController unitCostController = new TextEditingController();
  File _image;
  File _signImage;
  SharedPreferences sharedPreferences;
  String userId, mobile;
  // final picker = ImagePicker();

  Widget displaySelectedFile(File file) {
    return new Container(
      child: file == null
          ? new Text('Sorry nothing selected!!')
          : new Image.file(file, fit: BoxFit.cover),
    );
  }

  Future getImage() async {
    // final image =
    //     await picker.getImage(imageQuality: 50, source: ImageSource.gallery);
    String ipath = await ImageUtils.getimage(context);
    File temp = File(ipath);
    Directory appDir = await getApplicationDocumentsDirectory();
    final String path = appDir.path;
    final File fileImage = await temp.copy('$path/expense.png');
    setState(() {
      _image = fileImage;
    });
  }

  Future getSignImage() async {
    String ipath = await ImageUtils.getimage(context);
    // final image =
    //     await picker.getImage(imageQuality: 50, source: ImageSource.gallery);
    File temp = File(ipath);
    Directory appDir = await getApplicationDocumentsDirectory();
    final String path = appDir.path;
    final File fileImage = await temp.copy('$path/sign.png');
    setState(() {
      _signImage = fileImage;
    });
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

  _sendData(file, sign) async {
    try {
      double noOfUnits = double.parse(noOfUnitsController.text.toString());
      double unitCost = double.parse(unitCostController.text.toString());
      double subtotal = noOfUnits * unitCost;
      var request = http.MultipartRequest('POST',
          Uri.parse("http://isf.breaktalks.com/appconnect/addexpense.php"))
        ..fields['field_officer_id'] = userId
        ..fields['fund_request_id'] = "REQ001"
        ..fields['farm_id'] = "FARM001"
        ..fields['particulars'] = patricularsController.text.toString()
        ..fields['noofunits'] = noOfUnitsController.text.toString()
        ..fields['unitcost'] = unitCostController.text.toString()
        ..fields['subtot'] = subtotal.toString()
        ..files.add(await http.MultipartFile.fromPath('bills[]', file))
        ..files.add(await http.MultipartFile.fromPath('sign', sign));
      var response = await request.send();
      if (response.statusCode == 200) {
        print("Uploaded");
      } else {
        print({"${response.statusCode}"});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Add Expense",
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
              SizedBox(height: 30),
              Container(
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
                            "Add Expense",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all()),
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: patricularsController,
                              cursorColor: Colors.orange,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter your Item"),
                            ),
                          ),
                          SizedBox(
                            height: 15
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all()),
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: noOfUnitsController,
                              cursorColor: Colors.orange,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter the Qty"),
                            ),
                          ),
                          SizedBox(
                            height: 15
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all()),
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: unitCostController,
                              cursorColor: Colors.orange,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Cost Per Item"),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(),
                          Text(
                            "Attach Bills",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            height: 15,
                          ),
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
                            height: 15,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: Colors.orange[300],
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Center(
                              child: _signImage == null
                                  ? FlatButton(
                                      onPressed: () {
                                        getSignImage();
                                      },
                                      child: Icon(Icons.edit,
                                          color: Colors.white, size: 50),
                                    )
                                  : Column(
                                      children: [
                                        displaySelectedFile(_signImage),
                                        FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                _signImage = null;
                                              });
                                            },
                                            child: Text("Retake"))
                                      ],
                                    ),
                            ),
                          ),
                          Divider(),
                          SizedBox(
                            height: 5.5,
                          ),
                          FlatButton(
                              onPressed: () {
                                if (patricularsController.text.isNotEmpty &&
                                    noOfUnitsController.text.isNotEmpty &&
                                    unitCostController.text.isNotEmpty &&
                                    _image != null &&
                                    _signImage != null) {
                                  print("Add button Clicked");
                                  _sendData(_image.path, _signImage.path);
                                  setState(() {
                                    patricularsController.clear();
                                    noOfUnitsController.clear();
                                    unitCostController.clear();
                                    _image = null;
                                    _signImage = null;
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
                                            message: "Add All Details",
                                          ));
                                }
                              },
                              child: Text(
                                "Add Expense!",
                                style: TextStyle(
                                    color: Colors.orange[300],
                                    fontWeight: FontWeight.w500),
                              )),
                          Divider(),
                        ],
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
