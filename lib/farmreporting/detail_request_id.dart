import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apps/components/logout_overlay.dart';
import 'package:apps/investornavigation/chart.dart';
import 'package:apps/model/expense_model.dart';
import '../Utils/Image/PickImage.dart';
import '../model/overview.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Farm {
  String id;
  String farm;
  Farm({this.id, this.farm});
}

class DetailRequestID extends StatefulWidget {
  final ExpenseModel expenseList;
  // final Overview farmInfo;
  DetailRequestID({this.expenseList});
  @override
  _DetailRequestIDState createState() => _DetailRequestIDState();
}

class _DetailRequestIDState extends State<DetailRequestID> {
  SharedPreferences sharedPreferences;
  String userId, mobile;
  TextEditingController searchController = new TextEditingController();
  TextEditingController patricularsController = new TextEditingController();
  TextEditingController noOfUnitsController = new TextEditingController();
  TextEditingController unitCostController = new TextEditingController();
  File _image;
  ByteData _signImage;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  String farmid;
  Widget displaySelectedFile(File file) {
    return new Container(
      child: file == null
          ? new Text('Sorry nothing selected!!')
          : new Image.file(file, fit: BoxFit.cover),
    );
  }

  Widget displaysign(ByteData _signImage) {
    return new Container(
      child: _signImage == null
          ? new Text('Sorry nothing selected!!')
          : new Image.memory(_signImage.buffer.asUint8List(),
              fit: BoxFit.cover),
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

  _getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (userId == "") {
        userId = (sharedPreferences.getString('user_id') ?? '');
        mobile = (sharedPreferences.getString('mobile') ?? '');
      } else {
        userId = (sharedPreferences.getString('user_id') ?? '');
        mobile = (sharedPreferences.getString('mobile') ?? '');
      }
    });
  }

  List<Overview> farmList = [];
  Future<List<Overview>> _getOverViewInfo() async {
    var response = await http.post(
        "http://isf.breaktalks.com/appconnect/farmlist.php",
        body: {"field_officer_id": userId});
    var value = json.decode(response.body);
    var farmlist = value['farm_list'];

    if (response.statusCode == 200) {
      List spacecrafts = farmlist;
      farmList = [Overview(farmId: null, farmerName: 'General Purpose')];
      farmList.addAll(spacecrafts
          .map((spacecraft) => new Overview.fromJson(spacecraft))
          .toList());

      print(farmList[0]);
      return farmList;
    } else
      throw Exception(
          'We were not able to successfully download the json data.');
  }

  void showloading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: Dialog(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text('       Uploading Data...')
          ],
        ),
      )),
    );
  }

  Future _sendData(String file, ByteData sign) async {
    // try {
    showloading();
    double noOfUnits =
        double.tryParse(noOfUnitsController.text.toString()) ?? 0;
    double unitCost = double.tryParse(unitCostController.text.toString()) ?? 0;
    double subtotal = noOfUnits * unitCost;
    var request = http.MultipartRequest('POST',
        Uri.parse("http://isf.breaktalks.com/appconnect/addexpense.php"))
      ..fields['field_officer_id'] = userId
      ..fields['fund_request_id'] = widget.expenseList.fundRequestId.toString()
      ..fields['farm_id'] = farmid ?? "General Purpose"
      ..fields['particulars'] = patricularsController.text.toString()
      ..fields['noofunits'] = noOfUnitsController.text.toString()
      ..fields['unitcost'] = unitCostController.text.toString()
      ..fields['subtot'] = subtotal.toString()
      ..files.add(
          await http.MultipartFile.fromPath('bills[]', file, filename: 'Bill'))
      ..files.add(http.MultipartFile.fromBytes(
          'sign', sign?.buffer?.asUint8List() ?? [],
          filename: "signature.png"));
    print('request >> $request');
    var response = await request.send();
    print('response >> ${response.statusCode}');
    Navigator.pop(context);
    if (response.statusCode == 200) {
      farmid = null;
      print("Uploaded");
    } else {
      print({"Responce Code :: ${response.statusCode}"});
    }
    // } catch (e) {
    //   print('Error :: $e');
    // }
  }

  @override
  void initState() {
    super.initState();
    _getData();

    // print(widget.expenseList.total);
    // print(widget.expenseList.availableBalance);
    // print(widget.expenseList.fundRequestId);
  }

  Widget get farmdropdown {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.orange[100],
          border: Border.all()),
      child: SearchChoices.single(
        underline: SizedBox.shrink(),
        value: farmid,
        items: farmList
            .map((e) => DropdownMenuItem(
                  value: '${e.farmId}',
                  child: Text((e.farmId == null)
                      ? e.farmerName ?? ''
                      : '${e.farmId ?? ''}: ${e.farmerName ?? ''}'),
                ))
            .toList(),
        onChanged: (val) {
          setState(() {
            farmid = val;
          });
        },
        isExpanded: true,
        hint: farmid ?? "Select Farm",
        searchHint: 'Search',
      ),
    );
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
      body: FutureBuilder(
        future: _getOverViewInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              farmList != null) {
            return body();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget body() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.orange[50]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Total Amount \n₹${widget.expenseList.total}",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            widget.expenseList.availableBalance != null
                                ? "Avaiable Amount \n₹${widget.expenseList.availableBalance}"
                                : "N/A",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(2.0),
                    child: LiquidCircularProgressIndicator(
                      value: widget.expenseList.availableBalance != null
                          ? double.parse(widget.expenseList.availableBalance
                                  .toString()) /
                              double.parse(widget.expenseList.total.toString())
                          : .5, // Defaults to 0.5.
                      valueColor: AlwaysStoppedAnimation(Colors
                          .orange), // Defaults to the current Theme's accentColor.
                      backgroundColor: Color(
                          0xfff3e6e3), // Defaults to the current Theme's backgroundColor.
                      borderColor: Color(0xfff3e6e3),
                      borderWidth: 5.0,
                      direction: Axis
                          .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                      center: Text(
                        "₹${widget.expenseList.availableBalance.toString()}",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                                "ADD EXPENSE TO",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.orange[300],
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                widget.expenseList.fundRequestId,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.orange[300],
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Divider(),
                              SizedBox(height: 20),
                              farmdropdown,
                              SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(),
                                    color: Colors.orange[100]),
                                child: TextFormField(
                                  textAlign: TextAlign.start,
                                  controller: patricularsController,
                                  cursorColor: Colors.orange,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 6),
                                      hintText: "Enter your Item"),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Cannot Leave it Empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
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
                                      hintText: "Enter the Qty"),
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
                                  controller: unitCostController,
                                  cursorColor: Colors.orange,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 6),
                                      hintText: "Cost Per Item"),
                                  validator: (value) {
                                    // double noOfUnits = double.parse(
                                    //     noOfUnitsController.text.toString());
                                    // double unitCost = double.parse(
                                    //     unitCostController.text.toString());
                                    // double subtotal = noOfUnits * unitCost;
                                    // double availableCost = double.parse(widget
                                    //     .expenseList.availableBalance
                                    //     .toString());
                                    if (value.isEmpty) {
                                      return "Cannot Leave it Empty";
                                    }
                                    // if (subtotal > availableCost) {
                                    //   return "You dont have sufficient Funds";
                                    // }
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
                              SizedBox(height: 25),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 100,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        color: Colors.orange[300],
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Center(
                                      child: _image == null
                                          ? FlatButton(
                                              onPressed: () {
                                                getImage();
                                              },
                                              child: Icon(Icons.add_a_photo,
                                                  color: Colors.white,
                                                  size: 50),
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
                                    height: 80,
                                    width: 100,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        color: Colors.orange[300],
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Center(
                                      child: _signImage == null
                                          ? FlatButton(
                                              onPressed: () async {
                                                ByteData data =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SignatureWidget(),
                                                  ),
                                                );
                                                _signImage = data;
                                                setState(() {});
                                              },
                                              child: Icon(
                                                  FontAwesomeIcons
                                                      .fileSignature,
                                                  color: Colors.white,
                                                  size: 50),
                                            )
                                          : FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  _signImage = null;
                                                });
                                              },
                                              child: Text("Retake")),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 50),
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
                              _signImage == null
                                  ? SizedBox()
                                  : Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.orange[300],
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: displaysign(_signImage),
                                    ),
                              SizedBox(height: 20),
                              SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: RaisedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState.validate() &&
                                        _image != null ||
                                        _signImage != null) {
                                      print("Add button Clicked");
                                      await _sendData(_image?.path, _signImage);
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
                                                message: "Added Expense",
                                              ));
                                    } else {
                                      if (farmid.isEmpty ||
                                          patricularsController.text.isEmpty ||
                                          noOfUnitsController.text.isEmpty ||
                                          unitCostController.text.isEmpty) {
                                        showDialog(
                                            context: context,
                                            builder: (_) => LogoutOverlay(
                                                message: "Enter All fields"));
                                      } else if (_image == null &&
                                          _signImage == null) {
                                        showDialog(
                                            context: context,
                                            builder: (_) => LogoutOverlay(
                                                message: "Please Add Image"));
                                      }
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
                              Divider(),
                            ],
                          )))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SignatureWidget extends StatelessWidget {
  final _sign = GlobalKey<SignatureState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Put Signature"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Signature(
              color: Colors.black,
              strokeWidth: 5.0,
              key: _sign,
            ),
          ),
          RaisedButton(
            child: Text("Save"),
            onPressed: () async {
              final sign = _sign.currentState;
              //retrieve image data, do whatever you want with it (send to server, save locally...)
              final image = await sign.getData();
              var data = await image.toByteData(format: ui.ImageByteFormat.png);
              sign.clear();
              final encoded = base64.encode(data.buffer.asUint8List());
              Navigator.of(context).pop(data);
            },
          ),
        ],
      ),
    );
  }
}
